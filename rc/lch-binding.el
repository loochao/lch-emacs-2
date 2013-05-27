;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; BINDINGS.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Charles Lu
;;
;; Author:  Charles Lu <loochao@gmail.com>
;; URL:     http://www.princeton.edu/~chaol
;; License: GNU
;; This file is not part of GNU Emacs.
;;
;; Commentary:
;; Global bindings
(message "=> lch-binding: loading...")

;;; REQUIRE
(require 'lch-key-util)                     ;Crucial To use lch-set-key
(require 'one-key)

;;; README
;; About command-map
;; Super and Meta are direct-command-map, like s-k is bound to 'kill-this-buffer
;; others are command-map-prefix
;; according how often the command will be used, it goes into those maps by this seq:
;; [C-c/C-x] => f1 => C-z => C-{. , / o}
;;; Super (command-map)
(lch-set-key
 '(
   ("s-," . previous-buffer)
   ("s-." . next-buffer)
   ))
;; One-key-menu-super
(defvar one-key-menu-super-alist nil "")
(setq one-key-menu-super-alist
      '(
        (("a" . "select all") . mark-whole-buffer)
        (("," . "prev-buffer") . previous-buffer)                               ;; => lch-binding.el
        (("." . "next-buffer") . next-buffer)                                   ;; => lch-binding.el
        (("k" . "kill-buffer") . kill-this-buffer)
        (("<r,l,u,d>" . "emms-seek (-/+ 10/60)"))                               ;; => lch-emms.el
        ))

(defun one-key-menu-super ()
  "The `one-key' menu for SUPER."
  (interactive)
  (one-key-menu "SUPER" one-key-menu-super-alist t))
(define-key global-map (kbd "s-m") 'one-key-menu-super)

;;; Meta (command-map)
(lch-set-key
 '(
   ("M-1" . shell)
   ))

;; One-key-menu-meta
(defvar one-key-menu-meta-alist nil "")
(setq one-key-menu-meta-alist
      '(
        (("<f1>" . "one-key-help") . one-key-menu-help)                         ;; => lch-one-key.el
        (("<left>" . "hide-body") . hide-body)                                  ;; => lch-elisp.el
        (("<right>" . "show-all") . show-all)                                   ;; => lch-elisp.el
        (("<up>" . "outline-previous-heading") . outline-previous-heading)      ;; => lch-elisp.el
        (("<down>" . "outline-next-heading") . outline-next-heading)            ;; => lch-elisp.el
        (("<SPC>" . "anything") . anything)                                     ;; => lch-elisp.el
        (("/" . "dabbrev") . dabbrev-expand)                                    ;; => emacs-defaults
        (("'" . "yasnippet") . yas-expand)                                      ;; => lch-elisp.el        
        (("-" . "thing-edit") . one-key-menu-edit)                              ;; => lch-one-key.el
        (("1" . "shell") . shell)                                               ;; => lch-binding.el
        (("2" . "term") . lch-create-switch-term)                               ;; => lch-binding.el
        (("6" . "erc-switch") . one-key-menu-irc-channel)                       ;; => lch-web.el
        (("8" . "org-agenda") . org-agenda)                                     ;; => lch-org.el
        (("9" . "anything-menu") . one-key-menu-anything)                       ;; => lch-binding.el
        (("a" . "anything-map") . anything)                                     ;; => lch-elisp.el
        (("k" . "one-key-kill") . one-key-menu-kill)                            ;; => lch-util.el
        (("o" . "org-export-menu") . one-key-menu-org-export)                   ;; => lch-org-export.el
        ))

(defun one-key-menu-meta ()
  "The `one-key' menu for META."
  (interactive)
  (one-key-menu "META" one-key-menu-meta-alist t))
