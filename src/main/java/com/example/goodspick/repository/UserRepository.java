package com.example.goodspick.repository;

import com.example.goodspick.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    // 회원가입 시 중복 체크
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);

    // 로그인 시 사용자 조회
    Optional<User> findByUsername(String username);
}