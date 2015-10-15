From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH v4 61/79] include/uapi/linux/scc.h: include linux/sockios.h
Date: Thu, 15 Oct 2015 07:56:39 +0200
Message-ID: <1444888618-4506-62-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation error:

error: =E2=80=98SIOCDEVPRIVATE=E2=80=99 undeclared here (not in a funct=
ion)
  SIOCSCCRESERVED =3D SIOCDEVPRIVATE

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/scc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/scc.h b/include/uapi/linux/scc.h
index 72b6b81..2992b88 100644
--- a/include/uapi/linux/scc.h
+++ b/include/uapi/linux/scc.h
@@ -3,6 +3,7 @@
 #ifndef _UAPI_SCC_H
 #define _UAPI_SCC_H
=20
+#include <linux/sockios.h>
=20
 /* selection of hardware types */
=20
--=20
2.5.0
