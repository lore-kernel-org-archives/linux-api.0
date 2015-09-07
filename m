From: =?iso-8859-1?Q?Cl=E9ment?= Vuchener <clement.vuchener@gmail.com>
Subject: [PATCH v2 0/1] Corsair Vengeance K90 driver
Date: Mon, 7 Sep 2015 17:58:36 +0200
Message-ID: <cover.1441641275.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-input-owner@vger.kernel.org
To: jikos@kernel.org
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

I removed the k90_profile class completely. I cannot write a good enoug=
h ABI with what I know of the keyboard so I am leaving that part out of=
 the kernel. If I change my mind in the future, it will be done in anot=
her patch.

I also fixed a bug I had when unregistering the led device. Work was be=
ing scheduled after the led device was unregistered.

On the name change, I kept a lot of K90 references. As far as I know, t=
he only similar keyboard is the K60 that shares the same firmware but d=
oes not have all the special keys and backlight, and for which the hid-=
generic driver should be enough. The more recent RGB keyboard series us=
es a different protocol from what I have seen from the unofficial users=
pace driver (CKB from MSC).

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
 drivers/hid/hid-corsair.c                          | 555 +++++++++++++=
++++++++
 drivers/hid/hid-ids.h                              |   3 +
 6 files changed, 585 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsair
 create mode 100644 drivers/hid/hid-corsair.c

--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-input" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
