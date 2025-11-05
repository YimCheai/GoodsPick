package com.example.goodspick.controller;

import com.example.goodspick.entity.User;
import com.example.goodspick.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {

    private final UserService userService;

    public HomeController(UserService userService) {
        this.userService = userService;
    }

    @RequestMapping("/")
    public ModelAndView index() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("index"); // /WEB-INF/views/index.jsp
        return mav;
    }

    @GetMapping("/need")
    public String need() {
        return "need"; // This will resolve to /WEB-INF/views/need.jsp
    }
    @GetMapping("/provide")
    public String provide() {
        return "provide"; // This will resolve to /WEB-INF/views/need.jsp
    }
    @GetMapping("/need_post")
    public String need_post() {
        return "need_post"; // This will resolve to /WEB-INF/views/need.jsp
    }
    // 회원가입 페이지
    @GetMapping("/signup")
    public String signupForm() {
        return "signup";  // signup.jsp
    }

    // 회원가입 처리
    @PostMapping("/signup")
    public String signupSubmit(@RequestParam String username,
                               @RequestParam String password,
                               @RequestParam String email,
                               Model model) {

        User user = new User(username, password, email);
        String error = userService.registerUser(user);

        if (error != null) {
            model.addAttribute("error", error);
            return "signup";
        }

        // 가입 성공하면 로그인 페이지로 이동
        return "redirect:/login";
    }

    // 로그인 페이지
    @GetMapping("/login")
    public String loginForm() {
        return "login";  // login.jsp
    }

    // 로그인 처리
    @PostMapping("/login")
    public String loginSubmit(@RequestParam String username,
                              @RequestParam String password,
                              Model model,
                              HttpSession session) {

        User user = userService.login(username, password);

        if (user == null) {
            model.addAttribute("error", "아이디 또는 비밀번호가 일치하지 않습니다");
            return "login";
        }

        // 로그인 성공 시 세션에 사용자 정보 저장
        session.setAttribute("loginUser", user);
        return "redirect:/"; // 로그인 성공 후 메인 페이지 이동
    }

    // 로그아웃 처리
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 세션 삭제
        return "redirect:/login";
    }
}