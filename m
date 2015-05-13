From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: [PATCH 2/5] doc: misc: Beaglebone capemanager documentation
Date: Wed, 13 May 2015 10:59:42 +0300
Message-ID: <1431503985-31853-3-git-send-email-pantelis.antoniou@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?UTF-8?q?Beno=C3=AEt=20Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Pantelis Antoniou <panto@antoniou-consulting.com>
List-Id: linux-api@vger.kernel.org

Add beaglebone capemanager documentation entry.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 Documentation/misc-devices/bone_capemgr.txt | 63 +++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/misc-devices/bone_capemgr.txt

diff --git a/Documentation/misc-devices/bone_capemgr.txt b/Documentation/misc-devices/bone_capemgr.txt
new file mode 100644
index 0000000..2a8c766
--- /dev/null
+++ b/Documentation/misc-devices/bone_capemgr.txt
@@ -0,0 +1,63 @@
+---------------------------
+  Beaglebone Cape-Manager
+---------------------------
+
+The beaglebone cape manager driver allows the automatic use of external
+peripheral capes to be automatically supported by Linux without any manual
+setup required by the user.
+
+Each beaglebone cape should contain an EEPROM that describes
+it in a fixed I2C address on the i2c2 bus of the baseboard.
+The format of the EEPROM is defined in the beaglebone reference
+manual at:
+http://beagleboard.org/static/beaglebone/latest/Docs/Hardware/BONE_SRM.pdf
+
+Reading the part number and revision information the manager
+requests a firmware file formatted as a device tree overlay blob.
+
+Applying the overlay the devices are instantiated and the cape is
+ready to be used.
+
+For instance if the part-number is BB-BONE-SERL-03 and the version is 00A1
+the firmware file requested will be BB-BONE-SERL-03-00A1-00A1.dtbo
+It will be located by the in-kernel firmware
+loader in the usual place, i.e.  /lib/firmware/`uname -r`, /lib/firmware etc.
+
+The driver supports the following parameters (either as part of the kernel
+command line or supplied at module insertion time).
+
+disable_partno:   A comma delimited list of PART-NUMBER[:REV] of
+                  disabled capes.
+enable_partno:    A comma delimited list of PART-NUMBER[:REV[:PRIO]] of
+                  enabled capes.
+boot_scan_period: The boot scan period in ms. When the cape manager is built-in
+                  the kernel image, the firmware loader cannot find the files
+		  before the rootfs is mounted. This parameter controls the
+		  period with which the boot state is checked in that case.
+
+There's a sysfs control interface which is defined at the ABI documentation
+area.
+
+Theory of operation:
+--------------------
+
+On driver probe the I2C EEPROM of the baseboard is read and information about
+the current baseboard is retrieved. This information includes the mapping from
+baseboard board name to DT friendly compatible string. I.e. the "A335BONE" board
+name from EEPROM is mapped to the "ti,beaglebone" compatible string which should
+be present in the dtbo to be loaded.
+
+Afterwards the EEPROMs declared in each slot are probed, and the EEPROMs found
+are decoded keeping track the cape part-number and version data.
+
+Using the part-number and version a firmware file is requested (the firmware
+file requested is <part-number>-<version>.dtbo).
+
+The dtbo is unflattend and the resulting device tree is matched against a
+compatible baseboard, and in case of multiple parallel loading capes the
+priorities defined are honored.  That means that when there are multiple capes
+being loaded in parallel the ones with the lowest priority number are loaded
+first.
+
+Applying the device tree overlay makes the cape operational, as if it was part
+of the kernel's booting device tree.
-- 
1.7.12

