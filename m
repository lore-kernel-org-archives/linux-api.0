From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 67/98] include/uapi/linux/netfilter/ipset/ip_set_bitmap.h: include linux/netfilter/ipset/ip_set.h
Date: Sat, 30 May 2015 17:38:59 +0200
Message-ID: <1433000370-19509-68-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation error:

error: =E2=80=98IPSET_ERR_TYPE_SPECIFIC=E2=80=99 undeclared here (not i=
n a function)
  IPSET_ERR_BITMAP_RANGE =3D IPSET_ERR_TYPE_SPECIFIC,

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter/ipset/ip_set_bitmap.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h b/inclu=
de/uapi/linux/netfilter/ipset/ip_set_bitmap.h
index 6a2c038..fd5024d 100644
--- a/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h
+++ b/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI__IP_SET_BITMAP_H
 #define _UAPI__IP_SET_BITMAP_H
=20
+#include <linux/netfilter/ipset/ip_set.h>
+
 /* Bitmap type specific error codes */
 enum {
 	/* The element is out of the range of the set */
--=20
2.1.4
