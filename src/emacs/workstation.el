;;; -*- Emacs-Lisp -*- ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defconst ws-running-on-xemacs (string-match "XEmacs" emacs-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ws-goto-position-and-grab-focus (file-name line-number column-number
						  &optional text-begin other-window-p)
  (ws-goto-position file-name line-number column-number text-begin other-window-p)
  (select-frame-set-input-focus (window-frame (display-buffer (current-buffer)))))

(defun ws-goto-position-and-grab-mouse (file-name line-number column-number
						  &optional text-begin other-window-p)
  (ws-goto-position file-name line-number column-number text-begin other-window-p)
  (raise-frame)
  (let (posn)
    (setq posn (posn-at-point))
    (setq rc (posn-col-row posn))
    (setq x (car rc))
    (setq y (cdr rc))
    (setq x (+ x 5))
    (setq y (+ y 5))
    (set-mouse-position
     (window-frame (posn-window posn)) x y)))

(defun ws-goto-position (file-name line-number column-number
				   &optional text-begin other-window-p)
  (let ((*FIND-FILE-MUST-EXIST* t) (find-file-existing-other-name t))
    (cond
     ((null other-window-p)
      (find-file (expand-file-name file-name))
      (message nil))
     (t
      (find-file-other-window (expand-file-name file-name))
      (message nil)))
    (goto-line line-number)
    (if text-begin
	(beginning-of-line-text)
      (move-to-column column-number))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defface ws-link 
  '((t (:background "grey50" 
	:box (:line-width 1 :color "grey50" :style released-button))))
  t)

(defface ws-mouse-link 
  '((t (:background "grey25" 
	:box (:line-width 1 :color "grey25" :style released-button))))
  t)

(defface ws-link-selected 
  '((t (:background "royal blue" 
	:box (:line-width 1 :color "royal blue" :style released-button)))) 
  t)

(defface ws-mouse-link-selected 
  '((t (:background "medium blue" 
	:box (:line-width 1 :color "medium blue" :style released-button)))) 
  t)

