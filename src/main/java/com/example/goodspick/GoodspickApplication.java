package com.example.goodspick;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@Slf4j
@SpringBootApplication
public class GoodspickApplication {

	public static void main(String[] args) {
		SpringApplication.run(GoodspickApplication.class, args);
		log.info("\n\n==================================== GoodspickApplication started ====================================\n");
	}

}
