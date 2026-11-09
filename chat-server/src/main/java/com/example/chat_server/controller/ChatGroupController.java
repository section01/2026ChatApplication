package com.example.chat_server.controller;

import com.example.chat_server.entity.ChatGroup;
import com.example.chat_server.service.ChatGroupService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

// グループ情報に関するAPI
@RestController
@RequestMapping("/api/groups")
public class ChatGroupController {

    private final ChatGroupService chatGroupService;

    public ChatGroupController(ChatGroupService chatGroupService) {
        this.chatGroupService = chatGroupService;
    }

    // すべてのグループ情報を取得
    @GetMapping
    public List<ChatGroup> getGroups() {
        return chatGroupService.getGroups();
    }

    // グループ情報を登録
    @PostMapping
    public ChatGroup createGroup(@RequestBody ChatGroup chatGroup) {
        return chatGroupService.saveGroup(chatGroup);
    }

    // グループ名を変更
    @PutMapping("/{groupId}")
    public ChatGroup updateGroup(
            @PathVariable Long groupId,
            @RequestBody ChatGroup chatGroup) {

        // 指定されたグループの名前を変更
        return chatGroupService.updateGroup(
                groupId,
                chatGroup.getName()
        );
    }
}