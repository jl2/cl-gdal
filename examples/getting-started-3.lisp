;;;; getting-started-2.lisp
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

(in-package :cl-gdal.examples)

(defun getting-started-3 (&key
                            (file-name 
                             (autowrap:asdf-path '(:cl-gdal.examples "OSMP_Trails/OSMP_Trails.shp"))))

  (gdal:gdal-all-register)

  (let* ((np (cffi:null-pointer))
         (dataset (gdal:gdal-open-ex file-name gdal:+of-vector+ np np np))
         (layer (gdal:ogr-ds-get-layer dataset 0)))
    (format t "Dataset~%Name: ~a~%Layer Count: ~a~%" (gdal:ogr-ds-get-name dataset) (gdal:ogr-ds-get-layer-count dataset))
    (format t "~%Layer~%Name: ~a~%" (gdal:ogr-l-get-name layer))
    
    (autowrap:free layer)
    (autowrap:free dataset)))
