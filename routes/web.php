<?php

use App\Ai\Agents\ChatAgent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/ai-test', function(){
    $response = (new ChatAgent)->prompt('What is capital of India?');
    return response()->json([
        'response'=> (string) $response
    ]);
});

Route::get('chat',function(){
    return view('chat');
})->name('chat');

Route::get('/chat/stream', function(Request $request){
    $request->validate([
        'message'=>'required|string'
    ]);
   
    $response = (new ChatAgent)->stream($request->message);
    return $response;
})->name('chat.stream');