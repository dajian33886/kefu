package com.kefu.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers(
                    "/",
                    "/index.html",
                    "/favicon.ico",
                    "/manifest.webmanifest",
                    "/sw.js",
                    "/css/**",
                    "/js/**",
                    "/img/**",
                    "/fonts/**",
                    "/assets/**",
                    "/landing/**",
                    "/kjs-assets/**",
                    "/share-assets/**",
                    "/fanghong/**",
                    "/404.html",
                    "/welcome.html",
                    "/maintenance.html",
                    "/blocked.html",
                    "/notfound.html",
                    "/actuator/health",
                    "/actuator/health/**",
                    "/actuator/**",
                    "/login",
                    "/logout",
                    "/api/auth/**",
                    "/api/login/**",
                    "/error"
                ).permitAll()
                .anyRequest().authenticated()
            )
            .httpBasic(Customizer.withDefaults())
            .formLogin(form -> form.disable());
        return http.build();
    }
}
