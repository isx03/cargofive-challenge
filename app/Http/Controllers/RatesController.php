<?php

namespace App\Http\Controllers;

use App\Models\Rate;
use App\Models\Carrier;
use App\Models\Surcharge;
use Illuminate\Http\Request;
use App\Models\SurchargeConcept;
use Illuminate\Http\JsonResponse;
use App\Services\SpreadsheetLoadRates;

class RatesController extends Controller
{
    public function loadRates(Request $request): JsonResponse
    {
        try {
            // validate file must be excel
            $this->validate($request, [
                'file' => 'required|file|mimes:xls,xlsx'
            ]);
            // extract and validate spreadsheet data
            $spreadsheetLoadRates = new SpreadsheetLoadRates($request->file);
            $rows = $spreadsheetLoadRates->validateContent();
            // parse data to insert rates
            $rates = array_map(function($row){
                return [
                    "surcharge_id" => $row["surcharge_id"],
                    "carrier_id" => $row["carrier_id"],
                    "amount" => $row["amount"],
                    "currency" => $row["currency"],
                ];
            }, $rows);
            Rate::insert($rates);
            return response()->json([
                "message" => "Rates saved successfully"
            ], 201);
        } catch (\Exception $e) {
            $errorMessage = $e->getMessage();
            $errorStatusCode = $e->getCode();
            $errorStatusCode = $errorStatusCode != 0 ? $errorStatusCode : 500;
            return response()->json([
                'message' => $errorMessage,
            ], $errorStatusCode);
        }
    }

    private function organizeRatesBySurcharges($rates): array
    {
        $ratesOrganized = [];
        foreach($rates as $rate){
            $rateRow = [
                'id' => $rate['rate_id'],
                'amount' => $rate['amount'],
                'currency' => $rate['currency'],
            ];
            $carrierRow = [
                'id' => $rate['carrier_id'],
                'name' => $rate['carrier'],
                'rates' => [ $rateRow ]
            ];
            
            $positionSurcharge = findPositionOfObjectByColumnAndValue($rate['surcharge_id'], 'surcharge_id', $ratesOrganized);
            if( $positionSurcharge === false ){
                $ratesOrganized[] = [
                    'id' => $rate['rate_id'],
                    'surcharge_id' => $rate['surcharge_id'],
                    'surcharge_concept' => $rate['surcharge_concept'],
                    'apply_to' => $rate['apply_to'],
                    'carriers' => [$carrierRow]
                ];
                continue;
            }
            $positionCarrier = findPositionOfObjectByColumnAndValue($rate['carrier_id'], 'id', $ratesOrganized[$positionSurcharge]['carriers']);
            
            if( $positionCarrier === false ){
                $ratesOrganized[$positionSurcharge]['carriers'][] = $carrierRow;
                continue;
            }

            $ratesOrganized[$positionSurcharge]['carriers'][$positionCarrier]['rates'][] = $rateRow;
        }
        return $ratesOrganized;
    }

    function ratesBySurcharges(Request $request): JsonResponse
    {
        $conditions = [];
        if( !empty($request->surcharge_concept_id) ){
            $surchargeConceptId = intval($request->surcharge_concept_id);
            $surchargeConcept = SurchargeConcept::find($surchargeConceptId);
            if( !$surchargeConcept ){
                return response()->json([
                    'message' => 'Surcharge concept does not exist',
                ], 404);
            }
            $conditions[] = "surcharges.surcharge_concept_id = {$surchargeConceptId}";
        }

        if( !empty($request->carrier_id) ){
            $carrierId = intval($request->carrier_id);
            $carrier = Carrier::find($carrierId);
            if( !$carrier ){
                return response()->json([
                    'message' => 'Carrier does not exist',
                ], 404);
            }
            $conditions[] = "rates.carrier_id = {$carrierId}";
        }

        if( !empty($request->apply_to) ){
            $applyTo = cleanString($request->apply_to);
            if( !in_array($applyTo, Surcharge::TYPE_APPLIES) ){
                return response()->json([
                    'message' => "Apply to must be 'origin','freight' or 'destination'",
                ], 404);
            }
            $conditions[] = "surcharges.apply_to = '{$applyTo}'";
        }

        $conditions = implode(' AND ', $conditions);

        try {
            $ratesQuery = Rate::select(
                        'rates.id AS rate_id',
                        'surcharges.id AS surcharge_id',
                        'surcharge_concepts.name AS surcharge_concept',
                        'carriers.id AS carrier_id',
                        'carriers.name AS carrier',
                        'surcharges.apply_to',
                        'rates.amount',
                        'rates.currency'
                    )
                    ->join('surcharges', 'rates.surcharge_id', '=', 'surcharges.id')
                    ->join('surcharge_concepts', 'surcharges.surcharge_concept_id', '=', 'surcharge_concepts.id')
                    ->join('carriers', 'rates.carrier_id', '=', 'carriers.id');
            if( !empty($conditions) ){
                $ratesQuery->whereRaw($conditions);
            }
            $rates = $ratesQuery->orderBy('rates.id', 'ASC')
                ->get()
                ->toArray();
            
            $ratesOrganized = $this->organizeRatesBySurcharges($rates);
            return response()->json([
                'message' => 'Rates by surcharges organized successfully',
                'data' => $ratesOrganized
            ], 200);
        } catch (\Exception $e) {
            $errorMessage = $e->getMessage();
            $errorStatusCode = $e->getCode();
            $errorStatusCode = $errorStatusCode != 0 ? $errorStatusCode : 500;
            return response()->json([
                'message' => $errorMessage,
            ], $errorStatusCode);
        }
    }

}
