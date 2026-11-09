package com.example.chat_server.service;

import com.example.chat_server.entity.Message;
import com.example.chat_server.repository.MessageRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MessageService {

    private final MessageRepository messageRepository;

    public MessageService(MessageRepository messageRepository) {
        this.messageRepository = messageRepository;
    }

    // DBからメッセージ一覧を取得
    public List<Message> getMessages() {
        // 送信日時が古い順にメッセージを取得
        return messageRepository.findAllByOrderByCreatedAtAsc();
    }

    // メッセージをDBに保存
    public Message saveMessage(Message message) {
        return messageRepository.save(message);
    }
}