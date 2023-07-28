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
     * php artisan make:model LinkedSocialAccount --migration => migration
     *
     * php artisan migrate
     */
    public function up(): void
    {
        Schema::create('linked_social_accounts', function (Blueprint $table) {
            $table->increments('id');
            $table->bigInteger('user_id');
            $table->string('provider_name')->nullable();
            $table->string('provider_id')->unique()->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('linked_social_accounts');
    }
};
