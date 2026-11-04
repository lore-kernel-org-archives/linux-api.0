Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.205.221.221
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763370;
	b=Zl6s+dCbspBsPhBvo+I8Cib6wii7rPh/oZxHyMej7WXBV6JXLEHj3pCxEvXyHfbdTENt
	 bUpT4EZpnldFs+WTjPopWdcFAYWH2AZp/9P+5b8dxEF1ZZiWsoNejv0zOeCYl85x7tsYz
	 Xtrszzf0bnGSs3fy+iZqKhADHWrBg5TipTasBl+sDKQD6nc5wgRtae71xvDEuSHMSr1wE
	 ec09SDa0j62B93Qt0Q3SLUvK7YHkEgqtTgl8kv7mvAUG34+Lfv63ywNl0PUq/GqJecM6s
	 VS85eDVCqzplhVw3EboOUEoGDbLqUZFDsaNVGv4ku2wy3+f8vcAjviiy5NMhAOgpePw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763370;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qpopuN+doQba10jwAd2uL5NWTJlgEoGqpws2vkRC128=;
	b=wt/geMWep/upn3dU3neWhsPr9xvmi7BADu6Kf5gOb2AwZP+jRS5UeyXYpnJJQV+LiD3b
	 sXZqtPdnI+IV7Dsqslce1jzg+8SJWb+sFd1Q+Ano7qK4tXJokI9c9ik1f+Ipyxycmgq/m
	 ElFwFi05r5nLG840vP/yZK49xXbu4mEkaoOdaC/0L6B0mHLLfIM0wxKFgbs9s022KS0gQ
	 0zBEFZx5plKPq1NRjPbMk1GzCECsO3WDjO28teZlmKKfnI4NqCLhoT2TjLijApbd/OR9n
	 7Lep/3fOeeurWi0yzJWgMYA3KXVGMVoiu2Jgzabx7g7V5pUkPHro2FqPeePITeYTAxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SgFS66+b;
	arc=none smtp.remote-ip=203.205.221.221
Received: from out203-205-221-221.mail.qq.com (out203-205-221-221.mail.qq.com [203.205.221.221])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75311606A31B;
	Wed,  4 Nov 2026 03:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75311606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=SgFS66+b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1793763365; bh=qpopuN+doQba10jwAd2uL5NWTJlgEoGqpws2vkRC128=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgFS66+bOeE86tIX0Eq0IxCQpnWyOCfdSirYX4vTQNoeDI33U7rNMYlo1LVbS585c
	 EbSs3liyLu55O90hy3WYYxDPm7oKjGbZL6BO9L6KcPHXtmkBKn/XUucNshYTeCYnud
	 y5cV4qNYdFB82vwCml8wAHkFplWz7u+l3l9Ug2KY=
