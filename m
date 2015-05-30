From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 61/98] include/uapi/linux/netfilter_ipv6/ip6t_rt.h: include linux/in6.h
Date: Sat, 30 May 2015 17:38:53 +0200
Message-ID: <1433000370-19509-62-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fixes userspace compiler error:

error: array type has incomplete element type
  struct in6_addr addrs[IP6T_RT_HOPS]; /* Hops */

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter_ipv6/ip6t_rt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_rt.h b/include/uapi/linux/netfilter_ipv6/ip6t_rt.h
index 7605a5f..558f81e 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_rt.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_rt.h
@@ -2,7 +2,7 @@
 #define _IP6T_RT_H
 
 #include <linux/types.h>
-/*#include <linux/in6.h>*/
+#include <linux/in6.h>
 
 #define IP6T_RT_HOPS 16
 
-- 
2.1.4
