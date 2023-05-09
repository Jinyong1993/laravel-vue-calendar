<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\Board;
use App\Models\BoardComment;
use App\Http\Requests\BoardCommentCreateRequest;
use App\Http\Requests\BoardCommentEditRequest;
use App\Http\Requests\BoardCommentDeleteRequest;

class BoardCommentController extends Controller
{
    public function store(BoardCommentCreateRequest $request)
    {
        try {
            $request->store();

            return redirect()
                ->back()
                ->with('message', '保存しました。');

        } catch (\Throwable $th) {
            return redirect()
                ->back()
                ->withErrors($request->messages());
        }
    }

    public function update(BoardCommentEditRequest $request)
    {
        try {
            $request->update();

            return redirect()
                ->back()
                ->with('message', '更新しました。');

        } catch(\Throwable $th) {
            return redirect()
                ->back()
                ->withErrors($request->messages());
        }
    }

    public function delete(BoardCommentDeleteRequest $request)
    {
        try {
            $request->delete();

            return redirect()
                ->back()
                ->with('message', '削除しました。');

        } catch(\Throwable $th) {
            return redirect()
                ->back()
                ->withErrors($request->messages());
        }

    }
}
