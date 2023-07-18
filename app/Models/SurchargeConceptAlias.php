<?php

namespace App\Models;

use App\Models\SurchargeConcept;
use Illuminate\Database\Eloquent\Model;

class SurchargeConceptAlias extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'surcharge_concept_aliases';
    
    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    public function surchargeConcept(): BelongsTo
    {
        return $this->belongsTo(SurchargeConcept::class);
    }
}
