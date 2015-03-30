From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 00/10] Add simple EEPROM Framework via regmap.
Date: Mon, 30 Mar 2015 22:54:52 +0100
Message-ID: <1427752492-17039-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

Thankyou all for providing inputs and comments on previous versions of this patchset.
Here is the v4 of the patchset addressing all the issues raised as
part of previous versions review.

This patchset adds a new simple EEPROM framework to kernel.

Up until now, EEPROM drivers were stored in drivers/misc, where they all had to
duplicate pretty much the same code to register a sysfs file, allow in-kernel
users to access the content of the devices they were driving, etc.
    
This was also a problem as far as other in-kernel users were involved, since
the solutions used were pretty much different from on driver to another, there
was a rather big abstraction leak.
    
This introduction of this framework aims at solving this. It also introduces DT
representation for consumer devices to go get the data they require (MAC
Addresses, SoC/Revision ID, part numbers, and so on) from the EEPROMs.
    
Having regmap interface to this framework would give much better
abstraction for eeproms on different buses.

patch 1-2 Introduces two regmap helper functions.
patch 3-5 Introduces the EEPROM framework.
Patch 6 Adds helper functions for eeproms based on mmio.
Patch 7 migrates an existing driver to eeprom framework.
Patch 8-9 Adds Qualcomm specific qfprom driver.
Patch 10 adds entry in MAINTAINERS.

Its also possible to migrate other eeprom drivers to this framework.

Providers APIs:
	eeprom_register/unregister();

Consumers APIs:
	eeprom_cell_get()/of_eeprom_cell_get();
	eeprom_cell_put();
	eeprom_cell_read()/eeprom_cell_write();

Device Tree:

	/* Provider */
	qfprom: qfprom@00700000 {
		compatible 	= "qcom,qfprom";
		reg		= <0x00700000 0x1000>;
		...

		/* Data cells */
		tsens_calibration: calib@404 {
			reg = <0x404 0x10>;
		};

		serial_number: sn {
			reg = <0x104 0x4>, <0x204 0x4>, <0x30c 0x4>;

		};
		...
	};
	
	/* Consumer node */
	tsens: tsens {
		...
		calibration = <&tsens_calibration>;
		...
	};

userspace interface: binary file in /sys/class/eeprom/*/eeprom

ex:
hexdump /sys/class/eeprom/qfprom0/eeprom
                                                                                                                                                                                                                  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
0000000 0000 0000 0000 0000 0000 0000 0000 0000
...
*
0001000


Changes since v3(https://lkml.org/lkml/2015/3/24/1066)
 * simplified logic in bin_attr_eeprom_read/write spotted by Mark Brown.
 * moved from using regmap_bulk_read/write to regmap_raw_read/write
 spotted by Mark Brown
 * Fixed return error codes for the dummy wrappers spotted by Sascha Hauer
 * Fixed various error code checks in core spotted by Sascha Hauer.
 * Simplified consumer bindings suggested by Sascha Hauer.
 * Added eeprom-mmio helper functions.

Changes since v2(https://lkml.org/lkml/2015/3/13/168)
 * Fixed error handling in eeprom_register spotted by Mark Brown
 * Added new regmap_get_max_register() and regmap_get_reg_stride().
 * Fixed module build errors reported by kbuild robot.
 * recycle the ids when eeprom provider is released.

Changes since v1(https://lkml.org/lkml/2015/3/5/153)
 * Fix various Licencing issues spotted by Paul Bolle and Mark Brown
 * Allow eeprom core to build as module spotted by Paul Bolle.
 * Fix various kconfig issues spotted by Paul Bolle.
 * remove unessary atomic varible spotted by Mark Brown.
 * Few cleanups and common up some of the code in core.
 * Add qfprom bindings.

Changes since RFC(https://lkml.org/lkml/2015/2/19/307)
 * Fix documentation and error checks in read/write spotted by Andrew Lunn
 * Kconfig fix suggested by Stephen Boyd.
 * Add module owner suggested by Stephen Boyd and others.
 * Fix unsafe handling of eeprom in unregister spotted by Russell and Mark Brown.
 * seperate bindings patch as suggested by Rob.
 * Add MAINTAINERS as suggested by Rob.
 * Added support to allow reading eeprom for things like serial number which
 * canbe scatters across.
 * Added eeprom data using reg property suggested by Sascha and Stephen.
 * Added non-DT support.
 * Move kerneldoc to the src files spotted by Mark Brown.
 * Remove local list and do eeprom lookup by using class_find_device()


Thanks,
srini


Maxime Ripard (1):
  eeprom: sunxi: Move the SID driver to the eeprom framework

Srinivas Kandagatla (9):
  regmap: Introduce regmap_get_max_register.
  regmap: Introduce regmap_get_reg_stride.
  eeprom: Add a simple EEPROM framework for eeprom providers
  eeprom: Add a simple EEPROM framework for eeprom consumers
  eeprom: Add bindings for simple eeprom framework
  eeprom: Add simple eeprom-mmio consumer helper functions.
  eeprom: qfprom: Add Qualcomm QFPROM support.
  eeprom: qfprom: Add bindings for qfprom
  eeprom: Add to MAINTAINERS for eeprom framework

 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 -
 .../bindings/eeprom/allwinner,sunxi-sid.txt        |  21 +
 .../devicetree/bindings/eeprom/eeprom.txt          |  58 +++
 .../devicetree/bindings/eeprom/qfprom.txt          |  34 ++
 .../bindings/misc/allwinner,sunxi-sid.txt          |  17 -
 MAINTAINERS                                        |   9 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/base/regmap/regmap.c                       |  24 +
 drivers/eeprom/Kconfig                             |  36 ++
 drivers/eeprom/Makefile                            |  13 +
 drivers/eeprom/core.c                              | 504 +++++++++++++++++++++
 drivers/eeprom/eeprom-mmio.c                       |  69 +++
 drivers/eeprom/eeprom-mmio.h                       |  41 ++
 drivers/eeprom/qfprom.c                            |  51 +++
 drivers/eeprom/sunxi-sid.c                         |  64 +++
 drivers/misc/eeprom/Kconfig                        |  13 -
 drivers/misc/eeprom/Makefile                       |   1 -
 drivers/misc/eeprom/sunxi_sid.c                    | 156 -------
 include/linux/eeprom-consumer.h                    |  61 +++
 include/linux/eeprom-provider.h                    |  43 ++
 include/linux/regmap.h                             |  14 +
 22 files changed, 1045 insertions(+), 209 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/eeprom/allwinner,sunxi-sid.txt
 create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
 create mode 100644 Documentation/devicetree/bindings/eeprom/qfprom.txt
 delete mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 drivers/eeprom/Kconfig
 create mode 100644 drivers/eeprom/Makefile
 create mode 100644 drivers/eeprom/core.c
 create mode 100644 drivers/eeprom/eeprom-mmio.c
 create mode 100644 drivers/eeprom/eeprom-mmio.h
 create mode 100644 drivers/eeprom/qfprom.c
 create mode 100644 drivers/eeprom/sunxi-sid.c
 delete mode 100644 drivers/misc/eeprom/sunxi_sid.c
 create mode 100644 include/linux/eeprom-consumer.h
 create mode 100644 include/linux/eeprom-provider.h

-- 
1.9.1
