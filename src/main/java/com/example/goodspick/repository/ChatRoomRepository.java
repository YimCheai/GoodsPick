package com.example.goodspick.repository;

import com.example.goodspick.entity.ChatRoom;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ChatRoomRepository extends MongoRepository<ChatRoom, String> {

    // 특정 사용자가 참여한 채팅방 목록
    List<ChatRoom> findByParticipantsContaining(String userId);

    // 두 사용자 간의 채팅방 찾기 (커스텀 쿼리 사용)
    @Query("{ 'participants': { $all: ?0 } }")
    Optional<ChatRoom> findByParticipantsContainingAll(List<String> participants);

    // ChatRoomRepository.java 확인
    @Query(value = "{ 'participants': { $all: ?0 } }", sort = "{ 'lastMessageTime': -1 }")
    Optional<ChatRoom> findChatRoomByParticipants(List<String> participants);
}