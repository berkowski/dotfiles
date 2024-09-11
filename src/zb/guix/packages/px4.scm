(define-module (zb guix packages px4)
    #:use-module (guix packages)
    #:use-module (guix download)
    #:use-module (guix git-download)
    #:use-module (guix build-system cmake)
    #:use-module (guix build-system python)
    #:use-module (guix build-system pyproject)
    #:use-module (guix utils)
    #:use-module (guix gexp)
    #:use-module ((guix licenses) #:prefix license:)
    #:use-module (gnu packages version-control)
    #:use-module (gnu packages python)
    #:use-module (gnu packages python-build)
    #:use-module (gnu packages python-check)
    #:use-module (gnu packages check)
    #:use-module (gnu packages time)
    #:use-module (gnu packages python-xyz)
    #:use-module (gnu packages xml))

(define-public px4
    (package 
       (name "px4")
       (version "1.14.3")
       (source 
          (origin 
             (method git-fetch)
             (uri (git-reference 
                     (url "https://github.com/PX4/PX4-Autopilot.git")
                     (commit (string-append "v" version))
                     (recursive? #t)))
             (sha256
                (base32
                   "1qzm9p8skakz5sah327rrxlfslg70d4nwkx9s1ww66i9phawfb3r"))))
       (build-system cmake-build-system)
       (native-inputs (list python
                            python-kconfiglib
                            python-empy
                            python-jinja2
                            python-pyyaml
                            python-jsonschema
                            python-pyros-genmsg
                            python-catkin-pkg
                            python-future
                            python-lxml))
                           
                            ;;python-toml
                            ;;python-six
                            ;;python-sympy
                            ;;python-requests
                            ;;python-pyulog
                            ;;python-pyserial
                            ;;python-pymavlink
                            ;;python-wheel
                            ;;python-pybments
                            ;;python-psutil
                            ;;python-pkgconfig
                            ;;python-pandas
                            ;;python-packaging
                            ;;python-nunavut
                            ;;python-numpy
                            ;;python-matplotlib
                            ;;python-coverage
                            ;;python-cerberus
                            ;;python-argparse
                            ;;python-argcomplete))
                          
        
       (synopsis "A reliable open source autopilot")
       (description "A reliable open source autopilot")
       (home-page "https://px4.io")
       (license license:expat)))

;; for px4
(define-public python-kconfiglib
  (package
    (name "python-kconfiglib")
    (version "14.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "kconfiglib" version))
       (sha256
        (base32 "0g690bk789hsry34y4ahvly5c8w8imca90ss4njfqf7m2qicrlmy"))))
    (build-system pyproject-build-system)
    (propagated-inputs `((,python "tk")))
    (home-page "https://github.com/ulfalizer/Kconfiglib")
    (synopsis "A flexible Python Kconfig implementation")
    (description
     "This package provides a flexible Python Kconfig implementation.")
    (license license:isc)))

;; for px4
(define-public python-pyros-genmsg
  (package
    (name "python-pyros-genmsg")
    (version "0.5.8")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference 
                (url "https://github.com/ros/genmsg.git")
                (commit version)))
        (sha256
         (base32 "1pvdxd66mlw690gdg2y2bixz1c6fqsx3513x3w2hm1ylbifzbx6a"))))

    (build-system pyproject-build-system)
    (native-inputs (list python-nose))
    (propagated-inputs (list python-catkin-pkg))
    (home-page "https://github.com/ros/genmsg")
    (synopsis
     " Standalone Python library for generating ROS message and service data structures for various languages.")
    (description
     "Standalone Python library for generating ROS message and service data structures
for various languages.")
    (license license:bsd-3)))

;; for python-catkin-pkg
(define-public python-flake8-import-order
  (package
    (name "python-flake8-import-order")
    (version "0.18.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flake8-import-order" version))
       (sha256
        (base32 "03lh1n98lx8ncrr6n8cv5qj3birvqyqbpfhisw4hqgnsjbw42fg2"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-pylama
                         python-pytest))
    (propagated-inputs (list python-pycodestyle python-setuptools))
    (home-page "https://github.com/PyCQA/flake8-import-order")
    (synopsis
     "Flake8 and pylama plugin that checks the ordering of import statements.")
    (description
     "Flake8 and pylama plugin that checks the ordering of import statements.")
    (license #f)))

;; for python-catkin-pkg
(define-public python-flake8-docstrings
  (package
    (name "python-flake8-docstrings")
    (version "1.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flake8_docstrings" version))
       (sha256
        (base32 "1bs1m5kqw25sn68f06571q5s3aaxd06mv7k952bqdrhnvi4cg32c"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-flake8 python-pydocstyle))
    (home-page "https://github.com/pycqa/flake8-docstrings")
    (synopsis "Extension for flake8 which uses pydocstyle to check docstrings")
    (description
     "Extension for flake8 which uses pydocstyle to check docstrings.")
    (license license:expat)))

;; for python-catkin-pkg
(define-public python-flake8-deprecated
  (package
    (name "python-flake8-deprecated")
    (version "2.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/gforcada/flake8-deprecated.git")
              (commit version)))
       (sha256
        (base32 "1iwg821g6x5h0lcasb6xlvwa4f6icysirbwy5vn0r25pgj058b7m"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-hatchling
                         python-pytest))
    (propagated-inputs (list python-flake8))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
          (replace 'check (lambda* _ (invoke "pytest" "run_tests.py"))))))
    (home-page "https://github.com/gforcada/flake8-deprecated")
    (synopsis "Warns about deprecated method calls")
    (description "Warns about deprecated method calls.")
    (license license:gpl2)))

;; for python-catkin-pkg
(define-public python-flake8-comprehensions
  (package
    (name "python-flake8-comprehensions")
    (version "3.15.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/adamchainz/flake8-comprehensions.git")
             (commit version)))
       (sha256
        (base32 "15a3spn5gw69ha6lb36rnmilr1837hlfg3n4zp15vnl66cxdw0x1"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-pytest
                         python-pytest-flake8-path
                         python-pytest-randomly))
    (propagated-inputs (list python-flake8))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
          (replace 'check (lambda* _ (invoke "pytest" "tests/test_flake8_comprehensions.py"))))))
    (home-page "https://github.com/adamchainz/flake8-comprehensions")
    (synopsis
     "A flake8 plugin to help you write better list/set/dict comprehensions.")
    (description
     "This package provides a flake8 plugin to help you write better list/set/dict
comprehensions.")
    (license #f)))

;; for python-catkin-pkg
(define-public python-flake8-class-newline
  (package
    (name "python-flake8-class-newline")
    (version "1.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flake8-class-newline" version))
       (sha256
        (base32 "1w8z88asz90jm1msz06vi7dj0da8sfw5ajyvabfv7f4fr0iljk2i"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-flake8))
    (home-page "https://github.com/AlexanderVanEck/flake8-class-newline")
    (synopsis "Flake8 lint for newline after class definitions.")
    (description "Flake8 lint for newline after class definitions.")
    (license license:expat)))

;; for python-catkin-pkg
(define-public python-flake8-builtins
  (package
    (name "python-flake8-builtins")
    (version "2.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "flake8_builtins" version))
       (sha256
        (base32 "19psav7pnqy3m5g4z1zah4ksbnk9bzx1jbbibs631xg44gc3vamx"))))
    (build-system pyproject-build-system)
    (home-page "https://github.com/gforcada/flake8-builtins")
    (native-inputs (list python-hatchling
                         python-flake8
                         python-pytest))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check (lambda* _ (invoke "pytest" "run_tests.py"))))))
                  
    (synopsis
     "Check for python builtins being used as variables or parameters")
    (description
     "Check for python builtins being used as variables or parameters.")
    (license #f)))

;; for px4
(define-public python-catkin-pkg
  (package
    (name "python-catkin-pkg")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "catkin_pkg" version))
       (sha256
        (base32 "1dg1q3m5y8kmz3w9m3d6lylzpfsymyyb8hcjfdjg90kjj599yvj7"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-docutils python-pyparsing python-dateutil
                             python-setuptools))
    (native-inputs (list python-flake8
                         python-flake8-blind-except
                         python-flake8-builtins
                         python-flake8-class-newline
                         python-flake8-comprehensions
                         python-flake8-deprecated
                         python-flake8-docstrings
                         python-flake8-import-order
                         python-flake8-quotes
                         python-pytest
                         python-hatchling))
    (arguments
     `(#:tests? #f))
    (home-page "http://wiki.ros.org/catkin_pkg")
    (synopsis "catkin package library")
    (description "catkin package library.")
    (license license:bsd-3)))

(define-public python-pytest-flake8-path
  (package
    (name "python-pytest-flake8-path")
    (version "1.5.0")
    (source
     (origin
       (method git-fetch)

       (uri (git-reference
             (url "https://github.com/adamchainz/pytest-flake8-path.git")
             (commit version)))
       (sha256
        (base32 "1wwjmyrhh4rhgvm2zqd2hlcfcc1njd27hdxs7j6p269qca411w14"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-pytest-randomly))
    (propagated-inputs (list python-flake8 python-pytest))
    (arguments
     `(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (replace 'check (lambda* _ (invoke "pytest" "tests"))))))
    (home-page "https://github.com/adamchainz/pytest-flake8-path")
    (synopsis "A pytest fixture for testing flake8 plugins.")
    (description
     "This package provides a pytest fixture for testing flake8 plugins.")
    (license license:expat)))
            
