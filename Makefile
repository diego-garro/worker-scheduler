POETRY=poetry
POETRY_RUN=$(POETRY) run

COVERAGE=coverage
COVERAGE_RUN=$(COVERAGE) run -m

SOURCE_FILES=$(shell find . -path "./src/*.py")
TEST_FILES=$(shell find . -path "./tests/**/*.py")
SOURCES_FOLDER=src

BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

check_no_main:
ifeq ($(BRANCH),main)
	echo "You are good to go!"
else
	$(error You are not in the main branch)
endif

check:
	mypy --config-file mypy.ini src/

patch: check_no_main
	$(POETRY_RUN) bumpversion patch --verbose
	git push --follow-tags

minor: check_no_main
	$(POETRY_RUN) bumpversion minor --verbose
	git push --follow-tags

major: check_no_main
	$(POETRY_RUN) bumpversion major --verbose
	git push --follow-tags

style:
	$(POETRY_RUN) isort $(SOURCES_FOLDER)
	$(POETRY_RUN) black $(SOURCE_FILES)

lint:
	$(POETRY_RUN) isort $(SOURCES_FOLDER) --check-only
	$(POETRY_RUN) black $(SOURCE_FILES) --check

mypy:
	$(POETRY_RUN) mypy $(SOURCES_FOLDER)

test:
	$(POETRY_RUN) pytest tests

test-verbose:
	$(POETRY_RUN) pytest tests -vv

coverage:
	$(POETRY_RUN) $(COVERAGE_RUN) pytest tests
	$(POETRY_RUN) $(COVERAGE) html --skip-covered --skip-empty

codecov:
	$(POETRY_RUN) codecov

run:
	$(POETRY_RUN) python -m $(SOURCES_FOLDER)