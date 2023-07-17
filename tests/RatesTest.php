<?php

namespace Tests;

use Laravel\Lumen\Testing\DatabaseMigrations;
use Laravel\Lumen\Testing\DatabaseTransactions;

class RatesTest extends TestCase
{
    public function testRatesBySurchargesReturnsSuccessfulResponse(): void
    {
        $responseAuthenticate = $this->call('POST', '/authenticate',[
            'email' => env('USER_EMAIL'),
            'password' => env('USER_PASSWORD')
        ]);

        $contentAuthenticate = json_decode($responseAuthenticate->content());

        $this->get('/rates/surcharges', [
            'HTTP_Authorization' => "Bearer {$contentAuthenticate->token}"
        ]);
        $this->seeStatusCode(200);
        $this->seeJsonStructure(
            [
                "message",
                "data"
            ]
        );

    }

    public function testRatesBySurchargesReturnsUnauthorizedBearerTokenRequiredResponse(): void
    {
        $this->get('/rates/surcharges');
        $this->seeStatusCode(401);
        $this->seeJsonStructure(
            [
                "message"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("Unauthorized: Bearer token required", $content->message);
    }

    public function testRatesBySurchargesReturnsUnauthorizedInvalidJwtResponse(): void
    {
        $this->get('/rates/surcharges', [
            'HTTP_Authorization' => "Bearer " . env('INVALID_JWT')
        ]);
        $this->seeStatusCode(401);
        $this->seeJsonStructure(
            [
                "message"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("Invalid JWT", $content->message);
    }
}
