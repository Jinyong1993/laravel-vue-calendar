<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class BoardComment extends Model
{
    protected $table = 'board_comment';
    protected $primaryKey = 'comment_id';
    use SoftDeletes;

    protected $fillable = [
        'comment_id',
        'board_id',
        'note',
        'user_id',
        'updated_at',
        'created_at',
        'deleted_at',
    ];
}
