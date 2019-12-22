From: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
Subject: [PATCH] uapi: Prevent redefinition of struct iphdr
Date: Sun, 22 Dec 2019 00:02:27 -0600
Message-ID: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <musl-return-15067-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
To: netdev@vger.kernel.org, linux-api@vger.kernel.org, musl@lists.openwall.com
Cc: "A. Wilcox" <AWilcox@Wilcox-Tech.com>
List-Id: linux-api@vger.kernel.org

As with struct ethhdr, the musl libc provides its own definition of the
iphdr struct.  This guard ensures software like net-tools builds correctly
on the musl libc.

The __UAPI_DEF_IPHDR definition is in ip.h itself to prevent the issue in
commit da360299b673 ("uapi/if_ether.h: move __UAPI_DEF_ETHHDR libc define")
from being seen here.

Signed-off-by: A. Wilcox <AWilcox@Wilcox-Tech.com>
---
 include/uapi/linux/ip.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
index e42d13b55cf3..d34a0d295672 100644
--- a/include/uapi/linux/ip.h
+++ b/include/uapi/linux/ip.h
@@ -83,6 +83,13 @@
 
 #define IPV4_BEET_PHMAXLEN 8
 
+/* Allow libcs to deactivate this - musl has its own copy in <netinet/ip.h> */
+
+#ifndef __UAPI_DEF_IPHDR
+#define __UAPI_DEF_IPHDR	1
+#endif
+
+#if __UAPI_DEF_IPHDR
 struct iphdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u8	ihl:4,
@@ -104,6 +111,7 @@ struct iphdr {
 	__be32	daddr;
 	/*The options start here. */
 };
+#endif
 
 
 struct ip_auth_hdr {
-- 
2.22.1
