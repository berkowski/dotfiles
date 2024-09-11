(define-module (zb guix packages mbsystem)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build utils)
  #:use-module ((guix licenses) :prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages python)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages geo)
  #:use-module (gnu packages lesstif)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages image))

(define-public otpsnc
  (package
   (name "otpsnc")
   (version "2021.10.29")
   (source (origin
            (method url-fetch)
            (uri (string-append "file://" (dirname (current-filename)) "/OTPSnc-with-tpxo9.tar.bz"))
	    (sha256 (base32 "194aaaz1j4afaf4nqpcg62zy6yp2q5rrm3r84zvps6ycrbmx2nnw"))))
   (build-system gnu-build-system)
   (arguments
    (list
     #:tests? #f
     #:phases
     #~(modify-phases %standard-phases
                      (delete 'configure)
                      (add-after 'unpack 'patch-fortran-includes
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (let ((netcdf-fortran (assoc-ref %build-inputs "netcdf-fortran"))
                                                (fortran (assoc-ref %build-inputs "gfortran-toolchain"))
                                                (out (assoc-ref %outputs "out")))
                                            (substitute* "makefile"
                                                         (("-I\\$\\(NCINCLUDE\\)") (string-append "-I" netcdf-fortran "/include "
                                                                                                  "-I" fortran "/include"))
                                                         (("-L\\$\\(NCLIB\\)") (string-append "-L" netcdf-fortran "/lib "
                                                                                              "-L" fortran "/lib"))
                                                         (("NCLIBS=.*$") "NCLIBS=-lnetcdff\n")))))

                      (add-after 'unpack 'patch-model-location
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (let ((out (assoc-ref %outputs "out")))
                                            (substitute* "DATA/Model_tpxo9"
                                                         (("DATA") (string-append out "/bin/DATA"))))))

                      (replace 'build
                               (lambda* (#:key make-flags #:allow-other-keys)
                                        (apply invoke "make" "predict_tide" make-flags)
                                        (apply invoke "make" "extract_HC" make-flags)))
                      (replace 'install
                               (lambda* (#:key inputs outputs #:allow-other-keys)
                                        (let* ((out (assoc-ref %outputs "out"))
                                               (bin (string-append out "/bin"))
                                               (share (string-append out "/share")))
                                          (for-each
                                           (lambda (f) (install-file f bin))
                                           '("extract_HC" "predict_tide"))
                                          ;; (install-file "extract_HC" bin)
                                          ;; (install-file "predict_tide" bin)
                                          (for-each
                                           (lambda (f) (install-file f (string-append share "/setup")))
                                           '("lat_lon" "lat_lon_time" "setup.inp" "time"))
                                          (for-each
                                           (lambda (f) (install-file f (string-append out "/bin/DATA")))
                                              '("DATA/Model_tpxo9" "DATA/h_tpxo9.v1.nc" "DATA/u_tpxo9.v1.nc" "DATA/grid_tpxo9.nc"))
                                          (install-file "README" (string-append share "/doc"))))))))
   (native-inputs
    (list gfortran-toolchain))
   (inputs
    (list netcdf-fortran))
   (synopsis "OSU Tidal Prediction Software")
   (description "OSU Tidal Prediction Software")
   (home-page "https://www.tpxo.net/otps")
   (license license:gpl3+)))

(define-public mbsystem
  (package
   (name "mbsystem")
   (version "5.8.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/dwcaress/MB-System/")
                  (commit version)))
            (file-name (git-file-name name version))
	        (sha256 (base32 "12zgpj2n9vknjqdkryr94d828s26cyxs75li1pdvmnnhdmhgmvgb"))
            (modules '((guix build utils)))
            (snippet
             '(begin
                (chmod "src/mbeditviz/CMakeLists.txt" #o664)
                (let ((p (open-file "src/mbeditviz/CMakeLists.txt" "a")))
                  (display "install(TARGETS mbeditvizlib DESTINATION ${CMAKE_INSTALL_LIBDIR})\n" p)
                  (close-output-port p))
                (chmod "src/qt-guilib/CMakeLists.txt" #o664)
                (let ((p (open-file "src/qt-guilib/CMakeLists.txt" "a")))
                  (display "install(TARGETS MBGui DESTINATION ${CMAKE_INSTALL_LIBDIR})\n" p)
                  (close-output-port p))

                (substitute* "src/qt-mbgrdviz/CMakeLists.txt"
                             (("COMPONENTS Gui Widgets Quick") "COMPONENTS Gui Widgets Quick QuickControls2 DataVisualization")
                             (("mbeditvizlib") "mbeditvizlib Qt5::QuickControls2 Qt5::DataVisualization"))
            ))))
   (build-system cmake-build-system)
   (arguments
    (list
     #:configure-flags
     '(let ((out (assoc-ref %outputs "out"))
            (otpsnc (assoc-ref %build-inputs "otpsnc")))
        (list (string-append "-DCMAKE_INSTALL_MANPAGES=" out "/share/man")
              (string-append "-DotpsDir=" otpsnc "/bin")))
     #:phases
     #~(modify-phases %standard-phases
                      (add-after 'unpack 'patch-doc-installdirs
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (let ((out (assoc-ref outputs "out")))
                                            (substitute* '("src/man/man1/CMakeLists.txt"
                                                           "src/man/man3/CMakeLists.txt")
                                                         (("MANPAGES") "MANDIR"))
                                            (substitute* "src/html/CMakeLists.txt"
                                                         (("INSTALL_DOC") "INSTALL_DOCDIR")))))
                      (add-after 'unpack 'patch-macro-commands
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (let ((coreutils (assoc-ref inputs "coreutils"))
                                                (bash (assoc-ref inputs "bash")))
                                            (substitute* (append (find-files "src/macros" "mbm_") '("src/otps/mbotps.c"))
                                                         (("/bin/rm") (string-append coreutils "/bin/rm"))
                                                         (("/bin/ls") (string-append coreutils "/bin/ls"))
                                                         (("/bin/sh") (string-append bash "/bin/sh"))))))
                      (add-after 'unpack 'patch-fonts
                                 (lambda* (#:key inputs outputs #:allow-other-keys)
                                          (substitute* '("src/mbvelocitytool/mbvelocity_callbacks.c"
                                                         "src/mbnavedit/mbnavedit_callbacks.c"
                                                         "src/mbnavadjust/mbnavadjust_callbacks.c"
                                                         "src/mbedit/mbedit_callbacks.c")
                                                       (("-bold-r-normal-\\*-13-\\*-75-75-c-70-iso8859-1") "-medium-r-semicondensed-*-13-*-75-75-c-60-iso8859-1")))))))
   (native-inputs
    (list python
          pkg-config))
   (inputs
    (list perl
          gdal
          gmt
          netcdf
          proj
          motif
          libtirpc
          fftw
          glu
          opencv
          otpsnc))
   (propagated-inputs
    (list otpsnc
          gmt
          netcdf))
   (synopsis "MB-System is an open source software package for the processing
and display of swath sonar data.")
   (description "MB-System is a software package consisting of programs which
manipulate, process, list, or display swath sonar bathymetry, amplitude, and sidescan
data. This software is distributed freely (and for free) in the form of source code
for Unix platforms. The heart of the system is an input/output library called MBIO
which allows programs to work transparently with any of a number of supported swath
sonar data formats. This approach has allowed the creation of \"generic\" utilities
which can be applied in a uniform manner to sonar data from a variety of sources.
Most of the programs are command-line tools, but the package does include graphical
tools for editing swath bathymetry, editing navigation, modeling bathymetry
calculation, and adjusting survey navigation.")
   (home-page "https://github.com/dwcaress/MB-System")
   (license license:gpl3+)))

