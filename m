From: Felipe Gasper <felipe@felipegasper.com>
Subject: [PATCH v2] net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.
Date: Fri, 17 May 2019 22:48:20 -0500
Message-ID: <20190518034820.16500-1-felipe@felipegasper.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Author: Felipe Gasper <felipe@felipegasper.com>
Date:   Fri May 17 16:54:40 2019 -0500

   net: Add UNIX_DIAG_UID to Netlink UNIX socket diagnostics.

   This adds the ability for Netlink to report a socket’s UID along with the
   other UNIX diagnostic information that is already available. This will
   allow diagnostic tools greater insight into which users control which socket.

   Signed-off-by: Felipe Gasper <felipe@felipegasper.com>

diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag.h
index 5c502fd..a198857 100644
--- a/include/uapi/linux/unix_diag.h
+++ b/include/uapi/linux/unix_diag.h
@@ -20,6 +20,7 @@ struct unix_diag_req {
 #define UDIAG_SHOW_ICONS	0x00000008	/* show pending connections */
 #define UDIAG_SHOW_RQLEN	0x00000010	/* show skb receive queue len */
 #define UDIAG_SHOW_MEMINFO	0x00000020	/* show memory info of a socket */
+#define UDIAG_SHOW_UID		0x00000040	/* show socket's UID */
 
 struct unix_diag_msg {
 	__u8	udiag_family;
@@ -40,6 +41,7 @@ enum {
 	UNIX_DIAG_RQLEN,
 	UNIX_DIAG_MEMINFO,
 	UNIX_DIAG_SHUTDOWN,
+	UNIX_DIAG_UID,
 
 	__UNIX_DIAG_MAX,
 };
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 3183d9b..e40f348 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -4,9 +4,11 @@
 #include <linux/unix_diag.h>
 #include <linux/skbuff.h>
 #include <linux/module.h>
+#include <linux/uidgid.h>
 #include <net/netlink.h>
 #include <net/af_unix.h>
 #include <net/tcp_states.h>
+#include <net/sock.h>
 
 static int sk_diag_dump_name(struct sock *sk, struct sk_buff *nlskb)
 {
@@ -110,6 +112,12 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	return nla_put(nlskb, UNIX_DIAG_RQLEN, sizeof(rql), &rql);
 }
 
+static int sk_diag_dump_uid(struct sock *sk, struct sk_buff *nlskb)
+{
+	uid_t uid = from_kuid_munged(sk_user_ns(sk), sock_i_uid(sk));
+	return nla_put(nlskb, UNIX_DIAG_UID, sizeof(uid_t), &uid);
+}
+
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_req *req,
 		u32 portid, u32 seq, u32 flags, int sk_ino)
 {
@@ -156,6 +164,10 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb, struct unix_diag_r
 	if (nla_put_u8(skb, UNIX_DIAG_SHUTDOWN, sk->sk_shutdown))
 		goto out_nlmsg_trim;
 
+	if ((req->udiag_show & UDIAG_SHOW_UID) &&
+	    sk_diag_dump_uid(sk, skb))
+		goto out_nlmsg_trim;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
