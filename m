From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v7 0/8] charger/mfd: max14577: Add support for MAX77836
Date: Wed, 24 Sep 2014 11:03:25 +0100
Message-ID: <20140924100325.GB19999@lee--X1>
References: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-pm@vger.kernel.org, Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Kyungmin Park <kyungmin.park@samsung.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Mark, Sebastian,

The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb=
42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-re=
gulator-power-v3.17

for you to fetch changes up to f453d80f908254293bf453a2d7e68974e2abc2af=
:

  Documentation: charger: max14577: Document exported sysfs entry (2014=
-09-24 10:58:07 +0100)

----------------------------------------------------------------
Immutable branch between MFD, Regulator and Power due for v3.17

----------------------------------------------------------------
Krzysztof Kozlowski (8):
      mfd: max14577: Add defines for MAX77836 charger
      mfd: max14577: Map charger device to its own of_node
      charger: max14577: Add support for MAX77836 charger
      regulator/mfd: max14577: Export symbols for calculating charger c=
urrent
      charger: max14577: Configure battery-dependent settings from DTS =
and sysfs
      power: max17040: Add ID for MAX77836 Fuel Gauge block
      devicetree: mfd: max14577: Add device tree bindings document
      Documentation: charger: max14577: Document exported sysfs entry

 Documentation/ABI/testing/sysfs-class-power        |  14 +
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
 drivers/mfd/max14577.c                             | 100 +++++-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/max14577_charger.c                   | 370 +++++++++++++=
++++++--
 drivers/power/max17040_battery.c                   |   3 +-
 drivers/regulator/max14577.c                       |  80 +----
 include/linux/mfd/max14577-private.h               |  95 ++++--
 include/linux/mfd/max14577.h                       |  30 ++
 9 files changed, 704 insertions(+), 139 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
