package com.example.chat_server.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

@Entity
public class Message {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    private Long id;

    private String text;

    // メッセージの送信者名
    private String senderName;

    // メッセージの送信日時
    private LocalDateTime createdAt;

    public Message() {
    }

    // メッセージ登録時に各項目を設定する
    public Message(String text, String senderName) {
        this.text = text;
        this.senderName = senderName;
        this.createdAt = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public String getText() {
        return text;
    }

    // 送信者名を取得する
    public String getSenderName() {
        return senderName;
    }

    // 送信者名を設定する
    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    // 送信日時を取得する
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    // 送信日時を設定する
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public void setText(String text) {
        this.text = text;
    }
}