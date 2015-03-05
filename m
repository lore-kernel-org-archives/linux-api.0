From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v1 0/6] Add simple EEPROM Framework via regmap.
Date: Thu,  5 Mar 2015 09:44:45 +0000
Message-ID: <1425548685-12887-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, andrew@lunn.ch, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

Thankyou all for providing inputs and comments on RFC patchset.
Here is the v1 of the patchset addressing all the issues raised as
part of RFC review.

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

patch 1-4 Introduces the EEPROM framework.
Patch 5 migrates an existing driver to eeprom framework.
Patch 6 Adds Qualcomm specific qfprom driver.

Its also possible to migrate other eeprom drivers to this framework.
Patch 6 can also be made a generic mmio-eeprom driver.

Providers APIs:
	eeprom_register/unregister();

Consumers APIs:
	eeprom_cell_get()/of_eeprom_cell_get()/of_eeprom_cell_get_byname();
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
		eeproms = <&tsens_calibration>;
		eeprom-names = "calib";
		...
	};

userspace interface:

hexdump /sys/class/eeprom/qfprom0/eeprom
                                                                                                                                                                                                                  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
0000000 0000 0000 0000 0000 0000 0000 0000 0000
...
*
0001000


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

Srinivas Kandagatla (5):
  eeprom: Add a simple EEPROM framework for eeprom providers
  eeprom: Add a simple EEPROM framework for eeprom consumers
  eeprom: Add bindings for simple eeprom framework
  eeprom: qfprom: Add Qualcomm QFPROM support.
  eeprom: Add to MAINTAINERS for eeprom framework

 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 -
 .../devicetree/bindings/eeprom/eeprom.txt          |  70 +++
 MAINTAINERS                                        |   9 +
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/eeprom/Kconfig                             |  38 ++
 drivers/eeprom/Makefile                            |  11 +
 drivers/eeprom/core.c                              | 506 +++++++++++++++++++++
 drivers/eeprom/eeprom-sunxi-sid.c                  | 129 ++++++
 drivers/eeprom/qfprom.c                            |  74 +++
 drivers/misc/eeprom/Kconfig                        |  13 -
 drivers/misc/eeprom/Makefile                       |   1 -
 drivers/misc/eeprom/sunxi_sid.c                    | 156 -------
 include/linux/eeprom-consumer.h                    |  67 +++
 include/linux/eeprom-provider.h                    |  47 ++
 15 files changed, 954 insertions(+), 192 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 create mode 100644 Documentation/devicetree/bindings/eeprom/eeprom.txt
 create mode 100644 drivers/eeprom/Kconfig
 create mode 100644 drivers/eeprom/Makefile
 create mode 100644 drivers/eeprom/core.c
 create mode 100644 drivers/eeprom/eeprom-sunxi-sid.c
 create mode 100644 drivers/eeprom/qfprom.c
 delete mode 100644 drivers/misc/eeprom/sunxi_sid.c
 create mode 100644 include/linux/eeprom-consumer.h
 create mode 100644 include/linux/eeprom-provider.h

-- 
1.9.1
