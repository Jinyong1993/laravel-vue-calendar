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
        $board = Board::find($request->board_id);

        return Inertia::render('Board/BoardEdit', [
            'board' => $board,
        ]);
    }

    public function save(Request $request)
    {
        Board::find($request->board_id)
        ->update([
            'title' => $request->title,
            'note' => $request->note,
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        return redirect()->route('board.list');
    }
}