Received: from hub.zhongying.com.zhongying.com ([2409:891f:8f46:1a8b:2dd5:45b2:eebc:59b4])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id 8DBB9AD2; Wed, 04 Nov 2026 11:35:27 +0800
X-QQ-mid: xmsmtpt1793763361th133irx5
Message-ID: <tencent_1E208C03035DF063166FD46C1DA1978F6306@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4AgHR8pUw7izfIXguPi5//qyNitnHngK09yoAuitbbDAMiCye2ku5
	 wEPVkXHIN4weRhn5RKColmvGD39TvYSlOJKmX7ooq2FJg8gEce0l0wSIELnzlptvQpUfOj8rBTp1
	 6EMzwuiQ1U8LGoD0LMaYxOhAqIygsTXtY+5R1y+oTg/EYkec8IFq1fkxiN+2i1dHK0ex/vSZ5QgU
	 Pf7/h8ckpxN9Wx7ag60uv1tryRnt90r7y8HjMQa+WFeY3ZCkxxdoAU762leBFitDSuQECPnROJFv
	 FGk12iiemQoz97ysigqYrRtZBmYNM5pVP2/ImgiZb+oyluZ4K7UwfTHkR9khTDUAn1a4uM943wq4
	 SIXb1NjsjkdvjWvUAOk/ajaPX+CWu5mWUqCLExXBuubW9LvjmsjGjOUqwfI1EfDytWWBAv5jiaO5
	 BZYlglfyBLlwPicG4sf+sm6xgVI3KlfadOAmwo1qvlBK00WQ+xy9YIupOW9HR4IoF8s63P2VtZW/
	 fCTFfcCHYa868Hu+XQQ38QWApmCl8oIpHr33+qC3kYK4xWcVtHXAz0+Vu0Fsda8+of2By0HVmrfc
	 mh35RiUmH5rNmCjLgBGhSRyKpToKP897qMjRTAbYKE7dKCOLgeoMsGGXjJaSTM60wvXsj/iqeP1s
	 dVPRQ/2jw4IlRAt6DXu9gbk4Y7hjww88nQPwlCT921FaWg2GqvyD+orBLGkLM+QbvOXAgwyZ7QK5
	 NkmhVXpHSaK3+ibMVFtZpmyuTw4ch/4swYZNIym3dsjwZVPxYfNeQ9ZRLZ1n3y0fM39RP6qnPb9B
	 kDiG6Ol76/s1zdCv61V06Lo8R99UurHXGquNuTCoHtZxGWFLileb13KjoD6B4J4g7eDujsBRNN9t
	 brct2OoK4o5KbWAsgMjUvm7qGSnT3GQr7/fRb4IjIIpvuc4uZB51DUjm86fBLMo8HHonJ3GpHTZE
	 kyGBlRAH5vMfrI/cVYFKe9ZX4ZBTuaFH+GkfuuwKFCj+nh8KC4f8LOL9BofNBUijJ8lKe63W4R2N
	 WTf89P08YNqNTWGs4nXwENeq/W/l+mfUvIzRtf93tlA8uowgLWnsnCbPBp2pZIhSlsydikx6L/0m
	 mdvjap
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: patrick <work_patrick@qq.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kselftest@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] netlink: add an optional per-netns ROUTE multicast index
Date: Wed,  4 Nov 2026 11:35:25 +0800
X-OQ-MSGID: <20261104033526.2917590-2-work_patrick@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261104033526.2917590-1-work_patrick@qq.com>
References: <20261104033526.2917590-1-work_patrick@qq.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NETLINK_ROUTE broadcasts visit subscribers in unrelated network namespaces
before checking whether they can receive a notification.

Maintain one ROUTE subscriber list per network namespace and one global
LISTEN_ALL_NSID list. Select those candidate lists when the new
net.core.netlink_route_mc_index sysctl is enabled. Exclude local sockets
from the second list to avoid duplicate delivery.

Preserve do_one_broadcast and the existing broadcast initialization,
locking, completion and error handling. Change only candidate selection
inside netlink_broadcast_filtered; do not force function inlining or add
separate broadcast setup, completion or indexed-walk helpers.

Use the existing table-grab protection for index maintenance at
subscription, option and removal transitions. Keep both indexes populated
while disabled so switching modes includes existing sockets immediately.
The sysctl defaults to zero, is visible only in init_net and affects all
network namespaces. Other Netlink protocols retain the original walk.
Disabling the switch retains index maintenance and memory costs.

AI assistance: An LLM assisted with implementation adaptation and
simplification.

Signed-off-by: patrick <work_patrick@qq.com>
---
 Documentation/admin-guide/sysctl/net.rst |  27 ++++++
 net/netlink/af_netlink.c                 | 109 ++++++++++++++++++++++-
 net/netlink/af_netlink.h                 |   4 +
 3 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index fe43e8595..0cda347ed 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -280,6 +280,33 @@ checksums.
 These messages are now emitted at KERN_DEBUG and can generally be enabled
 and controlled by the dynamic_debug facility.
 
+netlink_route_mc_index
+---------------------
+
+Selects the multicast candidate lists used for NETLINK_ROUTE notifications.
+This setting is available only in the initial network namespace and applies
+to notifications originating in all network namespaces.
+
+Values:
+
+	- 0 - walk the original global subscription list (default).
+	- 1 - walk the sender's network namespace subscription list and the
+	  global NETLINK_LISTEN_ALL_NSID subscription list, regardless of the
+	  number of subscribers.
+
+Both auxiliary indexes are maintained in either mode.
+Existing sockets are therefore included immediately when the index is enabled.
+Each broadcast reads the setting once and completes using its selected path;
+changing the setting does not restart broadcasts already in progress.
+Group membership, namespace, permission and socket filter checks still apply
+in both modes. Other Netlink protocols continue to use their original lists.
+
+The indexed path can reduce notification costs when there are many ordinary
+subscribers in other network namespaces. It may add overhead when most
+subscribers are local or listen across network namespaces. Disabling the
+indexed path does not remove its memory or subscription maintenance costs.
+Without CONFIG_SYSCTL, the setting remains at its default value of 0.
+
 netdev_budget
 -------------
 
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 1281c42a3..fa21290be 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/stat.h>
 #include <linux/socket.h>
