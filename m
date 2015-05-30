From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 63/98] include/uapi/linux/netfilter/xt_policy.h: include linux/in.h and linux/in6.h
Date: Sat, 30 May 2015 17:38:55 +0200
Message-ID: <1433000370-19509-64-git-send-email-mikko.rapeli@iki.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netfilter-devel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

=46ixes userspace compiler errors:

error: field =E2=80=98a4=E2=80=99 has incomplete type
  struct in_addr a4;
error: field =E2=80=98a6=E2=80=99 has incomplete type
  struct in6_addr a6;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter/xt_policy.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_policy.h b/include/uapi/li=
nux/netfilter/xt_policy.h
index be8ead0..d8a9800 100644
--- a/include/uapi/linux/netfilter/xt_policy.h
+++ b/include/uapi/linux/netfilter/xt_policy.h
@@ -2,6 +2,8 @@
 #define _XT_POLICY_H
=20
 #include <linux/types.h>
+#include <linux/in.h>
+#include <linux/in6.h>
=20
 #define XT_POLICY_MAX_ELEM	4
=20
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
