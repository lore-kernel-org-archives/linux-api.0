From: =?iso-8859-1?Q?Cl=E9ment?= Vuchener <clement.vuchener-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RESEND PATCH v3 0/1] Corsair Vengeance K90 driver
Date: Wed, 30 Sep 2015 15:13:23 +0200
Message-ID: <cover.1443618411.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

I have split the special functions between backlight and macro function=
s. This should make it easier to
test new devices. I think the macro functions will only be reused with =
the K95. While backlight is more
common feature, though I have no idea it is done with other Corsair har=
dware.

I have changed most sysfs attributes and LEDs so that the current value=
 is queried from the hardware instead
of tracking events. I started this way when I did not know how to read =
the value, but I think it is better done
this way when I can. I don't know how to read the state of the record L=
ED, so this one still use events to update
the state.

I removed the color from the LEDs name. I understand it is only necessa=
ry when having LEDs with several
colors. This way the names will stay the same across different hardware=
 with different backlight color. I
don't think it is an useful information here.

I also added event for the MR (macro record) button and profile switch =
buttons. I think that userspace
program may want to know about these events. For example for using prof=
ile keys to start some
configuration program.

changes in v3:
 - query the hardware instead of tracking the value with events when po=
ssible (except record_led)
 - added quirks for activating special functions (macro functions and b=
acklight)
 - allocation  of led name use kzalloc instead of devm_kzalloc (free me=
m when initialization failed)
 - renamed led devices (without colors)
 - added key codes for record and profile keys

changes in v2:
 - Removed the k90_profile class and devices
 - Renamed driver for a more generic name ("corsair" driver in hid-cors=
air.c)
 - Fixed led devices clean up (hang when unplugging and led state reset=
)
 - Added dependency on USB and LEDS_CLASS in Kconfig

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