+#include <linux/sysctl.h>
 #include <linux/un.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>
@@ -93,6 +94,69 @@ EXPORT_SYMBOL_GPL(nl_table);
 
 static DECLARE_WAIT_QUEUE_HEAD(nl_table_wait);
 
+/*
+ * Auxiliary NETLINK_ROUTE candidate indexes. Writers hold the table grabbed;
+ * broadcasts pin the same table with netlink_lock_table(). Socket/netns
+ * lifetime therefore follows the original mc_list, without another RCU domain.
+ */
+struct netlink_route_net {
+	struct hlist_head mc_list;
+};
+
+static unsigned int netlink_route_net_id;
+static HLIST_HEAD(netlink_route_all_nsid);
+
+/* Indexes stay populated in both modes; each broadcast samples this once. */
+static int netlink_route_mc_index __read_mostly;
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table netlink_route_sysctls[] = {
+	{
+		.procname	= "netlink_route_mc_index",
+		.data		= &netlink_route_mc_index,
+		.maxlen		= sizeof(netlink_route_mc_index),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+};
+
+static int __init netlink_route_sysctl_init(void)
+{
+	if (!register_net_sysctl(&init_net, "net/core", netlink_route_sysctls))
+		return -ENOMEM;
+	return 0;
+}
+fs_initcall(netlink_route_sysctl_init);
+#endif
+
+static void netlink_update_route_mc(struct sock *sk, unsigned int subscriptions)
+{
+	struct netlink_sock *nlk = nlk_sk(sk);
+	struct netlink_route_net *nn;
+
+	if (sk->sk_protocol != NETLINK_ROUTE)
+		return;
+
+	lockdep_assert_held(&nl_table_lock);
+	nn = net_generic(sock_net(sk), netlink_route_net_id);
+	if (subscriptions) {
+		if (hlist_unhashed(&nlk->mc_net_node))
+			hlist_add_head(&nlk->mc_net_node, &nn->mc_list);
+	} else if (!hlist_unhashed(&nlk->mc_net_node)) {
+		hlist_del_init(&nlk->mc_net_node);
+	}
+
+	if (subscriptions && nlk_test_bit(LISTEN_ALL_NSID, sk)) {
+		if (hlist_unhashed(&nlk->mc_all_nsid_node))
+			hlist_add_head(&nlk->mc_all_nsid_node,
+				       &netlink_route_all_nsid);
+	} else if (!hlist_unhashed(&nlk->mc_all_nsid_node)) {
+		hlist_del_init(&nlk->mc_all_nsid_node);
+	}
+}
+
 static struct lock_class_key nlk_cb_mutex_keys[MAX_LINKS];
 
 static const char *const nlk_cb_mutex_key_strings[MAX_LINKS + 1] = {
@@ -598,6 +662,7 @@ static void netlink_remove(struct sock *sk)
 		__sock_put(sk);
 
 	netlink_table_grab();
+	netlink_update_route_mc(sk, 0);
 	if (nlk_sk(sk)->subscriptions) {
 		__sk_del_bind_node(sk);
 		netlink_update_listeners(sk);
@@ -628,6 +693,8 @@ static int __netlink_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 
 	nlk = nlk_sk(sk);
+	INIT_HLIST_NODE(&nlk->mc_net_node);
+	INIT_HLIST_NODE(&nlk->mc_all_nsid_node);
 	mutex_init(&nlk->nl_cb_mutex);
 	lockdep_set_class_and_name(&nlk->nl_cb_mutex,
 					   nlk_cb_mutex_keys + protocol,
@@ -915,6 +982,7 @@ netlink_update_subscriptions(struct sock *sk, unsigned int subscriptions)
 	else if (!nlk->subscriptions && subscriptions)
 		sk_add_bind_node(sk, &nl_table[sk->sk_protocol].mc_list);
 	nlk->subscriptions = subscriptions;
+	netlink_update_route_mc(sk, subscriptions);
 }
 
 static int netlink_realloc_groups(struct sock *sk)
@@ -1555,8 +1623,25 @@ int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
 
 	netlink_lock_table();
 
-	sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].mc_list)
-		do_one_broadcast(sk, &info);
+	if (ssk->sk_protocol == NETLINK_ROUTE &&
+	    READ_ONCE(netlink_route_mc_index)) {
+		struct netlink_route_net *nn;
+		struct netlink_sock *nlk;
+
+		nn = net_generic(net, netlink_route_net_id);
+		hlist_for_each_entry(nlk, &nn->mc_list, mc_net_node)
+			do_one_broadcast(&nlk->sk, &info);
+
+		/* Local all-nsid listeners were visited above. */
+		hlist_for_each_entry(nlk, &netlink_route_all_nsid,
+				     mc_all_nsid_node) {
+			if (!net_eq(sock_net(&nlk->sk), net))
+				do_one_broadcast(&nlk->sk, &info);
+		}
+	} else {
+		sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].mc_list)
+			do_one_broadcast(sk, &info);
+	}
 
 	consume_skb(skb);
 
