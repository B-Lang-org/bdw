
(create-file-buffer "*server*")

(setq load-path 
      (cons 
       (concat (expand-file-name (getenv "BDWDIR")) "/tcllib/emacs")
       load-path))

;; make sure system name is set correctly
(when (equal system-name "localhost.localdomain")
  (let ((name (shell-command-to-string "uname -n")))
    (when (> (length name) 0)
      (setq system-name (substring name 0 -1)))))

(require 'server)
(setq server-name (format "server-%d" (emacs-pid)))
(server-start)

(require 'workstation)

