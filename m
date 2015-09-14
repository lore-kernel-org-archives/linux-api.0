From: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 03/13] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Date: Mon, 14 Sep 2015 15:50:37 -0700
Message-ID: <1442271047-4908-4-git-send-email-palmer@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org, aishchuk-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 3chas3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org, dave-gkUM19QKKo4@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, iulia.manda21-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, plagnioj-sclMFOaUSTBWk0Htik3J/w@public.gmane.org, jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This used to be behind an #ifdef COMPAT_COMPAT, so most of userspace
wouldn't have seen the definition before.  Unfortunately this header
file became visible to userspace, so the definition has instead been
moved to net/atm/svc.c (the only user).

Signed-off-by: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Andrew Waterman <waterman-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
Reviewed-by: Albert Ou <aou-aFE07iDfcCIb0cFwG/AQJIdd74u8MsAO@public.gmane.org>
---
 include/uapi/linux/atmdev.h | 4 ----
 net/atm/svc.c               | 5 +++++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/atmdev.h b/include/uapi/linux/atmdev.h
index 93e0ec008ca8..3dcec701501c 100644
--- a/include/uapi/linux/atmdev.h
+++ b/include/uapi/linux/atmdev.h
@@ -100,10 +100,6 @@ struct atm_dev_stats {
 					/* use backend to make new if */
 #define ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct atm_iobuf)
  					/* add party to p2mp call */
-#ifdef CONFIG_COMPAT
-/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
-#define COMPAT_ATM_ADDPARTY  	_IOW('a', ATMIOC_SPECIAL+4,struct compat_atm_iobuf)
-#endif
 #define ATM_DROPPARTY 	_IOW('a', ATMIOC_SPECIAL+5,int)
 					/* drop party from p2mp call */
 
diff --git a/net/atm/svc.c b/net/atm/svc.c
index 3fa0a9ee98d1..9e2e6ef285e8 100644
--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -27,6 +27,11 @@
 #include "signaling.h"
 #include "addr.h"
 
+#ifdef CONFIG_COMPAT
+/* It actually takes struct sockaddr_atmsvc, not struct atm_iobuf */
+#define COMPAT_ATM_ADDPARTY _IOW('a', ATMIOC_SPECIAL+4, struct compat_atm_iobuf)
+#endif
+
 static int svc_create(struct net *net, struct socket *sock, int protocol,
 		      int kern);
 
-- 
2.4.6
