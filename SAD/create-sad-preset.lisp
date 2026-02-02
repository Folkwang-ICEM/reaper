;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FILE
;;; create-sad-preset.lisp
;;;
;;; NAME
;;; create SAD preset
;;;
;;; DESCRIPTION
;;; This program writes SAD (spatial audio designer) preset files e.g. from
;;; spherical coordinates (e.g. from IEM AllRAD ambisonics). 
;;; 
;;;
;;; AUTHOR
;;; Ruben Philipp Gottschalk <me@rubenphilipp.com>
;;;
;;; CREATED
;;; 2026-02-02
;;;
;;; $$ Last modified:  22:03:04 Mon Feb  2 2026 CET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Globals / Config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defparameter *sad-default-presets-dir*
  ;;; trailing slash!
  "~/Library/Application Support/Spatial Audio Designer Presets/")

(defparameter *sad-default-speaker-presets-dir*
  ;;; trailing slash!
  (concatenate 'string
               *sad-default-presets-dir*
               "Speaker Presets/"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Helpers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun deg-to-rad (deg)
  "Convert degrees to radians."
  (* deg (/ pi 180)))

(defun round-to-digits (v &optional (digits 0))
  "Round a float to n digits."
  (declare (type float v)
           (type (integer 0) digits))
  (let ((10^-digits (expt 10 (- digits))))
    (* (fround v 10^-digits)
       10^-digits)))

(defun iem-to-sad (a e d &key
                           (digits 3))
  "Convert spherical coordinates from IEM AllRAD to SAD cartesian coords."
  (let* ((azim (* -1 a)) ;; azim is flipped in IEM
         (elev e)
         (dist d)
         (x (* dist
               (cos (deg-to-rad elev))
               (sin (deg-to-rad azim))))
         (y (* dist
               (cos (deg-to-rad elev))
               (cos (deg-to-rad azim))))
         (z (* dist
               (sin (deg-to-rad elev)))))
    (values (round-to-digits x digits)
            (round-to-digits y digits)
            (round-to-digits z digits))))

(defun trailing-slash (path)
  "Make sure the given path has a trailing slash."
  (if (> (length path) 0)
    (if (char= #\/ (elt path (1- (length path))))
        path
        (format nil "~a/" path))
    ""))

(defmacro sad-line-comment (destination)
  "Outputs a SAD style (empty) comment line to the stream at destination."
  `(format ,destination "** ~%"))

(defmacro sad-top-header (destination)
  "Write the top header to the stream at destination."
  `(format ,destination
           "** ~12a~19a~15a~12a~%~
            ** ~12a~19a~%"
           "CHAN.NAME"
           "POSITION (X/Y/Z)"
           "CHAN.EXP.NO."
           "COMMENTS"
           " "
           "SCALE (1,1,1,1)"))

(defun sad-validate-channel (channel)
  "Validate and return a proper channel name as a string."
  (let ((result (if (numberp channel)
                     (format nil "Out_~3,'0d" channel)
                     channel)))
    result))

(defun sad-validate-ch-exp-no (exp-num)
  "Validate and return a proper CHAN.EXP.NO. as a string."
  (let ((result (if (numberp exp-num)
                     (format nil "CH~3,'0d" exp-num)
                     exp-num)))
    result))

(defun sad-parse-xyz-list (xyz-list)
  "Parse a XYZ-list (length 3) to a SAD-style coord-list."
  (unless (eq (length xyz-list) 3)
    (error "xyz-list must be a list of length 3."))
  (format nil "(~a,~a,~a)"
          (first xyz-list)
          (second xyz-list)
          (third xyz-list)))

(defmacro sad-output-channel-header (exp-num channel pos-xyz
                                     comment destination)
  "Writes a SAD header for a given channel to the stream at destination.
   - exp-num. CHAN.EXP.NO.
   - channel. CHAN.NAME
   - pos-xyz. XYZ-coordinates as a list of length 3.
   - comment. a COMMENT for the SAD preset (ignored when NIL).
   - destination. the destination stream"
  `(let ((chan-name (sad-validate-channel ,channel))
         (position (sad-parse-xyz-list ,pos-xyz))
         (ch-exp-no (sad-validate-ch-exp-no ,exp-num)))
     (unless ,comment
       (setf ,comment ""))
     (format ,destination "** ~12a~19a~15a~a~%"
             chan-name position ch-exp-no ,comment)))

(defmacro sad-output-assignment (channel pos-xyz destination)
  "Writes the SAD output assignment lines to a stream at destination."
  `(let ((chan-name (sad-validate-channel ,channel))
         (position (sad-parse-xyz-list ,pos-xyz)))
     (format ,destination "~a << ~a~%"
             chan-name position)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This function writes a SAD .presets file from a list of speaker coordinates.
;;; These coordinates follow the idiom of the IEM AllRADecoder, i.e. the
;;; quadrants II and III (the "westward" ones) correspond to a positive value
;;; of the azimuth while for quadrants I and IV, the azimuth is negative.
;;;
;;; The list of speakers must be a list of lists of the length of the numbers
;;; of speakers in your speaker array.  The list for each speaker must have the
;;; following items:
;;; 1) The channel id of the speaker. This can be either an integer or a symbol.
;;;    For example, a value of 3 will be converted to "Out_003" for SAD, while
;;;    the symbol lfe wille be converted to the CHAN.NAME "LFE".
;;; 2) The azimuth value as a number.
;;; 3) The elevation value as a number.
;;; 4) The distance as a number. It is generally recommended to use 100 here for
;;;    speaker setups which are constructed following the idea of a full sphere.
;;; 5) An optional comment as a string.
;;;
;;; The Result will be written to a SAD preset file in the given location (by
;;; default the standard location for your SAD presets, cf. globals).
;;;
;;; EXAMPLE:
#|
(spherical-coords->sad-preset
 '((6 -90 26.21100044250488 100 "floor")
   (7 180 24.8799991607666 100)
   (8 90 26.21100044250488 100)
   (9 45 36.54700088500977 100)
   (10 -45 36.54700088500977 100)
   (11 -135 36.54700088500977 100)
   (12 135 36.54700088500977 100)
   (13 22.55699920654297 0 100)
   (14 -22.55699920654297 0 100)
   (15 -67.44300079345703 0 100)
   (16 -112.556999206543 0 100)
   (17 -157.4429931640625 0 100)
   (18 157.4429931640625 0 100)
   (19 112.556999206543 0 100)
   (20 67.44300079345703 0 100)
   (lfe 0 -90 100))
