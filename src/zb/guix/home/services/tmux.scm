(define-module (zb guix home services tmux)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (guix gexp))

(define-public home-tmux-service-type
  (simple-service 'home-tmux-service-type
		  home-xdg-configuration-files-service-type
		  `(("tmux/tmux.conf" ,(local-file "../../../../../dotfiles/tmux/.config/tmux/tmux.conf")))))
