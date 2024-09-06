(define-module (zb packages qgroundcontrol)
    #:use-module (guix packages)
    #:use-module (guix download)
    #:use-module (guix git-download)
    #:use-module (guix build-system python)
    #:use-module (guix build-system pyproject)
    #:use-module (guix build-system qt)
    #:use-module ((guix licenses) #:prefix license:)
    #:use-module (gnu packages version-control)
    #:use-module (gnu packages qt)
    #:use-module (gnu packages pkg-config)
    #:use-module (gnu packages sdl)
    #:use-module (gnu packages compression)
    #:use-module (zb packages mavlink))

(define-public python-dronecan
  (package
    (name "python-dronecan")
    (version "1.0.26")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "dronecan" version))
       (sha256
        (base32 "08dzb1g0s68mb4jvvmlwcyj4gsa2yas2iq5ahcmwq3j0mz2isshg"))))
    (build-system pyproject-build-system)
    (home-page "https://dronecan.github.io")
    (synopsis "Python implementation of the DroneCAN protocol stack")
    (description
     "Python implementation of the @code{DroneCAN} protocol stack.")
    (license license:expat)))

(define-public qgroundcontrol
    (package 
       (name "qgroundcontrol")
       (version "4.4.1")
       (source 
          (origin 
             (method git-fetch)
             (uri (git-reference 
                     (url "https://github.com/mavlink/qgroundcontrol")
                     (commit (string-append "v" version))
                     (recursive? #t)))
             (sha256
                (base32
                   "18bnfllikdpk1j266yr3c2iljaqzg82l5m1vkbdv25q20r0pvl8m"))))
       ;;cmake builds seem to not be supported until QGC v5
       ;;    https://github.com/mavlink/qgroundcontrol/issues/11611
       ;;Use qmake.  Requires out-of-source build (method adapted from cmake-build-system.scm
       (build-system qt-build-system)
       (arguments
         `(#:tests? #f
           #:configure-flags '("CONFIG+=QGC_DISABLE_BUILD_SETUP"
                               "CONFIG+=QGC_DISABLE_INSTALLER_SETUP")
           #:phases
           (modify-phases %standard-phases
              (replace 'configure
                       (lambda* (#:key outputs (configure-flags '()) #:allow-other-keys)
                                (let* ((out (assoc-ref outputs "out"))
                                       (abs-srcdir (getcwd))
                                       (srcdir (string-append "../" (basename abs-srcdir))))
                                    (mkdir "../build")
                                    (chdir "../build")
                                    (format #t "build directory: ~s~%" (getcwd))
                                    (let ((args `(,(string-append srcdir "/qgroundcontrol.pro")
                                                  ,(string-append "PREFIX=" out)
                                                  ,(string-append "QMAKE_RPATHDIR=" out "/lib")
                                                  ,@configure-flags)))
                                       (format #t "running 'qmake' with arguments ~s~%" args)
                                       (apply invoke "qmake" args))))))))
       (native-inputs (list pkg-config
                            git
                            qttools-5))
       (inputs (list qtbase-5
                     qtconnectivity
                     qtcharts
                     qtlocation-5
                     qtdeclarative-5
                     qtmultimedia-5
                     qtquickcontrols2-5
                     qtquickcontrols-5
                     qtsvg-5
                     qtspeech-5
                     qtserialport-5
                     qtwayland-5
                     qtx11extras
                     qtgraphicaleffects
                     sdl2
                     zlib))
                     
                     
       (synopsis "Cross-platform ground control station for drones")
       (description "Cross-platform ground control station for drones")
       (home-page "http://qgroundcontrol.io/")
       (license license:gpl3)))
;(packages->manifest (list ardupilot-rover))
