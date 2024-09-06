(define-module (zb systems basic)
  #:use-module (gnu)
  #:use-module (gnu system setuid)
  #:use-module (gnu packages linux)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-service-modules avahi cups desktop networking dbus pm ssh xorg)
(use-package-modules cups fonts linux nfs wm)

(define-public basic-operating-system
  (operating-system
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))
   (locale "en_US.utf8")
   (timezone "America/New_York")
   (keyboard-layout (keyboard-layout "us"))
   (host-name "x1")

   ;; The list of user accounts ('root' is implicit).
   (users (cons* (user-account
                  (name "zac")
                  (comment "Zac")
                  (group "users")
                  (home-directory "/home/zac")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "dialout")))
                 %base-user-accounts))

   (packages (append (map specification->package
			  '("sway"
			    "swaylock"
			    "swayidle"
                            "git"
                            "tmux"
                            "stow"))
                     %base-packages))

   (privileged-programs
    (append (map file-like->setuid-program
		 (list (file-append nfs-utils "/sbin/mount.nfs")
		       (file-append ntfs-3g "/sbin/mount.ntfs-3g")))
	    %default-privileged-programs))

   (services (append
              (modify-services %base-services
			       (delete login-service-type)
			       (delete mingetty-service-type)
			       (delete console-font-service-type))

              (list
               ;; Seat management (can't use seatd because Wireplumber depends on elogind)
               (service elogind-service-type)

               ;; Configure TTYs and graphical greeter
               (service console-font-service-type
			(map (lambda (tty)
			       ;; Use a larger font for HIDPI screens
			       (cons tty (file-append
					  font-terminus
					  "/share/consolefonts/ter-132n")))
			     '("tty1" "tty2" "tty3")))

               (service greetd-service-type
			(greetd-configuration
                         (greeter-supplementary-groups (list "video" "input"))
                         (terminals
                          (list
                           ;; TTY1 is the graphical login screen for Sway
                           (greetd-terminal-configuration
                            (terminal-vt "1")
                            (terminal-switch #t))
                           ;; (default-session-command (greetd-wlgreet-sway-session
                           ;;                           (sway-configuration
                           ;;                            (plain-file "sway-greet.conf"
                           ;;                                        "output * bg /home/daviwil/.dotfiles/backgrounds/samuel-ferrara-uOi3lg8fGl4-unsplash.jpg fill\n"))))
                           

                           ;; Set up remaining TTYs for terminal use
                           (greetd-terminal-configuration (terminal-vt "2"))
                           (greetd-terminal-configuration (terminal-vt "3"))))))

               ;; Configure swaylock as a setuid program
               (service screen-locker-service-type
			(screen-locker-configuration
                         (name "swaylock")
                         (program (file-append swaylock "/bin/swaylock"))
                         (using-pam? #t)
                         (using-setuid? #f)))

               ;; Configure the Guix service and ensure we use Nonguix substitutes
               (simple-service 'add-nonguix-substitutes
                               guix-service-type
                               (guix-extension
				(substitute-urls
                                 (append (list "https://substitutes.nonguix.org")
                                         %default-substitute-urls))
				(authorized-keys
                                 (append (list (plain-file "nonguix.pub"
                                                           "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                         %default-authorized-guix-keys))))

               ;; Set up Polkit to allow `wheel' users to run admin tasks
               polkit-wheel-service

               ;; Networking services
               (service network-manager-service-type) ;; network-manager - use nm for networks
               (service wpa-supplicant-service-type)  ;; wpa-supplicant - wireless auth framework (needed by NetworkManager)
               (service bluetooth-service-type        ;; bluetooth - ... bluetooth
			(bluetooth-configuration
                         (auto-enable? #t)))
               (service usb-modeswitch-service-type)  ;; usb-modeswitch - mode switching for multi-mode USB devices (e.g. phones)

               ;; Basic desktop system services (copied from %desktop-services)
               (service avahi-service-type)           ;; avahi - mDNS/DNS-SD local network discovery
               (service udisks-service-type)          ;; udisks - well-defined D-Bus interfaces for storage
               (service upower-service-type)          ;; upower - power device enumeration
               (service cups-pk-helper-service-type)  ;; cups-pk-helper - PolicyKit helper to configuer cups
               (service geoclue-service-type)         ;; geoclue - D-Bus service that provides location information
               (service polkit-service-type)          ;; polkit - system-wide privilege policies
               (service dbus-root-service-type)       ;; dbus - inter-process communication framework
               (service ntp-service-type)             ;; ntp - network time protocol
               fontconfig-file-system-service         ;; Manage the fontconfig cache
               (service thermald-service-type)        ;; thermald - CPU throttling based on temerature
               ;; (service tlp-service-type              ;; tlp - battery friendly power scaling 
	       ;; 		(tlp-configuration
               ;;           (cpu-boost-on-ac? #t)
               ;;           (wifi-pwr-on-bat? #t)))

               ;; Enable Docker containers and virtual machines
               ;; (service docker-service-type)
               ;; (service libvirt-service-type
               ;;          (libvirt-configuration
               ;;           (unix-sock-group "libvirt")
               ;;           (tls-port "16555")))

               ;; Enable SSH access
               ;; (service openssh-service-type
               ;;          (openssh-configuration
               ;;           (openssh openssh-sans-x)
               ;;           (port-number 2222)))

               (service cups-service-type              ;; cups - Common Unix Print Service
			(cups-configuration
                         (web-interface? #t)
                         (extensions
                          (list cups-filters))))

               ;; Set up the X11 socket directory for XWayland
               (service x11-socket-directory-service-type)


               ;; Add udev rules for a few packages
               (udev-rules-service 'pipewire-add-udev-rules pipewire))))
   
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

   ;; placeholder file-system (every machine has dfferent UUIDs for partitions)
   (file-systems (cons*
                  (file-system
                   (mount-point "/tmp")
                   (device "none")
                   (type "tmpfs")
                   (check? #f))
                  %base-file-systems))))

