;; -*- emacs-lisp -*-
;;; Package.el
(setq gc-cons-threshold 8000000) ; augmente la taille du garbage collector
(package-initialize t)
(setq package-enable-at-startup nil)
(let ((default-directory "~/.emacs.d/elpa"))
  (normal-top-level-add-subdirs-to-load-path))
(require 'use-package)

(setq package-check-signature nil)
(setq package-enable-at-startup nil)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("gnu" . "https://elpa.gnu.org/packages/")))

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; bootstrap `quelpa'
(use-package quelpa
  :load-path "~/.emacs.d/private/quelpa"
  :config
  (setq quelpa-update-melpa-p nil)
  (use-package quelpa-use-package
    :load-path "~/.emacs.d/private/quelpa-use-package"))


(use-package general
  :quelpa (general :fetcher github :repo "noctuid/general.el"))
(use-package use-package-chords :config (key-chord-mode 1))
(use-package diminish)
(use-package bind-key)
(use-package server
  :config
  (unless (server-running-p) (server-start)))

;; met en place le serveur pour emacsclient
;;(unless (server-running-p) (server-start))

;;; Sane default
(setq
 use-package-verbose nil  ; use-package décrit les appels qu'il fait
 delete-old-versions -1	; supprime les vieilles versions des fichiers sauvegardés
 version-control t	; enable le version control
 vc-make-backup-files t	; backups file even when under vc
 vc-follow-symlinks t	; vc suit les liens  symboliques
 auto-save-file-name-transforms
 '((".*" "~/.emacs.d/auto-save-list/" t)); transforme les noms des fichiers sauvegardés
 inhibit-startup-screen t ; supprime l'écran d'accueil
 ring-bell-function 'ignore ; supprime cette putain de cloche.
 coding-system-for-read 'utf-8          ; use UTF8 pour tous les fichiers
 coding-system-for-write 'utf-8         ; idem
 sentence-end-double-space nil          ; sentences does not end with double space.
 default-fill-column 70
 initial-scratch-message ""
 save-interprogram-paste-before-kill t
 help-window-select t			; focus help window when opened
 tab-width 4                    ; tab are 4 spaces large
 )

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq-default indent-tabs-mode nil
              tab-width 4)

(prefer-coding-system 'utf-8)           ; utf-8 est le systeme par défaut.

(defalias 'yes-or-no-p 'y-or-n-p) ; remplace yes no par y n
(show-paren-mode) ; highlight delimiters
(line-number-mode) ; display line number in mode line
(column-number-mode) ; display colum number in mode line
(save-place-mode)    ; save cursor position between sessions
(setq initial-major-mode 'fundamental-mode)
;; supprime les caractères en trop en sauvegardant.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; apparences
(when window-system
  (tooltip-mode -1)                    ; don't know what that is
  (tool-bar-mode -1)                   ; sans barre d'outil
  (menu-bar-mode 1)                    ; barre de menu
  (scroll-bar-mode -1)                 ; enlève la barre de défilement
  (set-frame-font "Inconsolata 14")    ; police par défault
  (blink-cursor-mode -1)               ; pas de clignotement
  (global-visual-line-mode)
  (diminish 'visual-line-mode "") )

;; change la police par défault pour la frame courante et les futures.
(add-to-list 'default-frame-alist '(font . "Inconsolata 14"))
(set-face-attribute 'default nil :font "Inconsolata 14")

;; rend les scripts executable par défault si c'est un script.
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;;; keybindings

(when (eq system-type 'darwin)	; mac specific bindings
  (setq mac-right-command-modifier 'meta ; cmd de droite = meta
	mac-command-modifier 'control ; cmd de gauche = control
	mac-option-modifier 'super ; option de gauche = super
	mac-right-option-modifier nil ; option de droite = carac spéciaux
	mac-control-modifier 'hyper ; control de gauche = hyper (so does capslock)
	ns-function-modifier 'hyper ; fn key = hyper
	ns-right-alternate-modifier nil); cette touche n'existe pas.
  (setq locate-command "mdfind"))


;;; -------------------------------------------------------------------
;;; Packages

;;; -A-
(use-package abbrev :defer t
  :diminish "α"
  :init
  (add-hook 'text-mode-hook (lambda () (abbrev-mode 1)))
  ;; tell emacs where to read abbrev definitions from...
  (setq abbrev-file-name "~/dotfile/emacs/.abbrev_defs")
  (setq save-abbrevs 'silently))

(use-package ace-window :ensure t
  :commands
  ace-window
  :config
  (progn
    (setq aw-keys '(?t ?s ?r ?n ?m ?a ?u ?i ?e))
    )
  )

(use-package ag :ensure t
  :commands (counsel-ag
	     ag)
  :config
  (progn
    (setq ag-highlight-search t)
    (setq ag-reuse-buffers t)
    (add-to-list 'ag-arguments "--word-regexp")))

(use-package auto-fill-mode
  :diminish auto-fill-function
  :commands turn-on-auto-fill
  :init
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (diminish 'auto-fill-function ""))

(use-package autorevert :defer t
  :diminish auto-revert-mode
  ;; mainly to make autorevert disappear from the modeline
  )

(use-package avy :ensure t
  :commands (avy-goto-word-or-subword-1
	     avy-goto-word-1
	     avy-goto-char-in-line
	     avy-goto-line)
  :config
  (setq avy-keys '(?a ?u ?i ?e ?t ?s ?r ?n ?m))
  (setq avy-styles-alist
        '((avy-goto-char-in-line . post)
          (avy-goto-word-or-subword-1 . post))))

(use-package aggressive-indent :ensure t
  :diminish (aggressive-indent-mode . "")
  :commands aggressive-indent-mode
  :init
  (add-hook 'prog-mode-hook 'aggressive-indent-mode)
  :config
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
  (add-to-list 'aggressive-indent-excluded-modes 'perl-mode)
  )

;;; -B-
(use-package blank-mode :ensure t
  :commands blank-mode)


;;; -C-
(use-package calendar
  :commands (calendar)
  :config
  (general-define-key
   :keymaps 'calendar-mode-map
    "P" 'org-journal-previous-entry
    "N" 'org-journal-next-entry
    "o" 'org-journal-read-entry
    "." 'hydra-calendar/body))

(use-package color-theme-solarized :ensure t
  :init
  ;; to make the byte compiler happy.
  ;; emacs25 has no color-themes variable
  (setq color-themes '())
  :config
  ;; load the theme, don't ask for confirmation
  (load-theme 'solarized t)

  (defun solarized-switch-to-dark ()
    (interactive)
    (set-frame-parameter nil 'background-mode 'dark)
    (enable-theme 'solarized))
  (defun solarized-switch-to-light ()
    (interactive)
    (set-frame-parameter nil 'background-mode 'light)
    (enable-theme 'solarized))

  (solarized-switch-to-dark))

(use-package command-log-mode :ensure t
  :commands (command-log-mode))

(use-package company :ensure t
  :diminish ""
  :commands global-company-mode
  :init
  (add-hook 'after-init-hook #'global-company-mode)
  (setq
   company-idle-delay 0.2
   company-selection-wrap-around t
   company-minimum-prefix-length 2
   company-require-match nil
   company-dabbrev-ignore-case nil
   company-dabbrev-downcase nil
   company-show-numbers t)

  :config
  (global-company-mode)

  (use-package company-statistics
    :quelpa (company-statistics :fetcher github :repo "company-mode/company-statistics")
    :config
    (company-statistics-mode))

  (bind-keys :map company-active-map
    ("C-d" . company-show-doc-buffer)
    ("C-l" . company-show-location)
    ("C-n" . company-select-next)
    ("C-p" . company-select-previous)
    ("C-t" . company-select-next)
    ("C-s" . company-select-previous)
    ("TAB" . company-complete))

  (setq company-backends
	'((company-css
	   company-clang
	   company-capf
	   company-semantic
	   company-xcode
	   company-cmake
	   company-files
	   company-gtags
	   company-etags
	   company-keywords)))

  ;; from https://github.com/syl20bnr/spacemacs/blob/master/layers/auto-completion/packages.el
  (setq hippie-expand-try-functions-list
	'(
	  ;; Try to expand word "dynamically", searching the current buffer.
	  try-expand-dabbrev
	  ;; Try to expand word "dynamically", searching all other buffers.
	  try-expand-dabbrev-all-buffers
	  ;; Try to expand word "dynamically", searching the kill ring.
	  try-expand-dabbrev-from-kill
	  ;; Try to complete text as a file name, as many characters as unique.
	  try-complete-file-name-partially
	  ;; Try to complete text as a file name.
	  try-complete-file-name
	  ;; Try to expand word before point according to all abbrev tables.
	  try-expand-all-abbrevs
	  ;; Try to complete the current line to an entire line in the buffer.
	  try-expand-list
	  ;; Try to complete the current line to an entire line in the buffer.
	  try-expand-line
	  ;; Try to complete as an Emacs Lisp symbol, as many characters as
	  ;; unique.
	  try-complete-lisp-symbol-partially
	  ;; Try to complete word as an Emacs Lisp symbol.
	  try-complete-lisp-symbol)))

(use-package counsel :ensure t
  :bind*
  (("M-x"     . counsel-M-x)
   ("C-s"     . counsel-grep-or-swiper)
   ("C-x C-f" . counsel-find-file)
   ("C-x C-r" . counsel-recentf)
   ("C-c f"   . counsel-git)
   ("C-c s"   . counsel-git-grep)
   ("C-c /"   . counsel-ag)
   ("C-c l"   . counsel-locate)
   )
  :config
  (setq counsel-find-file-ignore-regexp "\\.DS_Store\\|.git")
  (defun counsel-package-install ()
    (interactive)
    (ivy-read "Install package: "
              (delq nil
                    (mapcar (lambda (elt)
                              (unless (package-installed-p (car elt))
                                (symbol-name (car elt))))
                            package-archive-contents))
              :action (lambda (x)
                        (package-install (intern x)))
              :caller 'counsel-package-install)))

(use-package counsel-osx-app :ensure t
  :commands counsel-osx-app
  :bind*
  ("C-c a" . counsel-osx-app)
  :config
  (setq counsel-osx-app-location
        '("/Applications/" "~/Applications/" "~/sam_app/")))

(use-package css-mode :ensure t
  :mode (("\\.css\\'" . css-mode)))

;;; -D-
(use-package dired
  :commands (dired)
  :config
  (bind-keys :map dired-mode-map
    ("." . hydra-dired-main/body)
    ("t" . dired-next-line)
    ("s" . dired-previous-line)
    ("r" . dired-find-file)
    ("c" . dired-up-directory))

  ;; use GNU ls instead of BSD ls
  (let ((gls "/usr/local/bin/gls"))
    (if (file-exists-p gls)
	(setq insert-directory-program gls)))
  ;; change default arguments to ls. must include -l
  (setq dired-listing-switches "-XGalg --group-directories-first --human-readable --dired")

  (use-package dired-x
    :init
    (add-hook 'dired-load-hook (lambda () (load "dired-x")))
    :config
    (add-hook 'dired-mode-hook #'dired-omit-mode)
    (setq dired-omit-verbose nil)
    (setq dired-omit-files
	  (concat dired-omit-files "\\|^.DS_Store$\\|^.projectile$\\|^.git$"))))


(use-package display-time
  :commands
  display-time-mode
  :config
  (setq display-time-24hr-format t
        display-time-day-and-date t
        display-time-format))

;;; -E-
(use-package ebib
  :quelpa (ebib :fetcher github :repo "joostkremers/ebib")
  :commands (ebib)
  :config

  (general-define-key :keymaps 'ebib-index-mode-map
    "." 'hydra-ebib/body
    "p" 'hydra-ebib/ebib-prev-entry
    "n" 'hydra-ebib/ebib-next-entry
    "C-p" 'hydra-ebib/ebib-push-bibtex-key-and-exit
    "C-n" 'hydra-ebib/ebib-search-next)

  (evil-set-initial-state 'ebib-index-mode 'emacs)
  (evil-set-initial-state 'ebib-entry-mode 'emacs)

  (setq ebib-preload-bib-files '("~/Dropbox/bibliography/stage_m2.bib"
                                 "~/Dropbox/bibliography/Biologie.bib"))

  (setq ebib-notes-use-single-file "~/dotfile/bibliographie/notes.org")

  (defhydra hydra-ebib (:hint nil :color blue)
    "
     ^Nav^            ^Open^           ^Search^        ^Action^
     ^---^            ^----^           ^------^        ^------^
  _n_: next        _e_: entry       _/_: search     _m_: mark
  _p_: prev        _i_: doi       _C-n_: next       _a_: add entry
_M-n_: next db     _u_: url         ^ ^             _r_: reload
_M-p_: prev db     _f_: file        ^ ^           _C-p_: push key
^   ^              _N_: note        ^ ^           ^   ^
"
    ("a" ebib-add-entry)
    ("e" ebib-edit-entry)
    ("f" ebib-view-file)
    ("g" ebib-goto-first-entry)
    ("G" ebib-goto-last-entry)
    ("i" ebib-browse-doi)
    ("m" ebib-mark-entry :color red)
    ("n" ebib-next-entry :color red)
    ("N" ebib-open-note)
    ("C-n" ebib-search-next :color red)
    ("M-n" ebib-next-database :color red)
    ("p" ebib-prev-entry :color red)
    ("C-p" ebib-push-bibtex-key)
    ("M-p" ebib-prev-database :color red)
    ("r" ebib-reload-all-databases :color red)
    ("u" ebib-browse-url)
    ("/" ebib-search :color red)
    ("?" ebib-info)
    ("q" ebib-quit "quit")
    ("." nil "toggle")))

(use-package eldoc :ensure t
  :commands turn-on-eldoc-mode
  :diminish ""
  :init
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode))

(use-package emacs-lisp-mode
  :mode
  (("*scratch*" . emacs-lisp-mode))
  :init
  (add-hook 'emacs-lisp-mode-hook
            (lambda () (setq-local lisp-indent-function #'Fuco1/lisp-indent-function)))

  (general-define-key
   :states '(normal emacs)
   :keymaps 'emacs-lisp-mode-map
   :prefix "ê"
    "" '(:ignore t :which-key "Emacs Help")
    "f" 'counsel-describe-function
    "k" 'counsel-descbinds
    "v" 'counsel-describe-variable
    "e" 'eval-last-sexp
    "b" 'eval-buffer
    "c" '(sam--eval-current-form-sp :which-key "eval-current")
    "u" 'use-package-jump
    "t" '(lispy-goto :which-key "goto tag")))

(use-package ereader :ensure t
  :mode (("\\.epub\\'" . ereader-mode)))

(use-package eshell
  :commands eshell
  :config
  (use-package eshell-z :ensure t)

  (require 'em-smart)


  (setq eshell-where-to-jump 'begin
        eshell-review-quick-commands nil
        eshell-smart-space-goes-to-end t)
  (add-hook 'eshell-mode-hook 'eshell-smart-initialize)
  (setq eshell-directory-name "~/dotfile/emacs/eshell/")
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'eshell-mode-map
    "C-'" (lambda () (interactive) (insert "exit") (eshell-send-input) (delete-window))))

(use-package ess-site
  :ensure ess
  :mode
  (("\\.sp\\'"           . S-mode)
   ("/R/.*\\.q\\'"       . R-mode)
   ("\\.[qsS]\\'"        . S-mode)
   ("\\.ssc\\'"          . S-mode)
   ("\\.SSC\\'"          . S-mode)
   ("\\.[rR]\\'"         . R-mode)
   ("\\.[rR]nw\\'"       . Rnw-mode)
   ("\\.[sS]nw\\'"       . Snw-mode)
   ("\\.[rR]profile\\'"  . R-mode)
   ("NAMESPACE\\'"       . R-mode)
   ("CITATION\\'"        . R-mode)
   ("\\.omg\\'"          . omegahat-mode)
   ("\\.hat\\'"          . omegahat-mode)
   ("\\.lsp\\'"          . XLS-mode)
   ("\\.do\\'"           . STA-mode)
   ("\\.ado\\'"          . STA-mode)
   ("\\.[Ss][Aa][Ss]\\'" . SAS-mode)
   ("\\.jl\\'"           . ess-julia-mode)
   ("\\.[Ss]t\\'"        . S-transcript-mode)
   ("\\.Sout"            . S-transcript-mode)
   ("\\.[Rr]out"         . R-transcript-mode)
   ("\\.Rd\\'"           . Rd-mode)
   ("\\.[Bb][Uu][Gg]\\'" . ess-bugs-mode)
   ("\\.[Bb][Oo][Gg]\\'" . ess-bugs-mode)
   ("\\.[Bb][Mm][Dd]\\'" . ess-bugs-mode)
   ("\\.[Jj][Aa][Gg]\\'" . ess-jags-mode)
   ("\\.[Jj][Oo][Gg]\\'" . ess-jags-mode)
   ("\\.[Jj][Mm][Dd]\\'" . ess-jags-mode))
  :commands
  (R stata julia SAS)

  :init
  (add-hook 'ess-mode-hook 'company-mode)
  (add-hook 'ess-mode-hook
            (lambda () (flycheck-mode)
              (run-hooks 'prog-mode-hook 'company-mode-hook)))
  (add-hook 'ess-R-post-run-hook (lambda () (smartparens-mode 1)))

  :config
  (load-file "~/dotfile/emacs/ess-config.el"))

(use-package esup :ensure t
  :commands esup)

(use-package evil :ensure t
  :commands (evil-mode)
  :init
  (add-hook 'after-init-hook (lambda () (evil-mode 1)))
  (setq evil-want-fine-undo t)
  (setq evil-want-C-i-jump nil)
  (setq evil-disable-insert-state-bindings t)

  :config
  (use-package evil-escape :ensure t
    :diminish
    (evil-escape-mode)
    :config
    (evil-escape-mode)
    (setq-default evil-escape-key-sequence "xq"
                  evil-escape-delay 0.2)
    (setq evil-escape-unordered-key-sequence t))

  (use-package evil-matchit :ensure t
    :commands
    evilmi-jump-items
    :config
    (global-evil-matchit-mode 1))

  (use-package evil-surround :ensure t
    :config
    (global-evil-surround-mode))

  (use-package evil-visual-mark-mode :ensure t
    :commands (evil-visual-mark-mode
               hydra-evil-mark/body
               hydra-evil-mark/evil-goto-mark)
    :defines (hydra-evil-mark/body
              hydra-evil-mark/evil-goto-mark)
    :config
    (defhydra hydra-evil-mark
      (:color teal
       :hint nil
       :pre (evil-visual-mark-mode)
       :before-exit (evil-visual-mark-mode 0))
      "mark"
      ("é" evil-goto-mark "mark" :color red)
      ("q" nil "quit" :color blue)))

  (use-package evil-visualstar :ensure t
    :config
    (global-evil-visualstar-mode t))

  (setq evil-default-state 'normal)
  (evil-set-initial-state 'dired-mode 'emacs)
  (evil-set-initial-state 'message-mode 'motion)
  (evil-set-initial-state 'help-mode 'emacs)
  (evil-set-initial-state 'ivy-occur-mode 'emacs)
  (evil-set-initial-state 'calendar-mode 'emacs)
  (evil-set-initial-state 'esup-mode 'emacs)

  ;; cursor color by state
  (setq evil-insert-state-cursor  '("#268bd2" bar)  ;; blue
        evil-normal-state-cursor  '("#b58900" box)  ;; blue
        evil-visual-state-cursor  '("#cb4b16" box)  ;; orange
        evil-replace-state-cursor '("#859900" hbar) ;; green
        evil-emacs-state-cursor   '("#d33682" box)) ;; magenta

  ;; maps that overrides evil-map.
  ;; keeps default keybindings.
  (setq evil-overriding-maps '((dired-mode-map)
                               (Buffer-menu-mode-map)
                               (color-theme-mode-map)
                               (comint-mode-map)
                               (compilation-mode-map)
                               (grep-mode-map)
                               (dictionary-mode-map)
                               (ert-results-mode-map . motion)
                               (Info-mode-map . motion)
                               (speedbar-key-map)
                               (speedbar-file-key-map)
                               (speedbar-buffers-key-map)
                               (calendar-mode-map)))
  (load-file "~/dotfile/emacs/keybindings.el")
  )


(use-package exec-path-from-shell :ensure t
  :defer 2
  :commands (exec-path-from-shell-initialize
             exec-path-from-shell-copy-env)
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-initialize)
  ;; wrap fasd in epfs config to make sure the fasd executable is found
  (use-package fasd :ensure t
    :config
    (global-fasd-mode 1)
    (setq fasd-completing-read-function 'ivy-completing-read)
    (setq fasd-enable-initial-prompt nil))
  ;; Install epdfinfo via 'brew install pdf-tools' and then install the
  ;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
  ;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
  ;; pdf-tools package using Emacs package system. If things get messed
  ;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
  ;; pdf-tools package and reinstall both as at the start.

  (use-package pdf-tools :ensure t
    :mode ("\\.pdf\\'" . pdf-view-mode)
    :config

    (setq-default pdf-view-display-size 'fit-width)
    (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo")

    (bind-keys
     :map pdf-view-mode-map
      ("." . hydra-pdftools/body)
      ("<s-spc>" .  pdf-view-scroll-down-or-next-page)
      ("g"  . pdf-view-first-page)
      ("G"  . pdf-view-last-page)
      ("r"  . image-forward-hscroll)
      ("c"  . image-backward-hscroll)
      ("t"  . pdf-view-next-line-or-next-page)
      ("s"  . pdf-view-previous-line-or-previous-page)
      ("r"  . pdf-view-next-page)
      ("c"  . pdf-view-previous-page)
      ("e"  . pdf-view-goto-page)
      ("u"  . pdf-view-revert-buffer)
      ("a"  . hydra-pdf-annotate/body)
      ("n"  . hydra-pdf-search/pdf-occur-next-error)
      ("y"  . pdf-view-kill-ring-save)
      ("i"  . pdf-misc-display-metadata)
      ("/"  . pdf-occur)
      ("b"  . pdf-view-set-slice-from-bounding-box)
      ("R"  . pdf-view-reset-slice)
      ("M-n" . pdf-occur-next-error))

    (use-package pdf-occur)
    (use-package pdf-annot)
    (use-package pdf-outline)
    (use-package pdf-history)
    (use-package pdf-view)

    (defhydra hydra-pdftools (:color amaranth :hint nil)
      "
^Move^ ^^   ^^      ^History^     ^Scale/fit   ^        ^Commands^
^----^-^^---^^      ^-------^     ^------------^        ^---------------------------^
^^   ^g^   ^^ | _b_: bwd     | _+_: zoom       |   [_a_]: annotate    _i_: info
^^   _s_   ^^ | _f_: fwd     | _-_: unzoom     | [_C-s_]: search      _d_: dark-mode
_c_  _e_  _r_ | ^^           | _0_: reset      |     _o_: outline
^^   _t_   ^^ | ^^           | _w_: fit width  |     _u_: revert
^^   ^G^   ^^ | ^^           | _h_: fit height |
^^   ^ ^   ^^ | ^^           | _p_: fit page   |
"
      ("g" pdf-view-first-page)
      ("G" pdf-view-last-page)
      ("e" pdf-view-goto-page)
      ("t" pdf-view-next-line-or-next-page)
      ("s" pdf-view-previous-line-or-previous-page )
      ("r" pdf-view-next-page-command )
      ("c" pdf-view-previous-page-command )
      ("b" pdf-history-backward )
      ("f" pdf-history-forward )
      ("+" pdf-view-enlarge )
      ("-" pdf-view-shrink )
      ("0" pdf-view-scale-reset)
      ("w" pdf-view-fit-width-to-window)
      ("h" pdf-view-fit-height-to-window)
      ("p" pdf-view-fit-page-to-window)
      ("a" hydra-pdf-annotate/body :color blue)
      ("C-s" hydra-pdf-search/body :color blue)
      ("o" pdf-outline)
      ("u" pdf-view-revert-buffer)
      ("i" pdf-misc-display-metadata)
      ("d" pdf-view-dark-minor-mode)
      ("é" hydra-window/body "wdw" :color blue)
      ("." nil "quit" :color blue))

    (defhydra hydra-pdf-annotate (:color teal :hint nil :columns 2)
      "Annotate"
      ("l" pdf-annot-list-annotations "list")
      ("d" pdf-annot-delete "delete")
      ("a" pdf-annot-attachment-dired "dired")
      ("m" pdf-annot-add-markup-annotation "markup")
      ("t" pdf-annot-add-text-annotation "text")
      ("." hydra-pdftools/body "back"))

    (defhydra hydra-pdf-search (:color teal :hint nil :columns 2)
      "Search"
      ("s" pdf-occur "search")
      ("n" pdf-occur-next-error "next" :color red)
      ("h" pdf-occur-history "history")
      ("a" pdf-links-action-perfom "link action")
      ("l" pdf-links-isearch-link "search link")
      ("." hydra-pdftools/body "back"))))

(use-package expand-region :ensure t
  :general
  ("s-SPC" 'hydra-expand-region/er/expand-region)
  :config
  (setq expand-region-fast-keys-enabled nil)
  (defhydra hydra-expand-region (:color red :hint nil)
    "
^Expand region^   ^Cursors^
_c_: expand       _n_: next
_r_: contract     _p_: prev
_R_: reset
"
    ("c" er/expand-region)
    ("r" er/contract-region)
    ("R" (lambda () (interactive)
           (let ((current-prefix-arg '(0)))
             (call-interactively #'er/contract-region))) :color blue)
    ("n" hydra-mc/mc/mark-next-like-this :color blue)
    ("p" hydra-mc/mc/mark-previous-like-this :color blue)
    ("q" nil "quit" :color blue)))

;;; -F-

(use-package flx :ensure t)

(use-package flycheck :ensure t
  :commands flycheck-mode
  :diminish (flycheck-mode . "ⓕ")
  :config
  (progn
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc r-lintr))
    (setq flycheck-highlighting-mode 'lines)
    (setq flycheck-check-syntax-automatically '(save)))
  )

;;; -G-
(use-package git-gutter :ensure t
  :diminish ""
  :commands (global-git-gutter-mode)
  :init
  (global-git-gutter-mode +1)
  (setq git-gutter:modified-sign "|")
  (setq git-gutter:added-sign "|")
  (setq git-gutter:deleted-sign "|")

  :config
  (add-to-list 'git-gutter:update-commands 'other-window)
  (add-to-list 'git-gutter:update-commands 'save-buffer)

  (use-package git-gutter-fringe :ensure t
    :init
    ;; (setq-default left-fringe-width 10)
    (setq-default right-fringe-width 0)
    (setq-default left-fringe-width 2)
    :config
    (set-face-foreground 'git-gutter-fr:modified "#268bd2") ;blue
    (set-face-foreground 'git-gutter-fr:added "#859900")    ;green
    (set-face-foreground 'git-gutter-fr:deleted "#dc322f")  ;red

    (fringe-helper-define 'git-gutter-fr:added nil
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   ")
    (fringe-helper-define 'git-gutter-fr:deleted 'top

      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      )
    (fringe-helper-define 'git-gutter-fr:modified 'top
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   "
      "   --   ")))

(use-package go-mode :ensure t
  :mode (("\\.go\\'" . go-mode))
  :config
  (when (memq window-system '(mac ns x))
    (dolist (var '("GOPATH" "GO15VENDOREXPERIMENT"))
      (unless (getenv var)
        (exec-path-from-shell-copy-env var))))

  (use-package company-go :ensure t
    :config
    (setq company-go-show-annotation t)
    (add-to-list 'company-backends 'company-go))

  (use-package go-eldoc :ensure t
    :config
    (add-hook 'go-mode-hook 'go-eldoc-setup))

  (use-package go-guru
    :load-path "~/src/golang.org/x/tools/cmd/guru/"
    :config
    (defhydra hydra-go-guru (:color blue :columns 2)
      ("s" go-guru-set-scope "scope")
      ("cr" go-guru-callers "callers")
      ("ce" go-guru-callees "callees")
      ("P" go-guru-peers "peers")
      ("d" go-guru-definition "def")
      ("f" go-guru-freevars "freevars")
      ("s" go-guru-callstack "stack")
      ("i" go-guru-implements "implements")
      ("p" go-guru-pointsto "points to")
      ("r" go-guru-referrers "referrers")
      ("?" go-guru-describe "describe")))

  (use-package flycheck-gometalinter :ensure t
    :config
    (setq flycheck-disabled-checkers '(go-gofmt go-golint go-vet go-build go-test go-errcheck))
    (flycheck-gometalinter-setup))

  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  ;; set tab width
  (add-hook 'go-mode-hook (lambda () (setq-local tab-width 4)))

  (dolist (delim '("{" "(" "["))
    (sp-local-pair 'go-mode delim nil
                   :post-handlers '((sam--create-newline-and-enter-sexp "RET"))))

  ;; from https://github.com/syl20bnr/spacemacs/blob/master/layers/%2Blang/go/packages.el
  (defun go-run-main ()
    (interactive)
    (async-shell-command
     (format "go run %s"
             (shell-quote-argument (buffer-file-name)))))

  ;; keybindings
  (general-define-key
   :states '(normal visual)
   :keymaps 'go-mode-map
    "," 'hydra-go/body)

  (defhydra hydra-go (:hint nil :color teal)
    "
         ^Command^      ^Imports^       ^Doc^
         ^-------^      ^-------^       ^---^
      _r_: run      _ig_: goto       _d_: doc at point
    [_g_]: guru     _ia_: add
    ^  ^            _ir_: remove
    "
    ("g" hydra-go-guru/body :color blue)
    ("r" go-run-main)
    ("d" godoc-at-point)
    ("ig" go-goto-imports )
    ("ia" go-import-add)
    ("ir" go-remove-unused-imports)
    ("q" nil "quit" :color blue)))


(use-package goto-chg :ensure t
  :commands (goto-last-change
             goto-last-change-reverse))

(use-package grab-mac-link :ensure t
  :commands grab-mac-link)

;;; -H-
(use-package helm
  ;; disabled for now, but I've copy and pasted here the advice from
  ;; tuhdo about helm.
  :disabled t
  :commands (helm-mode)
  :bind (("M-x" . helm-M-x))
  :config
  (setq
   ;; open helm buffer inside current window, not occupy whole other window
   helm-split-window-in-side-p t
   ;; input close to where I type
   helm-echo-input-in-header-line t)

  (defun helm-hide-minibuffer-maybe ()
    "Hide minibuffer in Helm session if we use the header line as input field."
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
	(overlay-put ov 'window (selected-window))
	(overlay-put ov 'face
		     (let ((bg-color (face-background 'default nil)))
		       `(:background ,bg-color :foreground ,bg-color)))
	(setq-local cursor-type nil))))

  (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)

  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1))

