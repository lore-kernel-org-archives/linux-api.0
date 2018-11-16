From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 3/4] tools: sync linux/bpf.h
Date: Fri, 16 Nov 2018 11:41:10 +0000
Message-ID: <20181116114111.31177-4-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181116114111.31177-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116114111.31177-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, songliubraving@fb.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Synchronize changes to linux/bpf.h from
* "bpf: allow zero-initializing hash map seed"
* "bpf: move BPF_F_QUERY_EFFECTIVE after map flags"

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 852dc17ab47a..05d95290b848 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -257,9 +257,6 @@ enum bpf_attach_type {
 /* Specify numa node during map creation */
 #define BPF_F_NUMA_NODE		(1U << 2)
 
-/* flags for BPF_PROG_QUERY */
-#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
-
 #define BPF_OBJ_NAME_LEN 16U
 
 /* Flags for accessing BPF object */
@@ -269,6 +266,12 @@ enum bpf_attach_type {
 /* Flag for stack_map, store build_id+offset instead of pointer */
 #define BPF_F_STACK_BUILD_ID	(1U << 5)
 
+/* Zero-initialize hash function seed. This should only be used for testing. */
+#define BPF_F_ZERO_SEED		(1U << 6)
+
+/* flags for BPF_PROG_QUERY */
+#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY = 0,
@@ -2201,6 +2204,8 @@ union bpf_attr {
  *		**CONFIG_NET** configuration option.
  *	Return
  *		Pointer to *struct bpf_sock*, or NULL in case of failure.
+ *		For sockets with reuseport option, *struct bpf_sock*
+ *		return is from reuse->socks[] using hash of the packet.
  *
  * struct bpf_sock *bpf_sk_lookup_udp(void *ctx, struct bpf_sock_tuple *tuple, u32 tuple_size, u32 netns, u64 flags)
  *	Description
@@ -2233,6 +2238,8 @@ union bpf_attr {
  *		**CONFIG_NET** configuration option.
  *	Return
  *		Pointer to *struct bpf_sock*, or NULL in case of failure.
+ *		For sockets with reuseport option, *struct bpf_sock*
+ *		return is from reuse->socks[] using hash of the packet.
  *
  * int bpf_sk_release(struct bpf_sock *sk)
  *	Description
-- 
2.17.1
