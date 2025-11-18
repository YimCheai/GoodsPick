package com.example.goodspick.controller;

import  com.example.goodspick.dto.ChatMessageDTO;
import  com.example.goodspick.entity.ChatRoom;
import com.example.goodspick.entity.Message;
import com.example.goodspick.service.ChatService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final SimpMessagingTemplate messagingTemplate;

    // WebSocket 메시지 처리
    @MessageMapping("/chat/{chatRoomId}")
    public void sendMessage(@DestinationVariable String chatRoomId, ChatMessageDTO messageDTO) {
        // 메시지 저장
        Message.MessageType type = messageDTO.getType().equals("IMAGE")
                ? Message.MessageType.IMAGE
                : Message.MessageType.TEXT;

        Message savedMessage = chatService.saveMessage(
                chatRoomId,
                messageDTO.getSenderId(),
                messageDTO.getSenderName(),
                messageDTO.getContent(),
                messageDTO.getImageUrl(),
                type
        );

        // 메시지를 해당 채팅방 구독자들에게 전송
        messageDTO.setTimestamp(savedMessage.getTimestamp());
        messagingTemplate.convertAndSend("/topic/chat/" + chatRoomId, messageDTO);
    }

    // REST API: 채팅방 목록 조회
    @GetMapping("/api/chat/rooms")
    @ResponseBody
    public List<ChatRoom> getChatRooms(@RequestParam String userId) {
        return chatService.getUserChatRooms(userId);
    }

    // REST API: 채팅방 생성 또는 가져오기
    @PostMapping("/api/chat/room")
    @ResponseBody
    public ChatRoom createOrGetChatRoom(@RequestParam String userId1, @RequestParam String userId2) {
        return chatService.createOrGetChatRoom(userId1, userId2);
    }

    // REST API: 채팅방 메시지 목록 조회
    @GetMapping("/api/chat/messages/{chatRoomId}")
    @ResponseBody
    public List<Message> getChatMessages(@PathVariable String chatRoomId) {
        return chatService.getChatRoomMessages(chatRoomId);
    }

    // REST API: 메시지 읽음 처리
    @PostMapping("/api/chat/read/{chatRoomId}")
    @ResponseBody
    public void markAsRead(@PathVariable String chatRoomId, @RequestParam String userId) {
        chatService.markMessagesAsRead(chatRoomId, userId);
    }

    // REST API: 읽지 않은 메시지 수 조회
    @GetMapping("/api/chat/unread/{chatRoomId}")
    @ResponseBody
    public long getUnreadCount(@PathVariable String chatRoomId, @RequestParam String userId) {
        return chatService.getUnreadCount(chatRoomId, userId);
    }
}