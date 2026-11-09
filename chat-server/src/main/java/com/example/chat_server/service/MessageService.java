package com.example.chat_server.service;

import com.example.chat_server.entity.Message;
import com.example.chat_server.repository.MessageRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import com.example.chat_server.entity.ChatGroup;
import com.example.chat_server.repository.ChatGroupRepository;

@Service
public class MessageService {

    private final MessageRepository messageRepository;
    private final ChatGroupRepository chatGroupRepository;

    public MessageService(
            MessageRepository messageRepository,
            ChatGroupRepository chatGroupRepository) {

        this.messageRepository = messageRepository;
        this.chatGroupRepository = chatGroupRepository;
    }

    // DBからメッセージ一覧を取得
    public List<Message> getMessages() {
        // 送信日時が古い順にメッセージを取得
        return messageRepository.findAllByOrderByCreatedAtAsc();
    }

    // 指定したグループのメッセージを取得
    public List<Message> getMessagesByGroupId(Long groupId) {
        return messageRepository.findAllByChatGroupIdOrderByCreatedAtAsc(groupId);
    }

    // メッセージをDBに保存
    public Message saveMessage(Message message) {

        // メッセージに設定されたグループIDからグループ情報を取得
        Long groupId = message.getChatGroup().getId();
        ChatGroup chatGroup = chatGroupRepository.findById(groupId)
                .orElseThrow(() -> new RuntimeException("グループが見つかりません"));

        // メッセージにグループ情報を設定
        message.setChatGroup(chatGroup);

        // メッセージを保存
        return messageRepository.save(message);
    }
}