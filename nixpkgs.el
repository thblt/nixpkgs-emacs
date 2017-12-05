(require 'tablist)
(require 'json)

(defvar nixpkgs-packages
  nil
  "The list of Nix packages.")

(defmacro get-buffer-create-init (buffer body)
  "Like `get-buffer-create' but initializes BUFFER with BODY if creating it."
  )

(defun nixpkgs-tabulated-list-entries ()
  (mapcar (lambda (x)
            (let* ((id (car x))
                  (props (cdr x))
                  (meta (alist-get 'meta props))
                  )
              `(,id [
                     ,(alist-get 'name props)
                     ,(--if-let (alist-get 'description meta) it "")

                     ]))) nixpkgs-packages)
  )

(defun nixpkgs-load-packages ()
  (interactive)
    (setq nixpkgs-packages (json-read-from-string (shell-command-to-string "nix-env -qa --json"))))

(defun nixpkgs-list-packages ()
  (interactive)
  (unless nixpkgs-packages (nixpkgs-load-packages))
  (switch-to-buffer (get-buffer-create "*Nix packages*"))
  (tablist-mode)
  (setq tabulated-list-format [("Name" 30 t )
                               ("Description" 99 nil)]
        tabulated-list-entries 'nixpkgs-tabulated-list-entries)
  (tabulated-list-init-header)
  (tabulated-list-print)
  (hl-line-mode)
  )
