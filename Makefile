#.ONESHELL:
#.PHONY: install

CONTAINERNAME := 
IMAGENAME :=

# Define the name of the virtual environment directory
VENV := env

# Define the name of the requirements file
REQS := requirements.txt

# Define a function to check if the virtual environment needs to be updated
define venv-updated
	@test -f $(VENV)/pyvenv.cfg && test $(REQS) -ot $(VENV)/pyvenv.cfg
endef

# Define a target to create the virtual environment and install the requirements
.PHONY: venv
venv: $(VENV)/pyvenv.cfg

$(VENV)/pyvenv.cfg: $(REQS) | $(VENV)
	$(call venv-updated) || ( \
		echo "Creating virtual environment..." && \
		python3 -m venv $(VENV) && \
		. $(VENV)/bin/activate && \
		pip install -r $(REQS) && \
		touch $(VENV)/pyvenv.cfg \
	)

# Define a target to create the virtual environment directory if it doesn't exist
$(VENV):
	mkdir -p $(VENV)

clean:
	$(info ##### Cleaning Project Folder #####)
	-find . -name "__pycache__" -exec rm -r '{}' \;
	-find . -name "*.pyc" -delete  
	-rm -r env

run: venv
	. $(VENV)/bin/activate; cd src; python3 main.py



container_clean:
	$(info ##### Removing Containers #####)
	-docker stop $(CONTAINERNAME)
	-docker rm $(CONTAINERNAME)

build: clean
	$(info ##### Building Image #####)
	docker build -t $(IMAGENAME) .

deploy: container_clean build
	$(info ##### Deploying Container #####)
	docker-compose -f docker-compose.yml up