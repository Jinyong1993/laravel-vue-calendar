<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Laravel\Socialite\Facades\Socialite;
use Illuminate\Support\Facades\Auth;

class OAuthLoginController extends Controller
{
    /**
     * 実装に参考したサイト
     * https://zenn.dev/naoki_oshiumi/articles/0f463859b6b462
     * https://zenn.dev/naoki_oshiumi/articles/80ab178d958447
     * https://qiita.com/u-dai/items/91df3b923dc82fed5b76
     * https://tech.bita.jp/article/28
     * https://reffect.co.jp/laravel/socialiote/
     *
     *
     * https://qiita.com/_______________/items/820058f690b4f0f4192a => Socialiteについて（下記のコードがよくわからんかったら）
     *
     * composer require laravel/socialite => Socialiteインストール
     *
     * https://ascii.jp/elem/000/001/477/1477126/ => database
     */

    public function getGoogleAuth()
    {
        // googleのアカウント選択画面にリダイレクトされ、どのアカウントでログイン・会員登録するかを選ぶことができる
        return Socialite::driver('google')->redirect();
    }

    public function authGoogleCallback()
    {
        // googleのアカウントからユーザー情報を取得
        $googleUser = Socialite::driver('google')->stateless()->user();

        // DBに保存する処理
        $user = User::firstOrCreate([
            'email' => $googleUser->email
        ], [
            'email_verified_at' => now(),
            'google_id' => $googleUser->getId()
        ]);

        Auth::login($user, true);

        // リダイレクト（ここではカレンダーのメインページ）
        return redirect('/home');
    }
}