(define-key global-map (kbd "M-m") 'one-key-menu-meta)

(defun lch-anything-menu ()
  "Generate one-key menu from anything-config.el"
  (with-temp-buffer
    (delete-region (point-min) (point-max))
    (insert-file (concat emacs-lisp-dir "/anything/anything-config.el"))
    (goto-char (point-min))
    (search-forward "define-key anything-command-map")
    (beginning-of-line)
    (kill-region (point-min) (point))
    (search-forward "'anything-c-run-external-command)")
    (end-of-line)
    (kill-region (point) (point-max))
    (goto-char (point-min))
    (while (search-forward "(define-key anything-command-map (kbd " nil t)
      (replace-match ""))
    (goto-char (point-min))
    (while (re-search-forward ") +'" nil t) (replace-match " . "))
    (goto-char (point-min))
    (while (re-search-forward "^\"" nil t) (replace-match "((\""))
    (goto-char (point-min))
    (while (re-search-forward "\\. \\(.+\\))" nil t) (replace-match ". \\1) . \\1)"))
    (goto-char (point-min))
    (while (re-search-forward " \\. \\(.*?\\))" nil t) (replace-match " . \"\\1\")"))
    (goto-char (point-min))
    (while (re-search-forward ") \\. \"\\(.*?\\)\")" nil t) (replace-match ") . \\1)"))
    (goto-char (point-min))
    (insert "(defvar one-key-menu-anything-alist nil \"\")")
    (newline-and-indent)
    (insert "(setq one-key-menu-anything-alist")
    (newline-and-indent)

    (insert "'(")
    (goto-char (point-max))

    (newline-and-indent)
    (insert "))")
    (lch-indent-buffer)
    (eval-buffer)
    ))

(lch-anything-menu)
(defun one-key-menu-anything ()
  "The `one-key' menu for ANYTHING."
  (interactive)
  (one-key-menu "ANYTHING" one-key-menu-anything-alist t))
(define-key global-map (kbd "M-9") 'one-key-menu-anything)

;;; Ctrl (command-map)
(lch-set-key
 '(
   ("C-=" . text-scale-increase)
   ("C--" . text-scale-decrease)
   ("C-2" . set-mark-command)
   ("C-o" . occur)
   ))

(defvar one-key-menu-ctrl-alist nil "")
(setq one-key-menu-ctrl-alist
      '(
        (("=" . "magnify-font") . text-scale-increase)                          ;; => lch-binding.el
        (("-" . "demagnify-font") . text-scale-decrease)                        ;; => lch-binding.el
        (("2" . "set-mark-command") . set-mark-command)                         ;; => lch-binding.el
        (("6" . "dired-jump") . dired-jump)                                     ;; => lch-dired.el
        (("o" . "occur") . occur)                                               ;; => lch-binding.el
        ))

(defun one-key-menu-ctrl ()
  "The `one-key' menu for CTRL."
  (interactive)
  (one-key-menu "CTRL" one-key-menu-ctrl-alist t))
(define-key global-map (kbd "C-M-m") 'one-key-menu-ctrl)

;;; C-x (command-map)
;; One-key-menu-ctrl-x
(lch-set-key
 '(
   ("C-x 4" . toggle-truncate-lines)
   ("C-x f" . ffap)
   ("C-x g" . goto-line)
   ("C-x u" . undo-tree-visualize)
   ("C-x C-b" . ibuffer)
   ))

(defvar one-key-menu-ctrl-x-alist nil "")
(setq one-key-menu-ctrl-x-alist
      '(
        (("4" . "toggle-truncate-lines") . toggle-truncate-lines)               ;; => lch-binding.el
        (("f" . "ffap") . ffap)                                                 ;; => lch-binding.el
        (("g" . "goto-line") . goto-line)                                       ;; => lch-binding.el
        (("u" . "undo-tree") . undo-tree-visualize)                             ;; => lch-elisp.el
        (("C-b" . "ibuffer") . ibuffer)                                         ;; => lch-elisp.el
        (("C-r" . "recentf") . recentf-open-files)                              ;; => lch-elisp.el
        ))

(defun one-key-menu-ctrl-x ()
  "The `one-key' menu for CTRL-X."
  (interactive)
  (one-key-menu "CTRL-X" one-key-menu-ctrl-x-alist t))
