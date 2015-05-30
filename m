From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 43/98] include/uapi/linux/hdlc/ioctl.h: include linux/if.h
Date: Sat, 30 May 2015 17:38:35 +0200
Message-ID: <1433000370-19509-44-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compiler error:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hdlc/ioctl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdlc/=
ioctl.h
index 04bc027..8bbee11 100644
--- a/include/uapi/linux/hdlc/ioctl.h
+++ b/include/uapi/linux/hdlc/ioctl.h
@@ -1,6 +1,7 @@
 #ifndef __HDLC_IOCTL_H__
 #define __HDLC_IOCTL_H__
=20
+#include <linux/if.h>
=20
 #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc uti=
lity */
=20
--=20
2.1.4
