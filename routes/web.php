<?php

use Illuminate\Foundation\Application;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use App\Http\Controllers\ExampleController;
use App\Http\Controllers\CalendarController;
use App\Http\Controllers\BoardController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
        'laravelVersion' => Application::VERSION,
        'phpVersion' => PHP_VERSION,
    ]);
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified',
])->group(function () {
    Route::get('/dashboard', function () {
        return Inertia::render('Dashboard');
    })->name('dashboard');
});

Route::prefix('example')->name('example.')->group(function () {
    Route::get('index', [ExampleController::class, 'index'])->name('index');
});

Route::prefix('calendar')->name('calendar.')->group(function () {
    Route::get('list', [CalendarController::class, 'list'])->name('list');
    Route::get('edit', [CalendarController::class, 'edit'])->name('edit');
    Route::get('dateBoard', [CalendarController::class, 'dateBoard'])->name('dateBoard');
    Route::get('myColor', [CalendarController::class, 'myColor'])->name('myColor');
    Route::get('searchEvent', [CalendarController::class, 'searchEvent'])->name('searchEvent');
    Route::post('eventUpdate', [CalendarController::class, 'eventUpdate'])->name('eventUpdate');
    Route::post('eventDelete', [CalendarController::class, 'eventDelete'])->name('eventDelete');
    Route::post('colorDelete', [CalendarController::class, 'colorDelete'])->name('colorDelete');
    Route::post('colorUpdate', [CalendarController::class, 'colorUpdate'])->name('colorUpdate');
});

Route::prefix('board')->name('board.')->group(function () {
    Route::get('list', [BoardController::class, 'list'])->name('list');
    Route::get('getBoard', [BoardController::class, 'getBoard'])->name('getBoard');
    Route::get('getBoardContent', [BoardController::class, 'getBoardContent'])->name('getBoardContent');
    Route::get('boardEdit', [BoardController::class, 'boardEdit'])->name('boardEdit');
    Route::post('save', [BoardController::class, 'save'])->name('save');
    Route::post('delete', [BoardController::class, 'delete'])->name('delete');
});
