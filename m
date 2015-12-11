From: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
Subject: [PATCH linux-next (v3) 2/3] MIPS: bcm63xx: nvram: Use nvram structure
 definition from header file
Date: Fri, 11 Dec 2015 21:56:17 +0000
Message-ID: <566B4681.7030904@simon.arlott.org.uk>
References: <566B460F.1040603@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <566B460F.1040603-qdVf85lJwsCyrPCCpiK2c/XRex20P6io@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Brian Norris <computersforpeace-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, Kevin Cernekee <cernekee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, MTD Maling List <linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Jonas Gorski <jogo-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>, bcm-kernel-feedback-list <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Use the common definition of the nvram structure from the header file
include/uapi/linux/bcm963xx_nvram.h instead of maintaining a separate
copy.

Read the version 5 size of nvram data from memory and then support the
version 4 and version 5 variants of nvram data checksums.

Signed-off-by: Simon Arlott <simon-A6De1vDTPLDsq35pWSNszA@public.gmane.org>
---
Compile tested only (there is no support for brcmnand on mach-bcm63xx).

v3: No changes (reworded commit message).

v2: Use external struct bcm963xx_nvram definition for bcm963268part.

 arch/mips/bcm63xx/nvram.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/mips/bcm63xx/nvram.c b/arch/mips/bcm63xx/nvram.c
index 4b50d40..36e74f9 100644
--- a/arch/mips/bcm63xx/nvram.c
+++ b/arch/mips/bcm63xx/nvram.c
@@ -16,25 +16,9 @@
 #include <linux/kernel.h>
 #include <linux/if_ether.h>
 
+#include <uapi/linux/bcm963xx_nvram.h>
 #include <bcm63xx_nvram.h>
 
-/*
- * nvram structure
- */
-struct bcm963xx_nvram {
-	u32	version;
-	u8	reserved1[256];
-	u8	name[16];
-	u32	main_tp_number;
-	u32	psi_size;
-	u32	mac_addr_count;
-	u8	mac_addr_base[ETH_ALEN];
-	u8	reserved2[2];
-	u32	checksum_old;
-	u8	reserved3[720];
-	u32	checksum_high;
-};
-
 #define BCM63XX_DEFAULT_PSI_SIZE	64
 
 static struct bcm963xx_nvram nvram;
@@ -47,17 +31,17 @@ void __init bcm63xx_nvram_init(void *addr)
 	u8 hcs_mac_addr[ETH_ALEN] = { 0x00, 0x10, 0x18, 0xff, 0xff, 0xff };
 
 	/* extract nvram data */
-	memcpy(&nvram, addr, sizeof(nvram));
+	memcpy(&nvram, addr, BCM963XX_NVRAM_V5_SIZE);
 
 	/* check checksum before using data */
 	if (nvram.version <= 4) {
-		check_len = offsetof(struct bcm963xx_nvram, reserved3);
-		expected_crc = nvram.checksum_old;
-		nvram.checksum_old = 0;
+		check_len = BCM963XX_NVRAM_V4_SIZE;
+		expected_crc = nvram.checksum_v4;
+		nvram.checksum_v4 = 0;
 	} else {
-		check_len = sizeof(nvram);
-		expected_crc = nvram.checksum_high;
-		nvram.checksum_high = 0;
+		check_len = BCM963XX_NVRAM_V5_SIZE;
+		expected_crc = nvram.checksum_v5;
+		nvram.checksum_v5 = 0;
 	}
 
 	crc = crc32_le(~0, (u8 *)&nvram, check_len);
-- 
2.1.4

-- 
Simon Arlott
