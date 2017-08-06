From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v06 34/36] uapi: break dependency loop between <linux/hdlc/ioctl.h> and <linux/if.h>
Date: Sun,  6 Aug 2017 18:44:25 +0200
Message-ID: <20170806164428.2273-35-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Frans Klaver <fransklaver@gmail.com>, David Miller <davem@davemloft.net>, "Dmitry V. Levin" <ldv@altlinux.org>, Jonas Gorski <jonas.gorski@gmail.com>
List-Id: linux-api@vger.kernel.org

Name structs in linux/hdlc/ioctl.h and forward declare and use them in
linux/if.h. Then include linux/if.h in linux/hdlc/ioctl.h to fix
user space compilation problem:

hdlc/ioctl.h:73:14: error: ‘IFNAMSIZ’ undeclared here (not in a function)
  char master[IFNAMSIZ]; /* Name of master FRAD device */
              ^~~~~~~~

This approach for suggested by Frans Klaver <fransklaver@gmail.com>
in lkml message
<CAH6sp9Ni636HR4sma0SeSZPs+Tws9Y41jij-=fu0gMZj5Zbsyg@mail.gmail.com>.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Frans Klaver <fransklaver@gmail.com>
Cc: David Miller <davem@davemloft.net>
---
 include/uapi/linux/hdlc/ioctl.h | 17 +++++++++--------
 include/uapi/linux/if.h         | 23 ++++++++++++++++-------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdlc/ioctl.h
index 04bc0274a189..717d3edef7d1 100644
--- a/include/uapi/linux/hdlc/ioctl.h
+++ b/include/uapi/linux/hdlc/ioctl.h
@@ -1,6 +1,7 @@
 #ifndef __HDLC_IOCTL_H__
 #define __HDLC_IOCTL_H__
 
+#include <linux/if.h>
 
 #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc utility */
 
@@ -36,25 +37,25 @@
 
 #ifndef __ASSEMBLY__
 
-typedef struct {
+typedef struct sync_serial_settings {
 	unsigned int clock_rate; /* bits per second */
 	unsigned int clock_type; /* internal, external, TX-internal etc. */
 	unsigned short loopback;
 } sync_serial_settings;          /* V.35, V.24, X.21 */
 
-typedef struct {
+typedef struct te1_settings {
 	unsigned int clock_rate; /* bits per second */
 	unsigned int clock_type; /* internal, external, TX-internal etc. */
 	unsigned short loopback;
 	unsigned int slot_map;
 } te1_settings;                  /* T1, E1 */
 
-typedef struct {
+typedef struct raw_hdlc_proto {
 	unsigned short encoding;
 	unsigned short parity;
 } raw_hdlc_proto;
 
-typedef struct {
+typedef struct fr_proto {
 	unsigned int t391;
 	unsigned int t392;
 	unsigned int n391;
@@ -64,16 +65,16 @@ typedef struct {
 	unsigned short dce; /* 1 for DCE (network side) operation */
 } fr_proto;
 
-typedef struct {
+typedef struct fr_proto_pvc {
 	unsigned int dlci;
 } fr_proto_pvc;          /* for creating/deleting FR PVCs */
 
-typedef struct {
+typedef struct fr_proto_pvc_info {
 	unsigned int dlci;
 	char master[IFNAMSIZ];	/* Name of master FRAD device */
-}fr_proto_pvc_info;		/* for returning PVC information only */
+} fr_proto_pvc_info;		/* for returning PVC information only */
 
-typedef struct {
+typedef struct cisco_proto {
     unsigned int interval;
     unsigned int timeout;
 } cisco_proto;
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 259617a551f2..b57d9cd08ac9 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -34,6 +34,15 @@
 #define	IFALIASZ	256
 #include <linux/hdlc/ioctl.h>
 
+/* Forward declarations to break dependency loop with <linux/hdlc/ioctl.h> */
+struct sync_serial_settings;
+struct ae1_settings;
+struct raw_hdlc_proto;
+struct fr_proto;
+struct fr_proto_pvc;
+struct fr_proto_pvc_info;
+struct cisco_proto;
+
 /* For glibc compatibility. An empty enum does not compile. */
 #if __UAPI_DEF_IF_NET_DEVICE_FLAGS_LOWER_UP_DORMANT_ECHO != 0 || \
     __UAPI_DEF_IF_NET_DEVICE_FLAGS != 0
@@ -206,15 +215,15 @@ struct if_settings {
 	unsigned int size;	/* Size of the data allocated by the caller */
 	union {
 		/* {atm/eth/dsl}_settings anyone ? */
-		raw_hdlc_proto		__user *raw_hdlc;
-		cisco_proto		__user *cisco;
-		fr_proto		__user *fr;
-		fr_proto_pvc		__user *fr_pvc;
-		fr_proto_pvc_info	__user *fr_pvc_info;
+		struct raw_hdlc_proto		__user *raw_hdlc;
+		struct cisco_proto		__user *cisco;
+		struct fr_proto		__user *fr;
+		struct fr_proto_pvc		__user *fr_pvc;
+		struct fr_proto_pvc_info	__user *fr_pvc_info;
 
 		/* interface settings */
-		sync_serial_settings	__user *sync;
-		te1_settings		__user *te1;
+		struct sync_serial_settings	__user *sync;
+		struct te1_settings		__user *te1;
 	} ifs_ifsu;
 };
 
-- 
2.13.3
