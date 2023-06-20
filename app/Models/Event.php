<?php

namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    protected $table = 'event';
    protected $primaryKey = 'event_id';
    protected $connection = 'mysql';

    protected $fillable = [
        'event_id',
        'user_id',
        'date_from',
        'date_to',
        'title',
        'text',
        'tag_id',
        'repeat_date',
        'updated_at',
        'created_at',
    ];

    public function tag()
    {
        return $this->belongsTo(Tag::class, 'tag_id', 'tag_id');
    }
}

