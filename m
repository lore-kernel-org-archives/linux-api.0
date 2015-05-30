From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH 71/98] include/uapi/linux/netfilter/xt_TEE.h: include linux/netfilter.h
Date: Sat, 30 May 2015 17:39:03 +0200
Message-ID: <1433000370-19509-72-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>, Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>, Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, coreteam-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: field =E2=80=98gw=E2=80=99 has incomplete type
  union nf_inet_addr gw;

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
---
 include/uapi/linux/netfilter/xt_TEE.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_TEE.h b/include/uapi/linux=
/netfilter/xt_TEE.h
index 5c21d5c..0109202 100644
--- a/include/uapi/linux/netfilter/xt_TEE.h
+++ b/include/uapi/linux/netfilter/xt_TEE.h
@@ -1,6 +1,8 @@
 #ifndef _XT_TEE_TARGET_H
 #define _XT_TEE_TARGET_H
=20
+#include <linux/netfilter.h>
+
 struct xt_tee_tginfo {
 	union nf_inet_addr gw;
 	char oif[16];
--=20
2.1.4
