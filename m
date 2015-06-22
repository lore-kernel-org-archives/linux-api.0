From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v6 0/9] Add simple NVMEM Framework via regmap.
Date: Tue, 23 Jun 2015 00:07:39 +0100
Message-ID: <1435014459-26138-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Mark Brown <broonie@kernel.org>, s.hauer@pengutronix.de, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org, pantelis.antoniou@konsulko.com, mporter@konsulko.com, stefan.wahren@i2se.com, wxt@rock-chips.com, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
List-Id: linux-api@vger.kernel.org

Thankyou all for providing inputs and comments on previous versions of this
patchset. Here is the v6 of the patchset addressing all the issues raised as
part of previous versions review.

This patchset adds a new simple NVMEM framework to kernel, and it is tested
with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
"begal bone cape manager" and few more on the way.

Greg KH,
 Is it possible to take these patches via your tree Or do you think it
 should go via ARM-SOC tree?

Up until now, NVMEM drivers like eeprom were stored in drivers/misc, where they
all had to duplicate pretty much the same code to register a sysfs file, allow
in-kernel users to access the content of the devices they were driving, etc.
    
This was also a problem as far as other in-kernel users were involved, since
the solutions used were pretty much different from on driver to another, there
was a rather big abstraction leak.
    
Introduction of this framework aims at solving this. It also introduces DT
representation for consumer devices to go get the data they require (MAC
Addresses, SoC/Revision ID, part numbers, and so on) from the NVMEMs.
    
After learning few things about QCOM qfprom and other eeprom/efuses, which
has packed fields at bit level. Which makes it important to add support to
such memories. This version adds support to this type of non volatile
memories by adding support to bit level nvmem-cells.

Having regmap interface to this framework would give much better
abstraction for nvmems on different buses.

patch 1-4 Introduces the NVMEM framework.
Patch 5-6 Adds Qualcomm specific qfprom driver.
Patch 7 migrates an existing driver to nvmem framework.
Patch 8 adds entry in MAINTAINERS.

Its also possible to migrate other nvmem drivers to this framework.

Providers APIs:
	nvmem_register/unregister();

Consumers APIs:
Cell based apis for both DT/Non-DT:
	nvmem_cell_get()/nvmem_cell_put();
	devm_nvmem_cell_get()/devm_nvmem_cell_put();
	of_nvmem_cell_get()
	nvmem_cell_read()/nvmem_cell_write();

Raw byte access apis for both DT/non-DT.
	nvmem_device_get()/nvmem_device_put()
	devm_nvmem_device_get()/nvmem_device_put()
	of_nvmem_device_get()

	nvmem_device_read()/nvmem_device_write();
	nvmem_device_cell_read()/nvmem_device_cell_write();

Device Tree:

	/* Provider */
	qfprom: qfprom@00700000 {
		...

		/* Data cells */
		tsens_calibration: calib@404 {
			reg = <0x404 0x10>;
		};

		tsens_calibration_bckp: calib_bckp@504 {
			reg = <0x504 0x11>;
			bit-offset = 6;
			nbits = 128;
		};

		pvs_version: pvs-version@6 {
			reg = <0x6 0x2>
			bit-offset = 7;
			nbits = 2;
		};

		speed_bin: speed-bin@c{
			reg = <0xc 0x1>;
			bit-offset = 2;
			nbits	= 3;

		};
		...
	};

userspace interface: binary file in /sys/class/nvmem/*/nvmem

ex:
hexdump /sys/class/nvmem/qfprom0/nvmem
                                                                                                                                                                                                                  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
0000000 0000 0000 0000 0000 0000 0000 0000 0000
...
*
0001000

Changes since v5(https://lkml.org/lkml/2015/5/21/643)
 * skipped regmap patches which are already merged by Mark.
 * Fixed lot of style related comments by Stephen.
 * Fixed sunxi driver.
 * added devm_* variants requested by Stephen.
 * added of_* variants requested by Pantelis Antoniou
 * added read_only options for non-dt drivers.
 * added basic how-to doc.

Changes since v4(https://lkml.org/lkml/2015/3/30/725)
 * rename eeprom to nvmem suggested by Matt Porter
 * added bit level support to nvmem cells, if not framework is
 	not usable for qcom platforms.
 * removed ternary operator shortcut suggested by Mark B.
 * unified consumer/provider apis for both DT and non-DT.
 * added name support for cell.
 * added bit level bindings.
 * added read-only support suggested by Matt Porter and others.
 * added new nvmem_device based consumer apis.

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
  nvmem: sunxi: Move the SID driver to the nvmem framework

Srinivas Kandagatla (8):
  nvmem: Add a simple NVMEM framework for nvmem providers
  nvmem: Add a simple NVMEM framework for consumers
  nvmem: Add nvmem_device based consumer apis.
  nvmem: Add bindings for simple nvmem framework
  Documentation: nvmem: add nvmem api level and how-to doc
  nvmem: qfprom: Add Qualcomm QFPROM support.
  nvmem: qfprom: Add bindings for qfprom
  nvmem: Add to MAINTAINERS for nvmem framework

 Documentation/ABI/testing/sysfs-driver-sunxi-sid   |   22 -
 .../bindings/misc/allwinner,sunxi-sid.txt          |   17 -
 .../bindings/nvmem/allwinner,sunxi-sid.txt         |   21 +
 Documentation/devicetree/bindings/nvmem/nvmem.txt  |   85 ++
 Documentation/devicetree/bindings/nvmem/qfprom.txt |   35 +
 Documentation/nvmem/nvmem.txt                      |  151 +++
 MAINTAINERS                                        |    9 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/misc/eeprom/Kconfig                        |   13 -
 drivers/misc/eeprom/Makefile                       |    1 -
 drivers/misc/eeprom/sunxi_sid.c                    |  156 ---
 drivers/nvmem/Kconfig                              |   36 +
 drivers/nvmem/Makefile                             |   12 +
 drivers/nvmem/core.c                               | 1069 ++++++++++++++++++++
 drivers/nvmem/qfprom.c                             |   89 ++
 drivers/nvmem/sunxi-sid.c                          |  160 +++
 include/linux/nvmem-consumer.h                     |  154 +++
 include/linux/nvmem-provider.h                     |   48 +
 19 files changed, 1872 insertions(+), 209 deletions(-)
 delete mode 100644 Documentation/ABI/testing/sysfs-driver-sunxi-sid
 delete mode 100644 Documentation/devicetree/bindings/misc/allwinner,sunxi-sid.txt
 create mode 100644 Documentation/devicetree/bindings/nvmem/allwinner,sunxi-sid.txt
 create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem.txt
 create mode 100644 Documentation/devicetree/bindings/nvmem/qfprom.txt
 create mode 100644 Documentation/nvmem/nvmem.txt
 delete mode 100644 drivers/misc/eeprom/sunxi_sid.c
 create mode 100644 drivers/nvmem/Kconfig
 create mode 100644 drivers/nvmem/Makefile
 create mode 100644 drivers/nvmem/core.c
 create mode 100644 drivers/nvmem/qfprom.c
 create mode 100644 drivers/nvmem/sunxi-sid.c
 create mode 100644 include/linux/nvmem-consumer.h
 create mode 100644 include/linux/nvmem-provider.h

-- 
1.9.1
