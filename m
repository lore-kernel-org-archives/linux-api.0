From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 36/45] include/uapi/linux/netfilter.h: include in.h and in6.h
Date: Tue, 17 Feb 2015 00:05:39 +0100
Message-ID: <1424127948-22484-37-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compile errors like:
error: field =E2=80=98in=E2=80=99 has incomplete type
error: field =E2=80=98in6=E2=80=99 has incomplete type

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfil=
ter.h
index ef1b1f8..750c04e 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -4,7 +4,8 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/sysctl.h>
-
+#include <linux/in.h>
+#include <linux/in6.h>
=20
 /* Responses from hook functions. */
 #define NF_DROP 0
--=20
2.1.4
