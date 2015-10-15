From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 75/79] include/uapi/xen/privcmd.h: fix compilation in userspace
Date: Thu, 15 Oct 2015 07:56:53 +0200
Message-ID: <1444888618-4506-76-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, Stefano Stabellini <stefano.stabellini@eu.citrix.com>, Russell King <linux@arm.linux.org.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

xen/interface/xen.h is not exported from kernel headers so remove the
dependency and provide needed defines for domid_t and xen_pfn_t if they
are not already defined by some other e.g. Xen specific headers.

Suggested by Andrew Cooper <andrew.cooper3@citrix.com> on lkml message
<5569F9C9.8000607@citrix.com>.

The ifdef for ARM is ugly but did not find better solutions for it.

Fixes userspace compilation error:

xen/privcmd.h:38:31: fatal error: xen/interface/xen.h: No such file or directory

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 arch/arm/include/asm/xen/interface.h |  2 +-
 include/uapi/xen/privcmd.h           | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 5006600..68a9d99 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -36,7 +36,7 @@
  * fine since it simply wouldn't be able to create any sure pfns in
  * the first place.
  */
-typedef uint64_t xen_pfn_t;
+typedef __u64 xen_pfn_t;
 #define PRI_xen_pfn "llx"
 typedef uint64_t xen_ulong_t;
 #define PRI_xen_ulong "llx"
diff --git a/include/uapi/xen/privcmd.h b/include/uapi/xen/privcmd.h
index 7ddeeda..95b73a9 100644
--- a/include/uapi/xen/privcmd.h
+++ b/include/uapi/xen/privcmd.h
@@ -35,7 +35,19 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
-#include <xen/interface/xen.h>
+
+/* Might be defined by Xen specific headers, but if not */
+#ifndef domid_t
+typedef __u16 domid_t;
+#endif /* domid_t */
+
+#ifndef xen_pfn_t
+#if (defined __ARMEL__ || defined __ARMEB__)
+typedef __u64 xen_pfn_t;
+#else
+typedef unsigned long xen_pfn_t;
+#endif /* (defined __ARMEL__ || defined __ARMEB__) */
+#endif /* xen_pfn_t */
 
 struct privcmd_hypercall {
 	__u64 op;
-- 
2.5.0
