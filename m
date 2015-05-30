From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 29/98] scsi_netlink_fc.h: include stdint.h in userspace
Date: Sat, 30 May 2015 17:38:21 +0200
Message-ID: <1433000370-19509-30-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
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
index 2493a0f..b857e34 100644
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
