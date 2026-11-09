package com.example.chat_server.service;

import com.example.chat_server.entity.ChatGroup;
import com.example.chat_server.repository.ChatGroupRepository;
import org.springframework.stereotype.Service;

import java.util.List;

// グループ情報を管理するService
@Service
public class ChatGroupService {

    private final ChatGroupRepository chatGroupRepository;

    public ChatGroupService(ChatGroupRepository chatGroupRepository) {
        this.chatGroupRepository = chatGroupRepository;
    }

    // すべてのグループ情報を取得
    public List<ChatGroup> getGroups() {
        return chatGroupRepository.findAll();
    }

    // グループ情報を登録
    public ChatGroup saveGroup(ChatGroup chatGroup) {
        return chatGroupRepository.save(chatGroup);
    }

    // グループ名を変更
    public ChatGroup updateGroup(Long groupId, String newName) {

        // 指定されたグループIDからグループ情報を取得
        ChatGroup chatGroup = chatGroupRepository.findById(groupId)
                .orElseThrow(() -> new RuntimeException("グループが見つかりません"));

        // グループ名を変更
        chatGroup.setName(newName);

        // 変更したグループ情報を保存
        return chatGroupRepository.save(chatGroup);
    }
}