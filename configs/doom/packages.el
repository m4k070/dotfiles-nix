;;; packages.el -*- lexical-binding: t; -*-

;; kanagawa.nvim と統一したテーマ
(package! kanagawa-themes)

;; Svelte サポート (:lang web は Svelte に未対応のため追加)
(package! svelte-mode)

;; vterm: ネイティブモジュールは nix (editor-common.nix) でビルド済み
;; straight による再ビルドを抑止してnix提供版を優先する
(package! vterm :built-in 'prefer)

;; treemacs-nerd-icons: アイコンフォント使用でテキストスケールに追従
(package! treemacs-nerd-icons)
