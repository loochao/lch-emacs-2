;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; ONE-KEY-CONF
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
(message "=> lch-one-key: loading...")
(require 'one-key)
(require 'thing-edit)
;;; Help
(defvar one-key-menu-help-alist nil
  "The `one-key' menu alist for help.")

(setq one-key-menu-help-alist
      '(
        ;; Apropos.
        (("z" . "Apropos") . apropos)
        (("{" . "Apropos Library") . apropos-library)
        (("\"" . "Apropos Value") . apropos-value)
        (("C" . "Apropos Command") . apropos-command)
        (("F" . "Apropos Function") . apropos-function)
        (("V" . "Apropos Variable") . apropos-variable)
        (("O" . "Apropos Option") . apropos-option)
        (("a" . "Apropos Command") . apropos-command)
        (("d" . "Apropos Documentation") . apropos-documentation)
        ;; Describe.
        (("/" . "Describe Input Method") . describe-input-method)
        (("f" . "Describe Function") . describe-function)
        (("g" . "Describe Gnu Project") . describe-gnu-project)
        (("h" . "Describe Hash") . describe-hash)
        (("b" . "Describe Bindings") . describe-bindings)
        (("c" . "Describe Command") . describe-command)
        (("m" . "Describe Mode") . describe-mode)
        (("k" . "Describe Key") . describe-key)
        (("K" . "Describe Key Briefly") . describe-key-briefly)
        (("o" . "Describe Option") . describe-option)
        (("p" . "Describe Char") . describe-char)
        (("s" . "Describe Syntax") . describe-syntax)
        (("u" . "Describe Unbound Keys") . describe-unbound-keys)
        (("v" . "Describe Variable") . describe-variable)
        (("L" . "Describe Language Environment") . describe-language-environment)
        (("w" . "Describe No Warranty") . describe-no-warranty)
        (("M-f" . "Describe Face") . describe-face)
        (("M-c" . "Describe Copying") . describe-copying)
        (("M-f" . "Describe File") . describe-file)
        (("M-k" . "Describe Keymap") . describe-keymap)
        (("M-t" . "Describe Option Of Type") . describe-option-of-type)
        ;; Info.
        (("M-i" . "Info") . info)
        (("M-o" . "Info Other Window") . info-other-window)
        (("M-s" . "Info Lookup Symbol") . info-lookup-symbol)
        (("M-k" . "Info Goto Emacs Key Command Node") . Info-goto-emacs-key-command-node)
        (("M-m" . "Info Emacs Manual") . info-emacs-manual)
        ;; View.
        (("C-d" . "View Emacs Debugging") . view-emacs-debugging)
        (("C-e" . "View External Packages") . view-external-packages)
        (("C-f" . "View Emacs FAQ") . view-emacs-FAQ)
        (("C-n" . "View Emacs News") . view-emacs-news)
        (("C-p" . "View Emacs Problems") . view-emacs-problems)
        (("C-t" . "View Emacs Todo") . view-emacs-todo)
        (("C-r" . "View Order Manuals") . view-order-manuals)
        (("C-E" . "View Echo Area Messages") . view-echo-area-messages)
        (("C-l" . "View Lossage") . view-lossage)
        (("C-n" . "View Emacs News") . view-emacs-news)
        ;; Misc.
        (("C-P" . "Finder By Keyword") . finder-by-keyword)
        (("C-u" . "Display Local Help") . display-local-help)
        (("C-a" . "About Emacs") . about-emacs)
        (("C-h" . "Help For Help") . help-for-help)
        (("C-H" . "Help With Tutorial") . help-with-tutorial)
        (("C-s" . "Wtf Is") . wtf-is)
        (("C-z" . "Sys Apropos") . sys-apropos)
        (("C-w" . "Where Is") . where-is)
        (("x" . "Find Function On Key") . find-function-on-key)
        ))

(defun one-key-menu-help ()
  "The `one-key' menu for help."
  (interactive)
  (one-key-menu "help" one-key-menu-help-alist t nil nil nil t))

(define-key global-map (kbd "M-<f1>") 'one-key-menu-help)

;;; Thing-edit
(defvar one-key-menu-thing-edit-alist nil
  "The `one-key' menu alist for THING-EDIT.")

(setq one-key-menu-thing-edit-alist
      '(
        ;; Copy.
        (("w" . "Copy Word") . thing-copy-word)
        (("s" . "Copy Symbol") . thing-copy-symbol)
        (("m" . "Copy Email") . thing-copy-email)
        (("f" . "Copy Filename") . thing-copy-filename)
        (("u" . "Copy URL") . thing-copy-url)
        (("x" . "Copy Sexp") . thing-copy-sexp)
        (("g" . "Copy Page") . thing-copy-page)
        (("t" . "Copy Sentence") . thing-copy-sentence)
        (("o" . "Copy Whitespace") . thing-copy-whitespace)
        (("i" . "Copy List") . thing-copy-list)
        (("c" . "Copy Comment") . thing-copy-comment)
        (("h" . "Copy Function") . thing-copy-defun)
        (("p" . "Copy Parentheses") . thing-copy-parentheses)
        (("l" . "Copy Line") . thing-copy-line)
        (("a" . "Copy To Line Begin") . thing-copy-to-line-beginning)
        (("e" . "Copy To Line End") . thing-copy-to-line-end)
        ;; Paste.
        (("W" . "Paste Word") . thing-paste-word)
        (("S" . "Paste Symbol") . thing-paste-symbol)
        (("M" . "Paste Email") . thing-paste-email)
        (("F" . "Paste Filename") . thing-paste-filename)
        (("U" . "Paste URL") . thing-paste-url)
        (("X" . "Paste Sexp") . thing-paste-sexp)
        (("G" . "Paste Page") . thing-paste-page)
        (("T" . "Paste Sentence") . thing-paste-sentence)
        (("O" . "Paste Whitespace") . thing-paste-whitespace)
        (("I" . "Paste List") . thing-paste-list)
        (("C" . "Paste Comment") . thing-paste-comment)
        (("H" . "Paste Function") . thing-paste-defun)
        (("P" . "Paste Parentheses") . thing-paste-parentheses)
        (("L" . "Paste Line") . thing-paste-line)
        (("A" . "Paste To Line Begin") . thing-paste-to-line-beginning)
        (("E" . "Paste To Line End") . thing-paste-to-line-end)
        ))

(defun one-key-menu-thing-edit ()
  "The `one-key' menu for THING-EDIT."
  (interactive)
  (one-key-menu "THING-EDIT" one-key-menu-thing-edit-alist t))

(define-key global-map (kbd "M--") 'one-key-menu-thing-edit)
;;; PROVIDE
(provide 'lch-one-key)
(message "~~ lch-one-key: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
