<?php

namespace App\Services;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

class JsonWebToken
{
    static function generateToken($data): string
    {
        $dateTimeImmutable = new \DateTimeImmutable();
        $expireClaim = $dateTimeImmutable->modify('+12 minutes')->getTimestamp();
        $payload = [
            "iss" => env('APP_URL'),
            "iat" => $dateTimeImmutable->getTimestamp(),
            "nbf" => $dateTimeImmutable->getTimestamp(),
            "exp" => $expireClaim,
            "data" => $data
        ];
        return JWT::encode($payload, env('JWT_SECRET'), 'HS512');
    }

    static function validateToken($token)
    {
        try {
            $tokenDecoded = JWT::decode($token, new Key(env('JWT_SECRET'), 'HS512'));
            $now = new \DateTimeImmutable();
            if ( $tokenDecoded->exp < $now->getTimestamp() ){
                throw new \ErrorException("JWT expired", 401);
            }
        } catch (\Throwable $th) {
            throw new \ErrorException("Invalid JWT", 401);
        }
    }
}