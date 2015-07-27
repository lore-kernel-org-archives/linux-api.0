From: Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v9 0/9] Add simple NVMEM Framework via regmap.
Date: Mon, 27 Jul 2015 12:12:47 +0100
Message-ID: <1437995567-11203-1-git-send-email-srinivas.kandagatla@linaro.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, s.hauer-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org, stefan.wahren-eS4NqCHxEME@public.gmane.org, wxt-TNX95d0MmH7DzftRWevZcw@public.gmane.org, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Greg/Kevin,

This patchset adds a new simple NVMEM framework to kernel, and it is tested
with various drivers like "QCOM thermal sensors", "QCOM cpr driver",
"begal bone cape manager" and few more on the way.

Can you please consider this as 4.3 material, AFAIK there are more than 3 drivers
depending on this framework which are wating since last 2 merge windows.

Should these patches go via ARM-SOC tree or via Greg's tree?

Thankyou all for providing inputs and comments on previous versions of this
patchset. Here is the v9 of the patchset addressing all the issues raised as
part of previous versions review.

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

Its also possible to migrate other nvmem drivers to this framework, and I think
some of them already posted patches based on this framework.

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
			bits = <6 128>
		};

		pvs_version: pvs-version@6 {
			reg = <0x6 0x2>
			bit-offset = 7;
			bits = <7 2>
		};

		speed_bin: speed-bin@c{
			reg = <0xc 0x1>;
			bits = <2 3>;

		};
		...
	};
/* Consumer */
	tsens {
		...
		nvmem-cells = <&tsens_calibration>;
		nvmem-cell-names = "calibration";
	};

userspace interface: binary file in /sys/bus/nvmem/devices/*/nvmem

ex:
hexdump /sys/bus/nvmem/devices/qfprom0/nvmem
                                                                                                                                                                                                                  
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
00000a0 db10 2240 0000 e000 0c00 0c00 0000 0c00
0000000 0000 0000 0000 0000 0000 0000 0000 0000
...
*
0001000

Changes since v8 (https://lkml.org/lkml/2015/7/20/352)
 * remove un-necessary header from qfprom, spotted by Stephen Boyd.
 * moved to usage of kcalloc as suggested by Stephen Boyd.
 * used u32 instead of int for cell sizes, suggested by Stefan Wahren
 * Fixed possible null pointer access, spotted by Stephen Boyd.
 * replaced orignal adding of device randomness in sunxi driver,
   spotted by Stefan Wahren.

Changes since v7 (https://lwn.net/Articles/650734/)
 * Fixed various style and documentation reated comments
 from Stephen Boyd, Stephen Wahren and Joe Perches.
 * Fixed read-only flag as suggested by Philipp Zabel
 * Changed bit level bindings as suggesed by Rob Herring.

(Removed long change log to make it readable.)

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
 Documentation/devicetree/bindings/nvmem/nvmem.txt  |   80 ++
 Documentation/devicetree/bindings/nvmem/qfprom.txt |   35 +
 Documentation/nvmem/nvmem.txt                      |  152 +++
 MAINTAINERS                                        |    9 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/misc/eeprom/Kconfig                        |   13 -
 drivers/misc/eeprom/Makefile                       |    1 -
 drivers/misc/eeprom/sunxi_sid.c                    |  156 ---
 drivers/nvmem/Kconfig                              |   39 +
 drivers/nvmem/Makefile                             |   12 +
 drivers/nvmem/core.c                               | 1083 ++++++++++++++++++++
 drivers/nvmem/qfprom.c                             |   85 ++
 drivers/nvmem/sunxi_sid.c                          |  171 ++++
 include/linux/nvmem-consumer.h                     |  157 +++
 include/linux/nvmem-provider.h                     |   47 +
 19 files changed, 1894 insertions(+), 209 deletions(-)
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
 create mode 100644 drivers/nvmem/sunxi_sid.c
 create mode 100644 include/linux/nvmem-consumer.h
 create mode 100644 include/linux/nvmem-provider.h

-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
