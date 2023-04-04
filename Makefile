

NAME=com.bolthole.getcred
VERSION=1.0.10

SRCS=main.sh


recipedir/recipe.yaml:	Makefile recipe-tmpl.yaml
	rm -rf recipedir
	mkdir recipedir
	sed -e 's/NAME/'$(NAME)'/' \
	-e 's/VERSION/'$(VERSION)'/' \
	 recipe-tmpl.yaml >recipedir/recipe.yaml

localstage:	$(SRCS)
	rm -rf artifactdir
	mkdir artifactdir
	mkdir -p artifactdir/$(NAME)/$(VERSION)
	cp $(SRCS) artifactdir/$(NAME)/$(VERSION)
	chmod 0755 artifactdir/$(NAME)/$(VERSION)/*

localdeploy:	recipedir/recipe.yaml localstage
	sudo /greengrass/v2/bin/greengrass-cli deployment create \
	  --recipeDir recipedir --artifactDir artifactdir \
	--merge $(NAME)=$(VERSION)


remove:
	sudo /greengrass/v2/bin/greengrass-cli deployment create \
	  --remove=$(NAME)
	rm -rf artifactdir recipedir

