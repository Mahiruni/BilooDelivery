SHELL := /bin/bash
FLUTTER_APPS := customer_app driver_app vendor_app

.PHONY: bootstrap format analyze test admin

bootstrap:
	./scripts/bootstrap.sh

format:
	dart format packages apps/customer_app/lib apps/driver_app/lib apps/vendor_app/lib

analyze:
	@set -e; \
	for app in $(FLUTTER_APPS); do \
		echo "Analyzing $$app"; \
		(cd apps/$$app && flutter pub get && flutter analyze); \
	done

test:
	cd apps/customer_app && flutter pub get && flutter test

admin:
	cd apps/admin_dashboard && python3 -m http.server 4173
