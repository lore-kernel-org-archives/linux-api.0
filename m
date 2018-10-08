From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 3/3] tools: add selftest for BPF_F_ZERO_SEED
Date: Mon,  8 Oct 2018 11:32:21 +0100
Message-ID: <20181008103221.13468-4-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
 <20181008103221.13468-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008103221.13468-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Check that iterating two separate hash maps produces the same
order of keys if BPF_F_ZERO_SEED is used.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_maps.c | 68 +++++++++++++++++++++----
 1 file changed, 57 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 9b552c0fc47d..a8d6af27803a 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -257,23 +257,35 @@ static void test_hashmap_percpu(int task, void *data)
 	close(fd);
 }
 
+static int helper_fill_hashmap(int max_entries)
+{
+	int i, fd, ret;
+	long long key, value;
+
+	fd = bpf_create_map(BPF_MAP_TYPE_HASH, sizeof(key), sizeof(value),
+			    max_entries, map_flags);
+	CHECK(fd < 0,
+	      "failed to create hashmap",
+	      "err: %s, flags: 0x%x\n", strerror(errno), map_flags);
+
+	for (i = 0; i < max_entries; i++) {
+		key = i; value = key;
+		ret = bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST);
+		CHECK(ret != 0,
+		      "can't update hashmap",
+		      "err: %s\n", strerror(ret));
+	}
+
+	return fd;
+}
+
 static void test_hashmap_walk(int task, void *data)
 {
 	int fd, i, max_entries = 1000;
 	long long key, value, next_key;
 	bool next_key_valid = true;
 
-	fd = bpf_create_map(BPF_MAP_TYPE_HASH, sizeof(key), sizeof(value),
-			    max_entries, map_flags);
-	if (fd < 0) {
-		printf("Failed to create hashmap '%s'!\n", strerror(errno));
-		exit(1);
-	}
-
-	for (i = 0; i < max_entries; i++) {
-		key = i; value = key;
-		assert(bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST) == 0);
-	}
+	fd = helper_fill_hashmap(max_entries);
 
 	for (i = 0; bpf_map_get_next_key(fd, !i ? NULL : &key,
 					 &next_key) == 0; i++) {
@@ -305,6 +317,39 @@ static void test_hashmap_walk(int task, void *data)
 	close(fd);
 }
 
+static void test_hashmap_zero_seed(void)
+{
+	int i, first, second, old_flags;
+	long long key, next_first, next_second;
+
+	old_flags = map_flags;
+	map_flags |= BPF_F_ZERO_SEED;
+
+	first = helper_fill_hashmap(3);
+	second = helper_fill_hashmap(3);
+
+	for (i = 0; ; i++) {
+		void *key_ptr = !i ? NULL : &key;
+
+		if (bpf_map_get_next_key(first, key_ptr, &next_first) != 0)
+			break;
+
+		CHECK(bpf_map_get_next_key(second, key_ptr, &next_second) != 0,
+		      "next_key for second map must succeed",
+		      "key_ptr: %p", key_ptr);
+		CHECK(next_first != next_second,
+		      "keys must match",
+		      "i: %d first: %lld second: %lld\n", i,
+		      next_first, next_second);
+
+		key = next_first;
+	}
+
+	map_flags = old_flags;
+	close(first);
+	close(second);
+}
+
 static void test_arraymap(int task, void *data)
 {
 	int key, next_key, fd;
@@ -1417,6 +1462,7 @@ static void run_all_tests(void)
 	test_hashmap(0, NULL);
 	test_hashmap_percpu(0, NULL);
 	test_hashmap_walk(0, NULL);
+	test_hashmap_zero_seed();
 
 	test_arraymap(0, NULL);
 	test_arraymap_percpu(0, NULL);
-- 
2.17.1
