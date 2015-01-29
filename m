From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 5/5] IB/core: ib_copy_to_udata(): don't silently truncate response
Date: Thu, 29 Jan 2015 19:00:02 +0100
Message-ID: <c69af8952bf25fdbcdfc527b0636bc3177798b95.1422553023.git.ydroneaud@opteya.com>
References: <cover.1422553023.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

While ib_copy_to_udata() should check for the available output
space as already proposed in some other patches [1][2][3], the
changes brought by commit 5a77abf9a97a ("IB/core: Add support for
extended query device caps") are silently truncating the data to
be written to userspace if the output buffer is not large enough
to hold the response data.

Silently truncating the response is not a reliable behavior as
userspace is not given any hint about this truncation: userspace
is leaved with garbage to play with.

Not checking the response buffer size and writing past the
userspace buffer is no good either, but it's the current behavior.

So this patch revert the particular change on ib_copy_to_udata()
as a better behavior is implemented in the upper level function
ib_uverbs_ex_query_device().

[1] "[PATCH 00/22] infiniband: improve userspace input check"

http://mid.gmane.org/cover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] "[PATCH 03/22] infiniband: ib_copy_from_udata(): check input length"

http://mid.gmane.org/2bf102a41c51f61965ee09df827abe8fefb523a9.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] "[PATCH 04/22] infiniband: ib_copy_to_udata(): check output length"

http://mid.gmane.org/d27716a3a1c180f832d153a7402f65ea8a75b734.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Link: http://mid.gmane.org/cover.1422553023.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 include/rdma/ib_verbs.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 0d74f1de99aa..65994a19e840 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1707,10 +1707,7 @@ static inline int ib_copy_from_udata(void *dest, struct ib_udata *udata, size_t
 
 static inline int ib_copy_to_udata(struct ib_udata *udata, void *src, size_t len)
 {
-	size_t copy_sz;
-
-	copy_sz = min_t(size_t, len, udata->outlen);
-	return copy_to_user(udata->outbuf, src, copy_sz) ? -EFAULT : 0;
+	return copy_to_user(udata->outbuf, src, len) ? -EFAULT : 0;
 }
 
 /**
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
