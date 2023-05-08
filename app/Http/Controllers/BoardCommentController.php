<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\Board;
use App\Models\BoardComment;
use App\Http\Requests\BoardCommentRequest;

class BoardCommentController extends Controller
{
    public function store(BoardCommentRequest $request)
    {
        try {
            $comment = new BoardComment();
            $comment->note = $request->note;
            $comment->board_id = $request->board_id;
            $comment->user_id = auth()->user()->id;

            $comment->save();

            return redirect()->back();
        } catch (Exception $e) {
            return $request->messages();
        }
    }

    public function update(BoardCommentRequest $request)
    {
        BoardComment::find($request->comment_id)
        ->update([
            'note' => $request->note,
        ]);

        return redirect()->back();
    }

    public function delete(Request $request)
    {
        BoardComment::find($request->comment_id)->delete();

        return redirect()->back();
    }
}
