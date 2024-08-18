package com.estudent.model;

public abstract class StringCodes {
    public static final String ERROR_AM_NOT_INTEGER = "Ο ΑΜ δεν είναι ακέραιος.";
    public static final String ERROR_AM_ALREADY_EXISTS = "Ο ΑΜ υπάρχει ήδη.";
    public static final String ERROR_AM_WRONG_LENGTH = "Ο ΑΜ πρέπει να αποτελείται από 5 ψηφία.";
    public static final String ERROR_PHONE_WRONG_LENGTH = "Το τηλέφωνο δεν είναι σωστό";
    public static final String ERROR_GENDER_NOT_INCLUDED = "Το gender πρέπει να ανήκει στις επιλογές {Male, Female, Other}.";
    public static final String ERROR_SEMESTER_INVALID = "Το εξάμηνο δεν είναι έγκυρο.";
    public static final Message ERROR_LOGIN_ACCESS_DENIED = new Message("Πρέπει να συνδεθείτε για να έχετε πρόσβαση στη σελίδα.", "alert-warning");
    public static final Message ERROR_LOGIN_WRONG_CREDENTIALS = new Message("Τα στοιχεία δεν αντιστοιχούν σε κάποιον χρήστη.", "alert-danger");
    public static final Message SUCCESS_LOGOUT = new Message("Έχετε αποσυνδεθεί επιτυχώς!", "alert-success");
    public static final String ERROR_FORBIDDEN_ACCESS = "Η πρόσβαση σε αυτή τη σελίδα είναι περιορισμένη.";
    public static final Message ERROR_GENERAL_ERROR = new Message("<strong>Ουπς!</strong> Συνέβη ένα σφάλμα. Προσπαθήστε ξανά αργότερα.", "alert-danger");
    
    public static final Message WARNING_TEACHES_ALREADY_EXISTS = new Message("<strong>Άκυρο!</strong> Αυτός ο συνδυασμός υπάρχει ήδη.", "alert-warning");
    public static final Message SUCCESS_TEACHES_INSERT = new Message("<strong>Επιτυχία!</strong> Πραγματοποιήθηκε η εγγραφή του καθηγητή με αυτό το μάθημα.", "alert-success");
    
    public static final Message ERROR_TEACHES_NO_ROW = new Message("<strong>Προσοχή!</strong> Αυτός ο συνδυασμός δεν υπάρχει.", "alert-danger");
    public static final Message SUCCESS_DELETE_TEACHES = new Message("<strong>Επιτυχία!</strong> Η ανάθεση έχει διαγραφεί.", "alert-success");
    
    public static final Message SUCCESS_INSERT_NEW_COURSE = new Message("<strong>Επιτυχία!</strong> Το μάθημα έχει προστεθεί.", "alert-success");
    public static final Message SUCCESS_UPDATE_COURSE = new Message("<strong>Επιτυχία!</strong> Το μάθημα έχει τροποποιηθεί.", "alert-success");
    public static final Message SUCCESS_DELETE_COURSE = new Message("<strong>Επιτυχία!</strong> Το μάθημα έχει διαγραφεί.", "alert-success");
    
    public static final Message SUCCESS_SET_LISTING = new Message("<strong>Επιτυχία!</strong> Η λίστα βαθμολόγησης δημιουργήθηκε.", "alert-success");
    
    public static final Message SUCCESS_INSERTED_GRADE = new Message("<strong>Επιτυχία!</strong> Ο βαθμός έχει καταχωρηθεί.", "alert-success");
    
    public static final Message SUCCESS_UPDATED_GRADE = new Message("<strong>Επιτυχία!</strong> Ο βαθμός έχει τροποποιηθεί.", "alert-success");
    
    public static final Message SUCCESS_DELETED_USER = new Message("<strong>Επιτυχία!</strong> Ο χρήστης έχει διαγραφεί.", "alert-success");
    
}
