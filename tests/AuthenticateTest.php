<?php

namespace Tests;

class AuthenticateTest extends TestCase
{
    public function testThatAuthenticateEndpointReturnsSuccessfulResponse(): void
    {
        $this->post('/authenticate', [
            'email' => env('USER_EMAIL'),
            'password' => env('USER_PASSWORD')
        ]);
        $this->seeStatusCode(200);
        $this->seeJsonStructure(
            [
                "message",
                "token"
            ]
        );
    }

    public function testAuthenticateEndpointWithoutParametersReturnsInternalErrorResponse(): void
    {

        $this->post('/authenticate');
        $this->seeStatusCode(500);
        $this->seeJsonStructure(
            [
                "message"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("The email field is required. (and 1 more error)", $content->message);
    }

    public function testAuthenticateEndpointWithParametersReturnsUnauthorizeResponse(): void
    {
        $this->post('/authenticate', [
            'email' => 'israel.flores@cargofive.com-',
            'password' => 'cargofive123.-'
        ]);
        $this->seeStatusCode(401);
        $this->seeJsonStructure(
            [
                "error"
            ]
        );
        $content = json_decode($this->response->content());
        $this->assertEquals("Unauthorized", $content->error);
    }
}
