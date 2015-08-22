From: Yann Cantin <yann.cantin@laposte.net>
Subject: [ebeam PATCH v2 0/2] Add a new USB eBeam input driver
Date: Sun, 23 Aug 2015 00:06:02 +0200
Message-ID: <1440281164-23111-1-git-send-email-yann.cantin@laposte.net>
Return-path: <linux-input-owner@vger.kernel.org>
Sender: linux-input-owner@vger.kernel.org
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz, gregkh@linuxfoundation.org, oneukum@suse.com, Yann Cantin <yann.cantin@laposte.net>
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

