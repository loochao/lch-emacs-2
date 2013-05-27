;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; AQUAMACS
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author:  Chao LU <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; Licence: GNU
;;
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Control file of which one to load

;;; CODE
(message "=> lch-aquamacs: loading...")

;; no Mac-specific key bindings
;; (osx-key-mode -1)  

(setq aquamacs-scratch-file nil                        ; do not save scratch file across sessions
      initial-major-mode 'emacs-lisp-mode              ; *scratch* shows up in emacs-lisp-mode
      ;; aquamacs-default-major-mode 'emacs-lisp-mode  ; new buffers open in emacs-lisp-mode
      ;; ns-command-modifier 'meta          ; Apple/Command key is Meta
      ;; ns-alternate-modifier nil          ; Option is the Mac Option key
      ns-use-mac-modifier-symbols  nil      ; display standard Emacs (and not standard Mac) modifier symbols)
      )

;; Frame and window management:
(setq cursor-type 'box)
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)
(tabbar-mode 1)
(one-buffer-one-frame-mode -1)       ; no one-buffer-per-frame
(setq special-display-regexps nil)   ; do not open certain buffers in special windows/frames
;; (smart-frame-positioning-mode -1) ; do not place frames behind the Dock or outside of screen boundaries

;;; PROVIDE
(provide 'lch-aquamacs)
(message "~~ lch-aquamacs: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
