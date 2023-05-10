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

    protected $casts = [
        'created_at' => 'datetime:Y-m-d H:i:s', // ←日付の形式を指定
        'updated_at' => 'datetime:Y-m-d H:i:s', // ←日付の形式を指定
    ];
}
