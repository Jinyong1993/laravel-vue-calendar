<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;

class CalendarController extends Controller
{
    public function main()
    {
        return Inertia::render('Calendar/CalendarMain');
    }
}
