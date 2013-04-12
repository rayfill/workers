(in-package :cl-user)
(defpackage workers
  (:use :cl)
  (:import-from :sb-thread :make-thread :join-thread :thread
		:make-semaphore :signal-semaphore
		:try-semaphore :wait-on-semaphore :semaphore-count)
  (:export :create-workers :wait-workers :start-workers
	   :kill-workers :workers-count))
(in-package :workers)

(defclass workers ()
  ((semaphore :initarg :semaphore :accessor semaphore)
   (workers-slot :initarg :workers :accessor workers)))

(defun ensure-function (func-designator)
  (if (functionp func-designator)
      func-designator
      (fdefinition func-designator)))

(defun create-workers (num job &rest args)
  (let ((job (ensure-function job))
	(semaphore (make-semaphore))
	(result (make-array num :initial-element nil)))
    (loop for i below num
       do (setf (svref result i)
		(make-thread (lambda (&rest args)
			       (wait-on-semaphore semaphore)
			       (apply job args))
			     :arguments args)))
    (make-instance 'workers :workers result :semaphore semaphore)))

(defun start-workers (workers)
  (signal-semaphore (semaphore workers) (length (workers workers))))
    
(defun wait-workers (workers)
  (let ((workers (workers workers)))
    (loop for i below (length workers)
	 do (setf (svref workers i) (join-thread (svref workers i))))
    (loop for elm across workers
	 collect elm)))

(defun kill-workers (workers)
  (let ((workers (workers workers)))
    (loop for i below (length workers)
	 when (typep (svref workers i) 'thread)
	 do (progn
	      (if (sb-thread:thread-alive-p (svref workers i))
		  (sb-thread:destroy-thread (svref workers i))
		  (sb-thread:join-thread (svref workers i)))
	      (setf (svref workers i) :destroyed))
	 end)))

(defun workers-count (workers)
  (length (workers workers)))
