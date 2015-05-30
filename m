From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 32/98] gntdev.h: use __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 17:38:24 +0200
Message-ID: <1433000370-19509-33-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:

xen/gntdev.h:38:2: error: unknown type name =E2=80=98uint32_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/xen/gntdev.h | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
index 5304bd3..aa7610a 100644
--- a/include/uapi/xen/gntdev.h
+++ b/include/uapi/xen/gntdev.h
@@ -33,11 +33,13 @@
 #ifndef __LINUX_PUBLIC_GNTDEV_H__
 #define __LINUX_PUBLIC_GNTDEV_H__
=20
+#include <linux/types.h>
+
 struct ioctl_gntdev_grant_ref {
 	/* The domain ID of the grant to be mapped. */
-	uint32_t domid;
+	__u32 domid;
 	/* The grant reference of the grant to be mapped. */
-	uint32_t ref;
+	__u32 ref;
 };
=20
 /*
@@ -50,11 +52,11 @@ _IOC(_IOC_NONE, 'G', 0, sizeof(struct ioctl_gntdev_=
map_grant_ref))
 struct ioctl_gntdev_map_grant_ref {
 	/* IN parameters */
 	/* The number of grants to be mapped. */
-	uint32_t count;
-	uint32_t pad;
+	__u32 count;
+	__u32 pad;
 	/* OUT parameters */
 	/* The offset to be used on a subsequent call to mmap(). */
-	uint64_t index;
+	__u64 index;
 	/* Variable IN parameter. */
 	/* Array of grant references, of size @count. */
 	struct ioctl_gntdev_grant_ref refs[1];
@@ -70,10 +72,10 @@ _IOC(_IOC_NONE, 'G', 1, sizeof(struct ioctl_gntdev_=
unmap_grant_ref))
 struct ioctl_gntdev_unmap_grant_ref {
 	/* IN parameters */
 	/* The offset was returned by the corresponding map operation. */
-	uint64_t index;
+	__u64 index;
 	/* The number of pages to be unmapped. */
-	uint32_t count;
-	uint32_t pad;
+	__u32 count;
+	__u32 pad;
 };
=20
 /*
@@ -93,13 +95,13 @@ _IOC(_IOC_NONE, 'G', 2, sizeof(struct ioctl_gntdev_=
get_offset_for_vaddr))
 struct ioctl_gntdev_get_offset_for_vaddr {
 	/* IN parameters */
 	/* The virtual address of the first mapped page in a range. */
-	uint64_t vaddr;
+	__u64 vaddr;
 	/* OUT parameters */
 	/* The offset that was used in the initial mmap() operation. */
-	uint64_t offset;
+	__u64 offset;
 	/* The number of pages mapped in the VM area that begins at @vaddr. *=
/
-	uint32_t count;
-	uint32_t pad;
+	__u32 count;
+	__u32 pad;
 };
=20
 /*
@@ -113,7 +115,7 @@ _IOC(_IOC_NONE, 'G', 3, sizeof(struct ioctl_gntdev_=
set_max_grants))
 struct ioctl_gntdev_set_max_grants {
 	/* IN parameter */
 	/* The maximum number of grants that may be mapped at once. */
-	uint32_t count;
+	__u32 count;
 };
=20
 /*
@@ -135,11 +137,11 @@ struct ioctl_gntdev_unmap_notify {
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
