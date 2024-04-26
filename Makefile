MISE=$(HOME)/.local/bin/mise
TUIST=$(MISE) x tuist -- tuist

all: bootstrap project_file

bootstrap:
	command -v $(MISE) >/dev/null 2>&1 || curl https://mise.jdx.dev/install.sh | sh
	$(MISE) install

project_file:
	$(TUIST) install
	$(TUIST) generate --no-open

project_cache_warmup:
	$(TUIST) cache Common --external-only
	$(TUIST) generate -n

update:
	$(TUIST) install --update
	$(TUIST) generate --no-open

build_debug:
	$(TUIST) build --generate --configuration Debug --build-output-path .build/ SkeletonProject

build_release:
	$(TUIST) build --generate --configuration Release --build-output-path .build/ SkeletonProject

format:
	$(MISE) x swiftlint -- swiftlint lint --force-exclude --fix .
	$(MISE) x swiftformat -- swiftformat . --config .swiftformat

clean:
	rm -rf build
	$(TUIST) clean

.SILENT: all bootstrap project_file update build_debug build_release format clean
