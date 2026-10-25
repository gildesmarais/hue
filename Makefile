.DEFAULT_GOAL := check

BIN := hue-mcp
MISE := $(shell command -v mise >/dev/null 2>&1 && printf 'mise exec -- ')
GO := $(MISE)go
GOFMT := $(MISE)gofmt

.PHONY: check lint lintfix ready build dev start

check:
	$(GO) test ./...

lint:
	@files=$$($(GOFMT) -l .); \
	if [ -n "$$files" ]; then printf '%s\n' "$$files"; exit 1; fi
	$(GO) vet ./...

lintfix:
	$(GOFMT) -w .

ready: lint check build

build:
	$(GO) build -o $(BIN) .

# MCP server from source. Loads .env when it exists.
dev:
	set -a; [ -f .env ] && . ./.env; set +a; $(GO) run .

# Same entry Cursor launches (./hue-mcp). Loads .env when it exists.
start: build
	set -a; [ -f .env ] && . ./.env; set +a; exec ./$(BIN)
