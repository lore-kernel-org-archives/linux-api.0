From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 06/13] Hide ep_take_care_of_epollwakeup() behind #ifdef __KERNEL__
Date: Wed,  9 Sep 2015 14:08:15 -0700
Message-ID: <1441832902-28993-7-git-send-email-palmer@dabbelt.com>
References: <2644177.lVCYzIBfPW@wuerfel>
 <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1441832902-28993-1-git-send-email-palmer@dabbelt.com>
Sender: netdev-owner@vger.kernel.org
To: arnd@arndb.de
Cc: 3chas3@gmail.com, hpa@zytor.com, mingo@redhat.com, plagnioj@jcrosoft.com, jikos@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-atm-general@lists.sourceforge.net, linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de, tomi.valkeinen@ti.com, x86@kernel.org, Palmer Dabbelt <palmer@dabbelt.com>
List-Id: linux-api@vger.kernel.org

This doesn't make any sense to expose to userspace.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Andrew Waterman <waterman@eecs.berkeley.edu>
Reviewed-by: Albert Ou <aou@eecs.berkeley.edu>
---
 include/uapi/linux/eventpoll.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/eventpoll.h b/include/uapi/linux/eventpoll.h
index bc81fb2e1f0e..290426bfb0aa 100644
--- a/include/uapi/linux/eventpoll.h
+++ b/include/uapi/linux/eventpoll.h
@@ -61,6 +61,7 @@ struct epoll_event {
 	__u64 data;
 } EPOLL_PACKED;
 
+#ifdef __KERNEL__
 #ifdef CONFIG_PM_SLEEP
 static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 {
@@ -73,4 +74,6 @@ static inline void ep_take_care_of_epollwakeup(struct epoll_event *epev)
 	epev->events &= ~EPOLLWAKEUP;
 }
 #endif
+#endif /*__KERNEL__*/
+
 #endif /* _UAPI_LINUX_EVENTPOLL_H */
-- 
2.4.6
