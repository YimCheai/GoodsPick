package com.example.goodspick.repository;

import com.example.goodspick.entity.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.Optional;

public interface UserRepository extends MongoRepository<User, String> {
    // 회원가입 시 중복 체크
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);

    // 로그인 시 사용자 조회
    Optional<User> findByUsername(String username);
}