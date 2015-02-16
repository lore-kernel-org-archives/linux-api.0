From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 22/45] scsi_netlink.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:25 +0100
Message-ID: <1424127948-22484-23-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes compilation error:

scsi/scsi_netlink.h:43:2: error: unknown type name =E2=80=98uint8_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/scsi/scsi_netlink.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_=
netlink.h
index 62b4eda..9d14592 100644
--- a/include/uapi/scsi/scsi_netlink.h
+++ b/include/uapi/scsi/scsi_netlink.h
@@ -22,8 +22,12 @@
 #ifndef SCSI_NETLINK_H
 #define SCSI_NETLINK_H
=20
-#include <linux/netlink.h>
+#ifdef __KERNEL__
 #include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+#include <linux/netlink.h>
=20
 /*
  * This file intended to be included by both kernel and user space
--=20
2.1.4
