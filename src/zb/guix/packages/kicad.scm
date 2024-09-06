(define-module (zb packages kicad)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gl))

(define-public kicad-8
  (package
   (inherit kicad)
   (name "kicad")
   (version "8.0.4")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://gitlab.com/kicad/code/kicad.git")
                  (commit version)))
              (sha256
               (base32
                "03971przr1kzmkr302qzx30mmp92mkwg29dwjvzayc522iskxcbx"))
              (file-name (git-file-name name version))))
   (inputs (modify-inputs (package-inputs kicad)
     (append libglvnd)
     (append libgit2)
     (append libsecret)))))
;;   (package
;;     (name "kicad")
;;     (version "7.0.11")
;;     (source (origin
;;               (method git-fetch)
;;               (uri (git-reference
;;                     (url "https://gitlab.com/kicad/code/kicad.git")
;;                     (commit version)))
;;               (sha256
;;                (base32
;;                 "1qn7w6pb1n5gx73z1zqbv140chh4307y8764z7xkdvric9i48qj4"))
;;               (file-name (git-file-name name version))))
;;     (build-system cmake-build-system)
;;     (arguments
;;      `(#:out-of-source? #t
;;        #:tests? #f ;no tests
;;        #:build-type "Release"
;;        #:configure-flags
;;        ,#~(list "-DKICAD_SCRIPTING_PYTHON3=ON"
;;                 (string-append "-DOCC_INCLUDE_DIR="
;;                                #$(this-package-input "opencascade-occt")
;;                                "/include/opencascade")
;;                 "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
;;                 "-DKICAD_USE_EGL=ON"    ;because wxWidgets uses EGL
;;                 "-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE")
;;        #:phases
;;        (modify-phases %standard-phases
;;          (add-after 'unpack 'fix-ngspice-detection
;;            (lambda* (#:key inputs #:allow-other-keys)
;;              (substitute* "eeschema/CMakeLists.txt"
;;                (("NGSPICE_DLL_FILE=\"\\$\\{NGSPICE_DLL_FILE\\}\"")
;;                 (string-append "NGSPICE_DLL_FILE=\""
;;                                (assoc-ref inputs "libngspice")
;;                                "/lib/libngspice.so\"")))))
;;          (add-after 'install 'wrap-program
;;            ;; Ensure correct Python at runtime.
;;            (lambda* (#:key inputs outputs #:allow-other-keys)
;;              (let* ((out (assoc-ref outputs "out"))
;;                     (python (assoc-ref inputs "python"))
;;                     (file (string-append out "/bin/kicad"))
;;                     (path (string-append out "/lib/python"
;;                                          ,(version-major+minor (package-version
;;                                                                 python))
;;                                          "/site-packages:"
;;                                          (getenv "GUIX_PYTHONPATH"))))
;;                (wrap-program file
;;                  `("GUIX_PYTHONPATH" ":" prefix
;;                    (,path))
;;                  `("PATH" ":" prefix
;;                    (,(string-append python "/bin:"))))))))))
;;     (native-search-paths
;;      (list (search-path-specification
;;             (variable "KICAD") ;to find kicad-doc
;;             (files '("")))
;;            (search-path-specification
;;             (variable "KICAD7_TEMPLATE_DIR")
;;             (files '("share/kicad/template")))
;;            (search-path-specification
;;             (variable "KICAD7_SYMBOL_DIR")
;;             (files '("share/kicad/symbols")))
;;            (search-path-specification
;;             (variable "KICAD7_FOOTPRINT_DIR")
;;             (files '("share/kicad/footprints")))
;;            (search-path-specification
;;             (variable "KICAD7_3DMODEL_DIR")
;;             (files '("share/kicad/3dmodels")))))
;;     (native-inputs (list boost
;;                          desktop-file-utils
;;                          gettext-minimal
;;                          pkg-config
;;                          swig
;;                          unixodbc
;;                          zlib))
;;     (inputs (list bash-minimal
;;                   cairo
;;                   curl
;;                   glew
;;                   glm
;;                   hicolor-icon-theme
;;                   libngspice
;;                   libsm
;;                   mesa
;;                   opencascade-occt
;;                   openssl
;;                   python-wrapper
;;                   gtk+
;;                   wxwidgets
;;                   python-wxpython
;;                   gdk-pixbuf))
;;     (home-page "https://www.kicad.org/")
;;     (synopsis "Electronics Design Automation Suite")
;;     (description
;;      "Kicad is a program for the formation of printed circuit
;; boards and electrical circuits.  The software has a number of programs that
;; perform specific functions, for example, pcbnew (Editing PCB), eeschema (editing
;; electrical diagrams), gerbview (viewing Gerber files) and others.")
;;     (license license:gpl3+)))
;; 
