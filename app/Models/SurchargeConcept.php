<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SurchargeConcept extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'surcharge_concepts';
    
    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;
}
