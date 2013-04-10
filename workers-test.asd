#|
  This file is a part of workers project.
|#

(in-package :cl-user)
(defpackage workers-test-asd
  (:use :cl :asdf))
(in-package :workers-test-asd)

(defsystem workers-test
  :author ""
  :license ""
  :depends-on (:workers
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "workers"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
