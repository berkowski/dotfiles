(define-module (zb guix systems desktop)
  #:use-module (zb guix systems base)
  #:use-module (zb guix substitutes)
  #:use-module (zb guix home services tmux)
  #:use-module (zb guix home services shells)
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
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
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
  (cons* bluez git tmux
	 (operating-system-packages zb-base-os)))

(define %zb-bluetooth-service
  (service bluetooth-service-type (bluetooth-configuration (auto-enable? #t))))

(define %zb-desktop-services
  (modify-services  (cons* %zb-bluetooth-service
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

(define %zb-sway-home-environment
  (home-environment
   (services %zb-desktop-home-services)))

(define %zb-sway-home-service
  (service guix-home-service-type `(("zac" ,%zb-sway-home-environment))))

(define %zb-sway-packages
  (cons* sway emacs-next-pgtk foot swayidle swaylock wofi
	 %zb-desktop-packages))

(define-public zb-sway-os
  (operating-system
   (inherit zb-base-os)
   (services (modify-services (cons* %zb-sway-home-service
				     %zb-desktop-services)))
   (packages %zb-sway-packages)))
