;;; init.el -*- lexical-binding: t; -*-

(doom! :input
       ;;japanese

       :completion
       company              ; nvim-cmp 相当のコード補完
       vertico              ; telescope 相当のミニバッファ補完UI

       :ui
       doom                 ; Doom UIの基本スタイル
       doom-dashboard       ; スタート画面
       hl-todo              ; TODO/FIXME ハイライト
       indent-guides        ; hlchunk 相当のインデントガイド
       (ligatures +extra)   ; リガチャサポート
       modeline             ; lualine 相当のステータスバー
       nav-flash            ; ジャンプ後にカーソル行をフラッシュ
       ophints              ; 操作範囲の視覚的フィードバック
       (popup +defaults)    ; ポップアップウィンドウ管理
       treemacs             ; neo-tree 相当のファイルツリー
       (vc-gutter +pretty)  ; Git差分をフリンジに表示
       vi-tilde-fringe      ; バッファ末尾の ~ 表示
       (window-select +numbers) ; ウィンドウ番号付き選択
       workspaces           ; タブ/ワークスペース管理
       which-key            ; which-key 相当のキーバインドナビ

       :editor
       (evil +everywhere)   ; Vim操作（全バッファで有効化）
       file-templates       ; 空ファイル用スニペット
       fold                 ; コード折りたたみ
       (format +onsave)     ; formatter.nvim 相当（保存時自動フォーマット, apheleia使用）
       multiple-cursors     ; 複数カーソル編集
       rotate-text          ; テキスト候補のサイクル
       snippets             ; スニペット

       :emacs
       dired                ; ファイルマネージャー
       electric             ; 電気的インデント
       (ibuffer +icons)     ; バッファ一覧
       undo                 ; 永続的なUndo履歴
       vc                   ; バージョン管理統合

       :term
       vterm                ; toggleterm 相当の端末エミュレータ

       :checkers
       syntax               ; LSP diagnostics / flycheck

       :tools
       (debugger +lsp)      ; nvim-dap 相当のデバッガー (Go remote debug対応)
       (eval +overlay)      ; コード実行オーバーレイ
       (lookup +dictionary) ; 定義/参照ジャンプ
       (lsp +peek)          ; neovim LSP 相当
       (magit +forge)       ; neogit + diffview 相当

       :os
       tty                  ; ターミナル環境の改善

       :lang
       (clojure +lsp)       ; Clojure (elin→CIDER)
       emacs-lisp           ; Emacs Lisp
       (fsharp +lsp)        ; F# (ionide-vim 相当)
       (go +lsp +tree-sitter) ; Go (go.nvim 相当)
       (javascript +lsp +tree-sitter) ; TypeScript/JavaScript (ts_ls相当)
       lua                  ; Lua (neovim設定ファイル用)
       markdown             ; Markdown
       nix                  ; Nix設定ファイル
       (org +pretty)        ; Org mode
       sh                   ; シェルスクリプト
       (web +lsp)           ; HTML/CSS/Svelte

       :config
       (default +bindings +smartparens))
