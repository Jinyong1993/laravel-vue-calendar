<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * OAuth
     * https://ascii.jp/elem/000/001/477/1477126/ => 参考したサイト
     * composer require doctrine/dbal => 既存テーブルのフィールドを変更する前にdoctrine/dbalパッケージをインストール
     * php artisan make:migration prepare_users_table_for_social_authentication --table users => migration
     *
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            // Making email and password nullable
            // $table->string('email')->nullable()->change();
            // $table->string('password')->nullable()->change();

        });
    }

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            // $table->string('email')->nullable(false)->change();
            // $table->string('password')->nullable(false)->change();

        });
    }
};
