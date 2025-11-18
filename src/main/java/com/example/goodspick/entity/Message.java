package com.example.goodspick.entity;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Data
@Document(collection = "messages")
public class Message {
    @Id
    private String id;
    private String chatRoomId;
    private String senderId;
    private String senderName;
    private String content;
    private String imageUrl; // 이미지 첨부 시
    private MessageType type; // TEXT, IMAGE
    private LocalDateTime timestamp;
    private boolean isRead;

    public enum MessageType {
        TEXT, IMAGE
    }
}