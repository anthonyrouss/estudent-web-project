package com.estudent.model;

public class User {
    private String username;
    private String firstName;
    private String lastName;
    private String phone;
    private String gender;
    private String email;
    private String role;
    
    private String salt;
    private String password;

    public User(String username, String firstName, String lastName, String phone, String email) {
        this.setUsername(username);
        this.setFirstName(firstName);
        this.setLastName(lastName);
        this.setPhone(phone);
        this.setEmail(email);
    }
    
    public User(String username, String firstName, String lastName, String phone, String email, String role) {
        this.setUsername(username);
        this.setFirstName(firstName);
        this.setLastName(lastName);
        this.setPhone(phone);
        this.setEmail(email);
        this.setRole(role);
    }
    
    public User(String username, String firstName, String lastName, String phone, String gender, String role, String email, String salt, String password) {
        this.setUsername(username);
        this.setFirstName(firstName);
        this.setLastName(lastName);
        this.setPhone(phone);
        this.setEmail(email);
        this.setGender(gender);
        this.setRole(role);
        this.setSalt(salt);
        this.setPassword(password);
    }

    public String getUsername() {
        return this.username;
    }

    private void setUsername(String username) {
        this.username = username;
    }

    public String getFirstName() {
        return this.firstName;
    }

    private void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return this.lastName;
    }

    private void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return this.phone;
    }

    private void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return this.gender;
    }

    private void setGender(String gender) {
        this.gender = gender;
    }

    public String getEmail() {
        return this.email;
    }

    private void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return this.role;
    }

    private void setRole(String role) {
        this.role = role;
    }

	public String getSalt() {
		return salt;
	}

	private void setSalt(String salt) {
		this.salt = salt;
	}

	public String getPassword() {
		return password;
	}

	private void setPassword(String password) {
		this.password = password;
	}
}
