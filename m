From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 23/45] scsi_netlink_fc.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:26 +0100
Message-ID: <1424127948-22484-24-git-send-email-mikko.rapeli@iki.fi>
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

scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-list b=
efore =E2=80=98uint64_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/scsi/scsi_netlink_fc.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/scsi/scsi_netlink_fc.h b/include/uapi/scsi/sc=
si_netlink_fc.h
index cbf76e4..d969337 100644
--- a/include/uapi/scsi/scsi_netlink_fc.h
+++ b/include/uapi/scsi/scsi_netlink_fc.h
@@ -21,6 +21,11 @@
 #ifndef SCSI_NETLINK_FC_H
 #define SCSI_NETLINK_FC_H
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
 #include <scsi/scsi_netlink.h>
=20
 /*
--=20
2.1.4
