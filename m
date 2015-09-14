From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 06/13] Move ep_take_care_of_epollwakeup() to fs/eventpoll.c
Date: Mon, 14 Sep 2015 15:50:40 -0700
Message-ID: <1442271047-4908-7-git-send-email-palmer__6878.71803897924$1442271301$gmane$org@dabbelt.com>
References: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
 <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442271047-4908-1-git-send-email-palmer@dabbelt.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, dhowells@redhat.com
Cc: viro@zeniv.linux.org.uk, ast@plumgrid.com, aishchuk@linux.vnet.ibm.com, aarcange@redhat.com, akpm@linux-foundation.org, luto@kernel.org, acme@kernel.org, bhe@redhat.com, 3chas3@gmail.com, chris@zankel.net, dave@sr71.net, dyoung@redhat.com, drysdale@google.com, davem@davemloft.net, ebiederm@xmission.com, geoff@infradead.org, gregkh@linuxfoundation.org, hpa@zytor.com, mingo@kernel.org, iulia.manda21@gmail.com, plagnioj@jcrosoft.com, jikos@kernel.org, josh@joshtriplett.org, kexec@lists.infradead.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org, mathieu.desnoyers@efficios.com, jcmvbkbc@gmail.com, paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de, tomi.valkeinen@ti.com, vgoyal@redhat.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This doesn't make any sense to expose to userspace, so it's been moved
to the one user.  This was introduced by commit 95f19f658ce1 ("epoll:
drop EPOLLWAKEUP if PM_SLEEP is disabled").

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 fs/eventpoll.c                 | 13 +++++++++++++
 include/uapi/linux/eventpoll.h | 12 ------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1e009cad8d5c..aadee3d1931a 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1812,6 +1812,19 @@ SYSCALL_DEFINE1(epoll_create, int, size)
 	return sys_epoll_create1(0);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
+		epev->events &= ~EPOLLWAKEUP;
+}
+#else
+static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
+{
+	epev->events &= ~EPOLLWAKEUP;
+}
+#endif
+
 /*
  * The following function implements the controller interface for
  * the eventpoll file that enables the insertion/removal/change of
diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2e1f0e..7850373079ee 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -61,16 +61,4 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
-#ifdef CONFIG_PM_SLEEP
-static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
-{
-	if ((epev->events & EPOLLWAKEUP) && !capable(CAP_BLOCK_SUSPEND))
-		epev->events &= ~EPOLLWAKEUP;
-}
-#else
-static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
-{
-	epev->events &= ~EPOLLWAKEUP;
-}
-#endif
 #endif /* _UAPI_LINUX_EVENTPOLL_H */
-- 
2.4.6
