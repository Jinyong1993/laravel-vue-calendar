<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Illuminate\Http\Request;
use App\Models\Board;

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

        $total_row = $query->count();
        $total_page = ceil($total_row / $per_page);

        $boards = $query
        ->offset($offset)->limit($per_page)->get()->all();
        // $data = array_slice($boards, $offset, $per_page);

        $result = [
            'data' => $boards,
            'total_row' => $total_row,
            'total_page' => $total_page,
        ];

        return $result;
    }

    public function getBoardContent(Request $request)
    {
        $board = Board::find($request->board_id);

        return Inertia::render('Board/BoardContent', [
            'board' => $board,
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
                'updated_at' => date('Y-m-d H:i:s'),
            ]);
        } else {
            $board = new Board();
            $board->title = $request->title;
            $board->note = $request->note;
            $board->user_id = auth()->user()->id;
            $board->updated_at = date('Y-m-d H:i:s');
            $board->created_at = date('Y-m-d H:i:s');

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
