;;; config.el -*- lexical-binding: t; -*-

;;; ユーザー情報
(setq user-full-name "Makoto Ito"
      user-mail-address "makoto.ito@tsukasa-ind.co.jp")

;;; Appearance

;; フォント (packages.nix の udev-gothic を使用)
(setq doom-font (font-spec :family "UDEV Gothic" :size 15)
      doom-variable-pitch-font (font-spec :family "UDEV Gothic" :size 15))

;; Braille Pattern (U+2800-28FF) 用フォント指定
;; UDEV Gothic / Nerd Fontsはこの範囲のグリフを持たず、fontconfigのフォールバックが
;; Unifont (ビットマップ、advance widthの設計特性が大きく異なる) まで到達してしまう。
;; Claude Code等のCLIツールがthinkingスピナーにBraille Patternを使うと、
;; vterm内で横方向に表示がズレる (emacs-libvterm issue #563と同種の現象)。
;; Adwaita MonoはBraille Patternをネイティブ・等幅で持つため明示的に割り当てる。
(add-hook 'after-setting-font-hook
          (lambda ()
            (set-fontset-font t '(#x2800 . #x28FF) "Adwaita Mono")))

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

;; <C-n>: ファイルツリーを表示してフォーカス
(map! :n "C-n" #'treemacs-select-window)

;; <C-S-n>: ファイルツリーを非表示
(defun my-treemacs-hide ()
  (interactive)
  (when-let ((win (treemacs-get-local-window)))
    (delete-window win)))
(map! :n "C-S-n" #'my-treemacs-hide)

;; <C-`>: フローティングターミナル (toggleterm の <C-`> 相当)
(map! :n "C-`" #'+vterm/toggle)

;; <F2>: LSPリネーム (neovim: vim.lsp.buf.rename)
(map! :n "<F2>" #'lsp-rename)

;; <F12>: 定義へジャンプ (neovim: vim.lsp.buf.definition / doom: g d と同等)
(map! :n "<F12>" #'lsp-find-definition)

;;; Treemacs (VSCode サイドバーライク設定)
;; 参考: https://apribase.net/2024/06/01/emacs-treemacs-like-vscode/
(after! treemacs
  (setq treemacs-width 30
        ;; VSCode のようにサイドバーのフォントを1段階小さく
        treemacs-text-scale -1
        treemacs-git-executable (executable-find "git")
        ;; 永続ファイルを XDG データディレクトリに移動
        treemacs-persist-file
        (expand-file-name "~/.local/share/emacs/treemacs/persist.org")
        treemacs-last-error-persist-file
        (expand-file-name "~/.local/share/emacs/treemacs/persist-last-error.org"))

  ;; シングルクリックでファイルを開く (VSCode デフォルト)
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action)
  ;; r でリネーム
  (define-key treemacs-mode-map "r" #'treemacs-rename-file)

  ;; シングルクリック後もフォーカスをTreemacsに残す (VSCode挙動)
  (defun my-treemacs-keep-focus (&rest _)
    (select-window (treemacs-get-local-window)))
  (advice-add 'treemacs-single-click-expand-action :after #'my-treemacs-keep-focus)

  ;; 右フリンジの継続・切り詰め矢印を非表示 (VSCode like)
  (defun my-treemacs-hide-fringe-indicators ()
    (setq-local fringe-indicator-alist
                (let ((alist (copy-tree fringe-indicator-alist)))
                  (setf (cdr (assq 'truncation alist)) '(nil nil)
                        (cdr (assq 'continuation alist)) '(nil nil))
                  alist)))
  (add-hook 'treemacs-mode-hook #'my-treemacs-hide-fringe-indicators)

  ;; プロジェクト単位の自動追従・ファイル監視・git状態表示
  (treemacs-project-follow-mode 1)
  (treemacs-filewatch-mode 1)
  (treemacs-git-mode 'simple)

  ;; ファイル無視リスト (node_modules, .direnv 等)
  (push (lambda (file _)
          (or (string= file ".clj-kondo")
              (string= file ".direnv")
              (string= file ".lsp")
              (string= file "node_modules")
              (string= file ".pre-commit-config.yaml")
              (string= file ".shadow-cljs")))
        treemacs-ignored-file-predicates))

;; nerd-icons テーマ (テキストスケール変更時もアイコンサイズが連動する)
(use-package! treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

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
