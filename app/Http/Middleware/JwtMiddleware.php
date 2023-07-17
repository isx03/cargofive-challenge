<?php

namespace App\Http\Middleware;

use Closure;
use App\Services\JsonWebToken;

class JwtMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        try {
            $authorization = $request->header('Authorization');
            if( !$authorization ){
                return response()->json([
                    "message" => 'Unauthorized: Bearer token required'
                ], 401);
            }
    
            $authorizationExplode = explode(" ", $authorization);
            $bearerToken = $authorizationExplode[1];
            JsonWebToken::validateToken($bearerToken);

            return $next($request);
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
