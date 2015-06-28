From: Finn Thain <fthain@telegraphics.com.au>
Subject: [RFC v3 23/24] m68k/mac: Fix PRAM accessors
Date: Sun, 28 Jun 2015 11:42:22 +1000
Message-ID: <20150628014205.292610325@telegraphics.com.au>
References: <20150628014159.732792697@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=mac68k-fix-pram-accessors
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Geert Uytterhoeven <geert@linux-m68k.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Tested on a PowerBook 520 and Quadra 650.

Changes since v2:
- Make use of the RTC_* macros from the previous patch and add a few more
besides.

---
 arch/m68k/mac/misc.c     |   39 +++++++++++++++++++++++++++++++++------
 include/uapi/linux/pmu.h |    2 ++
 2 files changed, 35 insertions(+), 6 deletions(-)

Index: linux/arch/m68k/mac/misc.c
===================================================================
--- linux.orig/arch/m68k/mac/misc.c	2015-06-28 11:41:54.000000000 +1000
+++ linux/arch/m68k/mac/misc.c	2015-06-28 11:41:55.000000000 +1000
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
@@ -257,6 +260,16 @@ static void via_rtc_send(__u8 data)
 #define RTC_REG_WRITE_PROTECT   13
 
 /*
+ * Inside Mac has no information about two-byte RTC commands but
+ * the MESS source code has the essentials.
+ */
+
+#define RTC_REG_XPRAM           14
+#define RTC_CMD_XPRAM_READ      (RTC_CMD_READ(RTC_REG_XPRAM) << 8)
+#define RTC_CMD_XPRAM_WRITE     (RTC_CMD_WRITE(RTC_REG_XPRAM) << 8)
+#define RTC_CMD_XPRAM_ARG(a)    (((a & 0xE0) << 3) | ((a & 0x1F) << 2))
+
+/*
  * Execute a VIA PRAM/RTC command. For read commands
  * data should point to a one-byte buffer for the
  * resulting data. For write commands it should point
@@ -303,11 +316,25 @@ static void via_rtc_command(int command,
 
 static unsigned char via_pram_read_byte(int offset)
 {
-	return 0;
+	unsigned char temp;
+
+	via_rtc_command(RTC_CMD_XPRAM_READ | RTC_CMD_XPRAM_ARG(offset), &temp);
+
+	return temp;
 }
 
 static void via_pram_write_byte(unsigned char data, int offset)
 {
+	unsigned char temp;
+
+	temp = 0x55;
+	via_rtc_command(RTC_CMD_WRITE(RTC_REG_WRITE_PROTECT), &temp);
+
+	temp = data;
+	via_rtc_command(RTC_CMD_XPRAM_WRITE | RTC_CMD_XPRAM_ARG(offset), &temp);
+
+	temp = 0x55 | RTC_FLG_WRITE_PROTECT;
+	via_rtc_command(RTC_CMD_WRITE(RTC_REG_WRITE_PROTECT), &temp);
 }
 
 /*
Index: linux/include/uapi/linux/pmu.h
===================================================================
--- linux.orig/include/uapi/linux/pmu.h	2015-06-28 11:41:27.000000000 +1000
+++ linux/include/uapi/linux/pmu.h	2015-06-28 11:41:55.000000000 +1000
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
