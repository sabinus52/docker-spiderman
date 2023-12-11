## Construction des images Docker PHP
## ----------------------------------
##
## Pour image spécifique, déclarer au préalable la variable VERSION
## Ex : VERSION=7.4 make build
##

ifndef VERSION
	VERSION:=5.6
endif

DOCKER_REPO:=sabinus52/spiderman-php
DOCKER_RUN:=docker run --rm $(DOCKER_REPO):$(VERSION)


.PHONY: help
help: Makefile  ## Aide
	@sed -n 's/^##//p' $<
	@/bin/echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/  \\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"
	@echo ""


.PHONY: build
build: ## Construction d'une image PHP dans une version spécifique
	@echo "Version : APACHE $(VERSION)"
	@echo "---------------------------------------------------------"
	@echo ""
	docker build -t $(DOCKER_REPO):$(VERSION)-apache --target apache --build-arg VERSION=$(VERSION) -f $(VERSION)/Dockerfile .
	@echo ""
	@echo ""
	@echo ""
	@echo "Version : CLI $(VERSION)"
	@echo "---------------------------------------------------------"
	@echo ""
	docker build -t $(DOCKER_REPO):$(VERSION)-cli    --target cli    --build-arg VERSION=$(VERSION) -f $(VERSION)/Dockerfile .


.PONY: test
test: ## Test d'une image dans une version spécifique
	@echo "===== Test de l'image ${DOCKER_REPO}:${VERSION}-apache ====="
	$(DOCKER_RUN)-apache date
	$(DOCKER_RUN)-apache php -v
	@echo "===== Test de l'image ${DOCKER_REPO}:${VERSION}-cli ====="
	$(DOCKER_RUN)-cli date
	$(DOCKER_RUN)-cli php -v


.PONY: test-phpinfo
test-phpinfo: ## Affichage des infos PHP d'une image dans une version spécifique
	$(DOCKER_RUN)-apache php -i


.PHONY: save
save: ## Sauvegarde de l'image dans une version spécifique
	@echo "Sauvegarde de l'image $(DOCKER_REPO):${VERSION}"
	docker save $(DOCKER_REPO):$(VERSION)-apache | gzip > images/${VERSION}-apache.tar.gz
	docker save $(DOCKER_REPO):$(VERSION)-cli | gzip > images/${VERSION}-cli.tar.gz
	@echo ""


.PHONY: push
push: ## Pousse l'image sur le registry "Docker Hub"
	@echo "Pousse l'image $(DOCKER_REPO):${VERSION} sur le Docker Hub"
	docker push $(DOCKER_REPO):$(VERSION)-apache
	docker push $(DOCKER_REPO):$(VERSION)-cli


.PHONY: build-all
build-all: ## Construction des images PHP dans toutes les versions
	VERSION=5.6 make build


.PHONY: save-all
save-all: ## Sauvegarde des images PHP dans toutes les versions
	VERSION=5.6 make save


.PHONY: push-all
push-all: ## Pousse toutes les images sur le registry "Docker Hub"
	VERSION=5.6 make push
