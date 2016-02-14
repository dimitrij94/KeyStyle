package com.example.controllers.rest;

import com.example.domain.place.Place;
import com.example.pojo.dto.PlaceDTO;
import com.example.services.placeservice.PlaceService;
import com.example.validators.PlaceFormValidator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * Created by Dmitrij on 21.01.2016.
 */
@RestController
@RequestMapping("/place")
public class PlaceRestController {

    @Autowired
    PlaceService service;

    @Autowired
    PlaceFormValidator validator;

    @RequestMapping(method = RequestMethod.POST, consumes = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Place> newPlace(@RequestBody PlaceDTO place,
                                          BindingResult errors) {
        validator.validate(place, errors);
        if (!errors.hasErrors()) {
            return new ResponseEntity<>(service.newPlace(place), HttpStatus.OK);
        } else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    @RequestMapping(value = "/{id}/photo", method = RequestMethod.POST, consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> addPhoto(@PathVariable("id") long id,
                                         MultipartFile file,
                                         UriComponentsBuilder builder) {
        if (!file.isEmpty()) {
            CommonsMultipartFile photo = (CommonsMultipartFile) file;
            service.addPhoto(photo, id);

            HttpHeaders headers = new HttpHeaders();
            headers.setLocation(builder.path("/{id}/photo/{name}").buildAndExpand(id, "main").toUri());
            return new ResponseEntity<>(headers, HttpStatus.OK);
        } else return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }


}
