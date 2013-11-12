;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; ORG
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
(message "=> lch-org: loading...")

;;; Vars
(defvar org-dir (concat emacs-path "/Org") "org dir")
(defvar org-source-dir (concat org-dir "/org")  "org source dir")
(defvar pub-html-dir (concat org-dir "/public_html") "public html dir")
(defvar org-mobile-dir (concat emacs-path "/MobileOrg") "org mobile dir")
(defvar org-private-dir (concat org-dir "/org")  "org private dir")
(defvar prv-html-dir (concat org-dir "/public_html") "private html dir")
(defvar worg-dir (concat git-dir "/worg")  "worg source dir")
(defvar worg-html-dir (concat git-dir "/worg_html") "worg html dir")

;;; Setting
;; Org now part of GNU Emacs
;;(require 'org-install)
(require 'org)
;; (load "org-loaddefs")

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(add-to-list 'auto-mode-alist '("README$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(setq org-tags-column -90)

;; (define-key global-map (kbd "C-c l") 'org-store-link)

(setq org-completion-use-ido t)
(setq org-hide-leading-stars t)        ;; Hide the first N-1 stars in a headline.
(setq org-log-done t)
(setq org-export-email-info t)
(setq org-reverse-note-order t)        ;; New notes on top.
(setq org-deadline-warning-days 14)    ;; No. of days to display before expiration of a deadline.

(setq org-directory org-private-dir)
(setq org-agenda-files
      (append (file-expand-wildcards (concat org-source-dir "/*.org"))))
(setq org-export-default-language "EN")

(setq org-mobile-directory org-mobile-dir)
(setq org-mobile-force-id-on-agenda-items nil)
(setq org-mobile-inbox-for-pull (concat org-mobile-dir "/mobileOrg.org"))

(setq org-export-with-LaTeX-fragments t)
;;; Todo
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords '((sequence "QUEUE(q)" "ACTIVE(a)" "PENDING(p@/!)" "|" "DONE(d@/!)" "CANCELLED(c@/!)")
                          (sequence "TOFNSH(t)" "|" "DONE")
                          (sequence "INVOICE(i)" "SENT(n)" "|" "RCVD(r)")
                          (sequence "PROJECT(P)" "|" "DONE(d)")
                          (type "APPT(a)")
                          (type "OBTAIN(o)" "EDU_OBT(e)" "NET_OBT(n)")
                          (type "TOSORT(S)")
                          (type "DELEGATED(d@!)")
                          (type "WAITING(w@/!)")
                          (type "SCHEDULED(s@/!)")
 ))

(setq org-todo-keyword-faces '(
                       ("QUEUE" :foreground "Lavender" :weight bold)
                       ("ACTIVE" :foreground "Cyan" :weight bold)
                       ("TOFNSH" :foreground "PINK" :weight bold)
                       ("DONE" :foreground "PeachPuff2" :weight bold)
                       ;; ("WAITING" :foreground "medium blue" :weight bold)
                       ("APPT" :foreground "medium blue" :weight bold)
                       ("NOTE" :foreground "brown" :weight bold)
                       ("STARTED" :foreground "dark orange" :weight bold)
                       ;; ("TODO" :foreground "red" :weight bold)
                       ("DELEGATED" :foreground "dark violet" :weight bold)
                       ("DEFERRED" :foreground "dark blue" :weight bold)
                       ("SOMEDAY" :foreground "dark blue" :weight bold)
                       ("PROJECT" :height 1.5 :weight bold :foreground "black")
                       ))
;;; Tag
(setq org-fast-tag-selection-single-key t)
(setq org-tag-alist '(
                      ("#A" . ?[)
                      ("#B" . ?])
                      ("#C" . ?\\)

                      ("Audio" . ?a)
                      ("Book" . ?b)
                      ("BIB" . ?B)
                      ("Culture" . ?c)
                      ("ComputerSE" . ?C)
                      ("Doc" . ?d)
                      ;; ("Cookery" . ?)
                      ("EBook" . ?e)
                      ;; ("English" . ?E)
                      ("EDU" . ?E)
                      ("GuoXue" . ?g)
                      ("Humor" . ?h)
                      ("HDoc" . ?H)
                      ("IDEA" . ?i)
                      ("Library" . ?l)
                      ("Life" . ?L)
                      ;; ("Love" . ?)
                      ;; ("List" . ?)
                      ("Mathematics" . ?m)
                      ("OBTAIN" . ?o)
                      ("Org" . ?O)
                      ("PLAN" . ?p)
                      ("Physics" . ?P)
                      ("Question" . ?q)
                      ("Research" . ?r)

                      ("Video" . ?v)
                      ("Web" . ?w)

                      ("ACTIVE" . ?1)
                      ("MOBILE" . ?2)
                      ("AUDIO" . ?3)
                      ("CAR" . ?4)

                      (:startgroup . nil)
                      ("BIB" . ?0)
                      ("STAR3" . ?,)
                      ("STAR4" . ?.)
                      ("STAR5" . ?/)
                      (:endgroup . nil)
                      ))

(setq org-tag-faces
      '(
        ("Audio" . (:foreground "Noccasin" :weight bold))
        ("Book" . (:foreground "Siennal1" :weight bold))
        ("Doc" . (:foreground "PaleGreen" :weight bold))
        ("EBook" . (:foreground "Gold1" :weight bold))
        ("Video" . (:foreground "Violet" :weight bold))

        ("BIB" . (:foreground "DeepSkyBlue" :background "OldLace" :weight bold))
        ("STAR3" . (:foreground "Black" :background "Grey" :weight bold))
        ("STAR4" . (:foreground "Black" :background "SandyBrown" :weight bold))
        ("STAR5" . (:foreground "Black" :background "MistyRose" :weight bold :box (:line-width 1 :style none)))

        ("Library" . (:foreground "LightCyan" :weight bold))
        ("Mathematics" . (:foreground "Tomato" :weight bold))
        ("Physics" . (:foreground "Peru" :weight bold))
        ("Question" . (:foreground "GreenYellow" :weight bold))
        ("ProbSet" . (:foreground "IndianRed" :weight bold))
        ("DATA" . (:foreground "NavyBlue" :background "OldLace" :weight bold))
        ("IMAGE" . (:foreground "DarkViolet" :background "OldLace" :weight bold))
        ("OBTAIN" . (:foreground "Moccasin" :weight bold))
        ("STUDY" . (:foreground "Gold" :weight bold))
        ("#A" . (:foreground "OrangeRed" :weight bold))
        ("#B" . (:foreground "Pink" :weight bold))
        ("#C" . (:foreground "Light Green" :weight bold))
        ("QUEUE" . (:foreground "Lavender" :weight bold))
        ("ACTIVE" . (:foreground "Cyan" :weight bold))
        ("T" . (:foreground "Cyan" :weight bold))
        ("DONE" . (:foreground "PeachPuff2" :weight bold))

        ("AUDIO" . (:foreground "Cyan" :weight bold))
        ("MOBILE" . (:foreground "Cyan" :weight bold))
        ("CAR" . (:foreground "Cyan" :weight bold))
        ("RECUR" . (:foreground "Cyan" :weight bold))
        ("DAILY" . (:foreground "Cyan" :weight bold))
        ("DUALLY" . (:foreground "Cyan" :weight bold))
        ("TRIPLY" . (:foreground "Cyan" :weight bold))
        ("WEEKLY" . (:foreground "Cyan" :weight bold))
        ))
