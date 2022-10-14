# From https://github.com/renode/renode/blob/master/tests/platforms/NRF52840.robot

*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${UART}                       sysbus.uart0

${STANDARD}=  SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...  """

${NO_DMA}=  SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...  uart0:                                  ${\n}
...  ${SPACE*4}easyDMA: false                ${\n}
...  uart1:                                  ${\n}
...  ${SPACE*4}easyDMA: false                ${\n}
...  """

${DMA}=     SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...  uart0:                                  ${\n}
...  ${SPACE*4}easyDMA: true                 ${\n}
...  uart1:                                  ${\n}
...  ${SPACE*4}easyDMA: true                 ${\n}
...  """

${ADXL_SPI}=     SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...                                          ${\n}
...  adxl372: Sensors.ADXL372 @ spi2         ${\n}
...                                          ${\n}
...  gpio0:                                  ${\n}
...  ${SPACE*4}22 -> adxl372@0 // CS         ${\n}
...  """

${ADXL_I2C}=     SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...                                          ${\n}
...  adxl372: Sensors.ADXL372 @ twi1 0x11    ${\n}
...  """

${BUTTON_LED}=     SEPARATOR=
...  """                                     ${\n}
...  using "platforms/cpus/nrf52840.repl"    ${\n}
...                                          ${\n}
...  gpio0:                                  ${\n}
...  ${SPACE*4}13 -> led@0                   ${\n}
...                                          ${\n}
...  button: Miscellaneous.Button @ gpio0 11 ${\n}
...  ${SPACE*4}invert: true                  ${\n}
...  ${SPACE*4}-> gpio0@11                   ${\n}
...                                          ${\n}
...  led: Miscellaneous.LED @ gpio0 13       ${\n}
...  """

*** Keywords ***
Create Machine
    [Arguments]              ${platform}  ${elf}

    Execute Command          mach create
    Execute Command          machine LoadPlatformDescriptionFromString ${platform}

    Execute Command          sysbus LoadELF ${URI}/${elf}

Run ZephyrRTOS Shell
    [Arguments]               ${platform}  ${elf}

    Create Machine            ${platform}  ${elf}
    Create Terminal Tester    ${UART}

    Execute Command           showAnalyzer ${UART}

    Start Emulation
    Wait For Prompt On Uart   uart:~$
    Write Line To Uart        demo ping
    Wait For Line On Uart     pong

*** Test Cases ***
Should Run Bluetooth sample
    Execute Command           emulation CreateBLEMedium "wireless"

    Execute Command           mach create "central"
    Execute Command           machine LoadPlatformDescription @platforms/cpus/nrf52840.repl
    Execute Command           sysbus LoadELF "${CURDIR}/central_hr.elf"
    Execute Command           connector Connect sysbus.radio wireless

    Execute Command           showAnalyzer ${UART}
    ${cen_uart}=  Create Terminal Tester   ${UART}   machine=central

    Execute Command           mach create "peripheral"
    Execute Command           machine LoadPlatformDescription @platforms/cpus/nrf52840.repl
    Execute Command           sysbus LoadELF "${CURDIR}/peripheral_hr.elf"
    Execute Command           connector Connect sysbus.radio wireless

    Execute Command           showAnalyzer ${UART}
    ${per_uart}=  Create Terminal Tester   ${UART}   machine=peripheral

    Execute Command           emulation SetGlobalQuantum "0.00001"

    Start Emulation

    Wait For Line On Uart     Booting Zephyr                    testerId=${cen_uart}
    Wait For Line On Uart     Booting Zephyr                    testerId=${per_uart}

    Wait For Line On Uart     Bluetooth initialized             testerId=${cen_uart}
    Wait For Line On Uart     Bluetooth initialized             testerId=${per_uart}

    Wait For Line On Uart     Scanning successfully started     testerId=${cen_uart}
    Wait For Line On Uart     Advertising successfully started  testerId=${per_uart}

    Wait For Line On Uart     Connected: C0:00:AA:BB:CC:DD      testerId=${cen_uart}
    Wait For Line On Uart     Connected                         testerId=${per_uart}
