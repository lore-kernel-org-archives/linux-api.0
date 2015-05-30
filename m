From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 75/98] include/uapi/linux/netfilter/xt_sctp.h: use _Bool type, 1 for true and 0 for false
Date: Sat, 30 May 2015 17:39:07 +0200
Message-ID: <1433000370-19509-76-git-send-email-mikko.rapeli@iki.fi>
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

=46ixes userspace compilation errors like:

error: unknown type name =E2=80=98bool=E2=80=99
 static __inline__ bool
error: =E2=80=98false=E2=80=99 undeclared (first use in this function)
    return false;

Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
---
 include/uapi/linux/netfilter/xt_sctp.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_sctp.h b/include/uapi/linu=
x/netfilter/xt_sctp.h
index 29287be..58ffcfb 100644
--- a/include/uapi/linux/netfilter/xt_sctp.h
+++ b/include/uapi/linux/netfilter/xt_sctp.h
@@ -66,26 +66,26 @@ struct xt_sctp_info {
=20
 #define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
 	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
-static inline bool
+static inline _Bool
 __sctp_chunkmap_is_clear(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i =3D 0; i < n; ++i)
 		if (chunkmap[i])
-			return false;
-	return true;
+			return 0;
+	return 1;
 }
=20
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
 	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
-static inline bool
+static inline _Bool
 __sctp_chunkmap_is_all_set(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i =3D 0; i < n; ++i)
 		if (chunkmap[i] !=3D ~0U)
-			return false;
-	return true;
+			return 0;
+	return 1;
 }
=20
 #endif /* _XT_SCTP_H_ */
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
