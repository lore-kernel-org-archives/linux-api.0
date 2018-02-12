From: Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] uapi/if_ether.h: move __UAPI_DEF_ETHHDR libc define
Date: Mon, 12 Feb 2018 23:59:51 +0100
Message-ID: <20180212225951.24708-1-hauke@hauke-m.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: linux-api@vger.kernel.org, netdev@vger.kernel.org, g.nault@alphalink.fr, Hauke Mehrtens <hauke@hauke-m.de>, "# 4 . 15" <stable@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

This fixes a compile problem of some user space applications by not
including linux/libc-compat.h in uapi/if_ether.h.

linux/libc-compat.h checks which "features" the header files, included
from the libc, provide to make the Linux kernel uapi header files only
provide no conflicting structures and enums. If a user application mixes
kernel headers and libc headers it could happen that linux/libc-compat.h
gets included too early where not all other libc headers are included
yet. Then the linux/libc-compat.h would not prevent all the
redefinitions and we run into compile problems.
This patch removes the include of linux/libc-compat.h from
uapi/if_ether.h to fix the recently introduced case, but not all as this
is more or less impossible.

It is no problem to do the check directly in the if_ether.h file and not
in libc-compat.h as this does not need any fancy glibc header detection
as glibc never provided struct ethhdr and should define
__UAPI_DEF_ETHHDR by them self when they will provide this.

The following test program did not compile correctly any more:

int main(void)
{
        return 0;
}

Fixes: 6926e041a892 ("uapi/if_ether.h: prevent redefinition of struct ethhdr")
Reported-by: Guillaume Nault <g.nault@alphalink.fr>
Cc: <stable@vger.kernel.org> # 4.15
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/uapi/linux/if_ether.h    | 6 +++++-
 include/uapi/linux/libc-compat.h | 6 ------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index f8cb5760ea4f..8bbbcb5cd94b 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -23,7 +23,6 @@
 #define _UAPI_LINUX_IF_ETHER_H
 
 #include <linux/types.h>
-#include <linux/libc-compat.h>
 
 /*
  *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
@@ -151,6 +150,11 @@
  *	This is an Ethernet frame header.
  */
 
+/* allow libcs like musl to deactivate this, glibc does not implement this. */
+#ifndef __UAPI_DEF_ETHHDR
+#define __UAPI_DEF_ETHHDR		1
+#endif
+
 #if __UAPI_DEF_ETHHDR
 struct ethhdr {
 	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index fc29efaa918c..8254c937c9f4 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -264,10 +264,4 @@
 
 #endif /* __GLIBC__ */
 
-/* Definitions for if_ether.h */
-/* allow libcs like musl to deactivate this, glibc does not implement this. */
-#ifndef __UAPI_DEF_ETHHDR
-#define __UAPI_DEF_ETHHDR		1
-#endif
-
 #endif /* _UAPI_LIBC_COMPAT_H */
-- 
2.11.0
