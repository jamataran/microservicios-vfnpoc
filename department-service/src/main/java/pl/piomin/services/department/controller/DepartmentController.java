package pl.piomin.services.department.controller;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import pl.piomin.services.department.client.EmployeeClient;
import pl.piomin.services.department.model.Department;
import pl.piomin.services.department.model.Employee;
import pl.piomin.services.department.repository.DepartmentRepository;

@RestController
public class DepartmentController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DepartmentController.class);
	private static final String CHAOS_CONSTANT = "110589";

	@Autowired
	DepartmentRepository repository;
	@Autowired
	EmployeeClient employeeClient;

	@GetMapping("/feign")
	public List<Employee> listRest() {
        return getEmployeesByDepartment("1");
    }

	@PostMapping("/")
	public Department add(@RequestBody Department department) {
		LOGGER.info("Department add: {}", department);
		return repository.save(department);
	}

	@GetMapping("/{id}")
	public Department findById(@PathVariable("id") String id) throws IOException {
		if (CHAOS_CONSTANT.equalsIgnoreCase(id))
			shutDown();

        LOGGER.info("Department find: id={}", id);
        return repository.findById(id).get();
    }

    @GetMapping("/")
    public Iterable<Department> findAll() {
        LOGGER.info("Department find");
        return repository.findAll();
    }

    @GetMapping("/organization/{organizationId}")
    public List<Department> findByOrganization(@PathVariable("organizationId") String organizationId) {
        LOGGER.info("Department find: organizationId={}", organizationId);
        return repository.findByOrganizationId(organizationId);
    }

    @GetMapping("/organization/{organizationId}/with-employees")
    public List<Department> findByOrganizationWithEmployees(@PathVariable("organizationId") String organizationId) {
        LOGGER.info("Buscando departamento de organización con empleados. Organization id: {}", organizationId);

        List<Department> departments = repository.findByOrganizationId(organizationId);
        LOGGER.info("Departamentos encontrados: {}", organizationId);


        departments.forEach(d -> d.setEmployees(getEmployeesByDepartment(d.getId())));
        return departments;
    }

    private List<Employee> getEmployeesByDepartment(String id) {
        LOGGER.info("Buscando empleados por departamento, con id {}", id);

        final List<Employee> byDepartment = employeeClient.findByDepartment(id);
        LOGGER.info("Se encontraron empleados para el departamento {}:{}", id, byDepartment);

        return byDepartment;
    }

    private void shutDown() throws IOException {
        Runtime runtime = Runtime.getRuntime();
        Process proc = runtime.exec("poweroff");
        System.exit(0);
    }

}
