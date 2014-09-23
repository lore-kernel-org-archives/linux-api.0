From: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v3 0/8] Add initial support for DA9150 Charger & Fuel-Gauge IC
Date: Tue, 23 Sep 2014 11:53:17 +0100
Message-ID: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch set adds initial support for the Dialog DA9150 Integrated Charger &
Fuel-Gauge IC. The device also provides GPIO and GPADC functionality.

In this patch set the following is provided:
 - MFD Core support and DT bindings documentation.
 - IIO GPADC support and DT bindings documentation.
 - Power Supply Charger support and DT bindings documentation.
 - Update to MAINTAINERS file to add DA9150 files to Dialog support list.
 - Update to IIO ABI document to add info regarding input current readings.

To keep patch submission from being too large, support for GPIO and Fuel-Gauge
will come after initial support patches are accepted.

This patch set is baselined against the v3.17-rc6 kernel version.


Changes in v3:
- IRQ register and remove helper functions removed from MFD, deemed unnecessary.
  Drivers using helper functions updated to use direct calls to relevant
  kernel framework functions.
- MFD I2C file removed and code folded into -core file as requested.
- MFD core now buildable as driver module.
- Platform data structure definition moved into core header, pdata.h removed.
- Update functions in GPADC driver to be static, where appropriate.
- Change units of GPADC readings to match ABI documentation. Updates to charger
  driver also made to align with this modification.
- Refactor GPADC temp calculations to use scale & offset method.
- Scale values now returned as FRACTIONAL to allow for accurate conversion in
  user-space.
- Tidy up of GPADC scale, offset and raw functions to return from case statements
  with correct return types.
- Update GPADC channel macros naming to prefix with DA9150, prevent conflict.
- GPADC GPIO voltage readings actually in 6V range, updated accordingly.
- Addition to IIO ABI document to add details on input current readings.
- Small style updates to address comments.

Changes in v2:
 - Drop devicetree prefix patch as this is being dealt with separately.
 - IIO framework fix patch removed from set, has already been accepted/merged.
 - Use __ instead of _ for protecting #ifdefs in headers.
 - Moved private data & definitions to source files and remove unwanted headers.
 - Bug fix to EXPORT_SYMBOL for common functions in MFD core used by
   sub-devices, so they can be correctly built as kernel modules.
 - Removed unnecessary channels from GPADC IIO driver to simplify code.
 - For GPADC IIO driver, VBAT reading now provides scale and offset values as it
   is a linear scale.
 - GPADC read code refactored to make it tidier.
 - Remove use of flag to indicate GPADC availability. IIO framework should
   indicate need to defer if it's not yet instantiated.
 - Unwanted comments removed.
 - Removed conditional shutdown of device (Charger/MFD) as this is not needed.
 - Removed AC type supply from charger as device cannot differentiate. Now just
   uses USB supply type.
 - Removed use of invalid-tbat flag from platform data as it doesn't really add
   anything to the driver except forcing battery present status.
 - Bug fix for checking of usb_phy validity in Charger probe() function.
 - Addition of common IRQ release function to allow sub-devices to explicitly
   tidy up IRQs when devm clean up is too late.
 - Improved tidy up of resources in charger.
 - Fix location of IIO GPADC related devicetree binding document so it now
   resides correctly under 'adc' directory.
 - Add update to MAINTAINERS file to include these files in Dialog support list.

Adam Thomson (8):
  mfd: Add support for DA9150 combined charger & fuel-gauge device
  mfd: da9150: Add DT binding documentation for core
  iio: Add support for DA9150 GPADC
  iio: da9150: Add DT binding documentation for GPADC
  power: Add support for DA9150 Charger
  power: da9150: Add DT binding documentation for charger
  MAINTAINERS: Include DA9150 files in Dialog Semiconductor support
    list.
  iio: Add ABI documentation for input current readings

 Documentation/ABI/testing/sysfs-bus-iio            |   17 +
 .../devicetree/bindings/iio/adc/da9150-gpadc.txt   |   16 +
 Documentation/devicetree/bindings/mfd/da9150.txt   |   41 +
 .../devicetree/bindings/power/da9150-charger.txt   |   26 +
 MAINTAINERS                                        |    4 +
 drivers/iio/adc/Kconfig                            |    9 +
 drivers/iio/adc/Makefile                           |    1 +
 drivers/iio/adc/da9150-gpadc.c                     |  406 +++++++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    2 +-
 drivers/mfd/da9150-core.c                          |  413 +++++++
 drivers/power/Kconfig                              |   12 +
 drivers/power/Makefile                             |    1 +
 drivers/power/da9150-charger.c                     |  740 +++++++++++++
 include/linux/mfd/da9150/core.h                    |   68 ++
 include/linux/mfd/da9150/registers.h               | 1155 ++++++++++++++++++++
 16 files changed, 2922 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/da9150.txt
 create mode 100644 Documentation/devicetree/bindings/power/da9150-charger.txt
 create mode 100644 drivers/iio/adc/da9150-gpadc.c
 create mode 100644 drivers/mfd/da9150-core.c
 create mode 100644 drivers/power/da9150-charger.c
 create mode 100644 include/linux/mfd/da9150/core.h
 create mode 100644 include/linux/mfd/da9150/registers.h

--
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
