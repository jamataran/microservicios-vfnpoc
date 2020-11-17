package es.autowired;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import es.autowired.config.SwaggerServicesConfig;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@SpringBootApplication
@EnableSwagger2
@EnableConfigurationProperties({SwaggerServicesConfig.class, SwaggerServicesConfig.SwaggerServices.class})
public class DocumentationApplication {

	public static void main(String[] args) {
		SpringApplication.run(DocumentationApplication.class, args);
	}
}
