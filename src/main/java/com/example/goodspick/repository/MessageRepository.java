package com.example.goodspick.repository;
import com.example.goodspick.entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface MessageRepository extends MongoRepository<Message, String> {
    List<Message> findByChatRoomIdOrderByTimestampAsc(String chatRoomId);
    List<Message> findByChatRoomIdAndIsReadFalseAndSenderIdNot(String chatRoomId, String userId);
    long countByChatRoomIdAndIsReadFalseAndSenderIdNot(String chatRoomId, String userId);
}