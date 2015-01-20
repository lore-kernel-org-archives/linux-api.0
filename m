From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 0/5] power: Add max77693 charger driver
Date: Tue, 20 Jan 2015 11:00:51 +0100
Message-ID: <1421748056-25735-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Dear Sebastian,


You already acked some earlier version of this patch. In that time
there were more dependencies on MFD tree. Now the MFD patch (2/5)
is acked by Lee Jones so could you pick up everything?


Changes since v4
================
1. Add patch 5/5: Update MAINTAINERS (with Sebastian's ack [2]).

Changes since v3
================
1. Patch 3/4: Don't create platform data structure for charger settings
   because driver won't be used on non-DT SoCs (its for Exynos based
   Trats2).
2. Patch 3/4: Drop Sebastian's ack [1] because of change above.

Changes since v2
================
1. Add ack from Sebastian Reichel (charger driver).
2. Drop patch "mfd: max77693: Map charger device to its own of_node"
   (applied by Lee Jones).


Changes since v1
================
1. Add patch 2/5: mfd: max77693: Map charger device to its own of_node
   (forgot to send it in v1)
2. Remove patches for DTS and configs. I'll send them later.
3. Add ack from Lee Jones (patch 3/5).


Description
===========
The patchset adds max77693 charger driver present on Trats2 board
(and Galaxy S III). The driver configures battery charger and exposes
power supply interface.

Driver is necessary to provide full charging stack on Trats2 device
(extcon, charger-manager etc.).

[1] https://lkml.org/lkml/2014/10/27/774
[2] https://lkml.org/lkml/2015/1/16/464


Best regards,
Krzysztof


Krzysztof Kozlowski (5):
  devicetree: power/mfd: max77693: Document new bindings for charger
  mfd: max77693: Add defines for MAX77693 charger driver
  power: max77693: Add charger driver for Maxim 77693
  Documentation: power: max77693-charger: Document exported sysfs entry
  MAINTAINERS: Add entry for Maxim chargers on Samsung boards

 Documentation/ABI/testing/sysfs-class-power        |  42 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |  45 ++
 MAINTAINERS                                        |   7 +
 drivers/power/Kconfig                              |   6 +
 drivers/power/Makefile                             |   1 +
 drivers/power/max77693_charger.c                   | 758 +++++++++++++++++++++
 include/linux/mfd/max77693-private.h               | 108 +++
 7 files changed, 967 insertions(+)
 create mode 100644 drivers/power/max77693_charger.c

-- 
1.9.1
