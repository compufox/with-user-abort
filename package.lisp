(in-package :cl-user)
(defpackage with-user-abort
  (:use :cl)
  (:export :user-abort
	   :with-user-abort))
(in-package :with-user-abort)

(define-condition user-abort (#+sbcl sb-sys:interactive-interrupt
			      #+ccl ccl:interrupt-signal-condition
			      #+clisp system::simple-interrupt-condition
			      #+ecl ext:interactive-interrupt
			      #+allergo excl:interrupt-signal)
  ())

(defmacro with-user-abort (&body body)
  "execute BODY, signalling user-abort if the interrupt signal is recieved"
  `(handler-bind ((#+sbcl sb-sys:interactive-interrupt
		   #+ccl ccl:interrupt-signal-condition
		   #+clisp system::simple-interrupt-condition
		   #+ecl ext:interactive-interrupt
		   #+allergo excl:interrupt-signal
		   #'(lambda (c)
		       (declare (ignore c))
		       (signal 'user-abort))))
     ,@body))