(define-key global-map (kbd "C-x m") 'one-key-menu-ctrl-x)

;;; C-c (command-map)
(lch-set-key
 '(
   ("C-c ." . repeat-complex-command)
   ("C-c c" . comment-region)                                                   ;; Shift+4 == $
   ("C-c g" . grep-find)
   ("C-c o" . occur)
   ("C-c u" . uncomment-region)
   ("C-c v" . less-minor-mode)
   ("C-c C-b" . list-bookmarks)
   ))

;; One-key-menu-ctrl-c
(defvar one-key-menu-ctrl-c-alist nil "")
(setq one-key-menu-ctrl-c-alist
      '(
        (("." . "repeat-complex-command") . repeat-complex-command)             ;; => lch-binding.el
        (("a" . "toggle-archive") . lch-toggle-archive)                         ;; => lch-util.el
        (("c" . "comment-region") . comment-region)                             ;; => lch-binding.el
        (("e" . "eval-buffer") . lch-eval-buffer)                               ;; => lch-util.el
        (("g" . "grep-find") . grep-find)                                       ;; => lch-binding.el
        (("i" . "indent-buffer-or-region") . lch-indent-region-or-buffer)       ;; => lch-util.el
        (("j" . "ace-jump") . ace-jump-mode)                                    ;; => lch-binding.el
        (("o" . "occur") . occur)                                               ;; => lch-binding.el
        (("s" . "-> scratch") . lch-create-switch-scratch)                      ;; => lch-util.el
        (("u" . "uncomment-region") . uncomment-region)                         ;; => lch-binding.el
        (("v" . "less") . less-minor-mode)                                      ;; => lch-binding.el
        (("C-b" . "list-bookmarks") . list-bookmarks)                           ;; => lch-binding.el
        (("C-f" . "lch-sudo-edit") . lch-sudo-edit)                             ;; => lch-network.el
        ))

(defun one-key-menu-ctrl-c ()
  "The `one-key' menu for CTRL-C."
  (interactive)
  (one-key-menu "CTRL-C" one-key-menu-ctrl-c-alist t))
(define-key global-map (kbd "C-c m") 'one-key-menu-ctrl-c)

;;; C-z (command-map)
(lch-set-key
 '(
   ("C-z c" . count-words)
   ))
;; One-key-menu-ctrl-z
(defvar one-key-menu-ctrl-z-alist nil "")
(setq one-key-menu-ctrl-z-alist
      '(
        (("c" . "count-words") . count-words)                                       ;; => lch-binding.el
        (("p" . "process") . lch-process)                                           ;; => lch-util.el
        (("f" . "fortune") . lch-echo-fortune)                                      ;; => lch-util.el
        ))
(defun one-key-menu-ctrl-z ()
  "The `one-key' menu for CTRL-Z."
  (interactive)
  (one-key-menu "CTRL-Z" one-key-menu-ctrl-z-alist t))
(define-key global-map (kbd "C-z m") 'one-key-menu-ctrl-z)

;;; Fn: (command-map)
(defvar one-key-menu-fn-alist nil "")
(setq one-key-menu-fn-alist
      '(
        (("<f2>" . "goto-last-change") . goto-last-change)                      ;; => lch-elisp.el
        (("<f3>" . "w3m") . lch-w3m-init)                                       ;; => lch-web.el
        (("<f7>" . "dictionary") . dictionary-search)                           ;; => lch-elisp.el
        (("<f8>" . "org-agenda") . org-agenda)                                  ;; => lch-org.el
        (("<f9>" . "lch-start-file-browser") . lch-start-file-browser)          ;; => lch-util.el
        (("<f12>" . "emms") . lch-emms-init)                                    ;; => lch-emms.el
        (("Shift+ [l,r,u,d] ->" . "windmove") . zone)                           ;; => lch-elisp.el
        (("M-<f9>" . "dired-single-magic") . dired-single-magic-buffer)         ;; => lch-dired.el
        (("M-<f12>" . "douban-music") . douban-music)                           ;; => lch-elisp.el
      ))

(defun one-key-menu-fn ()
  "The `one-key' menu for FN."
  (interactive)
  (one-key-menu "FN" one-key-menu-fn-alist t))
