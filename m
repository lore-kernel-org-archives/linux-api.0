From: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
Subject: [PATCH linux-next (v2) 1/3] MIPS: bcm963xx: Add nvram structure
Date: Thu, 10 Dec 2015 23:04:27 +0000
Message-ID: <566A04FB.7000104@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, MTD Maling List <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Jonas Gorski <jogo-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>, bcm-kernel-feedback-list <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

The BCM963xx has multiple nvram variants across different SoCs with
additional checksum fields added whenever the size of the nvram was
extended.

Signed-off-by: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
---
v2: Use external struct bcm963xx_nvram definition for bcm963268part.

 MAINTAINERS                         |  1 +
 include/uapi/linux/bcm963xx_nvram.h | 39 +++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)
 create mode 100644 include/uapi/linux/bcm963xx_nvram.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 1354720..5d2272c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2396,6 +2396,7 @@ F:	drivers/irqchip/irq-brcmstb*
 F:	drivers/power/bcm6358*
 F:	drivers/reset/bcm/reset-bcm6345*
 F:	include/linux/bcm63xx_wdt.h
+F:	include/uapi/linux/bcm963xx_nvram.h
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 M:	Prashant Sreedharan <prashant-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
diff --git a/include/uapi/linux/bcm963xx_nvram.h b/include/uapi/linux/bcm963xx_nvram.h
new file mode 100644
index 0000000..470a4b9
--- /dev/null
+++ b/include/uapi/linux/bcm963xx_nvram.h
@@ -0,0 +1,39 @@
+#ifndef _UAPI__LINUX_BCM963XX_NVRAM_H__
+#define _UAPI__LINUX_BCM963XX_NVRAM_H__
+
+#include <linux/sizes.h>
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define BCM963XX_NVRAM_V4_SIZE		300
+#define BCM963XX_NVRAM_V5_SIZE		(1 * SZ_1K)
+#define BCM963XX_NVRAM_V6_SIZE		BCM963XX_NVRAM_V5_SIZE
+#define BCM963XX_NVRAM_V7_SIZE		(3 * SZ_1K)
+
+#define BCM963XX_NVRAM_NR_PARTS		5
+
+struct bcm963xx_nvram {
+	u32	version;
+	char	bootline[256];
+	char	name[16];
+	u32	main_tp_number;
+	u32	psi_size;
+	u32	mac_addr_count;
+	u8	mac_addr_base[ETH_ALEN];
+	u8	__reserved1[2];
+	u32	checksum_v4;
+
+	u8	__reserved2[292];
+	u32	nand_part_offset[BCM963XX_NVRAM_NR_PARTS];
+	u32	nand_part_size[BCM963XX_NVRAM_NR_PARTS];
+	u8	__reserved3[388];
+	union {
+		u32	checksum_v5;
+		u32	checksum_v6;
+	};
+
+	u8	__reserved4[2044];
+	u32	checksum_v7;
+} __packed;
+
+#endif /* _UAPI__LINUX_BCM963XX_NVRAM_H__ */
-- 
2.1.4

-- 
Simon Arlott
