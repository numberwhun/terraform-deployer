.PHONY: help clean clean-pyc clean-build list test test-all coverage docs release sdist

help:
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean - clean-{build,pyc}"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "testall - run tests on every Python version with tox"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "docs - generate Sphinx HTML documentation, including API docs"
	@echo "sdist - package"

guard-%:
	@ if [ "${${*}}" == "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

clean: clean-build clean-pyc

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info
	rm -rf coverage.xml clonedigger.xml junit.xml
	rm -rf htmlcov

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +

install:
	python setup.py install > /dev/null

build: install
	python setup.py build > /dev/null

lint:
	flake8 neo test

test:
	py.test

testall:
	tox

coverage:
	coverage run --source neo_core setup.py test
	coverage report -m
	coverage html

docs:
	rm -f docs/neo.rst
	rm -f docs/modules.rst
	sphinx-apidoc -o docs/ neo
	$(MAKE) -C docs clean
	$(MAKE) -C docs html

sdist: clean
	python setup.py sdist
	ls -l dist

bdist: clean
	python setup.py bdist_wheel
