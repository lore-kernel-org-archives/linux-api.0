From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 1/4] bpf: allow zero-initializing hash map seed
Date: Fri, 16 Nov 2018 11:41:08 +0000
Message-ID: <20181116114111.31177-2-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181116114111.31177-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116114111.31177-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, songliubraving@fb.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Add a new flag BPF_F_ZERO_SEED, which forces a hash map
to initialize the seed to zero. This is useful when doing
performance analysis both on individual BPF programs, as
well as the kernel's hash table implementation.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/uapi/linux/bpf.h |  3 +++
 kernel/bpf/hashtab.c     | 13 +++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 47d606d744cc..8c01b89a4cb4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -269,6 +269,9 @@ enum bpf_attach_type {
 /* Flag for stack_map, store build_id+offset instead of pointer */
 #define BPF_F_STACK_BUILD_ID	(1U << 5)
 
+/* Zero-initialize hash function seed. This should only be used for testing. */
+#define BPF_F_ZERO_SEED		(1U << 6)
+
 enum bpf_stack_build_id_status {
 	/* user space need an empty entry to identify end of a trace */
 	BPF_STACK_BUILD_ID_EMPTY = 0,
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2c1790288138..4b7c76765d9d 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -23,7 +23,7 @@
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_RDONLY | BPF_F_WRONLY)
+	 BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_ZERO_SEED)
 
 struct bucket {
 	struct hlist_nulls_head head;
@@ -244,6 +244,7 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	 */
 	bool percpu_lru = (attr->map_flags & BPF_F_NO_COMMON_LRU);
 	bool prealloc = !(attr->map_flags & BPF_F_NO_PREALLOC);
+	bool zero_seed = (attr->map_flags & BPF_F_ZERO_SEED);
 	int numa_node = bpf_map_attr_numa_node(attr);
 
 	BUILD_BUG_ON(offsetof(struct htab_elem, htab) !=
@@ -257,6 +258,10 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 		 */
 		return -EPERM;
 
+	if (zero_seed && !capable(CAP_SYS_ADMIN))
+		/* Guard against local DoS, and discourage production use. */
+		return -EPERM;
+
 	if (attr->map_flags & ~HTAB_CREATE_FLAG_MASK)
 		/* reserved bits should not be used */
 		return -EINVAL;
@@ -373,7 +378,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 	if (!htab->buckets)
 		goto free_htab;
 
-	htab->hashrnd = get_random_int();
+	if (htab->map.map_flags & BPF_F_ZERO_SEED)
+		htab->hashrnd = 0;
+	else
+		htab->hashrnd = get_random_int();
+
 	for (i = 0; i < htab->n_buckets; i++) {
 		INIT_HLIST_NULLS_HEAD(&htab->buckets[i].head, i);
 		raw_spin_lock_init(&htab->buckets[i].lock);
-- 
2.17.1
