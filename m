From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 2/3] libbpf: require size hint in bpf_prog_test_run
Date: Fri, 16 Nov 2018 12:53:28 +0000
Message-ID: <20181116125329.3974-3-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Require size_out to be non-NULL if data_out is given. This prevents
accidental overwriting of process memory after the output buffer.

Adjust callers of bpf_prog_test_run to this behaviour.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/lib/bpf/bpf.c                      |  4 +++-
 tools/testing/selftests/bpf/test_progs.c | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 03f9bcc4ef50..127a9aa6170e 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -403,10 +403,12 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 	attr.test.data_in = ptr_to_u64(data);
 	attr.test.data_out = ptr_to_u64(data_out);
 	attr.test.data_size_in = size;
+	if (data_out)
+		attr.test.data_size_out = *size_out;
 	attr.test.repeat = repeat;
 
 	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
-	if (size_out)
+	if (data_out)
 		*size_out = attr.test.data_size_out;
 	if (retval)
 		*retval = attr.test.retval;
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 2d3c04f45530..560d7527b86b 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -150,6 +150,7 @@ static void test_xdp(void)
 	bpf_map_update_elem(map_fd, &key4, &value4, 0);
 	bpf_map_update_elem(map_fd, &key6, &value6, 0);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 
@@ -158,6 +159,7 @@ static void test_xdp(void)
 	      "err %d errno %d retval %d size %d\n",
 	      err, errno, retval, size);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != XDP_TX || size != 114 ||
@@ -182,6 +184,7 @@ static void test_xdp_adjust_tail(void)
 		return;
 	}
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 
@@ -189,6 +192,7 @@ static void test_xdp_adjust_tail(void)
 	      "ipv4", "err %d errno %d retval %d size %d\n",
 	      err, errno, retval, size);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != XDP_TX || size != 54,
@@ -252,6 +256,7 @@ static void test_l4lb(const char *file)
 		goto out;
 	bpf_map_update_elem(map_fd, &real_num, &real_def, 0);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != 7/*TC_ACT_REDIRECT*/ || size != 54 ||
@@ -259,6 +264,7 @@ static void test_l4lb(const char *file)
 	      "err %d errno %d retval %d size %d magic %x\n",
 	      err, errno, retval, size, *magic);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != 7/*TC_ACT_REDIRECT*/ || size != 74 ||
@@ -341,6 +347,7 @@ static void test_xdp_noinline(void)
 		goto out;
 	bpf_map_update_elem(map_fd, &real_num, &real_def, 0);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != 1 || size != 54 ||
@@ -348,6 +355,7 @@ static void test_xdp_noinline(void)
 	      "err %d errno %d retval %d size %d magic %x\n",
 	      err, errno, retval, size, *magic);
 
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, NUM_ITER, &pkt_v6, sizeof(pkt_v6),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != 1 || size != 74 ||
@@ -1795,6 +1803,7 @@ static void test_queue_stack_map(int type)
 			pkt_v4.iph.saddr = vals[MAP_SIZE - 1 - i] * 5;
 		}
 
+		size = sizeof(buf);
 		err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 					buf, &size, &retval, &duration);
 		if (err || retval || size != sizeof(pkt_v4) ||
@@ -1808,6 +1817,7 @@ static void test_queue_stack_map(int type)
 	      err, errno, retval, size, iph->daddr);
 
 	/* Queue is empty, program should return TC_ACT_SHOT */
+	size = sizeof(buf);
 	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
 				buf, &size, &retval, &duration);
 	CHECK(err || retval != 2 /* TC_ACT_SHOT */|| size != sizeof(pkt_v4),
-- 
2.17.1
