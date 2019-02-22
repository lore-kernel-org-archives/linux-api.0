From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 2/3] tools: sync changes to uapi/linux/bpf.h
Date: Fri, 22 Feb 2019 09:50:56 +0000
Message-ID: <20190222095057.9442-3-lmb@cloudflare.com>
References: <20190222095057.9442-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190222095057.9442-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc: linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Pull in definitions for bpf_sk_check_syncookie.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index bcdd2474eee7..bc2af87e9621 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
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
-- 
2.19.1
