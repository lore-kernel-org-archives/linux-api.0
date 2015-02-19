From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [RFC PATCH 0/3] Add simple EEPROM Framework via regmap.
Date: Thu, 19 Feb 2015 17:07:19 +0000
Message-ID: <1424365639-26634-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Kumar Gala <galak@codeaurora.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>, broonie@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

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

patch 1 Introduces the EEPROM framework.
Patch 2 migrates an existing driver to eeprom framework.
Patch 3 Adds Qualcomm specific qfprom driver.

Its also possible to migrate other eeprom drivers to this framework.
Patch 3 can also be made a generic mmio-eeprom driver.

Providers APIs:
	eeprom_register/unregister();

Consumers APIs:
	eeprom_cell_get()/eeprom_cell_get_byname();
	eeprom_cell_read()/eeprom_cell_write();

Device Tree:
	qfprom: qfprom@00700000 {
		#eeprom-cells = <2>;
		compatible 	= "qcom,qfprom";
		reg		= <0x00700000 0x1000>;
	};

	tsens: tsens {
		...
		eeproms = <&qfprom 0x404 0x10>, <&qfprom 0x414 0x10>;
		eeprom-names = "calib", "backup_calib";
		...
	};

userspace interface:

	hexdump /sys/class/eeprom/eeprom0/eeprom
                                                                                                                                                                                                                  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
0000000 0000 0000 0000 0000 0000 0000 0000 0000
...
*
0001000


Thanks,
srini

Maxime Ripard (2):
  eeprom: Add a simple EEPROM framework
  eeprom: sunxi: Move the SID driver to the eeprom framework

Srinivas Kandagatla (1):
  eeprom: qfprom: Add Qualcomm QFPROM support.

 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |  22 --
 .../devicetree/bindings/eeprom/eeprom.txt          |  48 ++++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/eeprom/Kconfig                             |  35 +++
 drivers/eeprom/Makefile                            |  11 +
 drivers/eeprom/core.c                              | 290 +++++++++++++++++++++
 drivers/eeprom/eeprom-sunxi-sid.c                  | 125 +++++++++
 drivers/eeprom/qfprom.c                            |  75 ++++++
 drivers/misc/eeprom/Kconfig                        |  13 -
 drivers/misc/eeprom/Makefile                       |   1 -
 drivers/misc/eeprom/sunxi_sid.c                    | 156 -----------
 include/linux/eeprom-consumer.h                    |  73 ++++++
 include/linux/eeprom-provider.h                    |  51 ++++
 14 files changed, 711 insertions(+), 192 deletions(-)
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
