package com.example.neo_services.employee;

import com.example.constants.WeekDays;
import com.example.graph.employee.PlaceEmployee;
import com.example.graph.place.Place;
import com.example.graph.schedules.EmployeeSchedule;
import com.example.graph.timeline.DayOfTheWeek;
import com.example.graph_repositories.employee.EmployeeRepository;
import com.example.graph_repositories.place.PlaceRepository;
import com.example.graph_repositories.timeline.DayOfTheWeekRepository;
import com.example.neo_services.mail.MailService;
import com.example.pojo.dto.EmployeeDTO;
import com.example.pojo.dto.ScheduleDTO;
import org.neo4j.graphdb.Transaction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.core.GraphDatabase;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by Dmitrij on 28.02.2016.
 */
@Service
public class EmployeeServiceImlementation implements EmployeeService {

    private GraphDatabase db;
    private MailService mailService;
    private PlaceRepository placeRepository;
    private EmployeeRepository employeeRepository;
    private DayOfTheWeekRepository dayOfTheWeekRepository;

    @Autowired
    public EmployeeServiceImlementation(GraphDatabase db,
                                        MailService mailService,
                                        PlaceRepository placeRepository,
                                        EmployeeRepository employeeRepository,
                                        DayOfTheWeekRepository dayOfTheWeekRepository) {
        this.db = db;
        this.mailService = mailService;
        this.placeRepository = placeRepository;
        this.employeeRepository = employeeRepository;
        this.dayOfTheWeekRepository = dayOfTheWeekRepository;
    }

    @Override
    public PlaceEmployee addEmployee(EmployeeDTO employeeDto, String placeName) {
        PlaceEmployee employee;
        try (Transaction tx = db.beginTx()) {
            employee = new PlaceEmployee(employeeDto);
            Place place = placeRepository.findByName(placeName);
            employee.setPlace(place);

            Set<EmployeeSchedule> employeeSchedules = new HashSet<>(7);
            for (ScheduleDTO dto : employeeDto.getSchedules()) {
                EmployeeSchedule schedule = new EmployeeSchedule(dto, employee);
                DayOfTheWeek dayOfTheWeek = dayOfTheWeekRepository.findByDayName(WeekDays.getInstace(dto.getDayOfTheWeekNum()).getFullName());
                schedule.setDay(dayOfTheWeek);
                employeeSchedules.add(schedule);
            }
            employee.setEmployeeSchedules(employeeSchedules);
            employee = employeeRepository.save(employee);
            tx.success();
        }
        mailService.confirmEmailMessage(employee);
        return employee;
    }
}
