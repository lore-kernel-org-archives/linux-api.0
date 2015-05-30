From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 52/98] include/uapi/linux/mqueue.h: include linux/types.h
Date: Sat, 30 May 2015 17:38:44 +0200
Message-ID: <1433000370-19509-53-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile error:

error: unknown type name =E2=80=98__kernel_long_t=E2=80=99
 __kernel_long_t mq_flags; /* message queue flags   */

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/mqueue.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/mqueue.h b/include/uapi/linux/mqueue.h
index d0a2b8e..bbd5116 100644
--- a/include/uapi/linux/mqueue.h
+++ b/include/uapi/linux/mqueue.h
@@ -18,6 +18,8 @@
 #ifndef _LINUX_MQUEUE_H
 #define _LINUX_MQUEUE_H
=20
+#include <linux/types.h>
+
 #define MQ_PRIO_MAX 	32768
 /* per-uid limit of kernel memory used by mqueue, in bytes */
 #define MQ_BYTES_MAX	819200
--=20
2.1.4
