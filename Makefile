all:
	@echo "Building dashclock for Pi"
	@export RPXC_IMAGE=dashclock-rpxc-image
	@rpxc sh -c 'mix deps.get && mix deps.compile'
