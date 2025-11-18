package com.example.goodspick.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ChatMessageDTO {
    private String chatRoomId;
    private String senderId;
    private String senderName;
    private String content;
    private String imageUrl;
    private String type; // TEXT, IMAGE
    private LocalDateTime timestamp;
}