(define-module (zb guix systems desktop)
  #:use-module (zb guix systems base)
  #:use-module (zb guix substitutes)
  #:use-module (zb guix home services foot)
  #:use-module (zb guix home services tmux)
  #:use-module (zb guix home services shells)
  #:use-module (zb guix home services sway)
  #:use-module (gnu services)
  #:use-module (gnu services desktop)
  #:use-module (gnu services guix)
  #:use-module (gnu services networking)
  #:use-module (gnu services sddm)
  #:use-module ((gnu services sound) #:prefix sound:)
  #:use-module (gnu services xorg)
  #:use-module (gnu system)
  #:use-module (gnu home)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix gexp)
  #:use-module (srfi srfi-1))

(define %zb-desktop-home-services
  (list home-tmux-service-type
	home-shell-service-type
	(service home-dbus-service-type)
	(service home-pipewire-service-type)))

(define %zb-desktop-home-environment
  (home-environment (services %zb-desktop-home-services)))

(define %zb-desktop-home-service
  (service guix-home-service-type `(("zac" ,%zb-desktop-home-environment))))

(define %zb-desktop-packages
  (cons* bluez git tmux pipewire wireplumber podman openssh
	 (operating-system-packages zb-base-os)))

(define %zb-bluetooth-service
  (service bluetooth-service-type (bluetooth-configuration (auto-enable? #t))))

(define %zb-podman-subuid-subgid-service
  (simple-service 'zb-podman-subuid-subgid-service
		  etc-service-type
		  `(("subuid" ,(plain-file "subuid" (string-append "zac" ":100000:65536")))
		    ("subgid" ,(plain-file "subgid" (string-append "zac" ":100000:65536"))))))


(define %zb-desktop-services
  (modify-services  (cons* %zb-bluetooth-service
			   %zb-podman-subuid-subgid-service
			   (remove (lambda (service)
			      (let* ((type (service-kind service))
				     (name (service-type-name type)))
				
				(or (memq type
					  (list gdm-service-type
						sddm-service-type
						accountsservice-service-type
						modem-manager-service-type
						sane-service-type))
				    (memq name
					  (list 'network-manager-applet
						'screen-locker)))))
			    %desktop-services))
		    (delete sound:alsa-service-type)
		    (delete sound:pulseaudio-service-type)))

(define %zb-sway-packages
  (cons* sway emacs-next-pgtk foot swayidle swaylock wofi
	 %zb-desktop-packages))

(define %zb-sway-home-environment
  (home-environment
   (services (cons* home-sway-service-type
	            home-foot-service-type
		    %zb-desktop-home-services))))

(define-public sway-home-environment
  %zb-sway-home-environment)

(define %zb-sway-home-service
  (service guix-home-service-type `(("zac" ,%zb-sway-home-environment))))

(define %zb-sway-swaylock-service-type
  (service screen-locker-service-type
	   (screen-locker-configuration
            (name "swaylock")
            (program (file-append swaylock "/bin/swaylock"))
            (using-pam? #t)
            (using-setuid? #f))))

(define-public zb-sway-os
  (operating-system
   (inherit zb-base-os)
   (services (modify-services (cons* %zb-sway-home-service
				     %zb-sway-swaylock-service-type
				     %zb-desktop-services)))
   (packages %zb-sway-packages)))