(use-package hideshow
  :commands hs-minor-mode
  :diminish hs-minor-mode
  :init
  (add-hook 'prog-mode-hook 'hs-minor-mode)
  )

(use-package hl-line
  ;; souligne la ligne du curseur
  :init
  (global-hl-line-mode))

(use-package hydra :ensure t)

(use-package hy-mode :ensure t
  :mode (("\\.hy\\'" . hy-mode))
  :init
  (add-hook 'hy-mode-hook (lambda () (lispy-mode 1))))

;;; -I-
(use-package ibuffer :ensure t
  :commands ibuffer
  :init
  (add-hook 'ibuffer-hook #'hydra-ibuffer-main/body)
  :config
  (define-key ibuffer-mode-map "." 'hydra-ibuffer-main/body))

(use-package imenu-anywhere
  :quelpa (imenu-anywhere :fetcher github :repo "vspinu/imenu-anywhere")
  :commands ivy-imenu-anywhere)

(use-package ivy
  :quelpa (ivy :fetcher github :repo "abo-abo/swiper")
  :diminish (ivy-mode . "")
  :commands ivy-switch-buffer
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 10)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil)
  ;; from https://github.com/company-mode/company-statistics
  ;; ignore buffers in the ignore buffer list.
  (setq ivy-use-ignore-default 'always)
  (setq ivy-ignore-buffers '("company-statistics-cache.el" "company-statistics-autoload.el"))
  ;; if ivy-flip is t, presents results on top of query.
  (setq ivy-flip nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-ignore-order)
          (t . ivy--regex-fuzzy)
          (t   . ivy--regex-ignore-order)))

  (defun ivy-switch-project ()
    (interactive)
    (ivy-read
     "Switch to project: "
     (if (projectile-project-p)
         (cons (abbreviate-file-name (projectile-project-root))
               (projectile-relevant-known-projects))
       projectile-known-projects)
     :action #'projectile-switch-project-by-name))

  (global-set-key (kbd "C-c m") 'ivy-switch-project)

  (ivy-set-actions
   'ivy-switch-project
   '(("d" dired "Open Dired in project's directory")
     ("v" counsel-projectile "Open project root in vc-dir or magit")
     ("c" projectile-compile-project "Compile project")
     ("r" projectile-remove-known-project "Remove project(s)"))))

;;; -J-

;;; -K-

;;; -L-
(use-package linum :defer t
  :init
  (add-hook 'linum-mode-hook 'sam--fix-linum-size))

(use-package lispy :ensure t
  :diminish (lispy-mode . "λ")
  :commands lispy-mode
  :init
  (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

  :config
  ;; adapté au bépo
  (lispy-define-key lispy-mode-map "s" 'lispy-up)
  (lispy-define-key lispy-mode-map "ß" 'lispy-move-up)
  (lispy-define-key lispy-mode-map "t" 'lispy-down)
  (lispy-define-key lispy-mode-map "þ" 'lispy-move-down)
  (lispy-define-key lispy-mode-map "c" 'lispy-left)
  (lispy-define-key lispy-mode-map "h" 'lispy-clone)
  (lispy-define-key lispy-mode-map "r" 'lispy-right)
  (lispy-define-key lispy-mode-map "®" 'lispy-forward)
  (lispy-define-key lispy-mode-map "©" 'lispy-backward)
  (lispy-define-key lispy-mode-map "C" 'lispy-ace-symbol-replace)
  (lispy-define-key lispy-mode-map "H" 'lispy-convolute)
  (lispy-define-key lispy-mode-map "»" 'lispy-slurp)
  (lispy-define-key lispy-mode-map "«" 'lispy-barf)
  (lispy-define-key lispy-mode-map "l" 'lispy-raise) ; replace "r" `lispy-raise' with "l"
  (lispy-define-key lispy-mode-map "j" 'lispy-teleport)
  (lispy-define-key lispy-mode-map "X" 'special-lispy-x)

  ;; change avy-keys to default bépo home row keys.
  (setq lispy-avy-keys '(?a ?u ?i ?e ?t ?s ?r ?n ?m))

  (defun sam--lispy-newline-before-paren ()
    (interactive)
    (if-looking-at-do-else ")"
                           (progn (end-of-line) (lispy-newline-and-indent-plain))
                           (lispy-newline-and-indent-plain)))

  (general-define-key
   :states '(insert emacs)
   :keymaps 'lispy-mode-map
    "RET" 'sam--lispy-newline-before-paren )

  )

(use-package lorem-ipsum :ensure t
  :commands
  (lorem-ipsum-insert-list
   lorem-ipsum-insert-sentences
   lorem-ipsum-insert-paragraphs))

;;; -M-
(use-package magit :ensure t
  :commands
  (magit-blame
   magit-commit
   magit-commit-popup
   magit-diff-popup
   magit-diff-unstaged
   magit-fetch-popup
   magit-init
   magit-log-popup
   magit-pull-popup
   magit-push-popup
   magit-revert
   magit-stage-file
   magit-status
   magit-unstage-file
   magit-blame-mode)

  :config
  (global-git-commit-mode)

  (use-package git-commit :ensure t :defer t)

  (use-package magit-gitflow :ensure t
    :commands
    turn-on-magit-gitflow
    :general
    (:keymaps 'magit-mode-map
     "%" 'magit-gitflow-popup)
    :init
    (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

  (use-package git-messenger :ensure t
    :general
    (:keymaps 'git-messenger-map
     "q" 'git-messenger:popup-close))

  (use-package git-timemachine :ensure t
    :commands git-timemachine
    :general
    (:keymaps 'git-timemachine-mode-map
     "n" 'git-timemachine-show-next-revision
     "p" 'git-timemachine-show-previous-revision
     "q" 'git-timemachine-quit
     "w" 'git-timemachine-kill-abbreviated-revision
     "W" 'git-timemachine-kill-revision))

  (setq magit-completing-read-function 'ivy-completing-read))

(use-package makefile-mode :defer t
  :init
  (add-hook 'makefile-bsdmake-mode-hook 'makefile-gmake-mode))

(use-package markdown-mode :ensure t
  :mode ("\\.md\\'" . markdown-mode)
  :config
  (add-hook 'markdown-mode-hook (lambda () (auto-fill-mode 0)))

  (defhydra hydra-markdown (:hint nil)
    "
Formatting         _s_: bold          _e_: italic     _b_: blockquote   _p_: pre-formatted    _c_: code
Headings           _h_: automatic     _1_: h1         _2_: h2           _3_: h3               _4_: h4
Lists              _m_: insert item
Demote/Promote     _l_: promote       _r_: demote     _U_: move up      _D_: move down
Links, footnotes   _L_: link          _U_: uri        _F_: footnote     _W_: wiki-link      _R_: reference
undo               _u_: undo
"


    ("s" markdown-insert-bold)
    ("e" markdown-insert-italic)
    ("b" markdown-insert-blockquote :color blue)
    ("p" markdown-insert-pre :color blue)
    ("c" markdown-insert-code)

    ("h" markdown-insert-header-dwim)
    ("1" markdown-insert-header-atx-1)
    ("2" markdown-insert-header-atx-2)
    ("3" markdown-insert-header-atx-3)
    ("4" markdown-insert-header-atx-4)

    ("m" markdown-insert-list-item)

    ("l" markdown-promote)
    ("r" markdown-demote)
    ("D" markdown-move-down)
    ("U" markdown-move-up)

    ("L" markdown-insert-link :color blue)
    ("U" markdown-insert-uri :color blue)
    ("F" markdown-insert-footnote :color blue)
    ("W" markdown-insert-wiki-link :color blue)
    ("R" markdown-insert-reference-link-dwim :color blue)

    ("u" undo :color teal)
    )

  (general-define-key
   :states '(normal visual insert emacs)
   :keymaps 'markdown-mode-map
   :prefix ","
   :non-normal-prefix "’"               ; Alt-, => ’
    "," 'hydra-markdown/body
    "=" 'markdown-promote
    "°" 'markdown-promote-subtree
    "-" 'markdown-demote
    "8" 'markdown-demote-subtree
    "o" 'markdown-follow-thing-at-point
    "j" 'markdown-jump
    "»" 'markdown-indent-region
    "«" 'markdown-exdent-region
    "gc" 'markdown-forward-same-level
    "gr" 'markdown-backward-same-level
    "gs" 'markdown-up-heading
    )

  (which-key-add-major-mode-key-based-replacements 'markdown-mode
    "C-c C-a" "insert"
    "C-c C-c" "export"
    "C-c TAB" "images"
    "C-c C-s" "text"
    "C-c C-t" "header"
    "C-c C-x" "move"
    )
  )

(use-package move-text :ensure t
  :commands
  (move-text-down
   move-text-up))

(use-package multiple-cursors
  :quelpa (multiple-cursors :fetcher github :repo "magnars/multiple-cursors.el")
  :general
  ("C-M-s" 'mc/mark-previous-like-this
   "C-M-t" 'mc/mark-next-like-this
   "C-M-S-s" 'mc/unmark-next-like-this
   "C-M-S-t" 'mc/unmark-previous-like-this
   "H-SPC" 'hydra-mc/body)
  :commands
  (hydra-mc/mc/mark-previous-like-this
   hydra-mc/mc/mark-next-like-this)
  :config

  ;; from https://github.com/abo-abo/hydra/wiki/multiple-cursors
  (defhydra hydra-mc (:hint nil)
    "
     ^Up^            ^Down^        ^Other^
----------------------------------------------
[_p_]   Next    [_n_]   Next    [_l_] Edit lines
[_P_]   Skip    [_N_]   Skip    [_a_] Mark all
[_M-p_] Unmark  [_M-n_] Unmark  [_r_] Mark by regexp
^ ^             ^ ^             [_q_] Quit
"
    ("l" mc/edit-lines :exit t)
    ("a" mc/mark-all-like-this :exit t)
    ("n" mc/mark-next-like-this)
    ("N" mc/skip-to-next-like-this)
    ("M-p" mc/unmark-next-like-this)
    ("p" mc/mark-previous-like-this)
    ("P" mc/skip-to-previous-like-this)
    ("M-n" mc/unmark-previous-like-this)
    ("r" mc/mark-all-in-region-regexp :exit t)
    ("q" nil :color blue)
    (" " nil "quit" :color blue)))

;;; -N-
(use-package nlinum :ensure t
  :init
  (defun sam--fix-linum-size ()
    "Fixe la taille de charactère dans linum mode"
    (interactive)
    (set-face-attribute 'linum nil :height 100 :foreground "#93a1a1"))
  :config
  (add-hook 'nlinum-mode-hook 'sam--fix-linum-size)
  (global-nlinum-mode))

;;; -O-

(use-package osx-clipboard :ensure t
  :if (not (window-system))
  :init
  (osx-clipboard-mode +1))

;; TODO work on outline hydra. useful for tex
(use-package outline
  :bind (("H-<tab>" . hydra-outline/body))
  :commands (outline-minor-mode
	     hydra-outline/body)
  :general ("C-M-c" 'outline-previous-heading
            "C-M-r" 'outline-next-heading)
  :diminish ((outline-minor-mode . "")
	     (outline-major-mode . ""))
  :config
  (defhydra hydra-outline
    (:hint nil :body-pre (outline-minor-mode 1))
    "
Outline

   ^Navigate^     ^Show/Hide^                            ^Manipulate^
_c_: up      _C-c_: hide subtree  _C-S-c_: hide all   _M-r_: demote
_t_: next    _C-t_: show entry    _C-S-t_: show child _M-c_: promote
_s_: prev    _C-s_: hide entry    _C-S-s_: hide child _M-t_: move down
_r_: next    _C-r_: show subtree  _C-S-r_: show all   _M-s_: move up
_b_: bwd
_f_: fwd
"
    ("c" outline-up-heading)
    ("t" outline-next-visible-heading)
    ("s" outline-previous-visible-heading)
    ("r" outline-next-heading)
    ("b" outline-backward-same-level)
    ("f" outline-forward-same-level)

    ("C-c" outline-hide-subtree)
    ("C-t" outline-show-entry)
    ("C-s" outline-hide-entry)
    ("C-r" outline-show-subtree)

    ("C-S-c" outline-hide-body)
    ("C-S-t" outline-show-children)
    ("C-S-s" outline-hide-sublevels)
    ("C-S-r" outline-show-all)

    ("M-r" outline-demote)
    ("M-c" outline-promote)
    ("M-t" outline-move-subtree-down)
    ("M-s" outline-move-subtree-up)

    ("i" outline-insert-heading "insert heading" :color blue)
    ("q" nil "quit" :color blue)))

;;; -P-
(use-package paradox :ensure t
  :commands (paradox-list-packages
             package-list-packages))

(use-package pbcopy :ensure t
  :if (not (display-graphic-p))
  :init
  (turn-on-pbcopy))

(use-package persp-mode
  :defer t
  :quelpa (persp-mode :fetcher github :repo "Bad-ptr/persp-mode.el")
  :diminish (persp-mode . "")
  :commands (persp-mode
             persp-next
             persp-prev
             pers-switch)
  :config

  (setq wg-morph-on nil)                ; switch off animation ?
  (setq persp-autokill-buffer-on-remove 'kill-weak)
  (setq persp-nil-name "nil")

  (defhydra hydra-persp (:hint nil :color blue)
    "
^Nav^        ^Buffer^      ^Window^     ^Manage^      ^Save/load^
^---^        ^------^      ^------^     ^------^      ^---------^
_n_: next    _a_: add      ^ ^          _r_: rename   _w_: save
_p_: prev    _b_: → to     ^ ^          _c_: copy     _W_: save subset
_s_: → to    _i_: import   _S_: → to    _C_: kill     _l_: load
^ ^          ^ ^           ^ ^          ^ ^           _L_: load subset
"
    ("n" persp-next :color red)
    ("p" persp-prev :color red)
    ("s" persp-switch)
    ("S" persp-window-switch)
    ("r" persp-rename)
    ("c" persp-copy)
    ("C" persp-kill)
    ("a" persp-add-buffer)
    ("b" persp-switch-to-buffer)
    ("i" persp-import-buffers-from)
    ("I" persp-import-win-conf)
    ("o" persp-mode)
    ("w" persp-save-state-to-file)
    ("W" persp-save-to-file-by-names)
    ("l" persp-load-state-from-file)
    ("L" persp-load-from-file-by-names)
    ("q" nil "quit"))

  (define-key evil-normal-state-map (kbd "M-p") 'hydra-persp/body)
  (global-set-key (kbd "H-p") 'persp-prev)
  (global-set-key (kbd "H-n") 'persp-next))

;; TODO what is that ?
(use-package pretty-mode :ensure t
  :disabled t
  :commands turn-on-pretty-mode
  :init
  (add-hook 'ess-mode-hook 'turn-on-pretty-mode))

(use-package prog-mode
  :config
  (global-prettify-symbols-mode))

(use-package projectile :ensure t
  :diminish (projectile-mode . "ⓟ")
  :commands
  (projectile-ag
   projectile-switch-to-buffer
   projectile-invalidate-cache
   projectile-find-dir
   projectile-find-file
   projectile-find-file-dwim
   projectile-find-file-in-directory
   projectile-ibuffer
   projectile-kill-buffers
   projectile-kill-buffers
   projectile-multi-occur
   projectile-multi-occur
   projectile-switch-project
   projectile-switch-project
   projectile-switch-project
   projectile-recentf
   projectile-remove-known-project
   projectile-cleanup-known-projects
   projectile-cache-current-file
   projectile-project-root
   )
  :config
  (projectile-global-mode 1)

  (use-package counsel-projectile :ensure t)

  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-completion-system 'ivy)
  (add-to-list 'projectile-globally-ignored-files ".DS_Store"))


(use-package python
  :ensure python-mode
  :mode
  (("\\.py\\'" . python-mode)
   ("\\.wsgi$" . python-mode))
  :interpreter
  (("ipython" . python-mode)
   ("python"  . python-mode))

  :config
  (load-file "~/dotfile/emacs/python-config.el"))

;;; -Q-

;;; -R-
(use-package rainbow-delimiters  :ensure t
  :commands rainbow-delimiters-mode
  :init
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package ranger :ensure t
  :commands
  (ranger
   deer)
  :general
  (:keymaps 'ranger-mode-map
   "t" 'ranger-next-file		; j
   "s" 'ranger-prev-file		; k
   "r" 'ranger-find-file		; l
   "c" 'ranger-up-directory		; c
   "j" 'ranger-toggle-mark		; t
   )

  :config
  (setq ranger-cleanup-eagerly t))

(use-package recentf
  :preface
  (defun recentf-add-dired-directory ()
    (if (and dired-directory
             (file-directory-p dired-directory)
             (not (string= "/" dired-directory)))
        (let ((last-idx (1- (length dired-directory))))
          (recentf-add-file
           (if (= ?/ (aref dired-directory last-idx))
               (substring dired-directory 0 last-idx)
             dired-directory)))))
  :init
  (add-hook 'dired-mode-hook 'recentf-add-dired-directory)
  (recentf-mode 1)
  :config
  (setq recentf-max-saved-items 50))

(use-package restart-emacs :ensure t
  :commands restart-emacs)

;;; -S-
(use-package scss-mode :ensure t
  :mode ("\\.scss\\'" . scss-mode))

(use-package sh-script :defer t
  :mode
  ( ("\\.zsh\\'" . sh-mode)
    ("zlogin\\'" . sh-mode)
    ("zlogout\\'" . sh-mode  )
    ("zpreztorc\\'" . sh-mode )
    ("zprofile\\'" . sh-mode )
    ("zshenv\\'" . sh-mode )
    ("zshrc\\'" . sh-mode))
  :config

  (use-package company-shell
    :quelpa (company-shell :fetcher github :repo "Alexander-Miller/company-shell")
    :config
    (add-to-list 'company-backends 'company-shell))
  (add-hook 'sh-mode-hook (lambda () (setq-local outline-regexp "###-----------------"))))




(use-package smartparens
  :ensure t
  :diminish (smartparens-mode . "")
  :commands smartparens-global-mode
  :bind (("C-M-f" . sp-forward-sexp)
         ("C-M-b" . sp-backward-sexp)
         ("C-M-d" . sp-down-sexp)
         ("C-M-a" . sp-backward-down-sexp)
         ("C-S-d" . sp-beginning-of-sexp)
         ("C-S-a" . sp-end-of-sexp)
         ("C-M-e" . sp-up-sexp)
         ("C-M-u" . sp-backward-up-sexp))
  :init
  (add-hook 'after-init-hook (lambda () (smartparens-global-mode)))

  :config
  ;; Only use smartparens in web-mode
  (sp-local-pair 'web-mode "<% " " %>")
  (sp-local-pair 'web-mode "{ " " }")
  (sp-local-pair 'web-mode "<%= "  " %>")
  (sp-local-pair 'web-mode "<%# "  " %>")
  (sp-local-pair 'web-mode "<%$ "  " %>")
  (sp-local-pair 'web-mode "<%@ "  " %>")
  (sp-local-pair 'web-mode "<%: "  " %>")
  (sp-local-pair 'web-mode "{{ "  " }}")
  (sp-local-pair 'web-mode "{% "  " %}")
  (sp-local-pair 'web-mode "{%- "  " %}")
  (sp-local-pair 'web-mode "{# "  " #}")
  (sp-local-pair 'org-mode "$" "$")
  (sp-pair "'" nil :actions :rem)


  (defun sam--create-newline-and-enter-sexp (&rest _ignored)
    "Open a new brace or bracket expression, with relevant newlines and indent. "
    ;; from https://github.com/Fuco1/smartparens/issues/80
    (newline)
    (indent-according-to-mode)
    (forward-line -1)
    (indent-according-to-mode)))

(use-package smex
  :quelpa (smex :fetcher github :repo "abo-abo/smex"))

(use-package smooth-scrolling :ensure t
  :config
  (smooth-scrolling-mode)
  (setq smooth-scroll-margin 5))

(use-package spaceline :ensure t
  :defer 1
  :config
  (use-package spaceline-config
    :init
    (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
    (setq powerline-default-separator 'utf-8)
    (setq spaceline-window-numbers-unicode t)
    :config
    (spaceline-emacs-theme)
    (window-numbering-mode)))

(use-package subword :defer t
  :init
  (add-hook 'prog-mode-hook (lambda () (subword-mode 1)))
  :diminish "")

(use-package swiper :ensure t
  :commands swiper)

;;; -T-
(use-package tex
  :ensure auctex
  :commands init-auctex
  :defines init-auctex
  :init
  (add-hook 'LaTeX-mode-hook 'latex-auto-fill-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
  :config
  (load-file "~/dotfile/emacs/latex-config.el"))

;;; -U-
(use-package undo-tree :ensure t
  :diminish undo-tree-mode
  :bind* (("C-x u" . undo-tree-visualize)))

;;; -V-
(use-package visual-regexp-steroids :ensure t
  :commands (vr/replace vr/query-replace))

;;; -W-
(use-package web-mode :ensure t
  :mode
  (("\\.phtml\\'"      . web-mode)
   ("\\.tpl\\.php\\'"  . web-mode)
   ("\\.twig\\'"       . web-mode)
   ("\\.html\\'"       . web-mode)
   ("\\.htm\\'"        . web-mode)
   ("\\.[gj]sp\\'"     . web-mode)
   ("\\.as[cp]x?\\'"   . web-mode)
   ("\\.eex\\'"        . web-mode)
   ("\\.erb\\'"        . web-mode)
   ("\\.mustache\\'"   . web-mode)
   ("\\.handlebars\\'" . web-mode)
   ("\\.hbs\\'"        . web-mode)
   ("\\.eco\\'"        . web-mode)
   ("\\.ejs\\'"        . web-mode)
   ("\\.djhtml\\'"     . web-mode))
  :config
  (use-package company-web :ensure t
    :config
    (add-to-list 'company-backends 'company-web-html)))

(use-package wgrep :ensure t :defer t)

(use-package which-key :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  ;; simple then alphabetic order.
  (setq which-key-sort-order 'which-key-prefix-then-key-order)
  (setq which-key-popup-type 'side-window
        which-key-side-window-max-height 0.5
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.5
        which-key-min-display-lines 7))

(use-package whitespace
  :diminish ""
  :commands whitespace-mode
  :init
  (add-hook 'prog-mode-hook 'whitespace-mode)
  :config
  (setq whitespace-line-column 100
        whitespace-style '(face lines-tail)))

(use-package window-numbering :ensure t
  :commands
  (window-numbering-mode
   select-window-0
   select-window-1
   select-window-2
   select-window-3
   select-window-4
   select-window-5
   select-window-6
   select-window-7
   select-window-8
   select-window-9)
  :config
  (defun window-numbering-install-mode-line (&optional position)
    "Do nothing, the display is handled by the powerline.")
  (window-numbering-install-mode-line))

;;; -X-

;;; -Y-
(use-package yasnippet
  :diminish yas-minor-mode
  :defer 10
  :init
  (with-eval-after-load 'yasnippet
    (progn
      (setq yas-snippet-dirs
	    (append yas-snippet-dirs '("~/dotfile/emacs/snippets")))))
  :config
  (yas-global-mode)
  (setq yas-indent-line nil))

;;; -Z-
(use-package zoom-frm :ensure t
  :commands
  (zoom-frm-in
   zoom-frm-out
   zoom-frm-unzoom
   zoom-in
   zoom-out)
  :config
  (setq zoom-frame/buffer 'buffer))

;;; -------------------------------------------------------------------

;;; personal functions
(load-file "~/dotfile/emacs/functions.el")
;;; org
(load-file "~/dotfile/emacs/org.el")

;;; custom
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)
