<?php

namespace App\Services;

use App\Models\Carrier;
use App\Models\Surcharge;
use App\Models\SurchargeAlias;
use Illuminate\Http\UploadedFile;
use PhpOffice\PhpSpreadsheet\IOFactory;

class SpreadsheetLoadRates
{

    const TYPE_APPLIES = ['origin','freight','destination'];

    public function __construct(UploadedFile $excelFile)
    {
        $spreadsheet = IOFactory::load($excelFile->getRealPath());
        $this->sheet = $spreadsheet->getActiveSheet();
        $this->rows = [];
        $this->carrierNames = [];
        $this->surchargeAliases = [];
    }

    private function getCarriersByNames(): array
    {
        return Carrier::whereIn('name', $this->carrierNames)
                ->get()
                ->toArray();
    }

    private function getSurchargesByPattern(): array
    {
        $surcharges = array_values($this->surchargeAliases);
        $conditions = array_map(function($surcharge){
            return "(name='{$surcharge['surcharge']}' AND apply_to='{$surcharge['apply_to']}')";
        }, $surcharges);
        $conditions = implode(' OR ', $conditions);
        return Surcharge::selectRaw('id, CONCAT(name,"-",apply_to) AS pattern')
                ->whereRaw($conditions)
                ->get()
                ->toArray();
    }

    private function validateCarriersAndSurchargeAliases(): void
    {
        $carriersDb = Carrier::whereIn('name', $this->carrierNames)
                        ->get()
                        ->toArray();
        $surchargesDb = SurchargeAlias::whereIn('name', $this->surchargeAliases)
                        ->get()
                        ->toArray();
        foreach($this->rows as $key => $row){
            // validate if carrier name of excel file exist in database
            $positionCarrier = findPositionOfObjectByColumnAndValue($row['carrier'], 'name', $carriersDb);
            if($positionCarrier === false){
                throw new \ErrorException("Fila {$row['number']}: carrier {$row['carrier']} does not exist", 404);
            }
            // validate is surcharge alias of excel file exist in database
            $positionSurchargeAlias = findPositionOfObjectByColumnAndValue($row['surcharge_alias'], 'name', $surchargesDb);
            if($positionSurchargeAlias === false){
                throw new \ErrorException("Fila {$row['number']}: surcharge alias '{$row['surcharge_alias']}' does not exist", 404);
            }
            $this->rows[$key]["carrier_id"] = $carriersDb[$positionCarrier]["id"];
            $this->rows[$key]["surcharge_id"] = $surchargesDb[$positionSurchargeAlias]["surcharge_id"];
        }
    }

    public function validateContent(): array
    {
        $rowLimit = $this->sheet->getHighestDataRow();
        $rowRange = range(2, $rowLimit);
        foreach($rowRange as $rowNumber){
            $row = [
                "number" => $rowNumber,
                "surcharge_alias" => cleanString($this->sheet->getCell( 'A' . $rowNumber )->getValue()),
                "carrier" => cleanString($this->sheet->getCell( 'B' . $rowNumber )->getValue()),
                "amount" => cleanString($this->sheet->getCell( 'C' . $rowNumber )->getValue()),
                "currency" => cleanString($this->sheet->getCell( 'D' . $rowNumber )->getValue()),
                "apply_to" => cleanString($this->sheet->getCell( 'E' . $rowNumber )->getValue())
            ];

            //TODO: MAKE VALIDATIONS OF ROW

            if( !in_array($row['surcharge_alias'], $this->surchargeAliases) ){
                $this->surchargeAliases[] = $row['surcharge_alias'];
            }

            if( !in_array($row['carrier'], $this->carrierNames) ){
                $this->carrierNames[] = $row['carrier'];
            }

            $this->rows[] = $row;
        }

        $this->validateCarriersAndSurchargeAliases();

        return $this->rows;
    }
}