(define-key global-map (kbd "<f1> <f1>") 'one-key-menu-fn)

;;; F1: (command-map)
(lch-set-key
 '(
   ("<f1> r" . re-builder)
   ("<f1> l" . locate)
   ("<f1> z" . zone)
   ))

;; One-key-menu-command
(defvar one-key-menu-command-alist nil "")
(setq one-key-menu-command-alist
      '(
        (("<f2>" . "start-terminal") . lch-start-terminal)                   ;; => lch-util.el
        (("f" . "fortune") . lch-cowsay-fortune)                             ;; => lch-elisp.el
        (("l" . "locate") . locate)                                          ;; => lch-binding.el
        (("r" . "re-builder") . re-builder)                                  ;; => lch-binding.el
        (("z" . "zone") . zone)                                              ;; => lch-binding.el
        ))

(defun one-key-menu-command ()
  "The `one-key' menu for COMMAND."
  (interactive)
  (one-key-menu "COMMAND" one-key-menu-command-alist t))
(define-key global-map (kbd "<f1> m") 'one-key-menu-command)

;;; F2: (mode-map)
(lch-set-key
 '(
   ("<f2> a" . auto-complete-mode)
   ("<f2> A" . artist-mode)
   ("<f2> c" . calendar)
   ("<f2> C" . calc)
   ("<f2> f" . auto-fill-mode)
   ("<f2> l" . lisp-mode)
   ("<f2> o" . org-mode)
   ("<f2> O" . outline-minor-mode)
   ("<f2> s" . flyspell-mode)
   ("<f2> w" . whitespace-mode)
   ))

;; One-key-menu-mode
(defvar one-key-menu-mode-alist nil "")
(setq one-key-menu-mode-alist
      '(
        (("a" . "auto-complete") . auto-complete-mode)                          ;; => lch-binding.el
        (("A" . "artist") . artist-mode)                                        ;; => lch-binding.el
        (("c" . "calendar") . calendar)                                         ;; => lch-binding.el
        (("C" . "calc") . calc)                                                 ;; => lch-binding.el
        (("f" . "auto-fill-mode") . auto-fill-mode)                             ;; => lch-binding.el
        (("l" . "lisp-mode") . lisp-mode)                                       ;; => lch-binding.el
        (("o" . "org-mode") . org-mode)                                         ;; => lch-binding.el
        (("O" . "outline-mode") . outline-minor-mode)                           ;; => lch-binding.el
        (("p" . "paredit-mode") . paredit-mode)                                 ;; => lch-binding.el
        (("s" . "flyspell-mode") . flyspell-mode)                               ;; => lch-binding.el
        (("w" . "whitespace-mode") . whitespace-mode)                           ;; => lch-binding.el
        ))

(defun one-key-menu-mode ()
  "The `one-key' menu for MODE."
  (interactive)
  (one-key-menu "MODE" one-key-menu-mode-alist t))
(define-key global-map (kbd "<f2> m") 'one-key-menu-mode)
;;; F3: (web-map)
;; W3m and webpage related.
(defvar one-key-menu-web-alist nil
  "The `one-key' menu alist for WEB.")

(setq one-key-menu-web-alist
      '(
        (("<f3>" . "w3m-init") . lch-w3m-init)                             ;; => lch-web.el
        (("g" . "google") . lch-google)                                    ;; => lch-web.el
        (("s" . "w3m-search") . one-key-menu-w3m-search)                   ;; => lch-web.el
        ))

(defun one-key-menu-web ()
  "The `one-key' menu for WEB."
  (interactive)
  (one-key-menu "WEB" one-key-menu-web-alist t))
(define-key global-map (kbd "<f3> m") 'one-key-menu-web)

;;; F4: (buffer-edit-map)
(lch-set-key
 '(
   ("<f4> f" . fill-region)
   ))

(defvar one-key-menu-edit-alist nil
  "The `one-key' menu alist for EDIT.")

