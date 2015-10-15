From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 45/79] linux/if.h linux/hdlc/ioctl.h: move IFNAMSIZ definition to hdlc/ioctl.h
Date: Thu, 15 Oct 2015 07:56:23 +0200
Message-ID: <1444888618-4506-46-git-send-email-mikko.rapeli@iki.fi>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: mikko.rapeli@iki.fi, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

And include linux/hdlc/ioctl.h from linux/if.h.

=46ixes userspace compiler error:

error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)

Suggested by Frans Klaver <fransklaver@gmail.com> on lkml message
<20150530195223.GA15645@bugger.home>.

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/hdlc/ioctl.h | 1 +
 include/uapi/linux/if.h         | 6 ++----
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdlc/=
ioctl.h
index 04bc027..d1b1de5 100644
--- a/include/uapi/linux/hdlc/ioctl.h
+++ b/include/uapi/linux/hdlc/ioctl.h
@@ -1,6 +1,7 @@
 #ifndef __HDLC_IOCTL_H__
 #define __HDLC_IOCTL_H__
=20
+#define IFNAMSIZ        16
=20
 #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc uti=
lity */
=20
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 9cf2394..0f98f0a 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -22,10 +22,8 @@
 #include <linux/types.h>		/* for "__kernel_caddr_t" et al	*/
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/compiler.h>		/* for "__user" et al           */
-
-#define	IFNAMSIZ	16
-#define	IFALIASZ	256
-#include <linux/hdlc/ioctl.h>
+#include <linux/hdlc/ioctl.h>           /* for IFNAMSIZ               =
  */
+#define        IFALIASZ        256
=20
 /**
  * enum net_device_flags - &struct net_device flags
--=20
2.5.0
