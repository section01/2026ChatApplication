package com.example.chat_server.repository;

import com.example.chat_server.entity.Message;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {

    // 送信日時が古い順にメッセージを取得
    List<Message> findAllByOrderByCreatedAtAsc();

    // 指定したグループのメッセージを古い順に取得
    List<Message> findAllByChatGroupIdOrderByCreatedAtAsc(Long groupId);
}