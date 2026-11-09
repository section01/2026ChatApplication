package com.example.chat_server.repository;

import com.example.chat_server.entity.ChatGroup;
import org.springframework.data.jpa.repository.JpaRepository;

// グループ情報を操作するRepository
public interface ChatGroupRepository extends JpaRepository<ChatGroup, Long> {
}