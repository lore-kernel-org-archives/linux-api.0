From: =?UTF-8?Q?Cl=c3=a9ment_Vuchener?= <clement.vuchener-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/1] Corsair Vengeance K90 driver
Date: Sat, 29 Aug 2015 16:03:21 +0200
Message-ID: <55E1BBA8.9040505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jkosina-IBi9RG/b67k@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

This patch implements a HID driver for the Corsair Vengeance K90 keyboa=
rd.

This keyboard has a backlight, macro keys (G1 to G18) and some other=20
special keys (macro recording, profile switching, changing the light=20
level or disabling the super/meta/"windows logo" keys). The macro=20
playback can be switched between hardware or software (from the driver=20
not a key). Using the generic HID driver, the macro keys and special=20
keys send wrong key code or no key code at all (because of the HID usag=
e=20
code used by the keyboard).
The purpose of this driver is to fix the behaviour of the keys using=20
incorrect HID usage codes and expose the other features to the user spa=
ce.

This is my first Linux driver and I would like to get feedback for both=
=20
my code and my choices for the user space interface.

=46or the keyboard to work in software mode, a user program needs to be=
=20
able to get key events. I am not sure about which key codes should be=20
used for that. I choose the BTN_TRIGGER_HAPPY* as they seem to be used=20
for devices with extra buttons.

The other special keys does send any key codes. They are used to change=
=20
the hardware state and user space should not need them directly.

Playback mode and current profile can be read and written through simpl=
e=20
sysfs attributes.

The backlight is managed through a LED class device.

Hardware macro profiles (there are three of them) are managed thanks to=
=20
devices of the new k90_profile class. Data is sent through binary=20
attributes in the same format sent to the hardware. I choose to do so t=
o=20
keep the driver simple. Should it use a more abstract ABI? Those=20
attributes are write-only as is does not look like there is way to read=
=20
them back (the Windows driver does not do it).

The macro recording is not actually done from hardware and this driver=20
does not implement it. The recording LED has its device, but having it=20
on or pressing the button does not record anything.

Cl=C3=A9ment Vuchener (1):
   Corsair Vengeance K90 driver

  Documentation/ABI/testing/sysfs-class-k90_profile  |  55 ++
  .../ABI/testing/sysfs-driver-hid-corsair-k90       |  15 +
  drivers/hid/Kconfig                                |  10 +
  drivers/hid/Makefile                               |   1 +
  drivers/hid/hid-core.c                             |   1 +
  drivers/hid/hid-corsair-k90.c                      | 690=20
+++++++++++++++++++++
  drivers/hid/hid-ids.h                              |   3 +
  7 files changed, 775 insertions(+)
  create mode 100644 Documentation/ABI/testing/sysfs-class-k90_profile
  create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsair=
-k90
  create mode 100644 drivers/hid/hid-corsair-k90.c

--=20
2.4.3
