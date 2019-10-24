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

(defun get-field-value (feature fdefn idx)
  (let* ((field-defn (gdal:ogr-fd-get-field-defn fdefn idx))
         (field-type (gdal:ogr-fld-get-type field-defn))
         (field-name (gdal:ogr-fld-get-name-ref field-defn))
         (value (cond ((= field-type gdal:+oft-integer+)
                       (gdal:ogr-f-get-field-as-integer feature idx))
                      ((= field-type gdal:+oft-integer64+)
                       (gdal:ogr-f-get-field-as-integer64 feature idx))
                      ((= field-type gdal:+oft-real+)
                       (gdal:ogr-f-get-field-as-double feature idx))
                      (t
                       (gdal:ogr-f-get-field-as-string feature idx)))))
    (values value field-name field-type)))

(defun get-layer-envelope (layer)
  (gdal:ogr-l-reset-reading layer)
  (let (;; (layer-envelope (autowrap:alloc 'gdal:ogr-envelope))
        (geo-envelope (autowrap:alloc 'gdal:ogr-envelope))
        (min-x most-positive-double-float)
        (max-x most-negative-double-float)
        (min-y most-positive-double-float)
        (max-y most-negative-double-float))
    (loop
       for feature = (gdal:ogr-l-get-next-feature layer)
       until (cffi:null-pointer-p (gdalll::ogr-feature-h-ptr feature))
       for geometry = (gdal:ogr-f-get-geometry-ref feature)
       do
         (gdal:ogr-g-get-envelope geometry geo-envelope)
         (setf min-x (min min-x (gdal:ogr-envelope.min-x geo-envelope)))
         (setf max-x (max max-x (gdal:ogr-envelope.max-x geo-envelope)))
         (setf min-y (min min-y (gdal:ogr-envelope.min-y geo-envelope)))
         (setf max-y (max max-y (gdal:ogr-envelope.max-y geo-envelope))))
    (autowrap:free geo-envelope)
    (values min-x max-x min-y max-y)))

(defun get-dataset-envelope (dataset)
  (let (;; (layer-envelope (autowrap:alloc 'gdal:ogr-envelope))
        (geo-envelope (autowrap:alloc 'gdal:ogr-envelope))
        (min-x most-positive-double-float)
        (max-x most-negative-double-float)
        (min-y most-positive-double-float)
        (max-y most-negative-double-float))
    (loop
       for i below (gdal:ogr-ds-get-layer-count dataset)
       for layer = (gdal:ogr-ds-get-layer dataset i)
       initially   (gdal:ogr-l-reset-reading layer)

       for layer-name = (gdal:ogr-l-get-name layer)
       do
         (loop
            for feature = (gdal:ogr-l-get-next-feature layer)
            until (cffi:null-pointer-p (gdalll::ogr-feature-h-ptr feature))
            for geometry = (gdal:ogr-f-get-geometry-ref feature)
            do
              (gdal:ogr-g-get-envelope geometry geo-envelope)
              (setf min-x (min min-x (gdal:ogr-envelope.min-x geo-envelope)))
              (setf max-x (max max-x (gdal:ogr-envelope.max-x geo-envelope)))
              (setf min-y (min min-y (gdal:ogr-envelope.min-y geo-envelope)))
              (setf max-y (max max-y (gdal:ogr-envelope.max-y geo-envelope))))
         (autowrap:free layer)
       finally (autowrap:free dataset))
    (autowrap:free geo-envelope)))
