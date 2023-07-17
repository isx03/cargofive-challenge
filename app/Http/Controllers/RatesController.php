<?php

namespace App\Http\Controllers;

use Throwable;
use App\Models\Rate;
use App\Models\Carrier;
use Illuminate\Http\Request;
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
                    "apply_to" => $row["apply_to"],
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
                'apply_to' => $rate['apply_to']
            ];

            $carrierRow = [
                'id' => $rate['carrier_id'],
                'name' => $rate['carrier'],
                'rates' => [ $rateRow ]
            ];

            $positionRate = findPositionOfObjectByColumnAndValue($rate['surcharge'], 'surcharge', $ratesOrganized);
            if($positionRate === false){
                $ratesOrganized[] = [
                    'id' => $rate['surcharge_id'],
                    'surcharge' => $rate['surcharge'],
                    'carriers' => [ $carrierRow ]
                ];
                continue;
            }

            $positionCarrier = findPositionOfObjectByColumnAndValue($rate['carrier'], 'name', $ratesOrganized[$positionRate]['carriers']);
            if( $positionCarrier === false ){
                $ratesOrganized[$positionRate]['carriers'][] = $carrierRow;
                continue;
            }
            $ratesOrganized[$positionRate]['carriers'][$positionCarrier]['rates'][] = $rateRow;
        }
        return $ratesOrganized;
    }

    public function ratesBySurcharges(): JsonResponse
    {
        try {
            $rates = Rate::select(
                        'rates.id AS rate_id',
                        'surcharges.id AS surcharge_id',
                        'surcharges.name AS surcharge',
                        'carriers.id AS carrier_id',
                        'carriers.name AS carrier',
                        'rates.apply_to',
                        'rates.amount',
                        'rates.currency'
                    )
                    ->join('surcharges', 'rates.surcharge_id', '=', 'surcharges.id')
                    ->join('carriers', 'rates.carrier_id', '=', 'carriers.id')
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
