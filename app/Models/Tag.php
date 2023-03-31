<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tag extends Model
{
    protected $table = 'tag';
    protected $primaryKey = 'tag_id';

    protected $fillable = [
        'tag_id',
        'user_id',
        'tag_name',
        'tag_note',
        'tag_color',
        'updated_at',
        'created_at',
    ];
}
