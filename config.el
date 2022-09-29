;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Kyubuem Lim"
      user-mail-address "kyubuem@gmail.com")

(unless (equal "Baterry status not available"
               (battery))
  (display-battery-mode 1))

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;;
(setq doom-font (font-spec :family "Fira Code Retina" :size 13)
      doom-variable-pitch-font (font-spec :family "Roboto" :size 13)
      doom-unicode-font (font-spec :family "D2Coding" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-palenight)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Library/Projects/org")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(setq ccls-args '("--init={\"cache\":{\"directory\":\"/home/goodboy/.cache/ccls\"},\"cacheFormat\":\"json\",\"compilationDatabaseDirectory\":\"build\",\"index\":{\"threads\":2}}"))
(setq lsp-lens-enable nil)

;;(add-to-list 'initial-frame-alist '(fullscreen . maximized))
;;(add-hook 'window-setup-hook #'toggle-frame-maximized)
;;(add-hook 'window-setup-hook #'toggle-frame-fullscreen)
;;(add-hook 'window-setup-hook #'toggle-frame)

(setq org-startup-with-inline-images t)

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

(setq plantuml-executable-path "/opt/homebrew/bin/plantuml")
(setq plantuml-default-exec-mode 'executable)

(add-hook 'evil-insert-state-exit-hook (lambda ()
                                         (setq evil-input-method nil)))

(setq default-input-method "korean-hangul")
;;(global-set-key (kbd "<S-SPC>") 'toggle-input-method)

(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))

(setq lsp-file-watch-threshold (* 1024 1024))
(setq read-process-output-max (* 10 1024 1024))

(setq lsp-auto-guess-root t)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(setq lsp-enable-file-watchers nil)

(use-package! cmake-mode
  :hook (cmake-mode . lsp-deferred))


(use-package! cmake-font-lock
  :after cmake-mode
  :config (cmake-font-lock-activate))

(use-package! clang-format
  :init
  (setq clang-format-executable "/opt/homebrew/bin/clang-format")
  (defun clang-format-save-hook-for-this-buffer ()
    "Create a buffer local save hook."
    (add-hook 'before-save-hook
              (lambda ()
                (progn
                  (when (locate-dominating-file "." ".clang-format")
                    (clang-format-buffer))
                  nil))
              nil
              t)))

(add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defun ccls/callee () (interactive) (lsp-ui-peek-find-custom "$ccls/call" '(:callee t)))
(defun ccls/caller () (interactive) (lsp-ui-peek-find-custom "$ccls/call"))

(use-package flycheck-clang-tidy
  :after flycheck
  :hook
  (flycheck-mode . flycheck-clang-tidy-setup)
  )

(setq flycheck-clang-tidy-executable "/opt/homebrew/Cellar/llvm/15.0.1/bin/clang-tidy")
