From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 44/45] nf_conntrack_tuple_common.h: include linux/types.h and linux/netfilter.h
Date: Tue, 17 Feb 2015 00:05:47 +0100
Message-ID: <1424127948-22484-45-git-send-email-mikko.rapeli@iki.fi>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netfilter-devel-owner@vger.kernel.org>
In-Reply-To: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compilation errors like:
error: unknown type name =E2=80=98__be16=E2=80=99

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter/nf_conntrack_tuple_common.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h b=
/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
index 2f6bbc5..a9c3834 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h
@@ -1,6 +1,9 @@
 #ifndef _NF_CONNTRACK_TUPLE_COMMON_H
 #define _NF_CONNTRACK_TUPLE_COMMON_H
=20
+#include <linux/types.h>
+#include <linux/netfilter.h>
+
 enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
 	IP_CT_DIR_REPLY,
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
