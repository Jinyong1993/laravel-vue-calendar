<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Event;

class CalendarController extends Controller
{
    public function main()
    {
        return Inertia::render('Calendar/CalendarMain');
    }

    public function dateBoard(Request $request)
    {
        $year = $request->year ?? date('Y');
        $month = $request->month ?? date('n');
        $query = array();

        // フォーメット　01,02...12
        $month = sprintf('%02d', $month);

        $first_date = "$year-$month-01";
        $time_stamp = strtotime($first_date);
        $last_date = date('Y-m-t', $time_stamp);

        $selects = Event::where('event.user_id', auth()->user()->id)
                        ->where('event.date_from', '<=', $last_date)
                        ->where('event.date_to', '>=', $first_date)
                        ->leftjoin('tag', 'tag.tag_id', '=', 'event.tag_id')
                        ->select('event.*', 'tag.tag_id', 'tag.tag_color')
                        ->get();

        foreach($selects as $select){
            if($select->date_from <= $first_date){
                $from = $first_date; // 1
            } else {
                $from = $select->date_from;
            }

            if($select->date_to <= $last_date){
                $to = $select->date_to;
            } else {
                $to = $last_date;
            }

            $from = date('d', strtotime($from));
            $to = date('d', strtotime($to));

            // 配列生成
            $day_range = range($from, $to);

            foreach($day_range as $day){
                $query[$day][] = $select;
            }
        }
        return $query;
    }

    public function eventUpdate(Request $request)
    {
        $event = Event::find($request->event_id);

        if(!$event){
            return;
        }

        $event->update([
            'title' => $request->title,
            'text' => $request->text,
            'date_from' => $request->date_from,
            'date_to' => $request->date_to,
            'tag_id' => $request->tag_id,
            'user_id' => auth()->user()->id,
            'updated_at' => date('Y-m-d H:i:s'),
        ]);

        return ['result' => true];
    }
}
