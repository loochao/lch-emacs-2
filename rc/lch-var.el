;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; VARIABLES
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
(message "=> lch-var: loading...")

(setq tetris-score-file (concat emacs-var-dir "/tetris-scores"))
(setq session-save-file (concat emacs-var-dir "/emacs-session"))
(setq abbrev-file-name (concat emacs-var-dir "/abbrev"))
(setq bbdb-file (concat emacs-var-dir "/bbdb"))

(setq todo-file-do (concat emacs-var-dir "/todo-do"))
(setq todo-file-done (concat emacs-var-dir "/todo-done"))
(setq todo-file-top (concat emacs-var-dir "/todo-top"))

(setq diary-file (concat emacs-var-dir "/diary"))

;; (setq semanticdb-default-save-directory "~/.emacs.d/.semantic")
;; (setq recentf-save-file (concat emacs-var-dir "/emacs-recentf"))             ;=> lch-org.el
;; (setq ido-save-directory-list-file (concat emacs-var-dir "/emacs-ido-last")) ;=> lch-elisp.el

(setq auto-mode-alist
      (append '(
                ("\\.\\(diffs?\\|patch\\|rej\\)\\'"    . diff-mode)
                ("\\.txt$"                             . org-mode)
                ("\\.tex$"                             . tex-mode)
                ("\\.cgi$"                             . perl-mode)
                ("[mM]akefile"                         . makefile-mode)
                ("\\.bash$"                            . shell-script-mode)
                ) auto-mode-alist))
;;; PROVIDE
(provide 'lch-var)
(message "~~ lch-var: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