(define-public mbsystem-debug-kmall
  (package
   (inherit mbsystem)
   (name "mbsystem-debug-kmall")
   (version "5.8.1")
   (arguments
    (substitute-keyword-arguments (package-arguments mbsystem)
      ((#:phases phases)
       #~(modify-phases #$phases
          (add-after 'unpack 'enable-kmall-debug
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (substitute* '("src/mbio/mbr_kemkmall.c")
                (("// #define MBR_KEMKMALL_DEBUG 1") "#define MBR_KEMKMALL_DEBUG 1 "))))))))))
                                                                                                                                                           

(define-public mbsystem-qt
  (package
   (inherit mbsystem)
   (name "mbsystem-qt")
   (arguments
    (substitute-keyword-arguments (package-arguments mbsystem)
                                  ((#:configure-flags flags ''())
                                   #~(cons "-DbuildQt=ON" #$flags))
                                  ((#:build-type _ #f)
                                   "Debug"
                                   )))
   (inputs (modify-inputs (package-inputs mbsystem)
                          (append qtbase-5
                                  qtdeclarative-5
                                  qtquickcontrols-5
                                  qtquickcontrols2-5
                                  qtdatavis3d
                                  vtk-qt
                                  glew
                                  hdf5
                                  libtheora
                                  jsoncpp
                                  libxml2
                                  libharu
                                  gl2ps
                                  eigen
                                  openmpi-c++
                                  double-conversion
                                  lz4
                                  ijg-libjpeg)))))

(define vtk-qt
  (package
   (inherit vtk)
   (arguments
    (substitute-keyword-arguments (package-arguments vtk)
                                  ((#:configure-flags flags ''())
                                   #~(cons* "-DVTK_QT_VERSION:STRING=5"
                                            "-DVTK_GROUP_ENABLE_Qt:BOOL=YES"
                                            #$flags))
                                  ((#:parallel-build? _ #t) #f)))
   (inputs (modify-inputs (package-inputs vtk)
                          (append qtbase-5
                                  qtdeclarative-5)))))

;; (define-public qtdatavisualation-5
;;   (package
;;     (inherit qtsvg-5)
;;     (name "qtquickcontrols")
;;     (version "5.15.10")
;;     (source (origin
;;               (method url-fetch)
;;               (uri (qt-url name version))
;;               (sha256
;;                (base32
;;                 "1szgm7d8d2lllq19iyf4ggif933bprgsgmp4wzyg0mwq21rnwsm0"))))
;;     (arguments
;;      (substitute-keyword-arguments (package-arguments qtsvg-5)
;;        ((#:tests? _ #f) #f)))           ; TODO: Enable the tests
;;     (inputs (list qtbase-5 qtdeclarative-5))
;;     (synopsis "Qt Quick Controls and other Quick modules")
;;     (description "The QtScript module provides classes for making Qt
;; applications scriptable.  This module provides a set of extra components that
;; can be used to build complete interfaces in Qt Quick.")))
   
(define-public mbsystem-qt
  (package
   (inherit mbsystem)
   (name "mbsystem-qt")
   (arguments
    (substitute-keyword-arguments (package-arguments mbsystem)
                                  ((#:configure-flags flags ''())
                                   #~(cons "-DbuildQt=ON" #$flags))
                                  ((#:build-type _ #f)
                                   "Debug"
                                   )))
   (inputs (modify-inputs (package-inputs mbsystem)
                          (append qtbase-5
                                  qtdeclarative-5
                                  qtquickcontrols-5
                                  qtquickcontrols2-5
                                  qtdatavis3d
                                  vtk-qt
                                  glew
                                  hdf5
                                  libtheora
                                  jsoncpp
                                  libxml2
                                  libharu
                                  gl2ps
                                  eigen
                                  openmpi-c++
                                  double-conversion
                                  lz4
                                  ijg-libjpeg)))))
