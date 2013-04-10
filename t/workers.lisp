#|
  This file is a part of workers project.
|#

(in-package :cl-user)
(defpackage workers-test
  (:use :cl
        :workers
        :cl-test-more))
(in-package :workers-test)

(plan nil)

(defun seq (base last &optional (step 1))
  (loop for i from base to last by step collect i))

(defun sum (max)
  (/ (* (+ 1 max) max) 2))

(let ((*random-state* (make-random-state)))
  (let ((number-of-max (+ 10000 (random 10000)))
	(number-of-threads (+ 100 (random 50))))
    (let* ((numbers (seq 1 number-of-max))
	   (workers (workers:create-workers number-of-threads
					    (lambda (arg)
					      (reduce #'+ arg))
					    numbers)))
      (start-workers workers)
      (is (reduce #'+ (wait-workers workers))
	  (* (sum number-of-max) number-of-threads)))))

(finalize)
