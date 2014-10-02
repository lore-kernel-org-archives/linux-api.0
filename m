From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/7] power/mfd: Add max77693 charger driver
Date: Thu, 02 Oct 2014 14:22:01 +0200
Message-ID: <1412252528-30148-1-git-send-email-k.kozlowski@samsung.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>, Javier Martinez Canillas <javier.martinez@collabora.co.uk>, linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Tomasz Figa <tomasz.figa@gmail.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
List-Id: linux-api@vger.kernel.org

Hi,


The patchset adds max77693 charger driver present on Trats2 board
(and Galaxy S III). The driver configures battery charger and exposes
power supply interface.

Driver is necessary to provide full charging stack on Trats2 device
(extcon, charger-manager etc.).

The first 2 patches depend on each other but the rest (documentation,
DTS, defconfigs) can be pulled independently.

Everything rebased on next-20140926.


P.S. Unfortunately the pathset touches defconfigs, dts and documentation
(new bindings) so the recipients list is huge. Sorry for that.


Best regards,
Krzysztof

Krzysztof Kozlowski (7):
  mfd: max77693: Add defines for MAX77693 charger driver
  power: max77693: Add charger driver for Maxim 77693
  devicetree: mfd: max77693: Document new bindings for charger
  Documentation: charger: max77693: Document exported sysfs entry
  ARM: dts: exynos4412-trats: Add max77693 charger node
  ARM: exynos_defconfig: Enable Maxim 77693 charger
  ARM: multi_v7_defconfig: Enable Maxim 77693 charger

 Documentation/ABI/testing/sysfs-class-power        |  42 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |  46 ++
 arch/arm/boot/dts/exynos4412-trats2.dts            |  10 +
 arch/arm/configs/exynos_defconfig                  |   1 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/power/Kconfig                              |   6 +
 drivers/power/Makefile                             |   1 +
 drivers/power/max77693_charger.c                   | 763 +++++++++++++++++++++
 include/linux/mfd/max77693-private.h               | 108 +++
 include/linux/mfd/max77693.h                       |   8 +
 10 files changed, 986 insertions(+)
 create mode 100644 drivers/power/max77693_charger.c

-- 
1.9.1