(setq ws-link-keymap (make-keymap))
(suppress-keymap ws-link-keymap)
(define-key ws-link-keymap [S-down-mouse-1] 'ignore)
(define-key ws-link-keymap [S-mouse-1] 'ws-toggle-command)
(define-key ws-link-keymap [mouse-1] 'ws-select-command)
(define-key ws-link-keymap [double-mouse-1] 'ws-toggle-node-open-close-command)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ws-add-link-at (num is-def echo file-name line-number column-number
			   &optional text-begin other-window-p)
  (cond
   ((file-exists-p (expand-file-name file-name))
    (save-excursion
      (ws-goto-position file-name line-number column-number text-begin other-window-p)
      (setq over (ws-add-link num echo text-begin)))
    (setq key (ws-create-position-key file-name line-number column-number))
    (setq num (overlay-get over 'ws-link-num))
    (overlay-put over 'ws-link-key key)
    (setq old (gethash key *ws-position-table*))
    (if (overlayp old) (delete-overlay old))
    (puthash key over *ws-position-table*)
    (if is-def (puthash num over *ws-definition-table*)
      (puthash num over *ws-instance-table*))
    (puthash num over *ws-position-table*)
    over)
   (t nil))
  )

(defun ws-add-link (num echo to-end)
  (ws-init)
  (if to-end
      (setq over (make-overlay (point) (save-excursion (end-of-line-text) (point))))
    (setq over (make-overlay (point) (save-excursion (forward-sexp 1) (point)))))
  (overlay-put over 'ws-link  t)
  (overlay-put over 'ws-link-num num)
  (overlay-put over 'keymap  ws-link-keymap)
  (if (not (string-equal echo ""))
      (overlay-put over 'help-echo echo))
  (ws-set-select over nil)
  over)

(defun ws-set-select (over select)
  (cond
   ((and select (overlay-get over 'ws-link))
    (setq num (overlay-get over 'ws-link-num))
    (message (format "NUMX %d" num))
;    (send-to-tcl (format "global tree; [set tree] selection add %d" num))
    (overlay-put over 'face      'ws-link-selected)
    (overlay-put over 'mouse-face'ws-mouse-link-selected)
    (overlay-put over 'selected t))
   ((overlay-get over 'ws-link)
    (setq num (overlay-get over 'ws-link-num))
;    (send-to-tcl (format "global tree; [set tree] selection remove %d" num))
    (overlay-put over 'face 'ws-link)
    (overlay-put over 'mouse-face     'ws-mouse-link)
    (overlay-put over 'selected nil))))

(defun ws-select (over)
  (ws-set-select over t))

(defun ws-unselect (over)
  (ws-set-select over nil))

(defun ws-selected (over)
  (overlay-get over 'selected))

(defun ws-toggle-select (over)
  (cond
   ((ws-selected over)
    (ws-set-select over nil))
   (t
    (ws-set-select over t))))

(defun ws-remove-links ()
  (remove-overlays nil nil 'ws-link t))

(defun ws-unselect-all-links ()
  (maphash (lambda (key over) (ws-unselect over)) 
	   *ws-position-table*))

(defun ws-select-num (num)
  (setq over (gethash num *ws-definition-table*))
  (if (overlayp over) (ws-select over))
  (setq over (gethash num *ws-instance-table*))
  (if (overlayp over) (ws-select over)))

(defun ws-toggle-select-num (num)
  (setq over (gethash num *ws-definition-table*))
  (if (overlayp over) (ws-toggle-select over))
  (setq over (gethash num *ws-instance-table*))
  (if (overlayp over) (ws-toggle-select over)))

(defun ws-select-nums (nums)
  (ws-unselect-all-links)
  (mapc 'ws-select-num nums))

(defun ws-get-num (over)
  (overlay-get over 'ws-link-num))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun ws-sync-tcl-selection ()
;;   (send-to-tcl 
;;    (ws-remove-parens
;;     (format "setCurrentSelection %s" (ws-get-selected)))))

(defun ws-sync-tcl-selection ()
)

(defun ws-remove-parens (string)
  (replace-regexp-in-string 
   "(" ""
   (replace-regexp-in-string ")" "" string)))

(defun ws-get-selected ()
  (let (selected)
    (maphash (lambda (key over) 
	       (if (ws-selected over)
		   (pushnew (overlay-get over 'ws-link-num) selected)))
	     *ws-position-table*)
    selected))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ws-select-command (event)
  (interactive "e")
  (let (posn overs nums)
    (ws-unselect-all-links)
    (setq posn (event-start event))
    (select-window (posn-window posn))
    (setq overs (overlays-at (posn-point posn)))
    (setq nums (mapcar 'ws-get-num overs))
    (ws-select-nums nums)
    (ws-sync-tcl-selection)))

(defun ws-select-region-command ()
  (interactive)
  (ws-select-region nil))

(defun ws-add-region-command ()
  (interactive)
  (ws-select-region t))

(defun ws-select-region (add)
  (let (current overs nums)
    (if add (setq current (ws-get-selected)))
    (ws-unselect-all-links)
    (setq overs (overlays-in (region-beginning) (region-end)))
    (setq nums (mapcar 'ws-get-num overs))
    (setq nums (append nums current))
    (ws-select-nums nums)
    (ws-sync-tcl-selection)
    (when transient-mark-mode (deactivate-mark))))

(defun ws-toggle-command (event)
  (interactive "e")
  (let (posn overs nums)
    (setq posn (event-start event))
    (select-window (posn-window posn))
    (setq overs (overlays-at (posn-point posn)))
    (setq nums (mapcar 'ws-get-num overs))
    (mapcar 'ws-toggle-select-num nums)
    (ws-sync-tcl-selection)))

(defun ws-remove-links-command ()
  (interactive)
  (ws-remove-links))

(defun ws-toggle-node-open-close-command (event)
  (interactive "e")
  (let (overs over num)
    (setq overs (overlays-at (posn-point (event-start event))))
    (if (not (null overs))
	(progn 
	  (setq over (car overs))
	  (setq num (overlay-get over 'ws-link-num))
	  (sleep-for 0 100)
	  (send-to-tcl (format "global tree; toggleNodeOpenClose [set tree] %d" num))))))

(defun ws-jump-to-bsvdef-command ()
  (interactive)
  (send-to-tcl (format "global tree; jumpToBSVDef [set tree]")))

(defun ws-jump-to-bsvinst-command ()
  (interactive)
  (send-to-tcl (format "global tree; jumpToBSVInst [set tree]")))

(defun ws-send-typed-signals-command ()
  (interactive)
  (send-to-tcl (format "global tree; sendTypedSignals [set tree]")))

(defun ws-send-typed-signals-verbose-command ()
  (interactive)
  (send-to-tcl (format "global tree; sendTypedSignalsVerbose [set tree]")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ws-prev-and-restore-state-command ()
  (interactive)
  (ws-prev-and-restore-state))

(defun ws-next-and-restore-state-command ()
  (interactive)
  (ws-next-and-restore-state))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq *ws-state-stack* nil)
(setq *ws-state-stack-pointer* -1)

(defun ws-save-state (file-name line-number column-number 
				&optional text-begin)
  (setq last-command 'ws-save-state)
  (let (nums info)
    (setq nums (ws-get-selected))
    (setq info (list nums file-name line-number column-number text-begin))
    (setq *ws-state-stack* (cons info *ws-state-stack*))))

(defun ws-prev-state ()
  (setq *ws-state-stack-pointer* (+ *ws-state-stack-pointer* 1))
  (cond
   ((>= *ws-state-stack-pointer* (length *ws-state-stack*))
    (setq *ws-state-stack-pointer* (-  (length *ws-state-stack*) 1))
    nil)
   (t
    (nth *ws-state-stack-pointer* *ws-state-stack*))))

(defun ws-next-state ()
  (setq *ws-state-stack-pointer* (- *ws-state-stack-pointer* 1))
  (cond
   ((< *ws-state-stack-pointer* 0)
    (setq *ws-state-stack-pointer* 0)
    nil)
   (t
    (nth *ws-state-stack-pointer* *ws-state-stack*))))

(defun ws-prev-and-restore-state ()
  (let (info nums)
    (cond
     ((eq last-command 'ws-save-state)
      (setq *ws-state-stack-pointer* 0))
     ((not (or (eq last-command 'ws-prev-and-restore-state-command)
	       (eq last-command 'ws-next-and-restore-state-command)))
      (setq *ws-state-stack-pointer* -1)))
    (setq info (ws-prev-state))
    (cond ((null info) 
	   (beep)
	   (message "The view history is empty."))
	  (t 
	   (setq nums (nth 0 info))
	   (ws-goto-position (nth 1 info) (nth 2 info) (nth 3 info) (nth 4 info))
	   (ws-select-nums nums)
	   (ws-sync-tcl-selection)))))

(defun ws-next-and-restore-state ()
  (let (info nums)
    (cond
     ((eq last-command 'ws-save-state)
      (setq *ws-state-stack-pointer* 0))
     ((not (or (eq last-command 'ws-prev-and-restore-state-command)
	       (eq last-command 'ws-next-and-restore-state-command)))
      (setq *ws-state-stack-pointer* -1)))
    (setq info (ws-next-state))
    (cond ((null info) 
	   (beep)
	   (message "Already at top of view history."))
	  (t 
	   (setq nums (nth 0 info))
	   (ws-goto-position (nth 1 info) (nth 2 info) (nth 3 info) (nth 4 info))
	   (ws-select-nums nums)
	   (ws-sync-tcl-selection)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq *ws-position-table* (make-hash-table :test 'equal))
(setq *ws-definition-table* (make-hash-table :test 'eq))
(setq *ws-instance-table* (make-hash-table :test 'eq))

(defun ws-create-position-key (file-name line-number column-number)
  (cons (expand-file-name file-name) line-number))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq *ws-tcl-channel* "") ;; value is set from tcl

(defun send-to-tcl (cmd)
  (setq exec (concat "echo \"" cmd "\" > " *ws-tcl-channel*))
  (shell-command-to-string  exec))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq bluespec-ws-mode-keymap (make-keymap))
(define-key bluespec-ws-mode-keymap "\M-." 'ws-jump-to-bsvdef-command)
(define-key bluespec-ws-mode-keymap "\M-," 'ws-jump-to-bsvinst-command)
(define-key bluespec-ws-mode-keymap "\M-p" 'ws-prev-and-restore-state-command)
(define-key bluespec-ws-mode-keymap "\M-n" 'ws-next-and-restore-state-command)
(define-key bluespec-ws-mode-keymap "\M-s" 'ws-select-region-command)
(define-key bluespec-ws-mode-keymap "\M-S" 'ws-add-region-command)

(define-key bluespec-ws-mode-keymap "\M-t" 'ws-send-typed-signals-command)
(define-key bluespec-ws-mode-keymap "\M-T" 'ws-send-typed-signals-verbose-command)

(define-minor-mode bluespec-ws-mode
  "Zaz."
  :lighter " BDW" 
  :keymap bluespec-ws-mode-keymap)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun display-echo (format)
  (interactive)
  (let ((help (help-at-pt-kbd-string)))
    (if help
	(message format help))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun end-of-line-text (&optional n)
  "Move to the end of the text on this line.
With optional argument, move forward N-1 lines first."
  (interactive "p")
  (end-of-line n)
  (skip-chars-backward " \t"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar ws-emacs-menu
  '("Bluespec"
    ;; ("Waves"
;;      )
;;     "----"
;;     ["Goto Definition of Selected Instantiation"  ws-jump-to-bsvdef-command]
;;     ["Goto Instantiation of Selected Definition"  ws-jump-to-bsvinst-command]
    ["Goto Previous View"  ws-prev-and-restore-state-command]
    ["Goto Next View"      ws-next-and-restore-state-command]
    )
  "Menu for BSW mode."
  )

(defun ws-init ()
  (cond ((not bluespec-ws-mode)
	 (bluespec-ws-mode)
	 (unless ws-running-on-xemacs
	   (easy-menu-define ws-menu bluespec-ws-mode-keymap "Menu for BSW mode"
	     ws-emacs-menu))
	 (add-hook 'after-revert-hook 'ws-init nil t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'workstation)
