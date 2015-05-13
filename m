From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH 0/5] The Beaglebone capemanager
Date: Wed, 13 May 2015 10:59:40 +0300
Message-ID: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?UTF-8?q?Beno=C3=AEt=20Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

This patchset introduces the beaglebone capemanager.
It allows seamless support for plugin boards for the beaglebone
family of boards via means of automatically loaded device tree
overlays.

For the EEPROM access it performs it is dependent on
Srinivas Kandagatla's EEPROM framework as posted in
https://lkml.org/lkml/2015/3/30/731.

The patch that adds the EEPROM framework interface to the at24
driver has been posted today and the subject line is:
"i2c: eeprom: at24: Provide an EEPROM framework interface"

The first patch contains the driver itself, while the rest
are just documentation entries and MAINTAINERS file updates.

Pantelis Antoniou (5):
  misc: Beaglebone capemanager
  doc: misc: Beaglebone capemanager documentation
  doc: dt: beaglebone cape manager bindings.
  doc: ABI: bone_capemgr sysfs API
  MAINTAINERS: Beaglebone capemanager maintainer

 .../testing/sysfs-devices-platform-bone_capemgr    |   63 +
 .../devicetree/bindings/misc/bone_capemgr.txt      |  123 ++
 Documentation/misc-devices/bone_capemgr.txt        |   63 +
 MAINTAINERS                                        |    8 +
 drivers/misc/Kconfig                               |   10 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/bone_capemgr.c                        | 1926 ++++++++++++++++++++
 7 files changed, 2194 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-bone_capemgr
 create mode 100644 Documentation/devicetree/bindings/misc/bone_capemgr.txt
 create mode 100644 Documentation/misc-devices/bone_capemgr.txt
 create mode 100644 drivers/misc/bone_capemgr.c

-- 
1.7.12

