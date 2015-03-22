From: NeilBrown <neil@brown.name>
Subject: [PATCH 00/14] Enhance twl4030_charger functionality. - V2
Date: Mon, 23 Mar 2015 10:20:28 +1100
Message-ID: <20150322231635.23789.70149.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, GTA04 owners <gta04-owner@goldelico.com>, inux-pm@vger.kernel.org, Pavel Machek <pavel@ucw.cz>, linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
List-Id: linux-api@vger.kernel.org

Hi Sebastian,
 here is V2 of my patches to improve the twl4030 charger.
 They include improved documentation and removal of changes
 to the CVENAC bit which I didn't properly understand.

 One patch needs to make a change in drivers/mfd, and that has
 been acked by Lee Jones.

Summary from before:
These patches make a number of improvements to twl4030_charger.

Some are just internal cleanups (e.g. use of devres).  Others allow
better control of charging through both manual and automatic means.

- the maximum current can be configured via sysfs.
- the charger will only draw that current if it can do so without
  the voltage dropping too much
- a 'continuous' mode is available which ignores voltage and just
  takes what it can (to be used with caution, but very useful in
  some circumstances).
- 'ac' and 'usb' power sources can be configured separately.


Thanks,
NeilBrown

---

NeilBrown (14):
      twl4030_charger: use devm_request_threaded_irq
      twl4030_charger: use devres for power_supply_register and kzalloc.
      twl4030_charger: use runtime_pm to keep usb phy active while charging.
      twl4030_charger: trust phy to determine when USB power is available.
      twl4030_charger: split uA calculation into a function.
      twl4030_charger: allow fine control of charger current.
      twl4030_charger: distinguish between USB current and 'AC' current
      twl4030_charger: allow max_current to be managed via sysfs.
      twl4030_charger: only draw USB current as negotiated with host.
      twl4030_charger: enable manual enable/disable of usb charging.
      twl4030_charger: add software controlled linear charging mode.
      twl4030_charger: add ac/mode to match usb/mode
      twl4030_charger: Increase current carefully while watching voltage.
      twl4030_charger: assume a 'charger' can supply maximum current.


 .../ABI/testing/sysfs-class-power-twl4030          |   45 ++
 drivers/mfd/twl-core.c                             |    9 
 drivers/power/twl4030_charger.c                    |  573 +++++++++++++++++---
 3 files changed, 536 insertions(+), 91 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-power-twl4030

--
Signature
