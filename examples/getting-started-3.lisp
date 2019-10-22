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

(defun getting-started-3 (&key (file-name (autowrap:asdf-path '(:cl-gdal.examples "OSMP_Trails/OSMP_Trails.shp"))))

  (gdal:gdal-all-register)

  (let* ((np (cffi:null-pointer))
         (dataset       (gdal:gdal-open-ex file-name gdal:+of-vector+ np np np))
         (layer-count   (gdal:ogr-ds-get-layer-count dataset)))
    (format t "Dataset~%Name: ~a~%Layer Count: ~a~%" (gdal:ogr-ds-get-name dataset) layer-count)
    (loop
       for i below layer-count
       do
         (let ((layer (gdal:ogr-ds-get-layer dataset i)))
           (format t "~%Layer ~a~%Name: ~a~%" i (gdal:ogr-l-get-name layer))
           (gdal:ogr-l-reset-reading layer)

           ;; TODO: Wrap this iteration in a macro or function
           (loop
              for feature = (gdal:ogr-l-get-next-feature layer)
              until (cffi:null-pointer-p (gdalll::ogr-feature-h-ptr feature))
              for fdefn = (gdal:ogr-l-get-layer-defn layer)
              do
                (format t "feature = ~a~%" feature)
                (format t "fdefn = ~a name: ~a ~%field count: ~a~%"
                        fdefn
                        (gdal:ogr-fd-get-name fdefn)
                        (gdal:ogr-fd-get-field-count fdefn))
                (loop
                   for i below (gdal:ogr-fd-get-field-count fdefn)
                   for field-defn = (gdal:ogr-fd-get-field-defn fdefn i)
                   for field-type = (gdal:ogr-fld-get-type field-defn)
                   do
                   ;; TODO: Make this a helper function
                     (let ((value (cond ((= field-type gdal:+oft-integer+)
                                         (gdal:ogr-f-get-field-as-integer feature i))
                                        ((= field-type gdal:+oft-integer64+)
                                         (gdal:ogr-f-get-field-as-integer64 feature i))
                                        ((= field-type gdal:+oft-real+)
                                         (gdal:ogr-f-get-field-as-double feature i))
                                        (t
                                         (gdal:ogr-f-get-field-as-string feature i)))))
                       (format t "~a ~a (~a) = ~a~%" field-defn (gdal:ogr-fld-get-name-ref field-defn) i value)))
                (autowrap:free feature))
           (autowrap:free layer)))
    (autowrap:free dataset)))
