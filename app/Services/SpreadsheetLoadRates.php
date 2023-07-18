<?php

namespace App\Services;

use App\Models\Carrier;
use App\Models\Surcharge;
use Illuminate\Http\UploadedFile;
use App\Models\SurchargeConceptAlias;
use PhpOffice\PhpSpreadsheet\IOFactory;

class SpreadsheetLoadRates
{
    public function __construct(UploadedFile $excelFile)
    {
        $spreadsheet = IOFactory::load($excelFile->getRealPath());
        $this->sheet = $spreadsheet->getActiveSheet();
        $this->rows = [];
        $this->carrierNames = [];
        $this->patternsConceptApplyTo = [];
    }

    private function getCarriersByNames(): array
    {
        return Carrier::whereIn('name', $this->carrierNames)
                ->get()
                ->toArray();
    }

    private function getSurchargesByPattern(): array
    {
        $conditions = array_map(function($pattern){
            return "(CONCAT(surcharge_concept_aliases.name,'-',surcharges.apply_to) = '{$pattern}')";
        }, $this->patternsConceptApplyTo);
        $conditions = implode(' OR ', $conditions);
        return Surcharge::selectRaw('surcharges.id AS surcharge_id,
            surcharge_concepts.id AS surcharge_concept_id,
            surcharge_concepts.name AS surcharge_concept_name,
            surcharges.apply_to,
            surcharge_concept_aliases.name AS surcharge_concept_alias,
            CONCAT(surcharge_concept_aliases.name,"-",surcharges.apply_to) AS pattern')
            ->join('surcharge_concepts', 'surcharges.surcharge_concept_id', '=', 'surcharge_concepts.id')
            ->join('surcharge_concept_aliases', 'surcharge_concept_aliases.surcharge_concept_id', '=', 'surcharge_concepts.id')
            ->whereRaw($conditions)
            ->get()
            ->toArray();
    }

    private function validateCarriersAndSurcharge(): void
    {
        $carriersDb = Carrier::whereIn('name', $this->carrierNames)
                        ->get()
                        ->toArray();
        $surchargesDb = $this->getSurchargesByPattern();
        foreach($this->rows as $key => $row){
            // validate if carrier name of excel file exist in database
            $positionCarrier = findPositionOfObjectByColumnAndValue($row['carrier'], 'name', $carriersDb);
            if($positionCarrier === false){
                throw new \ErrorException("Fila {$row['number']}: carrier {$row['carrier']} does not exist", 404);
            }
            // validate is surcharge config of excel file exist in database
            $positionSurchargeConceptAlias = findPositionOfObjectByColumnAndValue($row['pattern_concept_apply_to'], 'pattern', $surchargesDb);
            if($positionSurchargeConceptAlias === false){
                throw new \ErrorException("Fila {$row['number']}: config does not exist surcharge concept alias '{$row['surcharge_concept_alias']}' apply to '{$row['apply_to']}'", 404);
            }
            $this->rows[$key]["carrier_id"] = $carriersDb[$positionCarrier]["id"];
            $this->rows[$key]["surcharge_id"] = $surchargesDb[$positionSurchargeConceptAlias]["surcharge_id"];
        }
    }

    private function validateRow(array $row): void
    {
        if( empty($row["surcharge_concept_alias"]) ){
            throw new \ErrorException("Fila {$row['number']}: Surcharge is required", 400);
        }

        if( empty($row["carrier"]) ){
            throw new \ErrorException("Fila {$row['number']}: Carrier is required", 400);
        }

        if( empty($row["amount"]) ){
            throw new \ErrorException("Fila {$row['number']}: Amount is required", 400);
        }

        if(filter_var($row["amount"], FILTER_VALIDATE_FLOAT) === false){
            throw new \ErrorException("Fila {$row['number']}: amount is a invalid value", 400);
        }

        if( empty($row["currency"]) ){
            throw new \ErrorException("Fila {$row['number']}: Currency is required", 400);
        }

        if( empty($row["apply_to"]) ){
            throw new \ErrorException("Fila {$row['number']}: Apply to is required", 400);
        }

        if(!in_array($row['apply_to'], Surcharge::TYPE_APPLIES)){
            throw new \ErrorException("Fila {$row['number']}: A pply to must be origin, freight or destination", 400);
        }
    }

    public function validateContent(): array
    {
        $rowLimit = $this->sheet->getHighestDataRow();
        $rowRange = range(2, $rowLimit);
        foreach($rowRange as $rowNumber){
            $row = [
                "number" => $rowNumber,
                "surcharge_concept_alias" => strtoupper(cleanString($this->sheet->getCell( 'A' . $rowNumber )->getValue())),
                "carrier" => strtoupper(cleanString($this->sheet->getCell( 'B' . $rowNumber )->getValue())),
                "amount" => cleanString($this->sheet->getCell( 'C' . $rowNumber )->getValue()),
                "currency" => strtoupper(cleanString($this->sheet->getCell( 'D' . $rowNumber )->getValue())),
                "apply_to" => cleanString($this->sheet->getCell( 'E' . $rowNumber )->getValue())
            ];

            $this->validateRow($row);

            // catch pattern concept and apply to without repeat itself
            $patternConceptApplyTo = "{$row['surcharge_concept_alias']}-{$row['apply_to']}";
            $row["pattern_concept_apply_to"] = $patternConceptApplyTo;
            if( !in_array($patternConceptApplyTo, $this->patternsConceptApplyTo) ){
                $this->patternsConceptApplyTo[] = $patternConceptApplyTo;
            }
            // catch carriers without repeat itself
            if( !in_array($row['carrier'], $this->carrierNames) ){
                $this->carrierNames[] = $row['carrier'];
            }

            $this->rows[] = $row;
        }

        $this->validateCarriersAndSurcharge();

        return $this->rows;
    }
}