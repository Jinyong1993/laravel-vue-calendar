<?php

namespace App\Traits;

use App\Models\BoardComment;

trait BoardCommentRequestAuthorizeMine
{
    public function authorize(): bool
    {
        $this->comment = BoardComment::find($this->comment_id);

        return !(
            empty($this->comment) ||
            $this->comment->user_id != auth()->user()->id
        );
    }
}
