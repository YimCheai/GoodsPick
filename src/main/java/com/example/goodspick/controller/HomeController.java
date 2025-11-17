package com.example.goodspick.controller;

import com.example.goodspick.entity.Need;
import com.example.goodspick.entity.User;
import com.example.goodspick.service.NeedService;
import com.example.goodspick.service.ProvideService;
import com.example.goodspick.entity.Provide;
import com.example.goodspick.service.UserService;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class HomeController {

    private static final Logger log = LoggerFactory.getLogger(HomeController.class);

    private final UserService userService;
    private final NeedService needService; // Inject NeedService
    private final ProvideService provideService; // Inject ProvideService

    public HomeController(UserService userService, NeedService needService, ProvideService provideService) {
        this.userService = userService;
        this.needService = needService;
        this.provideService = provideService;
    }

    @RequestMapping("/")
    public ModelAndView index() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("index"); // /WEB-INF/views/index.jsp
        return mav;
    }

    @GetMapping("/need")
    public String need(@RequestParam(value = "query", required = false) String query, Model model) {
        List<Need> needs;
        if (query != null && !query.isEmpty()) {
            needs = needService.getNeedsByGoodsNameContaining(query);
        } else {
            needs = needService.getAllNeeds();
        }
        model.addAttribute("needs", needs);
        model.addAttribute("query", query); // Add query to model
        return "need";
    }
    @GetMapping("/provide")
    public String provide(@RequestParam(value = "query", required = false) String query, Model model) {
        List<Provide> provides;
        if (query != null && !query.isEmpty()) {
            provides = provideService.getProvidesByGoodsNameContaining(query);
        } else {
            provides = provideService.getAllProvides();
        }
        model.addAttribute("provides", provides);
        model.addAttribute("query", query); // Add query to model
        return "provide";
    }
    @GetMapping("/need_post")
    public String need_post() {
        return "need_post";
    }

    @GetMapping("/need/{id}")
    public String needDetail(@PathVariable String id, Model model, HttpSession session) {
        Need needItem = needService.getNeedById(id);
        model.addAttribute("needItem", needItem);
        User loginUser = (User) session.getAttribute("loginUser");
        model.addAttribute("loginUser", loginUser);
        return "need_detail";
    }
    @GetMapping("/provide_post")
    public String provide_post() {
        return "provide_post";
    }

    @GetMapping("/provide/{id}")
    public String provideDetail(@PathVariable String id, Model model, HttpSession session) {
        Provide provideItem = provideService.getProvideById(id);
        model.addAttribute("provideItem", provideItem);
        User loginUser = (User) session.getAttribute("loginUser");
        model.addAttribute("loginUser", loginUser);
        return "provide_detail";
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

    // Need Item 등록 처리
    @PostMapping("/need_post")
    public String registerNeed(@RequestParam("goodsName") String goodsName,
                               @RequestParam("goodsDescription") String goodsDescription,
                               @RequestParam(value = "inPersonTransaction", required = false) Boolean inPersonTransaction,
                               @RequestParam("image") MultipartFile image,
                               HttpSession session) { // Add HttpSession parameter
        
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            // Should ideally be caught by LoginInterceptor, but good to have a fallback
            return "redirect:/login"; 
        }
        String userId = loginUser.getId(); // Get userId from the logged-in user

        // inPersonTransaction이 null일 경우 false로 기본값 설정
        if (inPersonTransaction == null) {
            inPersonTransaction = false;
        }
        Need need = new Need(goodsName, goodsDescription, inPersonTransaction);
        needService.registerNeed(need, image, userId); // Pass userId to service
        return "redirect:/need"; // 등록 후 need 페이지로 리다이렉트
    }

    // Provide Item 등록 처리
    @PostMapping("/provide_post")
    public String registerProvide(@RequestParam("goodsName") String goodsName,
                                  @RequestParam("goodsDescription") String goodsDescription,
                                  @RequestParam(value = "inPersonTransaction", required = false) Boolean inPersonTransaction,
                                  @RequestParam(value = "image", required = false) MultipartFile image,
                                  @RequestParam(value = "price", required = false) String priceString, // Changed to String to handle parsing
                                  HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        String userId = loginUser.getId();

        if (inPersonTransaction == null) {
            inPersonTransaction = false;
        }

        Integer price = 0; // Default price
        if (priceString != null && !priceString.isEmpty()) {
            try {
                double doublePrice = Double.parseDouble(priceString);
                price = (int) Math.round(doublePrice); // Round to nearest integer
            } catch (NumberFormatException e) {
                log.warn("Invalid price format received for provide item: {}", priceString);
                // Optionally add error to model or redirect with error message
            }
        }

        Provide provide = new Provide(goodsName, goodsDescription, inPersonTransaction);
        
        // Handle image upload conditionally
        String imagePath = null;
        if (image != null && !image.isEmpty()) {
            imagePath = provideService.storeImage(image); // Call a new method in ProvideService to store the image
        }
        
        provide.setImagePath(imagePath); // Set imagePath (can be null)
        provide.setUserId(userId);
        provide.setPrice(price); // Set with Integer price
        provideService.saveProvide(provide); // Call a new method in ProvideService to save the Provide entity
        return "redirect:/provide"; // 등록 후 provide 페이지로 리다이렉트
    }
    
    @GetMapping("/mypage")
    public String mypage(Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        String userId = loginUser.getId();
        List<Need> userNeeds = needService.getNeedsByUserId(userId);
        List<Provide> userProvides = provideService.getProvidesByUserId(userId); // Fetch user's provides
        model.addAttribute("userNeeds", userNeeds);
        model.addAttribute("userProvides", userProvides); // Add user's provides to model
        return "mypage";
    }

    @PostMapping("/need/delete/{id}")
    public String deleteNeed(@PathVariable String id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; // Not logged in
        }

        Need needItem = needService.getNeedById(id);
        if (needItem == null) {
            // Item not found, maybe redirect to an error page or mypage
            return "redirect:/mypage";
        }

        // Security check: ensure the logged-in user is the owner
        if (!needItem.getUserId().equals(loginUser.getId())) {
            // Not the owner, unauthorized
            // Redirecting to the detail page, could also show an error message
            return "redirect:/need/" + id;
        }

        needService.deleteNeed(id);
        return "redirect:/mypage";
    }

    @PostMapping("/provide/delete/{id}")
    public String deleteProvide(@PathVariable String id, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login"; // Not logged in
        }

        Provide provideItem = provideService.getProvideById(id);
        if (provideItem == null) {
            // Item not found, maybe redirect to an error page or mypage
            return "redirect:/mypage";
        }

        // Security check: ensure the logged-in user is the owner
        if (!provideItem.getUserId().equals(loginUser.getId())) {
            // Not the owner, unauthorized
            // Redirecting to the detail page, could also show an error message
            return "redirect:/provide/" + id;
        }

        provideService.deleteProvide(id);
        return "redirect:/mypage";
    }

    @GetMapping("/need/edit/{id}")
    public String showNeedEditForm(@PathVariable String id, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Need needItem = needService.getNeedById(id);
        if (needItem == null) {
            return "redirect:/mypage"; // Or an error page
        }

        // Security check
        if (!needItem.getUserId().equals(loginUser.getId())) {
            return "redirect:/need/" + id; // Not authorized
        }

        model.addAttribute("needItem", needItem);
        return "need_edit";
    }

    @PostMapping("/need/edit/{id}")
    public String updateNeed(@PathVariable String id,
                             @RequestParam("goodsName") String goodsName,
                             @RequestParam("goodsDescription") String goodsDescription,
                             @RequestParam(value = "inPersonTransaction", required = false) Boolean inPersonTransaction,
                             @RequestParam(value = "image", required = false) MultipartFile image,
                             HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Need existingNeed = needService.getNeedById(id);
        if (existingNeed == null) {
            return "redirect:/mypage";
        }

        // Security check
        if (!existingNeed.getUserId().equals(loginUser.getId())) {
            return "redirect:/need/" + id;
        }

        // inPersonTransaction might be null if not submitted
        if (inPersonTransaction == null) {
            inPersonTransaction = false;
        }

        needService.updateNeed(id, goodsName, goodsDescription, inPersonTransaction, image);
        
        return "redirect:/need/" + id;
    }

    @GetMapping("/provide/edit/{id}")
    public String showProvideEditForm(@PathVariable String id, Model model, HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Provide provideItem = provideService.getProvideById(id);
        if (provideItem == null) {
            return "redirect:/mypage"; // Or an error page
        }

        // Security check
        if (!provideItem.getUserId().equals(loginUser.getId())) {
            return "redirect:/provide/" + id; // Not authorized
        }

        model.addAttribute("provideItem", provideItem);
        return "provide_edit";
    }

    @PostMapping("/provide/edit/{id}")
    public String updateProvide(@PathVariable String id,
                              @RequestParam("goodsName") String goodsName,
                              @RequestParam("goodsDescription") String goodsDescription,
                              @RequestParam("price") int price,
                              @RequestParam(value = "inPersonTransaction", required = false) Boolean inPersonTransaction,
                              @RequestParam(value = "image", required = false) MultipartFile image,
                              HttpSession session) {
        User loginUser = (User) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }

        Provide existingProvide = provideService.getProvideById(id);
        if (existingProvide == null) {
            return "redirect:/mypage";
        }

        // Security check
        if (!existingProvide.getUserId().equals(loginUser.getId())) {
            return "redirect:/provide/" + id;
        }

        if (inPersonTransaction == null) {
            inPersonTransaction = false;
        }

        provideService.updateProvide(id, goodsName, goodsDescription, price, inPersonTransaction, image);
        
        return "redirect:/provide/" + id;
    }
}