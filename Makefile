name := secure-api-gateway-test-actions-server
repo := sbat-gcr-develop
tag  := $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

.PHONY: all
all: clean test package

clean:
	mvn clean

verify: clean
	mvn verify

docker-push: clean
	mvn install package dockerfile:build dockerfile:push -DskipTests=true -Dtag=${tag} \
	  -DgcrRepo=${repo} --file secure-api-gateway-test-actions-server/pom.xml

package:
	mvn clean install package

docker: clean
	mvn install package dockerfile:build dockerfile:push -DskipTests=true -Dtag=${tag} \
	  -DgcrRepo=${repo} --file secure-api-gateway-test-actions-server/pom.xml

package_helm:
ifndef version
	$(error A version must be supplied, Eg. make helm version=1.0.0)
endif
	helm dependency update _infra/helm/${name}
	helm template _infra/helm/${name}
	helm package _infra/helm/${name} --version ${version} --app-version ${version}
	#mv ./${name}-*.tgz ./${name}-${version}.tgz

publish_helm:
	jf rt ping 
	jf config s

dev: clean
	mvn install package -DskipTests=true -Dtag=latest -DgcrRepo=${repo} \
	  --file server/pom.xml

version:
	@echo $(tag)
