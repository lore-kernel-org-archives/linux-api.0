From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 4/4] selftests: add a test for bpf_prog_test_run output size
Date: Tue, 20 Nov 2018 15:43:06 +0000
Message-ID: <20181120154306.16657-5-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181120154306.16657-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120154306.16657-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Make sure that bpf_prog_test_run returns the correct length
in the size_out argument and that the kernel respects the
output size hint. Also check that errno indicates ENOSPC.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_progs.c | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 299938603cb6..92e48c2ba2c6 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -124,6 +124,39 @@ static void test_pkt_access(void)
 	bpf_object__close(obj);
 }
 
+static void test_output_size_hint(void)
+{
+	const char *file = "./test_pkt_access.o";
+	struct bpf_object *obj;
+	__u32 retval, size, duration;
+	int err, prog_fd;
+	char buf[10];
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj, &prog_fd);
+	if (CHECK(err, "load", "err %d errno %d\n", err, errno))
+		return;
+
+	memset(buf, 0, sizeof(buf));
+
+	size = 5;
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				buf, &size, &retval, &duration);
+	CHECK(err != -1 || errno != ENOSPC || retval, "run",
+	      "err %d errno %d retval %d\n",
+	      err, errno, retval);
+
+	duration = 0;
+
+	CHECK(size != sizeof(pkt_v4), "out_size",
+	      "incorrect output size, want %lu have %u\n",
+	      sizeof(pkt_v4), size);
+
+	CHECK(buf[5] != 0, "overflow",
+	      "prog_test_run ignored size hint\n");
+
+	bpf_object__close(obj);
+}
+
 static void test_xdp(void)
 {
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -1847,6 +1880,7 @@ int main(void)
 	jit_enabled = is_jit_enabled();
 
 	test_pkt_access();
+	test_output_size_hint();
 	test_xdp();
 	test_xdp_adjust_tail();
 	test_l4lb_all();
-- 
2.17.1
