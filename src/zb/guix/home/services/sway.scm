(define-module (zb guix home services sway)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (guix gexp))

(define-public home-sway-service-type
  (simple-service 'home-sway-service-type
		  home-xdg-configuration-files-service-type
		  `(("sway/config" ,(local-file "../../../../../dotfiles/sway/.config/sway/config")))))
