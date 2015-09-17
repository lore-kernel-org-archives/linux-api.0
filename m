From: =?us-ascii?B?PT9VVEYtOD9xP0NsPUMzPUE5bWVudD0yMFZ1Y2hlbmVyPz0=?=
	<clement.vuchener@gmail.com>
Subject: [PATCH v3 0/1] Corsair Vengeance K90 driver
Date: Thu, 17 Sep 2015 13:41:25 +0200
Message-ID: <cover.1442489376.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jikos@kernel.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

I have split the special functions between backlight and macro function=
s. This should make it easier to test new devices. I think the macro fu=
nctions will only be reused with the K95. While backlight is more commo=
n feature, though I have no idea it is done with other Corsair hardware=
=2E

I have changed most sysfs attributes and LEDs so that the current value=
 is queried from the hardware instead of tracking events. I started thi=
s way when I did not know how to read the value, but I think it is bett=
er done this way when I can. I don't know how to read the state of the =
record LED, so this one still use events to update the state.

I removed the color from the LEDs name. I understand it is only necessa=
ry when having LEDs with several colors. This way the names will stay t=
he same across different hardware with different backlight color. I don=
't think it is an useful information here.

I also added event for the MR (macro record) button and profile switch =
buttons. I think that userspace program may want to know about these ev=
ents. For example for using profile keys to start some configuration pr=
ogram.

changes in v3:
- query the hardware instead of tracking the value with events when pos=
sible (except record_led)
- added quirks for activating special functions (macro functions and ba=
cklight)
- allocation  of led name use kzalloc instead of devm_kzalloc (free mem=
 when initialization failed)
- renamed led devices (without colors)
- added key codes for record and profile keys

Cl=E9ment Vuchener (1):
  Add Corsair Vengeance K90 driver

 Documentation/ABI/testing/sysfs-driver-hid-corsair |  15 +
 drivers/hid/Kconfig                                |  10 +
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-corsair.c                          | 673 +++++++++++++=
++++++++
 drivers/hid/hid-ids.h                              |   3 +
 6 files changed, 703 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsair
 create mode 100644 drivers/hid/hid-corsair.c

--=20
2.4.3
