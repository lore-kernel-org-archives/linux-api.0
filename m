From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 01/14] uapi: General notification queue definitions [ver
 #2]
Date: Thu, 07 Nov 2019 13:35:26 +0000
Message-ID: <157313372658.29677.3710868015853027530.stgit@warthog.procyon.org.uk>
References: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157313371694.29677.15388731274912671071.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: dhowells@redhat.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>dhowells@redhat.com, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.orglinux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add UAPI definitions for the general notification queue, including the
following pieces:

 (*) struct watch_notification.

     This is the metadata header for notification messages.  It includes a
     type and subtype that indicate the source of the message
     (eg. WATCH_TYPE_MOUNT_NOTIFY) and the kind of the message
     (eg. NOTIFY_MOUNT_NEW_MOUNT).

     The header also contains an information field that conveys the
     following information:

=09- WATCH_INFO_LENGTH.  The size of the entry (entries are variable
          length).

=09- WATCH_INFO_ID.  The watch ID specified when the watchpoint was
          set.

=09- WATCH_INFO_TYPE_INFO.  (Sub)type-specific information.

=09- WATCH_INFO_FLAG_*.  Flag bits overlain on the type-specific
          information.  For use by the type.

     All the information in the header can be used in filtering messages at
     the point of writing into the buffer.

 (*) struct watch_notification_removal

     This is an extended watch-removal notification record that includes an
     'id' field that can indicate the identifier of the object being
     removed if available (for instance, a keyring serial number).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/uapi/linux/watch_queue.h |   55 ++++++++++++++++++++++++++++++++++=
++++
 1 file changed, 55 insertions(+)
 create mode 100644 include/uapi/linux/watch_queue.h

diff --git a/include/uapi/linux/watch_queue.h b/include/uapi/linux/watch_qu=
eue.h
new file mode 100644
index 000000000000..5f3d21e8a34b
--- /dev/null
+++ b/include/uapi/linux/watch_queue.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_WATCH_QUEUE_H
+#define _UAPI_LINUX_WATCH_QUEUE_H
+
+#include <linux/types.h>
+
+enum watch_notification_type {
+=09WATCH_TYPE_META=09=09=3D 0,=09/* Special record */
+=09WATCH_TYPE__NR=09=09=3D 1
+};
+
+enum watch_meta_notification_subtype {
+=09WATCH_META_REMOVAL_NOTIFICATION=09=3D 0,=09/* Watched object was remove=
d */
+=09WATCH_META_LOSS_NOTIFICATION=09=3D 1,=09/* Data loss occurred */
+};
+
+/*
+ * Notification record header.  This is aligned to 64-bits so that subclas=
ses
+ * can contain __u64 fields.
+ */
+struct watch_notification {
+=09__u32=09=09=09type:24;=09/* enum watch_notification_type */
+=09__u32=09=09=09subtype:8;=09/* Type-specific subtype (filterable) */
+=09__u32=09=09=09info;
+#define WATCH_INFO_LENGTH=090x0000007f=09/* Length of record */
+#define WATCH_INFO_LENGTH__SHIFT 0
+#define WATCH_INFO_ID=09=090x0000ff00=09/* ID of watchpoint */
+#define WATCH_INFO_ID__SHIFT=098
+#define WATCH_INFO_TYPE_INFO=090xffff0000=09/* Type-specific info */
+#define WATCH_INFO_TYPE_INFO__SHIFT 16
+#define WATCH_INFO_FLAG_0=090x00010000=09/* Type-specific info, flag bit 0=
 */
+#define WATCH_INFO_FLAG_1=090x00020000=09/* ... */
+#define WATCH_INFO_FLAG_2=090x00040000
+#define WATCH_INFO_FLAG_3=090x00080000
+#define WATCH_INFO_FLAG_4=090x00100000
+#define WATCH_INFO_FLAG_5=090x00200000
+#define WATCH_INFO_FLAG_6=090x00400000
+#define WATCH_INFO_FLAG_7=090x00800000
+};
+
+
+/*
+ * Extended watch removal notification.  This is used optionally if the ty=
pe
+ * wants to indicate an identifier for the object being watched, if there =
is
+ * such.  This can be distinguished by the length.
+ *
+ * type -> WATCH_TYPE_META
+ * subtype -> WATCH_META_REMOVAL_NOTIFICATION
+ */
+struct watch_notification_removal {
+=09struct watch_notification watch;
+=09__u64=09id;=09=09/* Type-dependent identifier */
+};
+
+#endif /* _UAPI_LINUX_WATCH_QUEUE_H */