;;; Babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (perl . t)
   (ditaa . t)
   (dot . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (haskell . nil)
   (ocaml . nil)
   (python . t)
   (ruby . t)
   (screen . nil)
   (sh . t)
   (sql . nil)
   (sqlite . t)))

;; No prompt on every code block evaluation
(setq org-confirm-babel-evaluate nil)
;;; Capture
;; %a          annotation, normally the link created with org-store-link
;; %i          initial content, the region when remember is called with C-u.
;; %t          timestamp, date only
;; %T          timestamp with date and time
;; %u, %U      like the above, but inactive timestamps

(define-key global-map (kbd "M-0") 'org-capture)

(setq org-capture-templates
      '(
        ("a" "TODO-#A" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#A" "TODO-#A-") "* %? :#A:\n%U" :prepend t)
	;; ("A" "TODO-#A~" entry (file+olp (concat org-private-dir "/Refile.org") "TODOs" "TODO-#A") "* %? :#A:\n%U" :prepend t)
        ("b" "TODO-#B" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#B" "TODO-#B-") "* %? :#B:\n%U" :prepend t)
        ("B" "ACTIVE-#B" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#B" "TODO-#B-") "* ACTIVE %? :#B:\n%U" :prepend t)
        ("8" "BIB" entry (file+olp (concat org-private-dir "/Refile.org") "BIBs" "BIB") "* %? \n%U" :prepend t)
        ;; ("c" "TODO-#C" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#C" "TODO-#C-") "* %? :#C:\n%U" :prepend t)
        ;; ("C" "TODO-#C~" entry (file+olp (concat org-private-dir "/Refile.org") "TODOs" "TODO-#C") "* %? :#C:\n%U" :prepend t)
        ;; ("c" "COUNT" entry (file+datetree (concat org-private-dir "/iCount.org")) "* %? \n%U" :prepend t)
        ("d" "IDEA" entry (file+olp (concat org-private-dir "/iDea.org") "IDEAs" "IDEA") "* %? \n%U" :prepend t)
        ;; ("g" "GOOD" entry (file+olp (concat org-private-dir "/iPrv.org") "GOOD" "-GOOD-") "* %? :#B:\n%U" :prepend t)
        ;; ("i" "INBOX" entry (file+olp (concat org-private-dir "/Refile.org") "INBOXs" "INBOX") "* %? \n%U" :prepend t)
        ;; ("n" "NOTES" entry (file+olp (concat org-private-dir "/Refile.org") "NOTEs" "NOTE") "* %? \n%U" :prepend t)
        ;; ("q" "QUESTION" entry (file+olp (concat org-private-dir "/iPrv.org") "QUESTIONs" "QUESTION") "* %? \n%U" :prepend t)
        ;; ("l" "LOG" entry (file+datetree (concat org-private-dir "/iLog.org")) "* %U\n%?" :prepend t)
        ;; ("m" "MUSIC" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#C" "MUSICs") "* %? :#C:\n%U" :prepend t)
        ;; ("t" "TODO" entry (file+olp (concat org-private-dir "/Refile.org") "TODOs" "TODO") "* %? \n%U" :prepend t)
        ("o" "OBTAIN" entry (file+olp (concat org-private-dir "/iPrv.org") "TODO-#B" "OBTAINs") "* %? \n%U" :prepend t)
        ;; ("p" "PLAN" entry (file+olp (concat org-private-dir "/iLog.org") "PLANs" "PLAN") "* %u\np%?" :prepend t)
        ;; ("q" "QUESTION" entry (file+olp (concat org-private-dir "/Refile.org") "QUESTIONs" "QUESTION") "* %? \t%U" :prepend t)
        ;; ("v" "VERBAL" entry (file+olp (concat org-private-dir "/English.org") "Verbal" "Verbal") "* %? \n %U" :prepend t)
        ;; ("n" "note" entry (file (concat org-private-dir "/iPrv.org")) "* %? :NOTE: %U %a :CLOCK: :END:" :clock-in t :clock-resume t)
        ;; ("f" "appointment" entry (file+datetree (concat org-private-dir "/iPrv.org")) "* %? %U" :clock-in t :clock-resume t)
        ;; ("p" "Phone call" entry (file (concat org-private-dir "iPrv.org")) "* Phone %(bh/phone-call) - %(gjg/bbdb-company) :PHONE:\n%U\n\n%?" :clock-in t :clock-resume t)
        ;; ("w" "org-protocol" entry (file (concat org-private-dir "iPrv.org")) "* TODO Review %c %U" :immediate-finish t :clock-in t :clock-resume t)
        ))

;;; Agenda
(setq org-agenda-time-grid '((daily require-timed)
			     "________"
			     (0800 1000 1200 1400 1600 1800 2000 2200)))

(define-key global-map (kbd "M-8") 'org-agenda)
(setq org-agenda-custom-commands
      '(
        ("=" "ALL" tags "#A|DAILY|DUALLY|WEEKLY|RECUR|AUDIO|CAR|MOBILE|#B|#C|IDEA")
	("-" agenda "DAY/FOCUS" ((org-agenda-ndays 1)))
	 ;; ("1m" "MOBILE" tags "MOBILE/ACTIVE")
	 ;; ("1a" "AUDIO" tags "AUDIO/ACTIVE")
	 ;; ("1c" "CAR" tags "CAR/ACTIVE")
	 ;; ("1d" "RECUR DAILY" tags "DAILY/ACTIVE")
	 ;; ("1D" "RECUR DUALLY" tags "DUALLY/ACTIVE")
	 ;; ("1t" "RECUR TRIPLY" tags "TRIPLY/ACTIVE")
	 ;; ("1w" "RECUR WEEKLY" tags "WEEKLY/ACTIVE")
        ("`" "ALL TODO"
         (
	  (tags "#A/ACTIVE")
	  (tags "#B|OBTAIN/ACTIVE")
	  (tags "DAILY&T|DUALLY&T|WEEKLY/ACTIVE")
          (tags "MOBILE|AUDIO|CAR/ACTIVE")
	  (tags "DAILY|DUALLY/ACTIVE")
          ))
        ("1" "ACTIVE TODO-#A"
         (
          ;; (tags "PLAN/ACTIVE" ((org-agenda-overriding-header
          ;; ";>--------PLAN--------<;")))
          (tags "#E/ACTIVE")
	  (tags "#A/ACTIVE|WAITING" ((org-agenda-overriding-header
                                      ";>--------ACTIVE & #A TASKs--------<;")))
	  (agenda "Week Agenda" ((org-agenda-ndays 12)
				 (org-agenda-sorting-strategy
				  (quote ((agenda time-up priority-down tag-up))))
				 (org-deadline-warning-days 0)
				 (org-agenda-overriding-header
				  "\n;>--------AGENDA--------<;")))
	  (tags "#A/PENDING" ((org-agenda-overriding-header
                               ";>--------PENDING #A TASKs--------<;")))
          ))
	 ("2" "ACTIVE BLOCKS"
	  (
           (tags "MOBILE|AUDIO|CAR/ACTIVE")
           (tags "DAILY&T|DUALLY&T|WEEKLY/ACTIVE")
           (tags "#B|OBTAIN/ACTIVE")
           ;; (tags "#C/ACTIVE")
	   )
	  )
 	 ("3" "RECUR ACTIVE"
	  (
	   (tags "DAILY/ACTIVE")
	   (tags "DUALLY/ACTIVE")
	   (tags "WEEKLY/ACTIVE")
	   ;; (tags "RECUR/ACTIVE")
	   ))
         ;; ("4" "RECUR TOFNSH"
         ;;  (
         ;;   (tags "DAILY|DUALLY|WEEKLY/TOFNSH")
         ;;   ))
	 ;; ("5" "FUN ITEMS" tags "FUN")
         ("0" .  "MISCITEMS")
	 ("01" "TODO-#A QUEUE" tags "#A-ACTIVE")
	 ("02" "TODO-#B/#C/OBT QUEUE" tags "#B|OBTAIN|#C/QUEUE")
	 ("03" "ACM QUEUE" tags "AUDIO|CAR|MOBILE/QUEUE")
	 ("04" "TODO-#B" tags "#B")
	 ("05" "OBTAIN" tags "OBTAIN")
	 ("06" "TODO-#C" tags "#C")
	 ;; ("10" "TEST" occur-tree "Title="Quantum Mechanics"")
	 ;;       (agenda "")
	 ;;       (todo "ACTIVE|NEXT|QUEUE")
	 ;;       (tags "ACTIVE|TIMEBOX|MOBILE|AUDIO|CAR|DAILY|DUALLY|WEEKLY")
	 ;;  (todo "ACTIVE")
	 ;;  (tags "CAR")
	 ;;       ))
	 ;;  ("lpq" "Quantum Mechanics" tags "KEYWORD=\"Quantum Mechanics,\"")
      ("p" "Printed agenda"
         ((agenda "" ((org-agenda-ndays 7)                      ;; overview of appointments
                      (org-agenda-start-on-weekday nil)         ;; calendar begins today
                      (org-agenda-repeating-timestamp-show-all t)
                      (org-agenda-entry-types '(:timestamp :sexp))))
          (agenda "" ((org-agenda-ndays 1)                      ;; daily agenda
                      (org-deadline-warning-days 7)             ;; 7 day advanced warning for deadlines
                      (org-agenda-todo-keyword-format "[ ]")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-prefix-format "%t%s")))
          (todo "#B"                                          ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "\nTasks by Context\n------------------\n"))))
         ()
         )
 	("p" . "Priorities")
        ("pa" "A items" tags-todo "+PRIORITY=\"A\"")
        ("pb" "B items" tags-todo "+PRIORITY=\"B\"")
        ("pc" "C items" tags-todo "+PRIORITY=\"C\"")

	("t" . "Tags")
	("ta" "ALL #B" tags "#B" ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "8<========ALL #B========>8")
		 (org-agenda-with-colors t)
		 (org-agenda-compact-blocks nil)
		 (org-agenda-remove-tags t)))
	("te" "Emacs #B" tags "#B" ((org-agenda-files (list (concat org-source-dir "/iPrv.org")))))
        ))
;;; Key-binding
(define-key org-mode-map (kbd "M-<left>") 'hide-body)
(define-key org-mode-map (kbd "M-<right>") 'show-all)
;;; PROVIDE
(provide 'lch-org)
(message "~~ lch-org: done.")

;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
