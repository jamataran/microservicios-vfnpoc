package es.autowired.config;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import springfox.documentation.swagger.web.SwaggerResource;
import springfox.documentation.swagger.web.SwaggerResourcesProvider;

@Configuration
@Primary
@EnableAutoConfiguration
public class GatewaySwaggerResourceProvider implements SwaggerResourcesProvider {

    private final SwaggerServicesConfig swaggerServiceList;

    @Autowired
    public GatewaySwaggerResourceProvider(SwaggerServicesConfig swaggerServiceList) {
        this.swaggerServiceList = swaggerServiceList;
    }

    @Override
    public List<SwaggerResource> get() {
        return swaggerServiceList
                .getServices()
                .parallelStream()
                .map(s -> swaggerResource(s.getName(), s.getUrl(), s.getVersion()))
                .collect(Collectors.toList());
    }

    private SwaggerResource swaggerResource(String name, String location, String version) {
        SwaggerResource swaggerResource = new SwaggerResource();
        swaggerResource.setName(name);
        swaggerResource.setLocation(location);
        swaggerResource.setSwaggerVersion(version);
        return swaggerResource;
    }


}