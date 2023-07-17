<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use App\Services\JsonWebToken;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        try {
            $this->validate($request, [
                'email' => 'required|string',
                'password' => 'required|string',
            ]);
    
            $user = User::where('email', request('email'))->first();
            if( !$user ){
                return response()->json(['error' => 'Unauthorized'], 401);
            }
    
            if( !Hash::check($request->password, $user->password) ){
                return response()->json(['error' => 'Unauthorized'], 401);
            }

            $token = JsonWebToken::generateToken([
                "name" => $user->name,
                "email" => $user->email
            ]);

            return response()->json([
                "message" => "Login successfully",
                "token" => $token
            ]);
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