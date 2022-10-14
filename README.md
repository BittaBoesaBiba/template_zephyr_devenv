# Template for Zephyr BLE CI environment
Originates from this [blog entry](https://www.zephyrproject.org/developing-and-testing-bluetooth-low-energy-products-on-nrf52840-in-renode-and-zephyr/).
Since only few people enjoy setting up a development environment before actually getting started, this repository aims at providing a convenient "one-click" installer.


# Using the repository

## Installation
1. Create a top-level folder `zephyrproject` (recommended by [Zephyr Getting Started](https://docs.zephyrproject.org/latest/develop/getting_started/) ).
2. Clone this repository into `zephyrproject`.
3. Run `./dev_environment/dev_install` from within the repository. Note: This will also compile and run the tests.


## Building and Testing
Launch the interactive Docker container in the current terminal with `./run`. This repository is mounted into the Docker container at `/workdir/<name>`.

Automatic tests are run via [renode-test](https://renode.readthedocs.io/en/latest/introduction/testing.html)
e.g. `renode-test automatic.robot`

Manual tests can be performed with [renode](https://renode.readthedocs.io/en/latest/introduction/using.html)
e.g. `renode manual.resc`

Downloading to board is done with [west flash](https://docs.zephyrproject.org/latest/develop/west/build-flash-debug.html#flashing-west-flash)
e.g. `west flash --build-dir _tmp_build/<application> --skip-rebuild`

## References
* [How to structure Zephyr based applications](https://github.com/zephyrproject-rtos/example-application)
* [Zephyr docker](https://github.com/zephyrproject-rtos/docker-image)
* [Nordic docker](https://github.com/NordicPlayground/nrf-docker)
