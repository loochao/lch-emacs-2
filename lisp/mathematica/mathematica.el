;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This mathematica.el defines mathematica-mode version 2.1.0. ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; mathematical.el, A Mathematica interface through GNU Emacs
;;; Copyright (C) 2002  Jim Pivarski
;;; 
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License
;;; as published by the Free Software Foundation; either version 2
;;; of the License, or (at your option) any later version.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;; 
;;; You should have received a copy of the GNU General Public License
;;; along with this program; if not, write to the Free Software
;;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Mathematica is (C) Copyright 1988-1999 Wolfram Research, Inc.
;;;
;;; Protected by copyright law and international treaties.
;;;
;;; Unauthorized reproduction or distribution subject to severe civil
;;; and criminal penalties.
;;;
;;; Mathematica is a registered trademark of Wolfram Research.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; How to use this package:
;;; 
;;;   1) Save the file `mathematica.el' to some convenient directory.
;;;
;;;   2) Insert the following in your `.emacs' or `.xemacs/init.el'
;;;      initialization file:
;;;
;;;         (load-file "<convenient-directory-name>/mathematica.el")
;;;
;;;   2.1) If you want to make interaction (slightly) faster, run the
;;;        command M-x byte-compile-file RET mathematica.el RET.
;;;
;;;   2.2) This package uses the command-line interface to
;;;        Mathematica. If Mathematica is installed in the default
;;;        way, you can invoke this on the shell with the command name
;;;        `math'. If you need to type something different to start up
;;;        the text-only interface, such as
;;;        `/usr/local/mathematica/Executables/Linux/math', you need
;;;        to put the following in your `.emacs' or `.xemacs/init.el'
;;;        initialization file:
;;;
;;; (setq mathematica-command-line "/Applications/Mathematics/Mathematica.app/Contents/MacOS/MathKernel")
;;;
;;;        This command line is simply called, so you can include
;;;        arguments.
;;;
;;;   3) Start a Mathematica in Emacs process either by visiting a
;;;      file which ends in a `.m' suffix or by M-x mathematica RET.
;;;
;;;   4) Each Mathematica process is associated with one working
;;;      (interaction) buffer and one log buffer. The working buffer
;;;      is labeled `Mathematica [status...]' and the log buffer is
;;;      labeled `Mathematica Log'. If you want to only look at the
;;;      interaction buffer, type C-x 1. If you want to see both, type
;;;      C-c s.
;;;
;;;   4.1) Each interaction buffer is associated with exactly one
;;;        Mathematica process. Each Mathematica process is associated
;;;        with exactly one interaction buffer and one log buffer.
;;;        Commands and variables in one buffer WILL NOT AFFECT
;;;        commands and variables in another buffer. This was done on
;;;        purpose.
;;;
;;;   5) Type a mathematica command in the interaction buffer,
;;;      delimited from other commands and text by an empty line. To
;;;      execute it, put the cursor anywhere in the paragraph and type
;;;      C-j.
;;;
;;;   6) If the command is evaluated quickly, you will see the output
;;;      inserted below the command with an Out[] line number.
;;;
;;;   7) If the command takes a long time, you will see
;;;      `[Calculating...]' under the command, and when the result
;;;      arrives, it will be put where the `[Calculating...]' message
;;;      is. While Mathematica is calculating, you can continue typing
;;;      (or do whatever you want with Emacs). Just don't mess with
;;;      the `[Calculating...]' message and the output will go to the
;;;      right place. It won't overwrite your other work or go in the
;;;      wrong buffer or anything like that.
;;;
;;;   7.1) You can even send other commands while Mathematica is
;;;        calculating. Mathematica will handle them as soon as it is
;;;        finished with the one it's on. Every output will go to the
;;;        right `[Calculating...]' message.
;;;
;;;   8) If you want to abort a calculation, type C-c a. Mathematica
;;;      will abort the command it's working on and all commands that
;;;      have been sent to it while it was busy.
;;;
;;;   9) It's nice to know the following Emacs commands for getting
;;;      around paragraphs (command and output blocks): M-a goes to
;;;      the beginning of paragraph, M-e goes to the end, M-k kills
;;;      the next paragraph (e.g. unwanted output). Up and down arrows
;;;      while holding down shift skip paragraphs.
;;;
;;;   9.1) It's nice to know the following Emacs commands for getting
;;;        around parenthesis trees (since Mathematica is almost as
;;;        paren-crazy as lisp): C-M-f and C-M-b goes forward or
;;;        backward on the same parenthesis level (VERY useful for
;;;        adding arguments to a deeply-nested function). C-M-u and
;;;        C-M-d step up and down the parenthesis tree. All of this
;;;        takes into account parenthesis type: (), {} or [].
;;;
;;;   10) Emacs will complain if you try to quit without killing the
;;;       attached Mathematica processes. You can kill the one
;;;       associated with the current interaction buffer with C-c k,
;;;       but it is better to send the Mathematica command `Exit'.
;;;
;;;   11) If you have killed the Mathematica process associated with a
;;;       given interaction buffer and would like to restart it (a
;;;       good way of being certain there are no stray variables
;;;       messing with your calculations), type C-c r. If you type
;;;       this while there is a live Mathematica process attached,
;;;       this process is first killed.
;;;
;;;   APPENDIXES
;;;
;;;   A1) An alternative to C-j is the key sequence C-u C-j. This will
;;;       execute a paragraph in the same way, but when the output
;;;       comes up, the point will be set to the end of the output and
;;;       the mark will be set to the beginning. Then you can toggle
;;;       between looking at the beginning and end of a long output by
;;;       C-x x (interchange point and mark) and kill the output with
;;;       C-w (kill region between point and mark). This is the way I
;;;       used to do Mathematica interaction, but it's not really
;;;       convenient for small commands, keeping track of buffer
;;;       positions with the mark stack and especially for commands
;;;       that take a long time, since having the point change while
;;;       you're typing something else is atrocious.
;;;
;;;   A2) Keep in mind that while you can do multiple statements in a
;;;       single execution with Mathematica, they all need to end with
;;;       a semicolon except for the last one. A common mistake (for
;;;       me, at least) is to work on two commands independantly with
;;;       no semicolons at the end, so that their output can be seen,
;;;       then join them into a block for easy evaluation, forgetting
;;;       to put a semi-colon between them. Mathematica tries to
;;;       multiply them together, which is often wrong or confusing or
;;;       a Mathematica syntax error.
;;;
;;;   A3) Mathematica's default truncation at 78 characters can make
;;;       output hard to read, particularly tables. To update
;;;       Mathematica on your current window width, type `C-c w'.
;;;
;;;   A4) This package checks for balanced parentheses before sending
;;;       Mathematica the command since Mathematica would otherwise
;;;       sit and wait for a continuation that closes the paren stack.
;;;       This confuses the user (who is meanwhile staring at a
;;;       `[Calculating...]' message with no indication that
;;;       Mathematica is idle) and it confuses mathematica-mode, which
;;;       gets an off-by-one error in identifying which command goes
;;;       with which `[Calculating...]' message. THEREFORE, I avoid
;;;       the whole mess by only sending Mathematica paren-balanced
;;;       expressions.
;;;
;;;   A5) Try the tab key! I hope you like the indentation scheme. It
;;;       is meant to help keep track of parens, so that you know
;;;       what's an argument of what. Close parens are electric
;;;       (automatically indent).
;;;
;;;   A6) It sometimes happens that paren-match blinking slows down
;;;       the execution of a keyboard macro. You can turn off
;;;       paren-match blinking by:
;;;           M-: (setq blink-matching-delay 0) RET
;;;       When you want to turn it on again (it's a wonderful
;;;       feature), do this:
;;;           M-: (setq blink-matching-delay 1) RET
;;;
;;;   A7) Here are all of the commands that you can invoke:
;;;
;;;     key             binding
;;;     ---             -------
;;;     C-j             mathematica-execute
;;;     
;;;     C-c k           mathematica-kill-this-kernel
;;;     C-c r           mathematica-restart-kernel
;;;     C-c s           mathematica-split-screen
;;;     C-c a           mathematica-abort-calculation
;;;     C-c w           mathematica-send-window-width
;;;     
;;;     M-x mathematica-mode-copying   for a copyright message
;;;     M-x mathematica-mode-warantee  for a no-warantee message
;;;
;;;   A8) Here are all the variables you can set in your `.emacs' if
;;;       you wish:
;;;
;;;     variable                   		    default value
;;;     --------                   		    -------------
;;;     mathematica-command-line                    "math"
;;;     mathematica-always-start-kernel-with-mode   nil
;;;     mathematica-split-on-startup                nil

