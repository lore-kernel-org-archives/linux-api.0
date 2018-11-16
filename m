From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 2/4] bpf: move BPF_F_QUERY_EFFECTIVE after map flags
Date: Fri, 16 Nov 2018 11:41:09 +0000
Message-ID: <20181116114111.31177-3-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181116114111.31177-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116114111.31177-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, songliubraving@fb.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

BPF_F_QUERY_EFFECTIVE is in the middle of the flags valid
for BPF_MAP_CREATE. Move it to its own section to reduce confusion.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/uapi/linux/bpf.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 8c01b89a4cb4..05d95290b848 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -257,9 +257,6 @@ enum bpf_attach_type {
 /* Specify numa node during map creation */
 #define BPF_F_NUMA_NODE		(1U << 2)
 
-/* flags for BPF_PROG_QUERY */
-#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
-
 #define BPF_OBJ_NAME_LEN 16U
 
 /* Flags for accessing BPF object */
@@ -272,6 +269,9 @@ enum bpf_attach_type {
 /* Zero-initialize hash function seed. This should only be used for testing. */
 #define BPF_F_ZERO_SEED		(1U << 6)
 
+/* flags for BPF_PROG_QUERY */
+#define BPF_F_QUERY_EFFECTIVE	(1U << 0)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY = 0,
-- 
2.17.1
