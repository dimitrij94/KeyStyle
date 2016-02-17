package com.example.services.placeservice;

import com.example.domain.employee.PlaceEmployee;
import com.example.domain.owner.PlaceOwner;
import com.example.domain.place.Place;
import com.example.domain.place.PlaceSchedule;
import com.example.domain.users.PlaceUser;
import com.example.pojo.dto.PlaceDTO;
import com.example.pojo.dto.ScheduleDTO;
import com.example.services.authentication.owner.CustomOwnerDetails;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import java.io.IOException;
import java.util.List;

/**
 * Created by Dmitrij on 25.10.2015.
 */
public interface PlaceService {
    void sendNewOrder(PlaceUser user, long placeId,
                      long menuId, List<Long> services,
                      PlaceEmployee employee);


    Place registerNewPlace(PlaceDTO placeDTO, PlaceOwner owner) throws IOException;

    @PreAuthorize("principal.id==#id")
    void addPhoto(CommonsMultipartFile photo, long id);

    List<PlaceSchedule> updatePlaceSchedual(List<ScheduleDTO> newSchedual);

    CustomOwnerDetails placeOwner();

    Place newPlace(PlaceDTO place);

    @PreAuthorize("principal.id==#place.placeOwner.id")
    void deletePlace(Place place);

    @PreAuthorize("principal.id==#place.placeOwner.id")
    void updatePlace(Place place);

    Place getPlace(long id);
}