(setq auto-mode-alist
      (append
       '(
 	 ("\\.m\\'" . mathematica-mode)   ; .m -> mathematica plain-text
	 )
       auto-mode-alist))

;;; These variables you can change

(defvar mathematica-command-line "math"
  "How to access the command-line interface to Mathematica on your system."
  )

(defvar mathematica-always-start-kernel-with-mode nil
  "If t, a Mathematica kernel will be started every time you enter
Mathematica Mode (either by M-x mathematica-mode RET or by visiting a
.m file)."
  )

;; added by p.weitershausen@physik.tu-dresden.de
(defvar mathematica-never-start-kernel-with-mode nil
  "If t, a Mathematica kernel will never be started when you enter
Mathematica Mode (either by M-x mathematica-mode RET or by visiting a
.m file)."
  )
;; end addition by p.weitershausen@physik.tu-dresden.de

(defvar mathematica-split-on-startup nil
  "If t, entering Mathematica mode will split the screen to show you
the kernel starting up."
  )

;;; The rest of these variables are internal

(defvar mathematica-status ()
  "A word or two describing the state of the Mathematica kernel
associated with this buffer (local variable)."
  )

(defvar mathematica-kernel-workbuf ()
  "An association list connecting Mathematica processes with working
buffers."
  )

(defvar mathematica-kernel-marks ()
  "An association list connecting Mathematica processes with the mark
queue."
  )

(defvar mathematica-waiting-for-abort-message nil
  "A set of Mathematica processes which are waiting for an interrupt
message."
  )

