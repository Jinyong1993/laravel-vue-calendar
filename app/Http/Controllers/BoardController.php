<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\Board;
use App\Models\BoardComment;

class BoardController extends Controller
{
    public function list()
    {
        return Inertia::render('Board/BoardMain');
    }

    public function getBoard(Request $request)
    {
        $page_now = $request->page;
        $per_page = $request->per_page;
        $total_row = null;
        $total_page = null;

        $offset = $per_page * ($page_now - 1);

        $query = Board::select('board.*');

        if($request->sort_target){
            if($request->order == 'asc'){
                $request->order = 'desc';
            } else {
                $request->order = 'asc';
            }
            $query->orderBy($request->sort_target, $request->order);
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

        return redirect()->route('board.list');
    }

    public function delete(Request $request)
    {
        Board::find($request->board_id)->delete();

        return redirect()->route('board.list');
    }
}
