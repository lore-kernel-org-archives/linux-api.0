From: Andreas Dannenberg <dannenberg@ti.com>
Subject: [PATCH v8 00/14] power: bq24257: Add support for bq24250/bq24251
Date: Mon, 28 Sep 2015 17:33:48 -0500
Message-ID: <1443479642-23712-1-git-send-email-dannenberg@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>, David Woodhouse <dwmw2@infradead.org>, Laurentiu Palcu <laurentiu.palcu@intel.com>, Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Ramakrishna Pallala <ramakrishna.pallala@intel.com>, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, linux-api@vger.kernel.org, Andreas Dannenberg <dannenberg@ti.com>
List-Id: linux-api@vger.kernel.org

This patch series extends the driver to also support bq24250/bq24251.

The bq24250/251/257 devices have a very similar feature set and are
virtually identical from a control register point of view so it made
sense to extend the existing driver rather than submitting a new driver.
In addition to the new device support the driver is also extended to
allow access to some device features previously hidden. Basic and
potentially dangerous charger config parameters affecting the actual
charging of the Li-Ion battery are only configurable through firmware
rather than sysfs properties. However some newly introduced properties
are exposed through sysfs properties as access to them may be desired
from userspace. For example, it is now possible to manually configure
the maximum current drawn from the input source to accommodate different
chargers (0.5A, 1.5A, 2.0A and so on) based on system knowledge a
userspace application may have rather than rely on the auto-detection
mechanism that may not work in all possible scenarios.

Note that most patches have dependencies on other patches in the series.

v8:
- Rebased onto Sebastian's "next" tree and dropped the "power: bq24257:
  Remove IRQ config through stat-gpios" patch from the series as it's
  already present
- Reworded ti,current-limit DT doc description
- Removed linux/gpio.h include from the platform data patch
- Successfully re-tested the patch that implements the use of the
  managed power supply register functions regarding possible side
  effects and updated the patch's comment for better clarity. Also
  updated the description of that patch to explain the "why".
- Added handling of -EPROBE_DEFER during GPIO pin probe. This error now
  leads to an abort of the driver probe and the Kernel will re-try to
  probe the driver later (successfully tested).
- Added some of the previous Reviewed-by's from Laurentiu and Krzysztof
  (only if there were trivial changes stemming from the discussions or
  no changes at all)

v7:
- Fixed an issue that would have impacted running bisect on the series
  and double checked the entire series builds one by one by running
  a git rebase -i --exec="make ..." ... on the Kernel tree
- Minor simplification of a return from a function

v6:
- Removed the ability to configure the IRQ through "stat-gpios"
- Allow re-configuring the input_current_limit via sysfs also when
  charger auto-detection is enabled
- Use gpiod interface for initialization as a platform device (nice
  GPIO setup simplification)
- Document all newly introduced sysfs nodes
- Streamlined/fixed/simplified charger state handling as it relates
  to battery removal/insertion and the associated handling of the
  input current limit setting
- Minor simplifications/cleanup
- Rebased onto git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-
  power-supply.git (branch "next") and completely retested

v5:
- Added patch to use the managed version of power supply register which
  also fixes a code flow issue that was introduced
- Minor fixes / consistency cleanup (Krzysztof's feedback)

v4:
- Removed configurability of the safety timer multiplier through DT

v3:
- Dropped the driver/symbol rename patch from v2 due to anticipated
  issues with upcoming bq2425x family additions
- Reverted additional mutex coverage for I2C access due to regmap
  built-in mutex protection being sufficient
- Removed support for trickle charging due to being a rare/uncommon
  use case
- Fixed most checkpatch.pl --strict alignment issues (except where
  the line length would exceed 80 chars)
- Fixed an issue with how the return value of gpio_to_desc() was
  handled
- Fixed an issue with the definition of bq24257_of_match[]
- Reordered the patch series to put the DT doc changes to the
  beginning

v2:
- Aligned DT bindings better with existing "ti,*" charger bindings
- Dropped patch that improperly reported a missing battery as a dead
  battery
- Fixed (hopefully, that is -- still waiting for my test platform)
  issue with how the private ACPI driver_data used to identify which
  bq2425x device to use
- Removed boolean DT/ACPI properties mostly by replacing them with more
  intelligent handling in the driver
- Rework/clarification of DT bindings doc
- Renamed/refactored filenames/symbols from bq24257 to bq2425x to
  better reflect that multiple devices are covered. Despite initial
  hesitation I feel this is a good opportunity for some clean-up as
  the driver is still very new in the Kernel so the change should be
  low risk. This also addresses one of Andrew Davis' feedback items.
  Plus, it makes for a nice alignment with the existing bq2415x_charger
  driver.

v1:
- Initial submission

Andreas Dannenberg (14):
  dt: power: bq24257-charger: Cover additional devices
  power: bq24257: Streamline input current limit setup
  power: bq24257: Use managed power supply register
  power: bq24257: Simplify bq24257_power_supply_init()
  power: bq24257: Add basic support for bq24250/bq24251
  power: bq24257: Add bit definition for temp sense enable
  power: bq24257: Allow manual setting of input current limit
  power: bq24257: Add SW-based approach for Power Good determination
  power: bq24257: Add over voltage protection setting support
  power: bq24257: Add input DPM voltage threshold setting support
  power: bq24257: Allow input current limit sysfs access
  power: bq24257: Add various device-specific sysfs properties
  power: bq24257: Add platform data based initialization
  Documentation: power: bq24257: Document exported sysfs entries

 Documentation/ABI/testing/sysfs-class-power        |  58 +++
 .../devicetree/bindings/power/bq24257.txt          |  53 ++-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/bq24257_charger.c                    | 506 ++++++++++++++++++---
 include/linux/power/bq24257_charger.h              |  25 +
 5 files changed, 583 insertions(+), 64 deletions(-)
 create mode 100644 include/linux/power/bq24257_charger.h

-- 
1.9.1

