
.PHONY: install
install:
	git config --global init.templatedir '~/.git-templates'
	mkdir -p ~/.git-templates/hooks
	ln -sf $$PWD/sailr.sh $$HOME/.git-templates/hooks/commit-msg
	mkdir -p $$HOME/.sailr
	cp $$PWD/config.json $$HOME/.sailr/config.json

.PHONY: uninstall
uninstall:
	rm -rf $$HOME/.git-templates/hooks/commit-msg
	rm -rf $$HOME/.sailr