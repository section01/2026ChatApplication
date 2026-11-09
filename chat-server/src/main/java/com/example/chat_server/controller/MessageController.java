package com.example.chat_server.controller;

import com.example.chat_server.entity.Message;
import com.example.chat_server.service.MessageService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/messages")
public class MessageController {

    private final MessageService messageService;

    public MessageController(MessageService messageService) {
        this.messageService = messageService;
    }

    // メッセージ一覧を取得
    @GetMapping
    public List<Message> getMessages() {
        return messageService.getMessages();
    }

    // メッセージを登録
    @PostMapping
    public Message createMessage(@RequestBody Message message) {

        // 送信者名を設定
        message.setSenderName("自分");

        // 送信日時を設定
        message.setCreatedAt(java.time.LocalDateTime.now());

        // メッセージをデータベースに保存
        return messageService.saveMessage(message);
    }
}