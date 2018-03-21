From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/28] net: refactor socket_poll
Date: Wed, 21 Mar 2018 08:40:11 +0100
Message-ID: <20180321074032.14211-8-hch@lst.de>
References: <20180321074032.14211-1-hch@lst.de>
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <20180321074032.14211-1-hch@lst.de>
Sender: owner-linux-aio@kvack.org
To: viro@zeniv.linux.org.uk
Cc: Avi Kivity <avi@scylladb.com>, linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Factor out two busy poll related helpers for late reuse, and remove
a command that isn't very helpful, especially with the __poll_t
annotations in place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/net/busy_poll.h | 15 +++++++++++++++
 net/socket.c            | 21 ++++-----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 71c72a939bf8..c5187438af38 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -121,6 +121,21 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 #endif
 }
 
+static inline void sock_poll_busy_loop(struct socket *sock, __poll_t events)
+{
+	if (sk_can_busy_loop(sock->sk) &&
+	    events && (events & POLL_BUSY_LOOP)) {
+		/* once, only if requested by syscall */
+		sk_busy_loop(sock->sk, 1);
+	}
+}
+
+/* if this socket can poll_ll, tell the system call */
+static inline __poll_t sock_poll_busy_flag(struct socket *sock)
+{
+	return sk_can_busy_loop(sock->sk) ? POLL_BUSY_LOOP : 0;
+}
+
 /* used in the NIC receive handler to mark the skb */
 static inline void skb_mark_napi_id(struct sk_buff *skb,
 				    struct napi_struct *napi)
diff --git a/net/socket.c b/net/socket.c
index a93c99b518ca..3f859a07641a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1117,24 +1117,11 @@ EXPORT_SYMBOL(sock_create_lite);
 /* No kernel lock held - perfect */
 static __poll_t sock_poll(struct file *file, poll_table *wait)
 {
-	__poll_t busy_flag = 0;
-	struct socket *sock;
-
-	/*
-	 *      We can't return errors to poll, so it's either yes or no.
-	 */
-	sock = file->private_data;
-
-	if (sk_can_busy_loop(sock->sk)) {
-		/* this socket can poll_ll so tell the system call */
-		busy_flag = POLL_BUSY_LOOP;
-
-		/* once, only if requested by syscall */
-		if (wait && (wait->_key & POLL_BUSY_LOOP))
-			sk_busy_loop(sock->sk, 1);
-	}
+	struct socket *sock = file->private_data;
+	__poll_t events = poll_requested_events(wait);
 
-	return busy_flag | sock->ops->poll(file, sock, wait);
+	sock_poll_busy_loop(sock, events);
+	return sock->ops->poll(file, sock, wait) | sock_poll_busy_flag(sock);
 }
 
 static int sock_mmap(struct file *file, struct vm_area_struct *vma)
-- 
2.14.2

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
