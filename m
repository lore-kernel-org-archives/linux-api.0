From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 03/13] Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
Date: Mon, 14 Sep 2015 15:50:37 -0700
Message-ID: <1442271047-4908-4-git-send-email-palmer__47806.6281452358$1442271372$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This used to be behind an #ifdef COMPAT_COMPAT, so most of userspace
wouldn't have seen the definition before.  Unfortunately this header
file became visible to userspace, so the definition has instead been
moved to net/atm/svc.c (the only user).

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
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
