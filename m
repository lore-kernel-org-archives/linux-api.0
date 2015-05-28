From: Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] mei: fix up uuid matching
Date: Wed, 27 May 2015 17:17:27 -0700
Message-ID: <20150528001727.GB2033@kroah.com>
References: <1432741333-11889-1-git-send-email-tomas.winkler@intel.com>
 <20150527165054.GB3533@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A2C8C@hasmsx109.ger.corp.intel.com>
 <20150527172919.GA5525@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A2CDF@hasmsx109.ger.corp.intel.com>
 <20150527231420.GA29446@kroah.com>
 <20150527232254.GA8737@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B3C4A3096@hasmsx109.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B3C4A3096@hasmsx109.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, "arnd@arndb.de" <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

A previous commit, c93b76b34b4d ("mei: bus: report also uuid in module
alias") caused a build error as I missed applying a needed patch to add
some macros to uapi/linux/uuid.h.  Instead of those additional macros,
change the mei code to use the existing uuid structure directly.

Fixes: c93b76b34b4d
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index de8fd089a8a4..357b6ae4d207 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -30,11 +30,6 @@
 #define to_mei_cl_driver(d) container_of(d, struct mei_cl_driver, driver)
 #define to_mei_cl_device(d) container_of(d, struct mei_cl_device, dev)
 
-static inline uuid_le uuid_le_cast(const __u8 uuid[16])
-{
-	return *(uuid_le *)uuid;
-}
-
 static int mei_cl_device_match(struct device *dev, struct device_driver *drv)
 {
 	struct mei_cl_device *device = to_mei_cl_device(dev);
@@ -54,9 +49,9 @@ static int mei_cl_device_match(struct device *dev, struct device_driver *drv)
 
 	id = driver->id_table;
 
-	while (uuid_le_cmp(NULL_UUID_LE, uuid_le_cast(id->uuid))) {
+	while (uuid_le_cmp(NULL_UUID_LE, id->uuid)) {
 
-		if (!uuid_le_cmp(*uuid, uuid_le_cast(id->uuid))) {
+		if (!uuid_le_cmp(*uuid, id->uuid)) {
 			if (id->name[0]) {
 				if (!strncmp(name, id->name, sizeof(id->name)))
 					return 1;
diff --git a/drivers/nfc/mei_phy.h b/drivers/nfc/mei_phy.h
index a51f8f2685cc..fbfa3e61738f 100644
--- a/drivers/nfc/mei_phy.h
+++ b/drivers/nfc/mei_phy.h
@@ -5,7 +5,7 @@
 #include <net/nfc/hci.h>
 #include <linux/uuid.h>
 
-#define MEI_NFC_UUID __UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
+#define MEI_NFC_UUID UUID_LE(0x0bb17a78, 0x2a8e, 0x4c50, \
 		0x94, 0xd4, 0x50, 0x26, 0x67, 0x23, 0x77, 0x5c)
 #define MEI_NFC_HEADER_SIZE 10
 #define MEI_NFC_MAX_HCI_PAYLOAD 300
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 2d2b2b571d61..048c270822f9 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -614,7 +614,7 @@ struct ipack_device_id {
  */
 struct mei_cl_device_id {
 	char name[MEI_CL_NAME_SIZE];
-	__u8 uuid[16];
+	uuid_le uuid;
 	kernel_ulong_t driver_info;
 };
 
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 62c517f4b592..718b2a29bd43 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -34,6 +34,9 @@ typedef Elf64_Addr	kernel_ulong_t;
 typedef uint32_t	__u32;
 typedef uint16_t	__u16;
 typedef unsigned char	__u8;
+typedef struct {
+	__u8 b[16];
+} uuid_le;
 
 /* Big exception to the "don't include kernel headers into userspace, which
  * even potentially has different endianness and word sizes, since
@@ -131,13 +134,13 @@ static inline void add_wildcard(char *str)
 		strcat(str + len, "*");
 }
 
-static inline void add_uuid(char *str, __u8 uuid[16])
+static inline void add_uuid(char *str, uuid_le uuid)
 {
 	int len = strlen(str);
 	int i;
 
 	for (i = 0; i < 16; i++)
-		sprintf(str + len + (i << 1), "%02x", uuid[i]);
+		sprintf(str + len + (i << 1), "%02x", uuid.b[i]);
 }
 
 /**
