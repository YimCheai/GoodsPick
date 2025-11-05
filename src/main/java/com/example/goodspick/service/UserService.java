package com.example.goodspick.service;

import com.example.goodspick.entity.User;
import com.example.goodspick.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // 회원가입
    public String registerUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            return "이미 사용 중인 아이디입니다";
        }

        if (userRepository.existsByEmail(user.getEmail())) {
            return "이미 사용 중인 이메일입니다";
        }

        // 패스워드 암호화 (원하면 BCrypt 등 적용 가능)
        userRepository.save(user);
        return null;  // 오류 없으면 null
    }

    // 로그인
    public User login(String username, String password) {
        Optional<User> optionalUser = userRepository.findByUsername(username);

        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            if (user.getPassword().equals(password)) { // 단순 비교, 필요하면 BCrypt 적용 가능
                return user;
            }
        }
        return null; // 로그인 실패 시 null 반환
    }
}