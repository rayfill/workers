#|
  This file is a part of workers project.
|#

(in-package :cl-user)
(defpackage workers-asd
  (:use :cl :asdf))
(in-package :workers-asd)

(defsystem workers
  :version "0.1"
  :author ""
  :license ""
  :depends-on (:bordeaux-threads)
  :components ((:module "src"
                :components
                ((:file "workers"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (load-op workers-test))))