"Studio 1 15.1")
|#

(defun spherical-coords->sad-preset (speakers
                                     preset-name
                                     &key
                                       (outdir
                                        *sad-default-speaker-presets-dir*)
                                       (file-suffix ".preset"))
  (let ((outfile (format nil
                         "~aSAD~3,'0d ~a~a"
                         outdir
                         (length speakers)
                         preset-name
                         file-suffix)))
    (with-open-file (format-dest outfile :direction :output
                                         :if-exists :supersede
                                         :if-does-not-exist :create)
      (unless (every #'(lambda (x)
                         (and (listp x)
                              (> (length x) 3)
                              (numberp (nth 1 x))
                              (numberp (nth 2 x))
                              (numberp (nth 3 x))))
                     speakers)
        (error "Speaker list format invalid."))
      ;; header
      (sad-top-header format-dest)
      (sad-line-comment format-dest)
    
      ;; write speaker doc headers
      (loop for speaker in speakers
            for spk-number = (car speaker)
            for comment = (when (> (length speaker) 4)
                            (when (stringp (nth 4 speaker))
                              (nth 4 speaker)))
            for ch from 1
            for ae = (cdr speaker)
            for azim = (first ae)
            for elev = (second ae)
            for dist = (third ae)
            do
               (multiple-value-bind (x y z)
                   (iem-to-sad azim elev dist)
                 (when (eq spk-number 'lfe)
                   (setf spk-number "LFE"))
                 (sad-output-channel-header ch spk-number
                                            (list (round x)
                                                  (round y)
                                                  (round z))
                                            comment
                                            format-dest)))
      (format format-dest "~%~%~%")
      ;; write channel allocations
      (loop for speaker in speakers
            for spk-number = (car speaker)
            for ch from 1
            for ae = (cdr speaker)
            for azim = (first ae)
            for elev = (second ae)
            for dist = (third ae)
            do
               (multiple-value-bind (x y z)
                   (iem-to-sad azim elev dist)
                 (when (eq spk-number 'lfe)
                   (setf spk-number "!LFE"))
                 (sad-output-assignment spk-number
                                        (list (round x)
                                              (round y)
                                              (round z))
                                        format-dest)))
      ;; Not implemented yet...
      ;; RP  Mon Feb  2 21:41:49 2026
      (format format-dest "~%~%~%~%")
      (format format-dest "VIRTUAL CHAN.~%")
      (format format-dest "~%~%~%~%")
      (format format-dest "CHANNEL COMPENSATION")
      (format format-dest "~%~%~%~%"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; EOF create-sad-preset.lisp
