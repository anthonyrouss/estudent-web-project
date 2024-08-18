package com.estudent.model;

public class Message {
    private final String text;
    private final String type;

    public Message(String text, String type) {
        this.text = text;
        this.type = type;
    }

    public String getText() {
        return this.text;
    }

    public String getType() {
        return this.type;
    }
}