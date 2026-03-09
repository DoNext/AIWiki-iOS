.PHONY: lint-copy check-all release-appstore

lint-copy:
	python3 scripts/check_en_localizable_style.py

check-all:
	bash scripts/check_all.sh

release-appstore:
	bash scripts/release_to_app_store.sh
