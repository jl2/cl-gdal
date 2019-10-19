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

(defun getting-started-2 (&key
                            (file-name 
                             (autowrap:asdf-path '(:cl-gdal.examples "boulder.tif"))))
  (gdal:gdal-all-register)
  (let* ((img (gdal:gdal-open file-name gdal:+ga-read-only+))
         (projection (autowrap:alloc-ptr :double 6))
         (driver (gdal:gdal-get-dataset-driver img))
         (driver-short-name (gdal:gdal-get-driver-short-name driver))
         (driver-long-name (gdal:gdal-get-driver-long-name driver))
         (raster-x-size (gdal:gdal-get-raster-x-size img))
         (raster-y-size (gdal:gdal-get-raster-y-size img))
         (raster-count (gdal:gdal-get-raster-count img)))

    (format t "Driver short name: ~a~%" driver-short-name)
    (format t "Driver long name: ~a~%" driver-long-name)
    (format t "Raster x size: ~a~%" raster-x-size)
    (format t "Raster y size: ~a~%" raster-y-size)
    (format t "Raster count: ~a~%" raster-count)
    
    (loop for i below 6 do (setf (cffi:mem-ref projection :double i) 0.0))
    (format t "(gdal:gdal-get-geo-transform img projection) ~a~%" (gdal:gdal-get-geo-transform img projection))
    (loop
       for i below 6 do
         (format t "projection[~a] = ~a~%" i (cffi:mem-aref projection :double i)))
    (autowrap:free projection)))
