From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: [PATCH v06 30/36] uapi rdma/rdma_user_rxe.h: include in.h and in6.h
Date: Sun,  6 Aug 2017 18:44:21 +0200
Message-ID: <20170806164428.2273-31-mikko.rapeli@iki.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170806164428.2273-1-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Fixes these userspace compilation errors when rdma_user_rxe.h is compiled
alone:

rdma/rdma_user_rxe.h:59:20: error: field ‘_sockaddr’ has incomplete type
   struct sockaddr  _sockaddr;
                    ^~~~~~~~~
rdma/rdma_user_rxe.h:60:22: error: field ‘_sockaddr_in’ has incomplete type
   struct sockaddr_in _sockaddr_in;
                      ^~~~~~~~~~~~
rdma/rdma_user_rxe.h:61:23: error: field ‘_sockaddr_in6’ has incomplete type
   struct sockaddr_in6 _sockaddr_in6;
                       ^~~~~~~~~~~~~

Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Acked-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 include/uapi/rdma/rdma_user_rxe.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/rdma/rdma_user_rxe.h b/include/uapi/rdma/rdma_user_rxe.h
index 1de99cfdaf7d..ce6c929ca331 100644
--- a/include/uapi/rdma/rdma_user_rxe.h
+++ b/include/uapi/rdma/rdma_user_rxe.h
@@ -34,6 +34,8 @@
 #define RDMA_USER_RXE_H
 
 #include <linux/types.h>
+#include <linux/in.h>
+#include <linux/in6.h>
 
 union rxe_gid {
 	__u8	raw[16];
-- 
2.13.3
