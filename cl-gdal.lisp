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

(in-package :cl-gdal)

(loop for sym being the external-symbols of :gdal.ll
              for ssym = (symbol-name sym) then (symbol-name sym)
              when (not (or
                         ;; (cl-ppcre:scan "-IMPL" ssym)
                         ;; (cl-ppcre:scan ".IMPL\*" ssym)
                         (cl-ppcre:scan "^\\+__" ssym)
                         (cl-ppcre:scan "^__" ssym)
                         (cl-ppcre:scan "&" ssym)
                         ;; (cl-ppcre:scan "(_|-)H+" ssym)
                         (cl-ppcre:scan "PTHREAD" ssym)))
   collect (export sym))

(defparameter *log-level* 1)

(declaim (inline nullp home-dir image-codec-by-name))
(defun nullp ()
  (cffi:null-pointer))
