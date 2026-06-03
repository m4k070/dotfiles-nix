;;; config.el -*- lexical-binding: t; -*-

;;; ユーザー情報
(setq user-full-name "Makoto Ito"
      user-mail-address "makoto.ito@tsukasa-ind.co.jp")

;;; Appearance

;; フォント (packages.nix の udev-gothic を使用)
(setq doom-font (font-spec :family "UDEV Gothic" :size 14)
      doom-variable-pitch-font (font-spec :family "UDEV Gothic" :size 15))

;; Kanagawa テーマ (kanagawa.nvimと統一, doom sync後に有効)
(setq doom-theme 'kanagawa-wave)

;; 相対行番号 (neovim デフォルト動作と統一)
(setq display-line-numbers-type 'relative)

;;; Editor

;; タブ幅2・スペースインデント (tabstop=2, expandtab)
(setq-default tab-width 2
              indent-tabs-mode nil)

;; 垂直分割を右に開く (splitright相当)
(setq evil-vsplit-window-right t
      evil-split-window-below nil)

;; 検索: ignorecase + smartcase
(setq evil-ex-search-case 'smart)

;;; Keybindings
;;
;; Neovim → Doom Emacs 主要バインド対応表:
;;   <leader>ff  →  SPC f f   (find-file)
;;   <leader>fg  →  SPC s p   (search project / live grep)
;;   <leader>fb  →  SPC b b   (switch buffer)
;;   <leader>fh  →  SPC h h   (help)
;;   <leader>fr  →  SPC c f r (lsp-find-references) / g r
;;   <leader>fq  →  SPC f r   (recent files, frecencyの近似)
;;   <leader>c   →  g c c     (evil-commentary: コメントトグル)
;;   <leader>b   →  g c <motion> (ブロックコメント)
;;   <leader>e   →  SPC c e   (diagnostics)
;;   g d / <F12> →  lsp-find-definition
;;   SPC c r     →  lsp-rename

;; <C-n>: ファイルツリー (neo-tree の <C-n> 相当)
(map! :n "C-n" #'treemacs)

;; <C-`>: フローティングターミナル (toggleterm の <C-`> 相当)
(map! :n "C-`" #'+vterm/toggle)

;; <F2>: LSPリネーム (neovim: vim.lsp.buf.rename)
(map! :n "<F2>" #'lsp-rename)

;; <F12>: 定義へジャンプ (neovim: vim.lsp.buf.definition / doom: g d と同等)
(map! :n "<F12>" #'lsp-find-definition)

;;; Treemacs (neo-tree設定の移植)
(after! treemacs
  (setq treemacs-width 30
        treemacs-follow-mode t
        treemacs-filewatch-mode t))

;;; LSP
(after! lsp-mode
  ;; neovim の mason に相当するサーバーは nix (packages-common.nix) で管理済み
  (setq lsp-auto-guess-root t
        lsp-idle-delay 0.5))

;;; Formatter (formatter.nvim → apheleia)
;;
;; Go: gofmt は go module が処理 (apheleia のデフォルト)
;; JS/TS: biome を使用 (neovim の formatter.nvim と同じ)
(after! apheleia
  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))
  (dolist (mode '(typescript-mode
                  typescript-tsx-mode
                  js-mode
                  js2-mode
                  rjsx-mode
                  svelte-mode))
    (setf (alist-get mode apheleia-mode-alist) 'biome)))

;;; Go DAP (nvim-dap-go の remote debug設定を移植)
(after! dap-go
  (dap-register-debug-template "Go Remote"
    (list :type "go"
          :request "attach"
          :name "Debug the golang"
          :mode "remote"
          :port 2345
          :host "127.0.0.1")))

;;; Svelte
(use-package! svelte-mode
  :mode "\\.svelte\\'")

;;; Clojure (elin → CIDER)
(after! cider
  (setq cider-repl-pop-to-buffer-on-connect t
        cider-show-error-buffer t))

;;; F# (ionide-vim → lsp-mode + fsautocomplete)
(after! fsharp-mode
  (setq inferior-fsharp-program "dotnet fsi"))
