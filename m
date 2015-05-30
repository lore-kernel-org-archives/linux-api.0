From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 31/98] gntalloc.h: use __u16, __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:23 +0200
Message-ID: <1433000370-19509-32-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

xen/gntalloc.h:22:2: error: unknown type name =E2=80=98uint16_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/xen/gntalloc.h | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/uapi/xen/gntalloc.h b/include/uapi/xen/gntalloc.h
index 76bd580..48d2790 100644
--- a/include/uapi/xen/gntalloc.h
+++ b/include/uapi/xen/gntalloc.h
@@ -11,6 +11,8 @@
 #ifndef __LINUX_PUBLIC_GNTALLOC_H__
 #define __LINUX_PUBLIC_GNTALLOC_H__
=20
+#include <linux/types.h>
+
 /*
  * Allocates a new page and creates a new grant reference.
  */
@@ -19,17 +21,17 @@ _IOC(_IOC_NONE, 'G', 5, sizeof(struct ioctl_gntallo=
c_alloc_gref))
 struct ioctl_gntalloc_alloc_gref {
 	/* IN parameters */
 	/* The ID of the domain to be given access to the grants. */
-	uint16_t domid;
+	__u16 domid;
 	/* Flags for this mapping */
-	uint16_t flags;
+	__u16 flags;
 	/* Number of pages to map */
-	uint32_t count;
+	__u32 count;
 	/* OUT parameters */
 	/* The offset to be used on a subsequent call to mmap(). */
-	uint64_t index;
+	__u64 index;
 	/* The grant references of the newly created grant, one per page */
 	/* Variable size, depending on count */
-	uint32_t gref_ids[1];
+	__u32 gref_ids[1];
 };
=20
 #define GNTALLOC_FLAG_WRITABLE 1
@@ -43,9 +45,9 @@ _IOC(_IOC_NONE, 'G', 6, sizeof(struct ioctl_gntalloc_=
dealloc_gref))
 struct ioctl_gntalloc_dealloc_gref {
 	/* IN parameters */
 	/* The offset returned in the map operation */
-	uint64_t index;
+	__u64 index;
 	/* Number of references to unmap */
-	uint32_t count;
+	__u32 count;
 };
=20
 /*
@@ -67,11 +69,11 @@ struct ioctl_gntalloc_unmap_notify {
 	 * be cleared. Otherwise, it can be any byte in the page whose
 	 * notification we are adjusting.
 	 */
-	uint64_t index;
+	__u64 index;
 	/* Action(s) to take on unmap */
-	uint32_t action;
+	__u32 action;
 	/* Event channel to notify */
-	uint32_t event_channel_port;
+	__u32 event_channel_port;
 };
=20
 /* Clear (set to zero) the byte specified by index */
--=20
2.1.4
