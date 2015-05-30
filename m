From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 54/98] include/uapi/linux/dlm_netlink.h: include linux/dlmconstants.h
Date: Sat, 30 May 2015 17:38:46 +0200
Message-ID: <1433000370-19509-55-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: =E2=80=98DLM_RESNAME_MAXLEN=E2=80=99 undeclared here (not in a f=
unction)
  char resource_name[DLM_RESNAME_MAXLEN];

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/dlm_netlink.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/dlm_netlink.h b/include/uapi/linux/dlm_=
netlink.h
index 647c8ef..ef1e2e0 100644
--- a/include/uapi/linux/dlm_netlink.h
+++ b/include/uapi/linux/dlm_netlink.h
@@ -10,6 +10,7 @@
 #define _DLM_NETLINK_H
=20
 #include <linux/types.h>
+#include <linux/dlmconstants.h>
=20
 enum {
 	DLM_STATUS_WAITING =3D 1,
--=20
2.1.4
