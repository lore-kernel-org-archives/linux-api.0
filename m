From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 1/3] bpf: allow zero-initializing hash map seed
Date: Mon,  1 Oct 2018 11:45:07 +0100
Message-ID: <20181001104509.24211-2-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Add a new flag BPF_F_ZERO_SEED, which forces a hash map
to initialize the seed to zero.
---
 include/uapi/linux/bpf.h | 2 ++
 kernel/bpf/hashtab.c     | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index aa5ccd2385ed..9d15c8f179ac 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -252,6 +252,8 @@ enum bpf_attach_type {
 #define BPF_F_NO_COMMON_LRU	(1U << 1)
 /* Specify numa node during map creation */
 #define BPF_F_NUMA_NODE		(1U << 2)
+/* Zero-initialize hash function seed */
+#define BPF_F_ZERO_SEED		(1U << 6)
 
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 2c1790288138..a79e123dae62 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -23,7 +23,7 @@
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
-	 BPF_F_RDONLY | BPF_F_WRONLY)
+	 BPF_F_RDONLY | BPF_F_WRONLY | BPF_F_ZERO_SEED)
 
 struct bucket {
 	struct hlist_nulls_head head;
@@ -373,7 +373,11 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
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
