package com.example.chat_server.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

// グループ情報を管理するEntity
@Entity
public class ChatGroup {

    // グループID（自動採番）
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // グループ名
    private String name;

    // 空のコンストラクタ
    public ChatGroup() {
    }

    // グループ名を指定するコンストラクタ
    public ChatGroup(String name) {
        this.name = name;
    }

    // グループIDを取得
    public Long getId() {
        return id;
    }

    // グループ名を取得
    public String getName() {
        return name;
    }

    // グループ名を設定
    public void setName(String name) {
        this.name = name;
    }
}