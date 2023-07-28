<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LinkedSocialAccount extends Model
{
    use HasFactory;

    // $fillable配列に追加して、複数の値を保存できるように
    protected $fillable = [
        'provider_name',
        'provider_id',
    ];

    // public function user()
    // {
    //     return $this->belongsTo('user');
    // }
}
