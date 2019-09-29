;;;; gdal.lisp 
;;
;; Copyright (c) 2019 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>


;; Permission to use, copy, modify, and/or distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.

;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

(in-package :gdal.ll)

(cffi:define-foreign-library gdal-lib
    (:darwin (:or "libgdal.dylib" "libgdal"))
    (:unix (:or "libgdal.so" "libgdal" "gdal"))
    (t (:default "libgdal")))
(cffi:use-foreign-library gdal-lib)

(autowrap:c-include #+darwin"/opt/local/include/gdal.h"
                    #+linux"/home/jeremiah/oss_src/gdal/gdal/src/gdal.h"
                    :sysincludes (list #+linux"/usr/include/x86_64-linux-gnu/"
                                       #+linux"/usr/include/x86_64-linux-gnu/c++/7/"
                                       #+darwin"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/")
                    :language "c"
                    :spec-path '(gdal specs)

                    ;; :symbol-regex (("^BL_(.*)" () "\\1")
                    ;;                ("^BL(.*)" () "\\1")
                    ;;                ("^bl(.*)" () "\\1"))
                    
                    :exclude-definitions ("^va_list$"
                                          "Random"
                                          "Signal"
                                          "abort"
                                          "abs")
                    :symbol-exceptions (("random" . "gdal-random")
                                        ("remove"  "gdal-remove")
                                        ("signal" . "gdal-signal")
                                        ("abort" . "gdal-abort")
                                        ("abs" . "gdal-abs")))
