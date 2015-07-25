From: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: [RFC ebeam PATCH v2 0/2] Add a new USB eBeam input driver
Date: Sat, 25 Jul 2015 20:48:23 +0200
Message-ID: <1437850105-4814-1-git-send-email-yann.cantin@laposte.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, oneukum-IBi9RG/b67k@public.gmane.org, Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

New USB input driver for eBeam devices.

Notable stuff :
- need userspace gui tool for calibration (ebeam.tuxfamily.org)
- This driver breaks Luidia's proprietary application suite.

Patch 1 to blacklist the devices for hid generic-usb.

Patch 2 is the actual driver.

Changes :
RFC https://lkml.org/lkml/2015/7/20/634 : Use DEVICE_ATTR_RW()
RFC https://lkml.org/lkml/2015/7/21/107 : move usb id definitions out of ebeam.c
RFC https://lkml.org/lkml/2015/7/20/657 : Fix ABI documentation

Thanks for your help.


Yann Cantin (2):
hid: Blacklist eBeam devices
input: misc: New USB eBeam input driver

Documentation/ABI/testing/sysfs-driver-ebeam |  53 ++
drivers/hid/hid-core.c                       |   6 +
drivers/hid/hid-ids.h                        |   6 +
drivers/input/misc/Kconfig                   |  22 +
drivers/input/misc/Makefile                  |   1 +
drivers/input/misc/ebeam.c                   | 759 +++++++++++++++++++++++++++
6 files changed, 847 insertions(+)
create mode 100644 Documentation/ABI/testing/sysfs-driver-ebeam
create mode 100644 drivers/input/misc/ebeam.c

--
2.3.8
