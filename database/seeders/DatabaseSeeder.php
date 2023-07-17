<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $this->call([UsersTableSeeder::class]);
        ini_set('memory_limit', '-1');
        \DB::unprepared(file_get_contents(__dir__ . '/../backup/challenge.sql'));
    }
}
