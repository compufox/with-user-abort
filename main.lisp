(in-package :with-user-abort)

(define-condition user-abort (#+sbcl sb-sys:interactive-interrupt
			      #+ccl ccl:interrupt-signal-condition
			      #+clisp system::simple-interrupt-condition
			      #+ecl ext:interactive-interrupt
			      #+allegro excl:interrupt-signal)
  ()
  (:documentation "condition that inherits from implementation specific interrupt condition"))

(defun user-abort (&optional condition)
  (declare (ignore condition))
  (signal 'user-abort))

#+ccl
(progn
  (defun ccl-break-hook (cond hook)
    "SIGINT handler on CCL."
    (declare (ignore hook))
    (signal cond))

  (setf ccl:*break-hook* #'ccl-break-hook))

(defmacro with-user-abort (&body body)
  "execute BODY, signalling user-abort if the interrupt signal is received"
  `(handler-bind ((#+sbcl sb-sys:interactive-interrupt
		   #+ccl ccl:interrupt-signal-condition
		   #+clisp system::simple-interrupt-condition
		   #+ecl ext:interactive-interrupt
		   #+allegro excl:interrupt-signal
		   
		   #'user-abort))
     ,@body))
