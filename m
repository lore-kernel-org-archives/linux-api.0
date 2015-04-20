From: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Subject: [Patch v2 0/3] firmware: dmi_scan: add SBMIOS entry point and DMI tables
Date: Mon, 20 Apr 2015 13:19:44 +0300
Message-ID: <1429525187-3376-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, matt.fleming@intel.com, jdelvare@suse.de, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com
Cc: dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org, Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
List-Id: linux-api@vger.kernel.org

This series adds SMBIOS entry point table and DMI table under
/sys/firmware/dmi/tables in order to use as an alternative to utilities
reading them from /dev/mem.

Based on linux next
+ 2 patches that have not been sent by Jean Dalvere yet. They can be changed,
but, anyway, the series should be based on smth and it's desirable w/o
conflicts. The patches can be obtained with links:

http://jdelvare.nerim.net/devel/linux-3/jdelvare-dmi/firmware-dmi-03-simplify-displayed-version.patch
http://jdelvare.nerim.net/devel/linux-3/jdelvare-dmi/firmware-dmi-04-fix-product-uuid.patch

Link on V1:
https://lkml.org/lkml/2015/4/2/297

Changes since V1
	- correct error path in dmi-sysfs
	- don't use globally dmi_table var
	- use "DMI" in attribute name
	- correct error path in dmi_init
	- leave dmi_kobj even in case of error
	- include linux/kobject.h in header

Ivan Khoronzhuk (3):
  firmware: dmi_scan: rename dmi_table to dmi_decode_table
  firmware: dmi_scan: add SBMIOS entry and DMI tables
  Documentation: ABI: sysfs-firmware-dmi: add -entries suffix to file
    name

 ...sfs-firmware-dmi => sysfs-firmware-dmi-entries} |  2 +-
 .../ABI/testing/sysfs-firmware-dmi-tables          | 22 ++++++
 drivers/firmware/dmi-sysfs.c                       | 17 ++--
 drivers/firmware/dmi_scan.c                        | 92 ++++++++++++++++++++--
 include/linux/dmi.h                                |  2 +
 5 files changed, 120 insertions(+), 15 deletions(-)
 rename Documentation/ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries} (99%)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-tables

-- 
1.9.1