(setq one-key-menu-edit-alist
      '(
        (("3" . "copy-filename") . lch-copy-file-name-to-clipboard)        ;; => lch-util.el
        (("c" . "cleanup-buffer") . lch-cleanup-buffer)                    ;; => lch-util.el
        (("d" . "delete-buffer-n-file") . lch-delete-file-and-buffer)      ;; => lch-util.el
        (("f" . "fill-region") . fill-region)                              ;; => lch-binding.el
        (("k" . "kill-all-buffers") . kill-all-buffers)                    ;; => lch-util.el
        (("r" . "rename-buffer-n-file") . lch-rename-file-and-buffer)      ;; => lch-util.el
        (("t" . "insert-template") . template-expand-template)             ;; => lch-elisp.el
        ))

(defun one-key-menu-edit ()
  "The `one-key' menu for EDIT."
  (interactive)
  (one-key-menu "EDIT" one-key-menu-edit-alist t))
(define-key global-map (kbd "<f4> m") 'one-key-menu-edit)

;;; F5: (bookmark-map)
(defvar one-key-menu-bmk-alist nil
  "The `one-key' menu alist for BMK.")

(setq one-key-menu-bmk-alist
      '(
        (("a" . "add-bookmark") . bookmark-set)                   ;; => lch-bmk.el
        (("b" . "list-bookmark") . list-bookmarks)                ;; => lch-bmk.el
        (("j" . "jump-to-bookmark") . switch-to-bookmark)         ;; => lch-bmk.el
        (("n" . "bc-local-next") . bc-local-next)                 ;; => lch-bmk.el
        (("p" . "bc-local-previous") . bc-local-previous)         ;; => lch-bmk.el
        (("g" . "bc-goto-current") . bc-goto-current)             ;; => lch-bmk.el
        (("l" . "bc-list") . bc-list)                             ;; => lch-bmk.el
        (("/" . "bc-list") . bc-list)                             ;; => lch-bmk.el
        (("," . "bc-previous") . bc-previous)                     ;; => lch-bmk.el
        (("." . "bc-next") . bc-next)                             ;; => lch-bmk.el
        (("'" . "bc-set") . bc-set)                               ;; => lch-bmk.el
        (("<f5>" . "bc-set") . bc-set)                            ;; => lch-bmk.el
        ))

(defun one-key-menu-bmk ()
  "The `one-key' menu for BMK."
  (interactive)
  (one-key-menu "BMK" one-key-menu-bmk-alist t))
(define-key global-map (kbd "<f5> m") 'one-key-menu-bmk)

;;; F6: (network-map)
;; Network apps like erc related.
(defvar one-key-menu-network-alist nil
  "The `one-key' menu alist for NETWORK.")

(setq one-key-menu-network-alist
      '(
        (("<f6>" . "lch-erc-init") . lch-erc-init)                         ;; => lch-network.el
        (("e" . "lch-erc-init") . lch-erc-init)                            ;; => lch-network.el
        (("q" . "lch-erc-quit") . lch-erc-quit)                            ;; => lch-network.el
        ))

(defun one-key-menu-network ()
  "The `one-key' menu for NETWORK."
  (interactive)
  (one-key-menu "NETWORK" one-key-menu-network-alist t))
(define-key global-map (kbd "<f6> m") 'one-key-menu-network)

;;; F7: (dictionary-map)
(defvar one-key-menu-dict-alist nil
  "The `one-key' menu alist for DICT.")

(setq one-key-menu-dict-alist
      '(
        (("<f7>" . "dict-search") . dictionary-search)                    ;; => lch-elisp.el
        ))

(defun one-key-menu-dict ()
  "The `one-key' menu for DICT."
  (interactive)
  (one-key-menu "DICT" one-key-menu-dict-alist t))
