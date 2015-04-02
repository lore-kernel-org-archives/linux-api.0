From: Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Subject: [Patch 0/3] firmware: dmi_scan: add SBMIOS entry point and DMI tables
Date: Thu,  2 Apr 2015 15:57:00 +0300
Message-ID: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jdelvare-l3A5Bk7waGM@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This series adds SMBIOS entry point table and DMI table under
/sys/firmware/dmi/tables in order to use as an alternative to utilities
reading them from /dev/mem.

This is logical continuation of
"[Patch] firmware: dmi_scan: split dmisubsystem from dmi-sysfs"
https://lkml.org/lkml/2015/3/16/1070

Based on efi/next

Last changes:
	- renamed dmi_table to dmi_decode_table
	- moved tables under /sys/firmware/dmi/tables/
	- avoid "subsystem" word
	- split in separate patch correction of dmi-sysfs documentation
	- using -ENOSYS instead of -EINVAL
	- use user read only rights for table attributes
	- use "static" for attributes
	- check only dmi_available for table presents
	- don't correct dmi_walk to constantly map dmi_table
	- explicitly delete binary attributes
	- assign dmi_kobj = NULL in case of error
	- don't export dmi_kobj if CONFIG_DMI is not set
	- improve read callback for table attributes

Ivan Khoronzhuk (3):
  firmware: dmi_scan: rename dmi_table to dmi_decode_table
  firmware: dmi_scan: add SBMIOS entry and DMI tables
  Documentation: ABI: sysfs-firmware-dmi: add -entries suffix to file
    name

 ...sfs-firmware-dmi => sysfs-firmware-dmi-entries} |  2 +-
 .../ABI/testing/sysfs-firmware-dmi-tables          | 22 ++++++
 drivers/firmware/dmi-sysfs.c                       | 11 +--
 drivers/firmware/dmi_scan.c                        | 90 ++++++++++++++++++++--
 include/linux/dmi.h                                |  1 +
 5 files changed, 113 insertions(+), 13 deletions(-)
 rename Documentation/ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries} (99%)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-dmi-tables

-- 
1.9.1
