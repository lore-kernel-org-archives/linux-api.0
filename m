From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 49/98] Break dependency loop between linux/if.h and linux/hdlc/ioctl.h
Date: Sat, 30 May 2015 17:38:41 +0200
Message-ID: <1433000370-19509-50-git-send-email-mikko.rapeli@iki.fi>
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

This isn't pretty but does the job. I assume including plain linux/hdlc=
/ioctl.h
without linux/if.h is much more rare than the other way round, and that
these header file names are part of API, and that creating a new header=
 file
just for IFNAMSIZ isn't a good idea either.

=46ixes userspace compiler error:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hdlc/ioctl.h | 5 ++++-
 include/uapi/linux/if.h         | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdlc/=
ioctl.h
index 8bbee11..73982ec 100644
--- a/include/uapi/linux/hdlc/ioctl.h
+++ b/include/uapi/linux/hdlc/ioctl.h
@@ -1,7 +1,10 @@
 #ifndef __HDLC_IOCTL_H__
 #define __HDLC_IOCTL_H__
=20
-#include <linux/if.h>
+/* For breaking dependency loop between if.h and hdlc/ioctl.h */
+#ifndef IFNAMSIZ
+#define IFNAMSIZ        16
+#endif
=20
 #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc uti=
lity */
=20
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 9cf2394..e4b130a 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -23,6 +23,10 @@
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/compiler.h>		/* for "__user" et al           */
=20
+/**
+ * IFNAMSIZ is also defined in linux/hdlc/ioctl.h if it does not exist=
s
+ * to break dependency loop between linux/if.h and linux/hdlc/ioctl.h.
+ */
 #define	IFNAMSIZ	16
 #define	IFALIASZ	256
 #include <linux/hdlc/ioctl.h>
--=20
2.1.4
