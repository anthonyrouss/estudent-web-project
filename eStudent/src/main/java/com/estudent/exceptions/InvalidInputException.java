package com.estudent.exceptions;

public class InvalidInputException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public InvalidInputException() {
        super("Wrong credentials.");
    }

    public InvalidInputException(String message) {
        super(message);
    }
}
