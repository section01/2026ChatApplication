package com.example.chat_server.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
@CrossOrigin(origins = "*")
public class HealthController {

    public HealthController() {
        System.out.println("★★★★★ HealthController loaded ★★★★★");
    }

    @GetMapping("/health")
    public Map<String, String> health() {
        System.out.println("★★★★★ /health called ★★★★★");
        return Map.of("status", "OK");
    }
}