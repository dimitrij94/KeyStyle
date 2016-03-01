package com.example.configuration;

import com.example.filters.CsrfParamToHeaderFilter;
import com.example.handlers.MySimpleUrlAuthenticationSuccessHendler;
import com.example.neo_services.authentication.MyUserDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.csrf.CsrfFilter;
import org.springframework.security.web.csrf.CsrfTokenRepository;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;

/**
 * Created by Dmitrij on 08.10.2015.
 */
@Configuration
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class DemoSpringSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    MyUserDetailService myUserDetailService;

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth
                .authenticationProvider(createAuthenticationProvider(myUserDetailService));
    }


    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http.httpBasic()

                .and()
                .sessionManagement()
                .maximumSessions(1).and()
                .sessionFixation().changeSessionId()

                .and().logout()

                .and().rememberMe()
                .key("remember")

                .and().addFilterAfter(new CsrfParamToHeaderFilter(), CsrfFilter.class)
                .csrf()
                .csrfTokenRepository(csrfTokenRepository())

                .and().authorizeRequests()

                .regexMatchers(HttpMethod.GET, "rating/place/[0-9]{0,}", "/place/[0-9]{0,}/liked/", "/rating/place/[0-9]{0,}")
                .hasRole("USER")

                .antMatchers(HttpMethod.GET, "/user/orders", "/user/places")
                .hasRole("USER")

                .regexMatchers(HttpMethod.POST, "/menu/[0-9]{0,}/comment",
                        "/place/[0-9]{0,}/menu/[0-9]{0,}")
                .hasRole("USER")

                .regexMatchers(HttpMethod.POST, "/place/menu/[0-9]{0,}")
                .hasRole("OWNER")

                .antMatchers(HttpMethod.GET, "/user")
                .authenticated()

                .antMatchers(HttpMethod.POST, "/place")
                .authenticated()

                .antMatchers(HttpMethod.POST, "/user", "/registration")
                .permitAll()

                .antMatchers(HttpMethod.GET, "/user/test", "/resend", "/", "/registration", "/place/")
                .permitAll();

    }


    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new MySimpleUrlAuthenticationSuccessHendler();
    }


    private AuthenticationProvider createAuthenticationProvider(UserDetailsService service) {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(service);
        provider.setPasswordEncoder(passwordEncoder());
        provider.setHideUserNotFoundExceptions(true);
        return provider;
    }


    private CsrfTokenRepository csrfTokenRepository() {
        HttpSessionCsrfTokenRepository repository = new HttpSessionCsrfTokenRepository();
        repository.setHeaderName("X-XSRF-TOKEN");
        return repository;
    }


}
