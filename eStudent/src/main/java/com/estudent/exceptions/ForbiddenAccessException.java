package com.estudent.exceptions;

public class ForbiddenAccessException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public ForbiddenAccessException() {
        super("Η πρόσβαση σε αυτή τη σελίδα είναι περιορισμένη.");
    }

    public ForbiddenAccessException(String message) {
        super(message);
    }
}
