package com.example.goodspick.entity;

// model/ChatRoom.java
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Document(collection = "chatrooms")
public class ChatRoom {
    @Id
    private String id;
    private List<String> participants; // 참여자 userId 목록
    private String lastMessage;
    private LocalDateTime lastMessageTime;
    private int unreadCount; // 읽지 않은 메시지 수
    private LocalDateTime createdAt;
}

