From: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
Subject: [Patch v3 3/3] Documentation: ABI: sysfs-firmware-dmi: add -entries suffix to file name
Date: Tue, 21 Apr 2015 18:52:40 +0300
Message-ID: <1429631560-31359-4-git-send-email-ivan.khoronzhuk@globallogic.com>
References: <1429631560-31359-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1429631560-31359-1-git-send-email-ivan.khoronzhuk@globallogic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, matt.fleming@intel.com, jdelvare@suse.de, ard.biesheuvel@linaro.org, grant.likely@linaro.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, mikew@google.com
Cc: dmidecode-devel@nongnu.org, leif.lindholm@linaro.org, msalter@redhat.com, roy.franz@linaro.org, Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
List-Id: linux-api@vger.kernel.org

The dmi-sysfs module adds DMI table structures entries under
/sys/firmware/dmi/entries only, so rename documentation file to
sysfs-firmware-dmi-entries as more appropriate. Without renaming it's
confusing to differ this from sysfs-firmware-dmi-tables that adds raw
DMI table and actually adds "dmi" kobject.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@globallogic.com>
---
 .../ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries}      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename Documentation/ABI/testing/{sysfs-firmware-dmi => sysfs-firmware-dmi-entries} (99%)

diff --git a/Documentation/ABI/testing/sysfs-firmware-dmi b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
similarity index 99%
rename from Documentation/ABI/testing/sysfs-firmware-dmi
rename to Documentation/ABI/testing/sysfs-firmware-dmi-entries
index c78f9ab..210ad44 100644
--- a/Documentation/ABI/testing/sysfs-firmware-dmi
+++ b/Documentation/ABI/testing/sysfs-firmware-dmi-entries
@@ -1,4 +1,4 @@
-What:		/sys/firmware/dmi/
+What:		/sys/firmware/dmi/entries/
 Date:		February 2011
 Contact:	Mike Waychison <mikew@google.com>
 Description:
-- 
1.9.1
