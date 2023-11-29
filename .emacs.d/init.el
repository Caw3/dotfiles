(add-to-list 'default-frame-alist '(font . "JetBrains Mono-10"))
(add-to-list 'default-frame-alist '(line-spacing . 0.2))
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(display-battery-mode 0)
(blink-cursor-mode 0)

(setq inhibit-startup-message t)
(setq default-directory (expand-file-name "~/"))

;; Change backups directory to emacs folder
;; this avoid to save backup files in the same directory of the original files
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
                                               "backups"))))
;; Revert dired and other buffers when there are changes on disk
(setq global-auto-revert-non-file-buffers t)

;; Hide the bell in the center of screen
(setq ring-bell-function 'ignore)

;; Navigate through buffers
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

;; Fix unicode errors
(setenv "LANG" "en_US.UTF-8")
(setenv "LC_ALL" "en_US.UTF-8")
(setenv "LC_CTYPE" "en_US.UTF-8")

;; Fix size of scroll
(setq scroll-step 1
      scroll-conservatively  10000)

;; Avoid close emacs by mistake
(global-unset-key (kbd "C-x C-c"))

(defalias 'yes-or-no-p 'y-or-n-p)

;; place custom code generated for emacs in a separate file
(defconst custom-file (expand-file-name ".customize.el" user-emacs-directory))
(load custom-file :noerror)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)
(require 'use-package)

(require 'undo-tree)
(global-undo-tree-mode)

;; Use vim keybindings globally
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-fine-undo t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  ;; show a list of available interactive functions
  (evil-define-key 'normal 'global (kbd "<leader>SPC") #'(lambda ()
                                                           (interactive)
                                                           (call-interactively #'execute-extended-command)))
  (evil-define-key nil 'global (kbd "<leader>/") 'consult-ripgrep)
  ;; find in project using fuzzy search
  (evil-define-key nil 'global (kbd "<leader>e") 'project-find-file)
  (evil-define-key nil 'global (kbd "<leader>f") 'find-file)
  (evil-define-key nil 'global (kbd "<leader>k") 'kill-buffer)
  ;; toggle native line numbers
  (evil-define-key nil 'global (kbd "<leader>l") 'display-line-numbers-mode)
  (evil-define-key nil 'global (kbd "<leader>n") 'evil-buffer-new)
  ;; fuzzy search for current buffer content
  (evil-define-key nil 'global (kbd "<leader>q") 'consult-line)
  (evil-define-key nil 'global (kbd "<leader>y") 'consult-yank-from-kill-ring)
  ;; magit
  (evil-define-key nil 'global (kbd "<leader>g") 'magit)
  ;; Dired
  (define-key evil-normal-state-map (kbd "-") 'dired-jump))

(use-package evil-collection
 :after evil
 :ensure t
:config
(evil-collection-init))

;; A pretty modeline with useful information
(use-package doom-modeline
  :ensure t
  :defer t
  :custom
  ;; show evil state in modeline
  (doom-modeline-modal-icon nil)
  ;; file path will be relative to project root
  (doom-modeline-buffer-file-name-style 'relative-from-project)
  :hook
  (after-init . doom-modeline-mode))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-nord t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package evil-matchit
  :ensure t
  :config (global-evil-matchit-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :ensure t
  :after (evil)
  :config
  (evil-commentary-mode))

(use-package markdown-mode
  :ensure t
  :defer t)

;; add pair parenthesis, square brackets, etc
(add-hook 'prog-mode-hook 'electric-pair-mode)

;; disable `electric-pair-mode' in `org-mode', to avoid conflict with
;; `<s' source block
(add-hook 'org-mode-hook #'(lambda ()
                             (electric-pair-local-mode -1)))

(use-package consult
  :ensure t)

;; Show a marker in fringe area when there is a change in the current
;; buffer
(use-package diff-hl
  :ensure t
  :custom
  (diff-hl-show-staged-changes nil)
  :init
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)
  :config
  (global-diff-hl-mode))

;; UI for completion
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  ;; fixed height
  (vertico-resize nil)
  ;; show max 15 elements
  (vertico-count 15))

;; Enhance information in completion
(use-package marginalia
  :ensure
  :init
  (marginalia-mode))

;; Better completion style
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

;; Show help about the keys pressed
(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-minibuffer))

;; Magit
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

;; Completion at point support
(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous))
  :init
  (global-corfu-mode)
  :config
  ;; make corfu play well with evil-mode
  ;; https://github.com/minad/corfu/issues/12#issuecomment-869037519
  (with-eval-after-load 'evil
    (evil-make-overriding-map corfu-map)
    (advice-add 'corfu--setup :after 'evil-normalize-keymaps)
    (advice-add 'corfu--teardown :after 'evil-normalize-keymaps)))

(use-package vterm
  :ensure t
  :config

  (defvar last-window nil
	"The last window used before switching to vterm.")

  (defun open-or-switch-to-vterm ()
    "Toggle between the current window and vterm."
    (interactive)
    (let ((current-window (selected-window))
	  (vterm-window (get-buffer-window "*vterm*")))
      (if (eq current-window vterm-window)
	  (if (one-window-p)
	      (switch-to-buffer (other-buffer (current-buffer)))
	    (when (window-live-p last-window)
	      (select-window last-window)))
	(if (eq current-window vterm-window)
	    (when (window-live-p last-window)
	      (select-window last-window))
	  (setq last-window current-window)
	  (if (window-live-p vterm-window)
	      (select-window vterm-window)
	    (if (and (one-window-p t)
		     (equal (buffer-name) "*scratch*"))
		(vterm)
	      (let ((new-window (split-window-below -20)))
		(select-window new-window)
		(vterm))))))))

  (defun my-disable-evil-in-vterm ()
	"Disable evil-mode in vterm."
	(setq evil-insert-state-cursor 'box)
	(evil-emacs-state))

  (evil-set-initial-state 'vterm-mode 'emacs)

  (add-hook 'vterm-mode-hook 'my-disable-evil-in-vterm)
  (add-hook 'vterm-exit-functions
	    (lambda (_ _)
	      (let* ((buffer (current-buffer))
		     (window (get-buffer-window buffer)))
		(when (not (one-window-p))
		  (delete-window window))
		(kill-buffer buffer))))
  (add-hook 'vterm-mode-hook (lambda () (setq mode-line-format nil)))

  ;; KEY binding in evil-mode
  (evil-define-key 'normal 'global (kbd "C-`") 'open-or-switch-to-vterm)
  (evil-define-key 'emacs 'global (kbd "C-`") 'open-or-switch-to-vterm))
  
  (use-package undohist
    :ensure t
    :config
    (undohist-initialize))

(use-package org
  :ensure t)

;;; init.el ends here.
