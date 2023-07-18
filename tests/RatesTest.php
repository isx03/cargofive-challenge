<?php

namespace Tests;

use Illuminate\Http\UploadedFile;

class RatesTest extends TestCase
{
    public function testGetRatesEndpointReturnsSuccessfulResponse(): void
    {
        $responseAuthenticate = $this->call('POST', '/authenticate',[
            'email' => env('USER_EMAIL'),
            'password' => env('USER_PASSWORD')
        ]);

        $contentAuthenticate = json_decode($responseAuthenticate->content());

        $this->get('/rates', [
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

    public function testGetRatesEndpointReturnsUnauthorizedBearerTokenRequiredResponse(): void
    {
        $this->get('/rates');
        $this->seeStatusCode(401);
        $this->seeJsonStructure(
            [
                "message"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("Unauthorized: Bearer token required", $content->message);
    }

    public function testGetRatesEndpointReturnsUnauthorizedInvalidJwtResponse(): void
    {
        $this->get('/rates', [
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

    public function testLoadRatesEndpointReturnsSucessFully(): void
    {
        $responseAuthenticate = $this->call('POST', '/authenticate',[
            'email' => env('USER_EMAIL'),
            'password' => env('USER_PASSWORD')
        ]);
        
        $contentAuthenticate = json_decode($responseAuthenticate->content());

        $file = new UploadedFile(
            base_path('tests/files/correct_data.xlsx'),
            'correct_data.xlsx',
            null,
            null,
            true
        );

        $response = $this->post('/rates', [
            'file' => $file
        ], [
            'Authorization' => "Bearer {$contentAuthenticate->token}"
        ]);

        $this->seeStatusCode(201);
        $this->seeJsonStructure(
            [
                "message"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("Rates saved successfully", $content->message);
    }
}
