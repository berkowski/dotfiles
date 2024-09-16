(define-module (zb guix packages horizon-eda)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system meson)
  #:use-module (guix download)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages python)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages sqlite))

(define-public horizon-eda
  (package
   (name "horizon-eda")
   (version "2.6.0")
   (source (origin
	    (method url-fetch)
	    (uri (string-append "https://github.com/horizon-eda/horizon/archive/refs/tags/v"
				version
				".tar.gz"))
	    (sha256
	     (base32
              "0mhjp1azpxxkx4j94g9xblj9ihkvn7ivhbx3nss8mb4jbfh81rp7"))))
   (build-system meson-build-system)
   (arguments
    '(#:glib-or-gtk? #t))
      ;; #:phases (modify-phases %standard-phases
      ;; 			      (add-after 'install 'wrap-program
      ;; 					 (lambda* (#:key inputs outputs #:allow-other-keys)
      ;; 						  (let ((out (assoc-ref outputs "out"))
      ;; 							(hicolor-theme (assoc-ref inputs "hicolor-icon-theme"))
      ;; 							(adwaita-theme (assoc-ref inputs "adwaita-icon-theme"))
      ;; 							(shared-mime (assoc-ref inputs "shared-mime-info")))
      ;; 						    (wrap-program (string-append out "/bin/horizon-eda")
      ;; 								  `("XDG_DATA_DIRS" ":" prefix
      ;; 								    ,(map (lambda (package)
      ;; 									    (string-append package "/share"))
      ;; 									  `(,hicolor-theme
      ;; 									    ,adwaita-theme
      ;; 									    ,shared-mime)))
      ;; 								  `("GDK_PIXBUF_MODULE_FILE" =
      ;; 								    (,(getenv "GDK_PIXBUF_MODULE_FILE")))
      ;; 								  `("GSETTINGS_SCHEMA_DIR" =
      ;; 								    (,(string-append (assoc-ref inputs "gtk+")
      ;; 										     "/share/glib-2.0/schemas"))))))))))
   (native-inputs (list pkg-config
			ruby
			python
			python-wrapper
			cmake
			`(,glib "bin")
			git))
   (inputs (list gtkmm-3
		 (librsvg-for-system)
		 gdk-pixbuf
		 util-linux
		 zeromq
		 cppzmq
		 glm
		 libgit2
		 curl
		 opencascade-occt
		 podofo
		 libarchive
		 libspnav
		 sqlite
		 hicolor-icon-theme
		 adwaita-icon-theme
		 shared-mime-info))
   (home-page "https://horizon-eda.org/")
   (synopsis "Horizon EDA is an Electronic Design Automation package for printed circuit board design.")
   (description "Horizon EDA is an Electronic Design Automation package supporting an integrated end-to-end workflow for printed circuit board design including parts management and schematic entry.")
   (license license:cc-by-sa4.0)))
	    
