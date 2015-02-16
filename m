From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 27/45] include/uapi/linux/sysctl.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 00:05:30 +0100
Message-ID: <1424127948-22484-28-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, "David S. Miller" <davem@davemloft.net>, Ben Greear <greearb@candelatech.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: unknown type name =E2=80=98size_t=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/sysctl.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 43aaba1..b7b344f 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -26,6 +26,10 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
=20
+#ifndef __KERNEL__
+#include <stdlib.h>
+#endif
+
 struct completion;
=20
 #define CTL_MAXNAME 10		/* how many path components do we allow in a
--=20
2.1.4
