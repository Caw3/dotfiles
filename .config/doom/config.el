;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(after! vterm
  (defun send-C-u-to-vterm () (interactive) (vterm-send-key "u" nil nil t))
  (map! :map vterm-mode-map
        "C-u" #'send-C-u-to-vterm)
  (defun my-disable-evil-in-vterm ()
    "Disable evil-mode in vterm."
    (setq evil-insert-state-cursor 'box)
    (evil-emacs-state))

  (evil-set-initial-state 'vterm-mode 'emacs)
  (add-hook 'vterm-exit-functions
	    (lambda (_ _)
	      (let* ((buffer (current-buffer))
		     (window (get-buffer-window buffer)))
		(when (not (one-window-p))
		  (delete-window window))
		(kill-buffer buffer))))
  (add-hook 'vterm-mode-hook (lambda () (setq mode-line-format nil ))))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:

;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 12))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(defun md-compile ()
  "Compiles the currently loaded markdown file using pandoc into a PDF"
  (interactive)
  (save-buffer)
  (shell-command (concat "pandoc " (buffer-file-name) " -o "
                         (replace-regexp-in-string "md" "pdf" (buffer-file-name)))))

(defun update-other-buffer ()
  (interactive)
  (other-window 1)
  (revert-buffer nil t)
  (other-window -1))

(defun md-compile-and-update-other-buffer ()
  "Has as a premise that it's run from a markdown-mode buffer and the
   other buffer already has the PDF open"
  (interactive)
  (md-compile)
  (update-other-buffer))

(defun latex-compile-and-update-other-buffer ()
  "Has as a premise that it's run from a latex-mode buffer and the
   other buffer already has the PDF open"
  (interactive)
  (save-buffer)
  (shell-command (concat "pdflatex " (buffer-file-name)))
  (switch-to-buffer (other-buffer))
  (kill-buffer)
  (update-other-buffer))

(defun org-compile-beamer-and-update-other-buffer ()
  "Has as a premise that it's run from an org-mode buffer and the
   other buffer already has the PDF open"
  (interactive)
  (org-beamer-export-to-pdf)
  (update-other-buffer))

(defun org-compile-latex-and-update-other-buffer ()
  "Has as a premise that it's run from an org-mode buffer and the
   other buffer already has the PDF open"
  (interactive)
  (org-latex-export-to-pdf)
  (update-other-buffer))

(map!
 :leader
 :map org-mode-map
 :n "mm" 'org-compile-latex-and-update-other-buffer)

(after! latex
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master "main")
  (setq ispell-change-dictionary-hook "en_GB"))

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
