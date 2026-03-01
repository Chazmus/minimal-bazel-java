package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.HashMap;
import java.util.Map;

public class App {
  public static void main(String[] args) throws Exception {
    ObjectMapper mapper = new ObjectMapper();
    Map<String, String> payload = new HashMap<>();
    payload.put("message", "Hello, Bazel with Jackson!");

    String json = mapper.writeValueAsString(payload);
    System.out.println(json);
  }

  public String getGreeting() {
    return "Hello World";
  }
}