(define-key global-map (kbd "<f7> m") 'one-key-menu-dict)

;;; F8: 
;;; F9: (file-map)
(define-key global-map (kbd "<f9> 1") (lambda() (interactive) (dired org-source-dir)))

(define-key global-map (kbd "<f9> a") (lambda() (interactive) (find-file (concat org-source-dir "/Art-Ent.org"))))
(define-key global-map (kbd "<f9> b") (lambda() (interactive) (find-file (concat org-source-dir "/Bib-Edu.org"))))
(define-key global-map (kbd "<f9> C") (lambda() (interactive) (find-file (concat org-source-dir "/Culture.org"))))
(define-key global-map (kbd "<f9> C-c") (lambda() (interactive) (find-file (concat org-source-dir "/ComputerSE.org"))))
(define-key global-map (kbd "<f9> d") (lambda() (interactive) (find-file (concat emacs-doc-dir "/loochao-cheat-sheet.tex"))))
(define-key global-map (kbd "<f9> e") (lambda() (interactive) (find-file (concat org-source-dir "/Emacs.org"))))
(define-key global-map (kbd "<f9> E") (lambda() (interactive) (find-file (concat org-source-dir "/English.org"))))
(define-key global-map (kbd "<f9> C-e") (lambda() (interactive) (find-file (concat org-source-dir "/Economy.org"))))
(define-key global-map (kbd "<f9> g") (lambda() (interactive) (find-file (concat org-source-dir "/generality.org"))))
(define-key global-map (kbd "<f9> h") (lambda() (interactive) (find-file (concat org-source-dir "/Humor.org"))))
(define-key global-map (kbd "<f9> H") (lambda() (interactive) (find-file (concat org-source-dir "/Html.org"))))
(define-key global-map (kbd "<f9> C-h") (lambda() (interactive) (find-file (concat org-source-dir "/History.org"))))

(define-key global-map (kbd "<f9> i c") (lambda() (interactive) (find-file (concat org-private-dir "/iCount.org"))))
(define-key global-map (kbd "<f9> i d") (lambda() (interactive) (find-file (concat org-private-dir "/iDea.org"))))
(define-key global-map (kbd "<f9> i l") (lambda() (interactive) (find-file (concat org-private-dir "/iLog.org"))))
(define-key global-map (kbd "<f9> i n") (lambda() (interactive) (find-file (concat org-private-dir "/index.org"))))
(define-key global-map (kbd "<f9> i r") (lambda() (interactive) (find-file (concat org-private-dir "/iRsch.org"))))
(define-key global-map (kbd "<f9> i s") (lambda() (interactive) (find-file (concat org-private-dir "/iStuff.org"))))
(define-key global-map (kbd "<f9> i p") (lambda() (interactive) (find-file (concat org-private-dir "/iPrv.org"))))

(define-key global-map (kbd "<f9> l") (lambda() (interactive) (find-file (concat dropbox-path "/Library/Library.bib"))))
(define-key global-map (kbd "<f9> L") (lambda() (interactive) (find-file (concat org-source-dir "/Life.org"))))
(define-key global-map (kbd "<f9> C-l") (lambda() (interactive) (find-file (concat org-source-dir "/Library.org"))))
(define-key global-map (kbd "<f9> M") (lambda() (interactive) (find-file (concat org-source-dir "/Mathematics.org"))))
(define-key global-map (kbd "<f9> C-m") (lambda() (interactive) (find-file (concat org-source-dir "/Miscellaneous.org"))))
(define-key global-map (kbd "<f9> M-m") (lambda() (interactive) (find-file (concat org-source-dir "/Methodology.org"))))
(define-key global-map (kbd "<f9> O") (lambda() (interactive) (find-file (concat org-source-dir "/Opera.org"))))
(define-key global-map (kbd "<f9> p") (lambda() (interactive) (find-file (concat org-source-dir "/Pearl.org"))))
(define-key global-map (kbd "<f9> P") (lambda() (interactive) (find-file (concat org-source-dir "/Programming.org"))))
(define-key global-map (kbd "<f9> C-p") (lambda() (interactive) (find-file (concat org-source-dir "/iPU.org"))))
(define-key global-map (kbd "<f9> M-p") (lambda() (interactive) (find-file (concat org-source-dir "/Physics.org"))))
(define-key global-map (kbd "<f9> r") (lambda() (interactive) (find-file (concat dropbox-path "/Research/Research.bib"))))
(define-key global-map (kbd "<f9> R") (lambda() (interactive) (find-file (concat org-source-dir "/Refile.org"))))
(define-key global-map (kbd "<f9> s") (lambda() (interactive) (find-file (concat org-source-dir "/Softip.org"))))
(define-key global-map (kbd "<f9> S") (lambda() (interactive) (find-file (concat org-source-dir "/Sitemap.org"))))
(define-key global-map (kbd "<f9> u") (lambda() (interactive) (find-file (concat org-source-dir "/Unix.org"))))
(define-key global-map (kbd "<f9> W") (lambda() (interactive) (dired (concat dropbox-path "/GIT/Worg"))))
;; F9-ends
(defun lch-f9-menu-prompt ()
  (interactive)
  (let ( (begin 0) )
    (message "Too many to prompt. Please go to %s to find out." (concat emacs-rc-dir "/lch-binding.el"))
    (sit-for 1)
    (if  (yes-or-no-p "Would you like my opening binding-conf-file for you, my lord?")
        (progn
          (split-window-below)
          (other-window 1)
          (switch-to-buffer (get-buffer-create "*f9-menu*"))
          (insert-file (concat emacs-rc-dir "/lch-binding.el"))
          (search-forward "F9: (file-map)" nil t)
          (setq begin (point))
          (search-forward "F9-ends" nil t)
          (forward-line -1)
          (end-of-line)
          (emacs-lisp-mode)
          (narrow-to-region begin (point))
          (goto-char (point-min)))
      (progn
        (message "Have a nice day!")))
    ))
(define-key global-map (kbd "<f9> m") 'lch-f9-menu-prompt)
;;; F10 (file-map)
(define-key global-map (kbd "<f10> 1") (lambda() (interactive) (dired (concat emacs-dir "/rc"))))
(define-key global-map (kbd "<f10> 2") (lambda() (interactive) (dired dropbox-path)))
(define-key global-map (kbd "<f10> 3") (lambda() (interactive) (dired "~/Downloads")))
(define-key global-map (kbd "<f10> 4") (lambda() (interactive) (dired emacs-lisp-dir)))

(define-key global-map (kbd "<f10> b") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-binding.el"))))
(define-key global-map (kbd "<f10> B") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-bmk.el"))))
(define-key global-map (kbd "<f10> c") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-conf.el"))))
(define-key global-map (kbd "<f10> d") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-dired.el"))))
(define-key global-map (kbd "<f10> D") (lambda() (interactive) (find-file "~/.emacs")))
(define-key global-map (kbd "<f10> e") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-elisp.el"))))
(define-key global-map (kbd "<f10> E") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-emms.el"))))
(define-key global-map (kbd "<f10> C-e") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-env.el"))))
(define-key global-map (kbd "<f10> i") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-init.el"))))
(define-key global-map (kbd "<f10> n") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-network.el"))))
(define-key global-map (kbd "<f10> o") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-org.el"))))
(define-key global-map (kbd "<f10> p") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-one-key.el"))))
(define-key global-map (kbd "<f10> t") (lambda() (interactive) (find-file (concat emacs-dir "/rc/color-theme-loochao.el"))))
(define-key global-map (kbd "<f10> u") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-util.el"))))
(define-key global-map (kbd "<f10> v") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-var.el"))))
(define-key global-map (kbd "<f10> U") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-ui.el"))))
(define-key global-map (kbd "<f10> w") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-web.el"))))
;; F10-end

(defun lch-f10-menu-generate ()
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (switch-to-buffer (get-buffer-create "*f10-menu*"))
  (insert-file (concat emacs-rc-dir "/lch-binding.el"))
  (emacs-lisp-mode)
  (outline-minor-mode -1)
  (goto-char (point-min))
  (search-forward ";;; F10 (file-map)")
  (forward-line 1)
  (beginning-of-line)
  (delete-region (point-min) (point))
  (search-forward ";; F10-end")
  (forward-line -1)
  (end-of-line)
  (kill-region (point) (point-max))
  (goto-char (point-min))
  (while (search-forward "(define-key global-map (kbd " nil t)
    (replace-match "("))
  (goto-char (point-min))
  (while (search-forward " (lambda() (interactive) " nil t)
    (replace-match " \t <-> \t"))
  (goto-char (point-min))
  (while (re-search-forward "dired \\|find-file " nil t)
    (replace-match ""))
  (goto-char (point-min))
  (while (search-forward "(concat emacs-dir " nil t)
    (replace-match ""))
  (goto-char (point-min))
  (while (re-search-forward ")+" nil t)
    (replace-match ")"))
  (goto-char (point-min))
  (other-window 1))

(define-key global-map (kbd "<f10> m") 'lch-f10-menu-generate)

;;; F11 (ui-map)
(lch-set-key
 '(
   ("<f11> /" . eyedropper-foreground)
   ("<f11> b" . eyedropper-background)
   ("<f11> f" . eyedropper-foreground)
   ("<f11> l" . global-hl-line-mode)
   ("<f11> L" . setnu-mode)
   ("<f11> t" . tool-bar-mode)
   ))
;; One-key-menu-ui
(defvar one-key-menu-ui-alist nil "")
(setq one-key-menu-ui-alist
      '(
        (("1" . "cycle-fg-forward") . lch-cycle-fg-color-forward)               ;; => lch-ui.el
        (("2" . "cycle-bg-forward") . lch-cycle-bg-color-forward)               ;; => lch-ui.el
        (("3" . "frame-bg-pink") . lch-frame-pink)                              ;; => lch-ui.el
        (("4" . "frame-bg-black") . lch-frame-black)                            ;; => lch-ui.el
        (("/" . "eyedropper foreground") . eyedropper-foreground)
        (("b" . "eyedropper background") . eyedropper-background)
        (("f" . "eyedropper foreground") . eyedropper-foreground)
        (("l" . "highlight-line") . global-hl-line-mode)                        ;; => lch-binding.el
        (("L" . "setnu-mode") . setnu-mode)                                     ;; => lch-binding.el
        (("r" . "rainbow-delimiter") . rainbow-delimiters-mode)                 ;; => lch-ui.el
        (("R" . "rainbow-mode") . rainbow-mode)                                 ;; => lch-ui.el
        (("t" . "tool-bar-mode") . tool-bar-mode)                               ;; => lch-binding.el
        ))

(defun one-key-menu-ui ()
  "The `one-key' menu for UI."
  (interactive)
  (one-key-menu "UI" one-key-menu-ui-alist t))
(define-key global-map (kbd "<f11> m") 'one-key-menu-ui)

;;; F12 (emms-map)

;; One-key-menu-emms
(defvar one-key-menu-emms-alist nil
  "The `one-key' menu alist for EMMS.")

(setq one-key-menu-emms-alist
      '(
        (("<f12>" . "emms-init") . lch-emms-init)
        (("<f11>" . "emms-dir-switch") . lch-emms-music-dir-switch)
        (("<f10>" . "emms-add-dir") . lch-emms-add-dir)
        (("<f9>" . "emms-play-file") . emms-play-file)
        (("SPC" . "toggle-playing") . lch-emms-toggle-playing)
        (("," . "emms-previous") . emms-previous)
        (("." . "emms-next") . emms-next)
        (("/" . "emms-show") . emms-show)
        (("c" . "emms-check-in") . lch-emms-check-in)
        (("d" . "emms-dump") . lch-emms-dump)
        (("i" . "emms-mode-line") . emms-mode-line-toggle)
        (("j" . "emms-jump-to-file") . emms-jump-to-file)
        (("n" . "emms-next") . emms-next)
        (("p" . "emms-previous") . emms-previous)
        (("q" . "emms-quit") . lch-emms-quit)
        (("r" . "repeat-one") . emms-toggle-repeat-track)
        (("R" . "repeat-playlist") . emms-toggle-repeat-playlist)
        (("s" . "emms-shuffle") . lch-emms-shuffle)
        (("S" . "emms-stop") . emms-stop)
        (("x" . "emms-stop") . emms-stop)
        ))

(defun one-key-menu-emms ()
  "The `one-key' menu for EMMS."
  (interactive)
  (one-key-menu "EMMS" one-key-menu-emms-alist t))
(define-key global-map (kbd "<f12> m") 'one-key-menu-emms)

(lch-menu-to-key one-key-menu-emms-alist "<f12>")

;;; PROVIDE
(provide 'lch-binding)
(message "~~ lch-binding: done.")


;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
