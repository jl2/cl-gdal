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

(autowrap:c-include
 #+darwin"/opt/local/include/gdal.h"
 #+linux"/usr/include/gdal/gdal.h"
 :sysincludes (list #+linux"/usr/include/x86_64-linux-gnu/"
                    #+linux"/usr/include/x86_64-linux-gnu/c++/7/"
                    #+darwin"/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/")
 :spec-path '(cl-gdal specs)

 
 :exclude-definitions ("^va_list$" "Random" "Signal"
                                   "acos" "asin" "atan" "cos" "sin" "tan"
                                   "log" "exp" "acosh" "cosh" "asinh" "sinh"
                                   "tanh" "atanh"  "sqrt" "floor" "round"
                                   "time" "close" "open" "read" "write"
                                   "sleep" "truncate" "ceil"
                                   "abs" "abort" "random" "remove" "signal"))
 ;; :language "c"
 ;; :symbol-regex (("^GDAL_(.*)$" () "\\1")
 ;;                ("^Gdal(.*)$" () "\\1")
 ;;                ("^gdal(.*)$" () "\\1")
 ;;                ;; ("^(OGR.*)$" () "\\1")
 ;;                ;; ("^(Ogr.*)$" () "\\1")
 ;;                ;; ("^(ogr.*)$" () "\\1")
 ;;                )

 ;; #.(concatenate 'list
 ;; (loop for sym being each external-symbol of :cl
 ;;    for sym-str = (string-downcase (format nil "~a" sym))
 ;;    then (string-downcase (format nil "~a" sym))
 ;;    when (cl-ppcre:scan "^\\w+$" sym-str)
 ;;    collect (format nil "^~a$" sym-str))
 ;; )


 ;; :symbol-exceptions (("random" . "gdal-random")
 ;;                     ("remove" . "gdal-remove")
 ;;                     ("signal" . "gdal-signal"))

