From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:18 +0100
Message-ID: <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation error:

linux/dm-log-userspace.h:416:2: error: unknown type name =E2=80=98uint6=
4_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/dm-log-userspace.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/dm-log-userspace.h b/include/uapi/linux=
/dm-log-userspace.h
index 0fa0d9e..7b9684e 100644
--- a/include/uapi/linux/dm-log-userspace.h
+++ b/include/uapi/linux/dm-log-userspace.h
@@ -7,6 +7,11 @@
 #ifndef __DM_LOG_USERSPACE_H__
 #define __DM_LOG_USERSPACE_H__
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <linux/dm-ioctl.h> /* For DM_UUID_LEN */
=20
 /*
--=20
2.1.4
