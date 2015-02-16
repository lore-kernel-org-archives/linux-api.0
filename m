From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 21/45] scsi_bsg_fc.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 00:05:24 +0100
Message-ID: <1424127948-22484-22-git-send-email-mikko.rapeli@iki.fi>
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

scsi/scsi_bsg_fc.h:83:2: error: unknown type name =E2=80=98uint8_t=E2=80=
=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/scsi/scsi_bsg_fc.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/uapi/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_b=
sg_fc.h
index 3031b90..5cc25df 100644
--- a/include/uapi/scsi/scsi_bsg_fc.h
+++ b/include/uapi/scsi/scsi_bsg_fc.h
@@ -22,6 +22,12 @@
 #ifndef SCSI_BSG_FC_H
 #define SCSI_BSG_FC_H
=20
+#ifdef __KERNEL__
+#include <linux/types.h>
+#else
+#include <stdint.h>
+#endif
+
 /*
  * This file intended to be included by both kernel and user space
  */
--=20
2.1.4
