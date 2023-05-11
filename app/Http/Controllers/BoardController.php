<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\Board;
use Exception;

class BoardController extends Controller
{
    public function list()
    {
        return Inertia::render('Board/BoardMain');
    }

    public function getBoard(Request $request)
    {
        // ページネーション
        $page_now = $request->page['page_now'];
        $per_page = $request->page['per_page'];
        $total_row = null;
        $total_page = null;
        $offset = $per_page * ($page_now - 1);

        $query = Board::select('board.*');

        // ソート
        if($request->sort) {
            $query->orderBy($request->sort['name'], $request->sort['order']);
        } else {
            $query->orderBy('board_id', 'desc');
        }

        $total_row = $query->count();
        $total_page = ceil($total_row / $per_page);

        $boards = $query
        ->offset($offset)->limit($per_page)->get()->all();
        // $data = array_slice($boards, $offset, $per_page);

        return [
            'data' => $boards,
            'total_row' => $total_row,
            'total_page' => $total_page,
        ];
    }

    public function getBoardContent(Request $request)
    {
        $user_id = auth()->user()->id;
        $board = Board::find($request->board_id);
        if(!$board){
            return redirect()->route('board.list')->withErrors('処理中にエラーが発生しました。');
        }
        $board_comments = $board->comments()->get();

        return Inertia::render('Board/BoardContent', [
            'board' => $board,
            'board_comments' => $board_comments,
            'user_id' => $user_id,
        ]);
    }

    public function boardEdit(Request $request)
    {
        if(isset($request->board_id)){
            $board = Board::find($request->board_id);
        } else {
            $board = null;
        }

        return Inertia::render('Board/BoardEdit', [
            'board' => $board,
        ]);
    }

    public function save(Request $request)
    {
        try {
            if(!$request->title && !$request->note){
                return redirect()->back();
            }
            if($request->board_id){
                Board::find($request->board_id)
                ->update([
                    'title' => $request->title,
                    'note' => $request->note,
                ]);
            } else {
                $board = new Board();
                $board->title = $request->title;
                $board->note = $request->note;
                $board->user_id = auth()->user()->id;

                $board->save();
            }

            return redirect()->route('board.list')->with('message', '保存しました。');
        } catch(\Throwable $th) {
            return redirect()->route('board.list')->withErrors('処理中にエラーが発生しました。');
        }
    }

    public function delete(Request $request)
    {
        try {
            $board = Board::find($request->board_id);

            if(!$board){
                throw new Exception();
            }

            $board->delete();

            return redirect()->route('board.list')->with('message', '削除しました。');
        } catch(\Throwable $th) {
            return redirect()->route('board.list')->withErrors('処理中にエラーが発生しました。');
        }
    }
}
