<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Models\Event;
use App\Models\Tag;

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
                        ->select('event.*', 'tag.tag_id', 'tag.tag_color', 'tag.tag_name')
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
        if(!$request->event_id){
            $event = new Event();

            $event->title = $request->title;
            $event->text = $request->text;
            $event->date_from = $request->date_from;
            $event->date_to = $request->date_to;
            $event->user_id = auth()->user()->id;
            $event->tag_id = $request->tag_id ?? 0;
            $event->updated_at = date('Y-m-d H:i:s');
            $event->created_at = date('Y-m-d H:i:s');

            $event->save();
        } else {
            $event = Event::find($request->event_id);

            $event->update([
                'title' => $request->title,
                'text' => $request->text,
                'date_from' => $request->date_from,
                'date_to' => $request->date_to,
                'tag_id' => $request->tag_id,
                'user_id' => auth()->user()->id,
                'updated_at' => date('Y-m-d H:i:s'),
            ]);
        }

        return ['result' => true];
    }

    public function colorUpdate(Request $request)
    {
        if(!$request->tag_id){
            $tag = new Tag();

            $tag->tag_name = $request->tag_name;
            $tag->tag_note = $request->tag_note;
            $tag->tag_color = $request->tag_color;
            $tag->user_id = auth()->user()->id;
            $tag->updated_at = date('Y-m-d H:i:s');
            $tag->created_at = date('Y-m-d H:i:s');

            $tag->save();
        } else {
            $tag = Tag::find($request->tag_id);

            $tag->update([
                'tag_name' => $request->tag_name,
                'tag_note' => $request->tag_note,
                'tag_color' => $request->tag_color,
                'tag_id' => $request->tag_id,
                'user_id' => auth()->user()->id,
                'updated_at' => date('Y-m-d H:i:s'),
            ]);
        }

        return ['result' => true];
    }

    public function eventDelete(Request $request)
    {
        if(!$request->event_id){
            return ['result' => false];
        }

        Event::find($request->event_id)->delete();

        return ['result' => true];
    }

    public function colorDelete(Request $request)
    {
        if(!$request->tag_id){
            return ['result' => false];
        }

        Tag::find($request->tag_id)->delete();

        return ['result' => true];
    }

    public function myColor(Request $request)
    {
        $query = Tag::select('tag.*')
        ->where('tag.user_id', auth()->user()->id)
        ->get()->all();

        return $query;
    }

    public function searchEvent(Request $request)
    {
        $q = Event::select('event.*')
        ->where('event.user_id', auth()->user()->id)
        // ->where('event.title', 'LIKE', '%'.$request->search_title.'%')
        ->get()->all();

        return $q;
    }
}