(defvar mathematica-waiting-for-abort-message2 nil
  "A set of Mathematica processes which are waiting for the second
part of an interrupt message." )

(defvar mathematica-mode-map ()
  "Keymap used in Mathematica mode."
  )
(if mathematica-mode-map
    ()
  (setq mathematica-mode-map (make-sparse-keymap))
  (define-key mathematica-mode-map "\C-j" 'mathematica-execute)
  (define-key mathematica-mode-map "\M-\C-m" 'mathematica-execute)
  (define-key mathematica-mode-map "\C-ca" 'mathematica-abort-calculation)
  (define-key mathematica-mode-map "\C-cs" 'mathematica-split-screen)
  (define-key mathematica-mode-map "\C-cr" 'mathematica-restart-kernel)
  (define-key mathematica-mode-map "\C-ck" 'mathematica-kill-this-kernel)
  (define-key mathematica-mode-map "\C-cw" 'mathematica-send-window-width)
  (define-key mathematica-mode-map "\177" 'backward-delete-char-untabify)
  (define-key mathematica-mode-map ")" 'mathematica-electric-paren)
  (define-key mathematica-mode-map "]" 'mathematica-electric-braket)
  (define-key mathematica-mode-map "}" 'mathematica-electric-brace) 
 )

(defvar mathematica-mode-abbrev-table nil
  "Abbrev table in use in Mathematica-mode buffers."
  )

(defvar mathematica-mode-syntax-table nil "")
(if (not mathematica-mode-syntax-table)
    (let ((i 0))
      (setq mathematica-mode-syntax-table (make-syntax-table))

      ;; white space
      (modify-syntax-entry ?  " " mathematica-mode-syntax-table)  
      (modify-syntax-entry ?\t " " mathematica-mode-syntax-table)
      (modify-syntax-entry ?\f " " mathematica-mode-syntax-table)
      (modify-syntax-entry ?\n " " mathematica-mode-syntax-table)
      (modify-syntax-entry ?\^m " " mathematica-mode-syntax-table)
      
      ;; comments and parens
      (modify-syntax-entry ?( "()1b" mathematica-mode-syntax-table)  
      (modify-syntax-entry ?) ")(4b" mathematica-mode-syntax-table)
      (modify-syntax-entry ?* "_ 23b" mathematica-mode-syntax-table)

      ;; pure parens
      (modify-syntax-entry ?[ "(]" mathematica-mode-syntax-table)
      (modify-syntax-entry ?] ")[" mathematica-mode-syntax-table)
      (modify-syntax-entry ?{ "(}" mathematica-mode-syntax-table)
      (modify-syntax-entry ?} "){" mathematica-mode-syntax-table)

      ;; punctuation
      (modify-syntax-entry ?= "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?: "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?% "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?< "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?> "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?& "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?| "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?_ "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?/ "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?! "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?@ "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?# "." mathematica-mode-syntax-table)
      (modify-syntax-entry ?\' "." mathematica-mode-syntax-table)

      ;; quotes
      (modify-syntax-entry ?\\ "\\" mathematica-mode-syntax-table)
      (modify-syntax-entry ?\" "\"" mathematica-mode-syntax-table)

      ;; for Mathematica numbers, the following would be better as
      ;; parts of symbols
      (modify-syntax-entry ?- "_" mathematica-mode-syntax-table)
      (modify-syntax-entry ?. "_" mathematica-mode-syntax-table)
      (modify-syntax-entry ?\` "_" mathematica-mode-syntax-table)
      (modify-syntax-entry ?^ "_" mathematica-mode-syntax-table)

      (modify-syntax-entry ?$ "_" mathematica-mode-syntax-table)
      (modify-syntax-entry ?+ "_" mathematica-mode-syntax-table)

      ;; create an abbrev table for mathematica mode
      (define-abbrev-table 'mathematica-mode-abbrev-table ())

      ) ; end of let
  )

(defvar mathematica-font-lock-keywords
  '(
    ("^In\[[0-9]+\]:=" . font-lock-keyword-face)
    ("^Out\[[0-9]+\]=" . font-lock-keyword-face)
    ("^Out\[[0-9]+\]//[A-Za-z][A-Za-z0-9]*=" . font-lock-keyword-face)
    ("\\([A-Za-z][A-Za-z0-9]*\\)[ \t]*[\[][ \t]*[\[]" 1 "default")
    ("\\([A-Za-z][A-Za-z0-9]*\\)[ \t]*[\[]" 1 font-lock-function-name-face)
    ("//[ \t\f\n]*\\([A-Za-z][A-Za-z0-9]*\\)" 1 font-lock-function-name-face)
    ("\\([A-Za-z][A-Za-z0-9]*\\)[ \t\f\n]*/@" 1 font-lock-function-name-face)
    ("\\([A-Za-z][A-Za-z0-9]*\\)[ \t\f\n]*//@" 1 font-lock-function-name-face)
    ("\\([A-Za-z][A-Za-z0-9]*\\)[ \t\f\n]*@@" 1 font-lock-function-name-face)
    ("_[) \t]*\\?\\([A-Za-z][A-Za-z0-9]*\\)" 1 font-lock-function-name-face)
    ("\\(&&\\)" 1 "default")
    ("&" . font-lock-function-name-face)
    ("\\\\[[A-Za-z][A-Za-z0-9]*\]" . font-lock-constant-face )
    ("$[A-Za-z0-9]+" . font-lock-variable-name-face )
    ("\\([A-Za-z0-9]+\\)[ \t]*\\->" 1 font-lock-type-face )
    ("<<[ \t\f\n]*[A-Za-z][A-Za-z0-9]*`[ \t\f\n]*[A-Za-z][A-Za-z0-9]*[ \t\f\n]*`"
     . font-lock-type-face )
    ("[A-Za-z][A-Za-z0-9]*::[A-Za-z][A-Za-z0-9]*" . font-lock-warning-face)
    ("\\[Calculating\\.\\.\\.\\]" . font-lock-warning-face)
    ("\\[Mathematica.*\\]" . font-lock-warning-face)
    ("^Interrupt>" . font-lock-warning-face)
    ("-Graphics-" . font-lock-type-face)
    ("-DensityGraphics-" . font-lock-type-face)
    ("-ContourGraphics-" . font-lock-type-face)
    ("-SurfaceGraphics-" . font-lock-type-face)
    ("-Graphics3D-" . font-lock-type-face)
    ("-GraphicsArray-" . font-lock-type-face)
    ("-Sound-" . font-lock-type-face)
    ("-CompiledCode-" . font-lock-type-face)
    )
  )

(defun mathematica-log-mode ()
  "Major mode for viewing Mathematica interaction logs in Emacs."
  (interactive)
  (kill-all-local-variables)

  (setq major-mode 'mathematica-log-mode)
  (setq mode-name "Mathematica Log")
  
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(mathematica-font-lock-keywords nil t))

  (setq buffer-read-only t)
  )

(defun mathematica-mode ()
  "Major mode for editing Mathematica plain text files (.m) in Emacs.
Commands:
\\{mathematica-mode-map}"
  (interactive)
  (kill-all-local-variables)

  (use-local-map mathematica-mode-map)

  (setq major-mode 'mathematica-mode)
  (setq mode-name "Mathematica")

  (make-local-variable 'mathematica-status)
  (setq mathematica-status "not running")
  (setq mode-line-process '(" is " mathematica-status "."))

  (setq local-abbrev-table mathematica-mode-abbrev-table)
  (set-syntax-table mathematica-mode-syntax-table)

  (make-local-variable 'indent-line-function)
  (setq indent-line-function 'mathematica-indent-line)
;  (make-local-variable 'comment-indent-function)
;  (setq comment-indent-function 'mathematica-indent-comment)

  (make-local-variable 'comment-start)
  (setq comment-start "(*")
  (make-local-variable 'comment-end)
  (setq comment-end " *)")
  (make-local-variable 'comment-start-skip)
  (setq comment-start-skip "(\\*")

  (make-local-variable 'paragraph-start)
  (setq paragraph-start (concat page-delimiter "\\|$"))
  (make-local-variable 'paragraph-separate)
  (setq paragraph-separate paragraph-start)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(mathematica-font-lock-keywords nil t))

  (make-local-variable 'kill-buffer-hook)
  (setq kill-buffer-hook 'mathematica-kill-this-kernel)

;; added by p.weitershausen@physik.tu-dresden.de
;;   (if (or mathematica-always-start-kernel-with-mode
;; 	  (y-or-n-p "Start a Mathematica kernel for evaluations? ")
;; 	  ) ; end of or
  (if (and
       (not mathematica-never-start-kernel-with-mode)
       (or mathematica-always-start-kernel-with-mode
	   (y-or-n-p "Start a Mathematica kernel for evaluations? "))
       ) ; end of logical expression
;; end addition by p.weitershausen@physik.tu-dresden.de
      (progn
	(mathematica-internal-start-kernel (current-buffer))
	(if mathematica-split-on-startup
	    (mathematica-split-screen)
	  ) ; end if
	) ; end of progn
    (message "You can start a Mathematica kernel with C-c r or M-x mathematica-restart-kernel.")
    ) ; end if
  )

(defun mathematica ()
  "Start a Mathematica process in a new buffer."
  (interactive)
  (let ((oldval mathematica-always-start-kernel-with-mode))
    (setq mathematica-always-start-kernel-with-mode t)
    (switch-to-buffer (generate-new-buffer "*Mathematica*"))
    (insert "<<JavaGraphics`")
    (mathematica-mode)
    (setq mathematica-always-start-kernel-with-mode oldval)
    ) ; end let
  )

(defun mathematica-internal-start-kernel (workbuf)
  "Internal function for starting Mathematica kernels."
  (mathematica-cleanup-zombies)
  (if (bufferp workbuf)
      (let ((kernel) (oldbuf))
        (if (rassoc workbuf mathematica-kernel-workbuf)
            (message
             (format "There is already a kernel associated with \"%s\"."
                     (buffer-name workbuf)))
          (progn
            (message "Starting Mathematica kernel...")
            (setq kernel (start-process
                          (format "mathematica<%s>" (buffer-name workbuf))
                          (format "*mathematica<%s>*" (buffer-name workbuf))
                          mathematica-command-line))
            (message "Starting Mathematica kernel... done!")

	    (setq oldbuf (current-buffer))
	    (set-buffer (process-buffer kernel))
	    (mathematica-log-mode)
	    (set-buffer oldbuf)

            (setq mathematica-kernel-workbuf
                  (append mathematica-kernel-workbuf
                          (cons (cons kernel workbuf) nil)
                          ) ; end append
                  ) ; end setq

            (setq mathematica-kernel-marks
                  (append mathematica-kernel-marks
                          (cons (cons kernel []) nil)
                          ) ; end append
                  ) ; end setq

            (set-process-filter kernel 'mathematica-filter)
            (set-process-sentinel kernel 'mathematica-sentinel)

	    (if (processp kernel) (setq mathematica-status "starting up"))

            kernel
            ) ; end of "starting Mathematica" progn
          ) ; end if process already exists
        ) ; end let
    (message "argument is not a buffer!")
    ) ; end if
  )

(defun mathematica-split-screen ()
  "Splits the screen into work buffer above, log buffer below"
  (interactive)
  (let ((kernel (mathematica-kernel-from-workbuf (current-buffer))))
    (if kernel
	(set-window-buffer (split-window) (process-buffer kernel))
      (message "This buffer has no Mathematica kernel!")
      ) ; end if kernel
    ) ; end let
  )

(defun mathematica-kill-this-kernel ()
  "Kills the Mathematica kernel associated with this working buffer."
  (interactive)
  (let ((kernel (mathematica-kernel-from-workbuf (current-buffer)))
	(isreal))
    (setq isreal (processp kernel))
    (mathematica-kill-kernel kernel)
    (if isreal (message "Mathematica process killed."))
    (setq mathematica-status "not running")
    ) ; end let
  )

(defun mathematica-kill-kernel (kernel)
  "Internal function for killing a Mathematica kernel."
  (if (processp kernel)
      (progn
        (setq mathematica-kernel-workbuf
              (delete (assoc kernel mathematica-kernel-workbuf)
                      mathematica-kernel-workbuf)
              ) ; end of setq

        (setq mathematica-kernel-marks
              (delete (assoc kernel mathematica-kernel-marks)
                      mathematica-kernel-marks)
              ) ; end of setq

        (delete-process kernel)

        ) ; end of progn
    (mathematica-cleanup-zombies)
    ) ; end if kernel is still alive
  )

(defun mathematica-restart-kernel ()
  "Restarts the Mathematica kernel associated with this buffer."
  (interactive)
  (let ((kernel (mathematica-kernel-from-workbuf (current-buffer))))
    (if (processp kernel)
        (mathematica-kill-kernel kernel)
      nil)
    ) ; end of let
  (mathematica-internal-start-kernel (current-buffer))
  )

(defun mathematica-send-window-width ()
  "Tell Mathematica the current window width, so that output is properly aligned."
  (interactive)

  (let ((command (format "SetOptions[$Output, PageWidth -> %d, PageHeight -> Infinity];"
			 (- (window-width) 2)))
	(start-mark) (end-mark)
	(oldbuf (current-buffer))
	(oldpos (point))
	)
    (let ((kernel (mathematica-kernel-from-workbuf oldbuf)))
      (if (processp kernel)
	  (progn
	    (goto-char (point-max))
	    (insert "\n\n")
	    (setq start-mark (point-marker))
	    (insert "[Calculating...]")
	    (setq end-mark (point-marker))
	    (goto-char oldpos)

	    ;; insert the input and marks into the queue corresponding
	    ;; to this kernel
	    (if (= (mathematica-marks-length kernel) 0)
		(progn
		  (set-buffer (process-buffer kernel))
		  (goto-char (point-max))
		  (setq buffer-read-only nil)
		  (insert command)
		  (setq buffer-read-only t)
		  (goto-char (point-max))
		  (set-marker (process-mark kernel) (point))
		  (mathematica-insert-marks kernel start-mark end-mark t)
		  ) ; end progn
	      (mathematica-insert-marks kernel start-mark end-mark t command)
	      ) ; end if
	    
	    (process-send-string kernel (format "%s\n" command))
	    (setq mathematica-status "working")
	    (message command)
	    ) ; end progn
	(error "This buffer has no Mathematica kernel!")
	) ; end if
      ) ; end let kernel
    ) ; end let everything else
  )

(defun mathematica-execute (arg)
  "Executes a paragraph of code with the Mathematica kernel associated
with this buffer. If an arg is passed, the output will set position
and mark."
  (interactive "P")
  
  (if (null arg) (setq arg t) (setq arg nil)) ; (I had this backward at first.)

  (let ((kernel (mathematica-kernel-from-workbuf (current-buffer))) (oldpos (make-marker)))

    (if (processp kernel)
        (let ((start) (end) (kernel) (input) (oldbuf (current-buffer))
              (tmpbuf (generate-new-buffer "*mathematica-temp*"))
              (start-mark) (end-mark))

	  (set-marker oldpos (point))
	  (undo-boundary)

          ;; find the command and make a "[Calculating...]" notice
          (if (re-search-backward "[\f\n][ \t]*[\f\n]" nil t)
              nil
            (goto-char (point-min))
            ) ; end if
          (skip-chars-forward " \t\f\n")
          (setq start (point))
          (if (re-search-forward "[\f\n][ \t]*[\f\n]" nil t)
              nil
            (goto-char (point-max))
            ) ; end if
          (skip-chars-backward " \t\f\n")
          (setq end (point))

          ;; get the input
          (setq input (buffer-substring start end))

          ;; format it properly
          (set-buffer tmpbuf)
          (insert input)
          (goto-char (point-max))
          (beginning-of-line)
          (while (> (point) (point-min))
            (previous-line 1)
            (end-of-line)
            (insert " \\")
            (beginning-of-line)
            )

	  ;; I have to resolve the disagreement between Emacs and
	  ;; Mathematica about the use of "\[" as an open paren
	  (setq input
		(format "%s\n" (buffer-substring (point-min) (point-max))))

	  (beginning-of-buffer)
	  (while (search-forward "\\(" nil t) (replace-match "(" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\)" nil t) (replace-match ")" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\[" nil t) (replace-match "[" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\]" nil t) (replace-match "]" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\{" nil t) (replace-match "{" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\}" nil t) (replace-match "}" nil t))
	  (beginning-of-buffer)
	  (while (search-forward "\\\"" nil t)
	    (let ((number-of-quotes) (characters (append (buffer-substring (point-min) (point)) nil)))
	      (setq number-of-quotes (1- (- (length characters) (length (delq ?\" characters)))))
	      (if (= (% number-of-quotes 2) 0)
		  (replace-match "\"" nil t)
		(replace-match "" nil t)
		) ; end if
	      ) ; end let
	    ) ; end while

	  (let ((number-of-quotes) (characters (append (buffer-substring (point-min) (point-max)) nil)))
	    (setq number-of-quotes (- (length characters) (length (delq ?\" characters))))
	    (if (= (% number-of-quotes 2) 1)
		(progn
		  (set-buffer oldbuf)
		  (kill-buffer tmpbuf)
		  (goto-char oldpos)
		  (error "The quotes in this expression are not balanced")
		  ) ; end progn
	      ) ; end if
	    ) ; end let

	  (if (not (= (car (parse-partial-sexp (point-min) (point-max))) 0))
	      (progn
		(set-buffer oldbuf)
		(kill-buffer tmpbuf)
		(goto-char oldpos)
		(error "The parentheses in this expression are not balanced")
		) ; end progn
	    )

	  (set-buffer oldbuf)
          (kill-buffer tmpbuf)
	  (goto-char end)

	  (insert "\n\n")
	  (setq start-mark (point-marker))
	  (insert "[Calculating...]")
	  (setq end-mark (point-marker))

	  ;; insert the input and marks into the queue corresponding
	  ;; to this kernel
	  (setq kernel (mathematica-kernel-from-workbuf oldbuf))
	  (if (= (mathematica-marks-length kernel) 0)
	      (progn
		(set-buffer (process-buffer kernel))
		(goto-char (point-max))
		(setq buffer-read-only nil)
		(insert input)
		(setq buffer-read-only t)
		(goto-char (point-max))
		(set-marker (process-mark kernel) (point))
		(mathematica-insert-marks kernel start-mark end-mark arg)
		) ; end progn
	    (mathematica-insert-marks kernel start-mark end-mark arg input)
	    ) ; end if

	  (set-buffer oldbuf)
	  
          ;; send the command to Mathematica
	  (process-send-string kernel input)
	  (setq mathematica-status "working")

	  (goto-char oldpos)

          ) ; end let
      (error "This buffer has no Mathematica kernel!")
      ) ; end of if
    ) ; end of let
  )

(defun mathematica-filter (process output)
  "Puts the Mathematica output where it needs to go."
  (let ((oldbuf (current-buffer)) (maybe-more-output t))
    (progn
      (set-buffer (mathematica-workbuf-from-kernel process))
      (setq mathematica-status "spewing output into the log")
      (set-buffer oldbuf)

      ;; always put new output at the end
      (set-buffer (marker-buffer (process-mark process)))
      (goto-char (point-max))
      (setq buffer-read-only nil)
      (insert output)
      (setq buffer-read-only t)

      ;; but maybe this isn't all of it
      (while maybe-more-output
	(set-buffer (marker-buffer (process-mark process)))
	(goto-char (process-mark process))

	;; handle (and hide) Interrupt> messages
	(if (and (memq process mathematica-waiting-for-abort-message)
		 (re-search-forward "Interrupt> " nil t)
		 ) ; end of and
	    (progn
	      (set-buffer (mathematica-workbuf-from-kernel process))
	      (setq mathematica-status "trying to abort")
	      (set-buffer (marker-buffer (process-mark process)))

	      (process-send-string process "a\n")
	      (setq mathematica-waiting-for-abort-message
		    (delq process mathematica-waiting-for-abort-message)
		    ) ; end setq
	      (setq mathematica-waiting-for-abort-message2
		    (cons process mathematica-waiting-for-abort-message2)
		    ) ; end setq
	      (set-marker (process-mark process) (point))
	      (while (> (mathematica-marks-length process) 1)
		(let ((twomarks (mathematica-pop-marks process)) (cursorposition (make-marker)))
		  (set-buffer (marker-buffer (elt twomarks 0)))
		  (set-marker cursorposition (point))
		  (undo-boundary)
		  (goto-char (marker-position (elt twomarks 0)))
		  (delete-region (marker-position (elt twomarks 0))
				 (marker-position (elt twomarks 1)))
		  (insert "[Mathematica aborted this and the next calculation.]")
		  (if (elt twomarks 2) (goto-char cursorposition))
		  ) ; end let
		) ; end while
	      ) ; end progn
	  ) ; end if

	(if (re-search-forward "In\[[0-9]+\]:= " nil t)
	    (let ((newmark) (start) (end) (wholeoutput) (twomarks) (empty))
	      (set-buffer (mathematica-workbuf-from-kernel process))
	      (setq mathematica-status "sitting idle")
	      (set-buffer (marker-buffer (process-mark process)))

	      ;; this is where I would like to put the new mark,
	      ;; once I'm done with the old one
	      (setq newmark (point))

	      ;; I want the end of the wholeoutput to be at the
	      ;; beginning of this phrase
	      (re-search-backward "In\[[0-9]+\]:= " nil t)
	      (backward-char 2)
	      (setq end (point))
	      
	      ;; back to the beginning of the output
	      (goto-char (process-mark process))
	      (if (looking-at "[\r\n]") (forward-char))
	      (setq start (point))

; 	      ;; special case for abort messages (we don't want to see
; 	      ;; all the Interrupt> lines)
	      (if (and (memq process mathematica-waiting-for-abort-message2)
		       (re-search-forward "Out\[[0-9]+\]=" nil t))
		  (progn
		    (setq start (match-beginning 0))
		    (setq mathematica-waiting-for-abort-message2
			  (delq process mathematica-waiting-for-abort-message2)
			  ) ; end setq
		    ) ; end progn
		) ; end if

	      ;; finally set the new marker
	      (set-marker (process-mark process) newmark)
	      
	      ;; check to see if the output is empty
	      (skip-chars-forward " \t\n\r")
	      (setq empty (> (point) end))

	      ;; update the log point
	      (goto-char (point-max))

	      ;; copy the output to a string
	      (setq wholeoutput (buffer-substring start end))

	      ;; pop a set of marks from the input queue
	      (setq twomarks (mathematica-pop-marks process))
	      (if twomarks
		  (let ((m1 (elt twomarks 0)) (m2 (elt twomarks 1))
			(arg (elt twomarks 2)) (cursorposition (make-marker)))
		    ;; twomarks may contain an input string
		    (if (= (length twomarks) 4)
			(let ((input (elt twomarks 3)))
			  ;; enter the input at the appropriate In[]:= point
			  (goto-char start)
			  (setq buffer-read-only nil)
			  (insert input)
			  (setq buffer-read-only t)
			  ) ; end of let
		      nil
		      ) ; end of if
		    
		    ;; now we want to write over "[Calculating...]"
		    (set-buffer (marker-buffer m1))
		    (set-marker cursorposition (point))
		    (undo-boundary)
		    (goto-char (marker-position m1))
		    (delete-region (marker-position m1)
				   (marker-position m2))
		    (if (not empty)
			(progn
			  (insert wholeoutput)
			  (if (not arg) (insert "\n"))
			  ) ; end progn
		      (if (not (> (+ (point) 2) (point-max)))
			  (delete-char 2)
			) ; end if not at end of buffer
		      ) ; end if not empty

		    (if arg
			(goto-char cursorposition)
		      (push-mark (marker-position m1))
		      ) ; end if arg is not null
		    ) ; end of let
		) ; end of if twomarks
	      
	      ) ; end of let
	  (setq maybe-more-output nil) ; this is the case where
				       ; we're simply waiting for
				       ; more data
	  ) ; end of if
	) ; end while looking for more output lines
      ) ; end of progn
    (set-buffer oldbuf)
    ) ; end of let
  )

(defun mathematica-sentinel (process event)
  (let (twomarks m1 m2)
    (setq twomarks (mathematica-pop-marks process))
    (if twomarks
	(let ((m1 (elt twomarks 0)) (m2 (elt twomarks 1))
	      (arg (elt twomarks 2)) (cursorposition (make-marker)))
	  ;; now we want to write over "[Calculating...]"
	  (set-buffer (marker-buffer m1))
	  (set-marker cursorposition (point))
	  (undo-boundary)
	  (goto-char (marker-position m1))
	  (delete-region (marker-position m1)
			 (marker-position m2))
	  (insert (format "[Mathematica %s" event))
	  (delete-char -1)
	  (insert ".]")
	  (end-of-line)
	  (if (= (point) (point-max))
	      (insert "\n")
	    (forward-char 1)
	    )
	  (if arg
	      (goto-char cursorposition)
	    (push-mark (marker-position m1))
	    ) ; end if

	  (if (not (string-equal (process-status process) "run"))
	      (setq mathematica-status "not running")
	    (setq mathematica-status (format "returning \"%s\"" (substring event 0 -1)))
	    ) ; end if

	  ) ; end of let
      ) ; end of if twomarks
    ) ; end of let

  (let ((oldbuf (current-buffer)))
    (set-buffer (process-buffer process))
    (goto-char (point-max))
    (setq buffer-read-only nil)
    (insert (format "\n * * * Mathematica %s" event))
    (delete-char -1)
    (insert ". * * *\n\n")
    (setq buffer-read-only t)
    (set-marker (process-mark process) (point))
    (set-buffer oldbuf)
    ) ; end of let
  
  (mathematica-cleanup-zombies)
  )

(defun mathematica-abort-calculation ()
  "Abort the current Mathematica calculation, if there is any."
  (interactive)
  (let ((kernel (mathematica-kernel-from-workbuf (current-buffer))))
    (interrupt-process kernel)
    (setq mathematica-waiting-for-abort-message
	  (cons kernel mathematica-waiting-for-abort-message)
	  ) ; end setq
    ) ; end of let
  )

(defun mathematica-kernel-from-workbuf (workbuf)
  "Internal function for getting the kernel from a working buffer."
  (car (rassoc workbuf mathematica-kernel-workbuf))
  )

(defun mathematica-workbuf-from-kernel (kernel)
  "Internal function for getting the working buffer from a kernel."
  (cdr (assoc kernel mathematica-kernel-workbuf))
  )

(defun mathematica-insert-marks (kernel m1 m2 arg &optional input)
  "Internal function which inserts inserts [m1 m2 input] into the
queue corresponding to \"kernel\"."
  (let ((oldarray (cdr (assoc kernel mathematica-kernel-marks)))
        (newarray))
    (if input
	(setq newarray (vconcat (vector (vector m1 m2 arg input)) oldarray))
      (setq newarray (vconcat (vector (vector m1 m2 arg)) oldarray))
      ) ; end if input

    ;; first completely get rid of the old entry
    (setq mathematica-kernel-marks
          (delete (assoc kernel mathematica-kernel-marks)
                  mathematica-kernel-marks)
          ) ; end of setq

    ;; then put it back with the new values
    (setq mathematica-kernel-marks
          (append mathematica-kernel-marks
                  (cons (cons kernel newarray) nil)
                  ) ; end append
          ) ; end setq

    ) ; end of let
  )

(defun mathematica-pop-marks (kernel)
  "Internal function which takes [m1 m2 input] off the other end of
the queue corresponding to \"kernel\" and returns them."
  (let ((oldarray (cdr (assoc kernel mathematica-kernel-marks)))
        (newarray []) (i 0))

    (if (= (length oldarray) 0)
        nil
      (progn
        ;; first completely get rid of the old entry
        (setq mathematica-kernel-marks
              (delete (assoc kernel mathematica-kernel-marks)
                      mathematica-kernel-marks)
              ) ; end of setq

        (while (< i (1- (length oldarray)))
          (setq newarray (vconcat newarray (vector (elt oldarray i))))
          (setq i (1+ i))
          ) ; end of while

        ;; then put it back with the new values
        (setq mathematica-kernel-marks
              (append mathematica-kernel-marks
                      (cons (cons kernel newarray) nil)
                      ) ; end append
              ) ; end setq

        (elt oldarray (1- (length oldarray)))
        ) ; end of progn
      ) ; end of if
    ) ; end of let
  )

(defun mathematica-marks-length (kernel)
  "Internal function which returns the length of the marks queue."
  (length (cdr (assoc kernel mathematica-kernel-marks)))
  )

(defun mathematica-cleanup-zombies ()
  "Removes items from \"mathematica-kernel-workbuf\" and
\"mathematica-kernel-marks\" that no longer exist."
  (interactive)

  ;; first do it for mathematica-kernel-workbuf
  (let ((tmp (copy-alist mathematica-kernel-workbuf)) (i 0))
    (setq mathematica-kernel-workbuf nil)
    (while (< i (length tmp))
      (if (string= "run" (process-status (car (nth i tmp))))
          (setq mathematica-kernel-workbuf
                (append mathematica-kernel-workbuf (cons (nth i tmp) nil))
                ) ; end of setq
        nil
        ) ; end if
      (setq i (1+ i))
      ) ; end while
    ) ; end let

  ;; then for mathematica-kernel-marks
  (let ((tmp (copy-alist mathematica-kernel-marks)) (i 0))
    (setq mathematica-kernel-marks nil)
    (while (< i (length tmp))
      (if (string= "run" (process-status (car (nth i tmp))))
          (setq mathematica-kernel-marks
                (append mathematica-kernel-marks (cons (nth i tmp) nil))
                ) ; end of setq
        nil
        ) ; end if
      (setq i (1+ i))
      ) ; end while
    ) ; end let
  )

(defun mathematica-indent-samelinep (first second)
  "Determines if the two points belong to the same line."
  (let ((limit (- second first)) (same-line))
    (save-excursion
      (if (re-search-forward "[\f\n]" limit t)
	  (setq same-line nil)
	(setq same-line t)
	) ; end of if
      ) ; end of excursion
    ) ; end of let
  )

(defun mathematica-indent-determine-in-comment ()
  "Returns the beginning of the comment, or nil."
  (save-excursion
    (let ((here (point)) (no-open nil) (first-open) (no-close nil) (first-close))

      (if (search-backward "(*" nil t)
	  (setq first-open (point))
	(setq no-open t)
	) ; end if

      (goto-char here)
      (if (search-backward "*)" nil t)
	  (setq first-close (point))
	(setq no-close t)
	) ; end if
      
      (cond ((and no-open no-close) nil)
	    ((and (not no-open) no-close) first-open)
	    ((and no-open (not no-close)) nil)
	    ((and (not no-open) (not no-close))
	     (if (> first-open first-close) first-open nil)
	     )
	    ) ; end cond
      ) ; end let
    ) ; end excursion
  )

(defun mathematica-indent-determine-unbalanced ()
  "Returns the beginning of the open paren or nil. Assumes not in
comment."
  (save-excursion
    (let ((toplevel nil) (home nil))
      (condition-case nil
	  (while (not home)
	    (up-list -1)
	    (if (and (<= (+ (point) 2) (point-max))
		     (string=
		      (format "%s" (buffer-substring (point) (+ (point) 2)))
		      "(*")
		     ) ; end of and
		(setq home nil)
	      (setq home t)
	      ) ; end if this open paren is the start of a comment
	    ) ; end while looking for an unbalanced open paren
	(error (setq toplevel (point)))
	) ; end condition-case
      (if toplevel nil (point))
      ) ; end let
    ) ; end excursion
  )

(defun mathematica-indent-stepthrough-comments ()
  "Moves the point backward through comments and non-eoln whitespace."
  (let ((home nil))
    (while (not home)
      (skip-chars-backward " \t")
      (setq home t) ; tenative assumtion
      (if (and (>= (- (point) 2) (point-min))
	       (string=
		(format "%s" (buffer-substring (- (point) 2) (point)))
		"*)")
	       ) ; end of and
	  (if (search-backward "(*" nil t)
	      (setq home nil)
	    nil
	    ) ; end if comment has a beginning
	) ; end if we stopped at the end of a comment
      ) ; end loop between comments and whitespace
    ) ; end of let
  )

(defun mathematica-indent-line-emptyp ()
  "Returns t if the line the point is on is empty, nil if not."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (looking-at "[\f\n]")
    ) ; end excursion
  )

(defun mathematica-indent-determine-prevline ()
  "Returns the meaningful end of the previous line (is it a
semicolon?), under the assumtion that you're not in a comment or
unbalanced parens."
  (save-excursion
    (let ((home nil) (meaningful-end))
      (while (not home)
	(beginning-of-line)
	(if (= (point) (point-min))
	    (progn ; There's nowhere to go. You're quite done.
	      (setq meaningful-end nil)
	      (setq home t)
	      ) ; end of progn
	  (progn

	    (backward-char 1)
	    (mathematica-indent-stepthrough-comments)
	
	    (if (mathematica-indent-line-emptyp)
		(progn ; we're done, there is no previous line
		  (setq meaningful-end nil)
		  (setq home t)
		  ) ; end progn
	      (progn
		(setq meaningful-end (point))
		(beginning-of-line)
		(if (= meaningful-end (point))
		    (setq home nil) ; there was nothing on this line but
				    ; comments
		  (setq home t) ; this is a good line
		  )
		) ; end progn
	      ) ; end if-else line empty

	    ) ; end line empty progn
	  ) ; end line empty if-else

	) ; end while
      
      meaningful-end
      ) ; end let
    ) ; end excursion
  )

(defun mathematica-indent-determine-indent ()
  "Returns the indentation of the line the point is on."
  (save-excursion
    (beginning-of-line)
    (skip-chars-forward " \t")
    (current-column)
    ) ; end excursion
  )

(defun mathematica-indent-calculate (start)
  (save-excursion
    (goto-char start)
    (beginning-of-line)
    (skip-chars-forward " \t")

    (let ((start-char) (start-close-paren ? )
	  (in-comment) (in-unbalanced) (prevline))
      (if (not (= (point) (point-max)))
	  (progn
	    (setq start-char (char-after))
	    (cond ((= start-char ?\)) (setq start-close-paren ?\())
		  ((= start-char ?\]) (setq start-close-paren ?\[))
		  ((= start-char ?}) (setq start-close-paren ?{))
		  ) ; end of cond
	    ) ; end of progn
	nil
	) ; end if you're not at the very end of the buffer

      (setq in-comment (mathematica-indent-determine-in-comment))
      (if in-comment ; in-comment = the position of the opening of the comment
	  (let ((tmp (+ in-comment 2)) (tmp-column))
	    (goto-char tmp)
	    (setq tmp-column (current-column))

	    (skip-chars-forward " \t")
	    (if (looking-at "[\f\n]") ; first comment line has nothing
				      ; but "(*"
		(1+ tmp-column) ; return one space after the "(*"
	      (current-column)
	      ) ; end if
	    ) ; end let in-comment

	(progn ; from now on, you're not in a comment
	  (setq in-unbalanced (mathematica-indent-determine-unbalanced))
	  (if in-unbalanced ; in-unbalanced = the opening paren
	      (progn
		(goto-char in-unbalanced)
		(if (= (char-after) start-close-paren)
		    (current-column)
		  (let ((tmp in-unbalanced)) 
		    (forward-char 1)
		    (skip-chars-forward " \t")
		    (if (looking-at "[\f\n]")
			(+ (mathematica-indent-determine-indent) 4)
		      (current-column)
		      ) ; end if unbalanced-paren ends the line
		    ) ; end let unbalanced-paren isn't immediately matched
		  ) ; end if immediate match
		) ; end progn unbalanced-paren
	    
	    (progn ; from now on, you're not in a comment or
		   ; unbalanced paren (you're at toplevel)
	      (setq prevline (mathematica-indent-determine-prevline))
	      (if prevline
		  (progn ; prevline = end of the last line
		    (goto-char prevline)
		    (if (= (char-before) ?\;)
			0 ; a fully top-level command
		      4 ; a continuation of a toplevel command

		      ) ; end if last line ended in a semicolon
		    ) ; end progn there was a last line
		0 ; if there's no previous line (in this execution
		  ; block) don't indent
		) ; end prevline if-else
	      ) ; end at toplevel progn

	    ) ; end unbalanced if-else
	  ) ; end non-comment progn
	) ; end in-comment if-else
      ) ; end outermost let
    ) ; end excursion
  )

(defun mathematica-indent-line ()
  "Indent current line as Mathematica code."
  (interactive)
  (let ((indent (mathematica-indent-calculate (point))) shift-amt beg end
	(pos (- (point-max) (point))))
    (beginning-of-line)
    (setq beg (point))
    (skip-chars-forward " \t")
    (setq shift-amt (- indent (current-column)))
    (if (zerop shift-amt)
	nil
      (progn
	(delete-region beg (point))
	(indent-to indent)
	) ; end of progn
      ) ; end if there is nothing to shift
  
    (if (> (- (point-max) pos) (point))
	(goto-char (- (point-max) pos))
      nil
      ) ; end if we need to move the cursor
    ) ; end of let
  )

(defun mathematica-electric-paren (arg)
  "Indents on closing a paren."
  (interactive "p")
  (let ((start (point)))
    (if (not arg) (setq arg 1) nil)
    (let ((i 0)) (while (< i arg) (insert ")") (setq i (1+ i))))
    (save-excursion
      (goto-char start)
      (skip-chars-backward " \t")
      (if (= (current-column) 0)
	  (mathematica-indent-line)
	nil
	) ; end if
      ) ; end excursion
    ) ; end let
  (blink-matching-open)
  )

(defun mathematica-electric-braket (arg)
  "Indents on closing a braket."
  (interactive "p")
  (let ((start (point)))
    (if (not arg) (setq arg 1) nil)
    (let ((i 0)) (while (< i arg) (insert "]") (setq i (1+ i))))
    (save-excursion
      (goto-char start)
      (skip-chars-backward " \t")
      (if (= (current-column) 0)
	  (mathematica-indent-line)
	nil
	) ; end if
      ) ; end excursion
    ) ; end let
  (blink-matching-open)
  )

(defun mathematica-electric-brace (arg)
  "Indents on closing a brace."
  (interactive "p")
  (let ((start (point)))
    (if (not arg) (setq arg 1) nil)
    (let ((i 0)) (while (< i arg) (insert "}") (setq i (1+ i))))
    (save-excursion
      (goto-char start)
      (skip-chars-backward " \t")
      (if (= (current-column) 0)
	  (mathematica-indent-line)
	nil
	) ; end if
      ) ; end excursion
    ) ; end let
  (blink-matching-open)
  )

(provide 'mathematica)
