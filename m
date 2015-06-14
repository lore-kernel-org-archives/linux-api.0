From: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>
Subject: [RFC v2 23/24] m68k/mac: Fix PRAM accessors
Date: Sun, 14 Jun 2015 17:46:30 +1000
Message-ID: <20150614074613.054681242@telegraphics.com.au>
References: <20150614074607.242676098@telegraphics.com.au>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=mac68k-fix-pram-accessors
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Finn Thain <fthain-PnMVE5gNl/W9dxLkCovUHLpzq4S04n8Q@public.gmane.org>

---

Tested on a PowerBook 520 and Quadra 650.

---
 arch/m68k/mac/misc.c     |   35 +++++++++++++++++++++++++++++------
 include/uapi/linux/pmu.h |    2 ++
 2 files changed, 31 insertions(+), 6 deletions(-)

Index: linux/arch/m68k/mac/misc.c
===================================================================
--- linux.orig/arch/m68k/mac/misc.c	2015-06-14 17:46:02.000000000 +1000
+++ linux/arch/m68k/mac/misc.c	2015-06-14 17:46:03.000000000 +1000
@@ -119,19 +119,22 @@ static void pmu_write_time(long data)
 static unsigned char pmu_pram_read_byte(int offset)
 {
 	struct adb_request req;
-	if (pmu_request(&req, NULL, 3, PMU_READ_NVRAM,
-			(offset >> 8) & 0xFF, offset & 0xFF) < 0)
+
+	if (pmu_request(&req, NULL, 3, PMU_READ_XPRAM,
+	                offset & 0xFF, 1) < 0)
 		return 0;
 	while (!req.complete)
 		pmu_poll();
-	return req.reply[3];
+
+	return req.reply[1];
 }
 
 static void pmu_pram_write_byte(unsigned char data, int offset)
 {
 	struct adb_request req;
-	if (pmu_request(&req, NULL, 4, PMU_WRITE_NVRAM,
-			(offset >> 8) & 0xFF, offset & 0xFF, data) < 0)
+
+	if (pmu_request(&req, NULL, 4, PMU_WRITE_XPRAM,
+	                offset & 0xFF, 1, data) < 0)
 		return;
 	while (!req.complete)
 		pmu_poll();
@@ -284,11 +287,31 @@ static void via_pram_command(int command
 
 static unsigned char via_pram_read_byte(int offset)
 {
-	return 0;
+	unsigned char temp;
+	int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);
+
+	/* Use RTC command 0x38 for XPRAM access, as per MESS source code */
+	via_pram_command(addr | 0x3800 | 0x8001, &temp);
+
+	return temp;
 }
 
 static void via_pram_write_byte(unsigned char data, int offset)
 {
+	unsigned char temp;
+	int addr = ((offset & 0xE0) << 3) | ((offset & 0x1F) << 2);
+
+	/* Clear the write protect bit */
+	temp = 0x55;
+	via_pram_command(0x34 | 0x01, &temp);
+
+	/* Write the byte to XPRAM */
+	temp = data;
+	via_pram_command(0x3800 | 0x0001 | addr, &temp);
+
+	/* Set the write protect bit */
+	temp = 0xD5;
+	via_pram_command(0x34 | 0x01, &temp);
 }
 
 /*
Index: linux/include/uapi/linux/pmu.h
===================================================================
--- linux.orig/include/uapi/linux/pmu.h	2015-06-14 17:45:34.000000000 +1000
+++ linux/include/uapi/linux/pmu.h	2015-06-14 17:46:03.000000000 +1000
@@ -18,7 +18,9 @@
 #define PMU_POWER_CTRL		0x11	/* control power of some devices */
 #define PMU_ADB_CMD		0x20	/* send ADB packet */
 #define PMU_ADB_POLL_OFF	0x21	/* disable ADB auto-poll */
+#define PMU_WRITE_XPRAM		0x32	/* write eXtended Parameter RAM */
 #define PMU_WRITE_NVRAM		0x33	/* write non-volatile RAM */
+#define PMU_READ_XPRAM		0x3a	/* read eXtended Parameter RAM */
 #define PMU_READ_NVRAM		0x3b	/* read non-volatile RAM */
 #define PMU_SET_RTC		0x30	/* set real-time clock */
 #define PMU_READ_RTC		0x38	/* read real-time clock */
