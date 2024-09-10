(define-module (zb guix home services foot)
  #:use-module (gnu services)
  #:use-module (gnu home services)
  #:use-module (guix gexp))

(define-public home-foot-service-type
  (simple-service 'home-foot-service-type
		  home-xdg-configuration-files-service-type
		  `(("foot/foot.ini" ,(local-file "../../../../../dotfiles/foot/.config/foot/foot.ini")))))
