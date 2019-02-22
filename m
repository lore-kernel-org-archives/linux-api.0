From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 1/3] bpf: add helper to check for a valid SYN cookie
Date: Fri, 22 Feb 2019 09:50:55 +0000
Message-ID: <20190222095057.9442-2-lmb@cloudflare.com>
References: <20190222095057.9442-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190222095057.9442-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc: linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Using bpf_sk_lookup_tcp it's possible to ascertain whether a packet belongs
to a known connection. However, there is one corner case: no sockets are
created if SYN cookies are active. This means that the final ACK in the
3WHS is misclassified.

Using the helper, we can look up the listening socket via bpf_sk_lookup_tcp
and then check whether a packet is a valid SYN cookie ACK.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/uapi/linux/bpf.h | 18 ++++++++++-
 net/core/filter.c        | 68 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index bcdd2474eee7..bc2af87e9621 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2359,6 +2359,21 @@ union bpf_attr {
  *	Return
  *		A **struct bpf_tcp_sock** pointer on success, or NULL in
  *		case of failure.
+ *
+ * int bpf_sk_check_syncookie(struct bpf_sock *sk, void *iph, u32 iph_len, struct tcphdr *th, u32 th_len)
+ * 	Description
+ * 		Check whether iph and th contain a valid SYN cookie ACK for
+ * 		the listening socket in sk.
+ *
+ * 		iph points to the start of the IPv4 or IPv6 header, while
+ * 		iph_len contains sizeof(struct iphdr) or sizeof(struct ip6hdr).
+ *
+ * 		th points to the start of the TCP header, while th_len contains
+ * 		sizeof(struct tcphdr).
+ *
+ * 	Return
+ * 		0 if iph and th are a valid SYN cookie ACK, or a negative error
+ * 		otherwise.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -2457,7 +2472,8 @@ union bpf_attr {
 	FN(spin_lock),			\
 	FN(spin_unlock),		\
 	FN(sk_fullsock),		\
-	FN(tcp_sock),
+	FN(tcp_sock),			\
+	FN(sk_check_syncookie),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/net/core/filter.c b/net/core/filter.c
index 85749f6ec789..9e68897cc7ed 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5426,6 +5426,70 @@ static const struct bpf_func_proto bpf_tcp_sock_proto = {
 	.arg1_type	= ARG_PTR_TO_SOCK_COMMON,
 };
 
+BPF_CALL_5(bpf_sk_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
+	   struct tcphdr *, th, u32, th_len)
+{
+#if IS_ENABLED(CONFIG_SYN_COOKIES)
+	u32 cookie;
+	int ret;
+
+	if (unlikely(th_len < sizeof(*th)))
+		return -EINVAL;
+
+	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
+	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+		return -EINVAL;
+
+	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+		return -EINVAL;
+
+	if (!th->ack || th->rst)
+		return -ENOENT;
+
+	cookie = ntohl(th->ack_seq) - 1;
+
+	switch (sk->sk_family) {
+	case AF_INET:
+		if (unlikely(iph_len < sizeof(struct iphdr)))
+			return -EINVAL;
+
+		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
+		break;
+
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
+			return -EINVAL;
+
+		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
+		break;
+#endif /* CONFIG_IPV6 */
+
+	default:
+		return -EPROTONOSUPPORT;
+	}
+
+	if (ret > 0)
+		return 0;
+
+	return -ENOENT;
+#else
+	return -ENOTSUP;
+#endif
+}
+
+static const struct bpf_func_proto bpf_sk_check_syncookie_proto = {
+	.func		= bpf_sk_check_syncookie,
+	.gpl_only	= true,
+	.pkt_access	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_SOCKET,
+	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg3_type	= ARG_CONST_SIZE,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE,
+};
+
 #endif /* CONFIG_INET */
 
 bool bpf_helper_changes_pkt_data(void *func)
@@ -5678,6 +5742,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sk_release_proto;
 	case BPF_FUNC_tcp_sock:
 		return &bpf_tcp_sock_proto;
+	case BPF_FUNC_sk_check_syncookie:
+		return &bpf_sk_check_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
@@ -5713,6 +5779,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_xdp_sk_lookup_tcp_proto;
 	case BPF_FUNC_sk_release:
 		return &bpf_sk_release_proto;
+	case BPF_FUNC_sk_check_syncookie:
+		return &bpf_sk_check_syncookie_proto;
 #endif
 	default:
 		return bpf_base_func_proto(func_id);
-- 
2.19.1
