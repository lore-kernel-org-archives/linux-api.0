From: Maxim Uvarov <maxim.uvarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] fix trailing whitespaces in if.h
Date: Wed, 11 Mar 2015 16:08:28 +0300
Message-ID: <1426079308-10717-1-git-send-email-maxim.uvarov@linaro.org>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maxim Uvarov <maxim.uvarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Signed-off-by: Maxim Uvarov <maxim.uvarov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/uapi/linux/if.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 9cf2394..ee68193 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -157,7 +157,7 @@ enum {
 };
 
 /*
- *	Device mapping structure. I'd just gone off and designed a 
+ *	Device mapping structure. I'd just gone off and designed a
  *	beautiful scheme using only loadable modules with arguments
  *	for driver options and along come the PCMCIA people 8)
  *
@@ -169,7 +169,7 @@ enum {
 struct ifmap {
 	unsigned long mem_start;
 	unsigned long mem_end;
-	unsigned short base_addr; 
+	unsigned short base_addr;
 	unsigned char irq;
 	unsigned char dma;
 	unsigned char port;
@@ -206,7 +206,7 @@ struct ifreq {
 	{
 		char	ifrn_name[IFNAMSIZ];		/* if name, e.g. "en0" */
 	} ifr_ifrn;
-	
+
 	union {
 		struct	sockaddr ifru_addr;
 		struct	sockaddr ifru_dstaddr;
-- 
1.9.1
