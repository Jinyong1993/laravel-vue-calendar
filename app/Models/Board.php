<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Board extends Model
{
    protected $table = 'board';
    protected $primaryKey = 'board_id';

    use SoftDeletes;

    protected $fillable = [
        'board_id',
        'title',
        'note',
        'user_id',
        'hit',
        'updated_at',
        'created_at',
        'deleted_at',
    ];

    // 1:n セレクト
    public function comments()
    {
        return $this->hasMany(BoardComment::class, 'board_id', 'board_id');
    }
    public function board_file()
    {
        return $this->hasMany(BoardFile::class, 'board_id', 'board_id');
    }

}
