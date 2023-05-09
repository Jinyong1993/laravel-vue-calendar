<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\BoardComment;

class BoardCommentCreateRequest extends FormRequest
{
    private $comment;

    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\Rule|array|string>
     */
    public function rules(): array
    {
        return [
            'note' => 'required',
            // 'title' => ['required', 'unique:posts', 'max:255'],
        ];
    }

    public function messages()
    {
        return [
            'note.required' => '必須項目です',
            // 'email.email' => 'メールアドレスの形式で入力してください',
            // 'name属性.ルール名' => '変更後のメッセージ',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     *
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'note' => 'コメント内容',
            // 'author.name' => '著者名',
            // 'author.description' => '著者詳細',
        ];
    }

    public function store() {
        $comment = new BoardComment();
        $comment->note = $this->note;
        $comment->board_id = $this->board_id;
        $comment->user_id = auth()->user()->id;

        return $comment->save();
    }
}