@@ -1722,6 +1807,13 @@ static int netlink_setsockopt(struct socket *sock, int level, int optname,
 	case NETLINK_LISTEN_ALL_NSID:
 		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_BROADCAST))
 			return -EPERM;
+		if (sk->sk_protocol == NETLINK_ROUTE) {
+			netlink_table_grab();
+			assign_bit(NETLINK_F_LISTEN_ALL_NSID, &nlk->flags, val);
+			netlink_update_route_mc(sk, nlk->subscriptions);
+			netlink_table_ungrab();
+			return 0;
+		}
 		nr = NETLINK_F_LISTEN_ALL_NSID;
 		break;
 	case NETLINK_CAP_ACK:
@@ -2867,6 +2959,9 @@ static const struct net_proto_family netlink_family_ops = {
 
 static int __net_init netlink_net_init(struct net *net)
 {
+	struct netlink_route_net *nn = net_generic(net, netlink_route_net_id);
+
+	INIT_HLIST_HEAD(&nn->mc_list);
 #ifdef CONFIG_PROC_FS
 	if (!proc_create_net("netlink", 0, net->proc_net, &netlink_seq_ops,
 			sizeof(struct nl_seq_iter)))
@@ -2877,6 +2972,11 @@ static int __net_init netlink_net_init(struct net *net)
 
 static void __net_exit netlink_net_exit(struct net *net)
 {
+	struct netlink_route_net *nn = net_generic(net, netlink_route_net_id);
+
+	netlink_table_grab();
+	WARN_ON_ONCE(!hlist_empty(&nn->mc_list));
+	netlink_table_ungrab();
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("netlink", net->proc_net);
 #endif
@@ -2905,6 +3005,8 @@ static void __init netlink_add_usersock_entry(void)
 static struct pernet_operations __net_initdata netlink_net_ops = {
 	.init = netlink_net_init,
 	.exit = netlink_net_exit,
+	.id = &netlink_route_net_id,
+	.size = sizeof(struct netlink_route_net),
 };
 
 static inline u32 netlink_hash(const void *data, u32 len, u32 seed)
@@ -2980,7 +3082,8 @@ static int __init netlink_proto_init(void)
 	netlink_add_usersock_entry();
 
 	sock_register(&netlink_family_ops);
-	register_pernet_subsys(&netlink_net_ops);
+	if (register_pernet_subsys(&netlink_net_ops))
+		goto panic;
 	register_pernet_subsys(&netlink_tap_net_ops);
 	/* The netlink device handler may be needed early. */
 	rtnetlink_init();
diff --git a/net/netlink/af_netlink.h b/net/netlink/af_netlink.h
index 778a38093..bc7b38d4f 100644
--- a/net/netlink/af_netlink.h
+++ b/net/netlink/af_netlink.h
@@ -47,6 +47,10 @@ struct netlink_sock {
 						   unsigned long *groups);
 	struct module		*module;
 
+	/* NETLINK_ROUTE auxiliary multicast indexes; nl_table_lock protected. */
+	struct hlist_node	mc_net_node;
+	struct hlist_node	mc_all_nsid_node;
+
 	struct rhash_head	node;
 	struct rcu_head		rcu;
 };

