.PHONY: lint-copy check-all

lint-copy:
	python3 scripts/check_en_localizable_style.py

check-all:
	bash scripts/check_all.sh
