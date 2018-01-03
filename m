From: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
Subject: uapi/if_ether.h: prevent redefinition of struct ethhdr
Date: Wed,  3 Jan 2018 23:14:21 +0100
Message-ID: <20180103221421.8273-1-hauke@hauke-m.de>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, musl-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, felix.janda-1KBjaw7Xf1+zQB+pC5nmwQ@public.gmane.org, f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Musl provides its own ethhdr struct definition. Add a guard to prevent
its definition of the appropriate musl header has already been included.

glibc does not implement this header, but when glibc will implement this
they can just define __UAPI_DEF_ETHHDR 0 to make it work with the
kernel.

Signed-off-by: Hauke Mehrtens <hauke-5/S+JYg5SzeELgA04lAiVw@public.gmane.org>
---
 include/uapi/linux/if_ether.h    | 3 +++
 include/uapi/linux/libc-compat.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 3ee3bf7c8526..144de4d2f385 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -23,6 +23,7 @@
 #define _UAPI_LINUX_IF_ETHER_H
 
 #include <linux/types.h>
+#include <linux/libc-compat.h>
 
 /*
  *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
@@ -149,11 +150,13 @@
  *	This is an Ethernet frame header.
  */
 
+#if __UAPI_DEF_ETHHDR
 struct ethhdr {
 	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
 	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
 	__be16		h_proto;		/* packet type ID field	*/
 } __attribute__((packed));
+#endif
 
 
 #endif /* _UAPI_LINUX_IF_ETHER_H */
diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index 8254c937c9f4..fc29efaa918c 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -264,4 +264,10 @@
 
 #endif /* __GLIBC__ */
 
+/* Definitions for if_ether.h */
+/* allow libcs like musl to deactivate this, glibc does not implement this. */
+#ifndef __UAPI_DEF_ETHHDR
+#define __UAPI_DEF_ETHHDR		1
+#endif
+
 #endif /* _UAPI_LIBC_COMPAT_H */
-- 
2.11.0
