From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 4/4] selftests: add a test for bpf_prog_test_run_xattr
Date: Thu, 22 Nov 2018 14:09:10 +0000
Message-ID: <20181122140910.1079-5-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181122140910.1079-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181122140910.1079-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Make sure that bpf_prog_test_run_xattr returns the correct length
and that the kernel respects the output size hint. Also check
that errno indicates ENOSPC if there is a short output buffer given.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_progs.c | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index c1e688f61061..f9f5b1dbcc83 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -124,6 +124,54 @@ static void test_pkt_access(void)
 	bpf_object__close(obj);
 }
 
+static void test_prog_run_xattr(void)
+{
+	const char *file = "./test_pkt_access.o";
+	__u32 duration, retval, size_out;
+	struct bpf_object *obj;
+	char buf[10];
+	int err;
+	struct bpf_prog_test_run_attr tattr = {
+		.repeat = 1,
+		.data = &pkt_v4,
+		.size = sizeof(pkt_v4),
+		.data_out = buf,
+		.size_out = 5,
+	};
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &tattr.prog_fd);
+	if (CHECK(err, "load", "err %d errno %d\n", err, errno))
+		return;
+
+	memset(buf, 0, sizeof(buf));
+
+	err = bpf_prog_test_run_xattr(&tattr, &size_out, &retval, &duration);
+	CHECK(err != -1 || errno != ENOSPC || retval, "run",
+	      "err %d errno %d retval %d\n", err, errno, retval);
+
+	CHECK(size_out != sizeof(pkt_v4), "output_size",
+	      "incorrect output size, want %lu have %u\n",
+	      sizeof(pkt_v4), size_out);
+
+	CHECK(buf[5] != 0, "overflow",
+	      "BPF_PROG_TEST_RUN ignored size hint\n");
+
+	tattr.data_out = NULL;
+	tattr.size_out = 0;
+	errno = 0;
+
+	err = bpf_prog_test_run_xattr(&tattr, NULL, &retval, &duration);
+	CHECK(err || errno || retval, "run_no_output",
+	      "err %d errno %d retval %d\n", err, errno, retval);
+
+	tattr.size_out = 1;
+	err = bpf_prog_test_run_xattr(&tattr, NULL, NULL, &duration);
+	CHECK(err != -EINVAL, "run_wrong_size_out", "err %d\n", err);
+
+	bpf_object__close(obj);
+}
+
 static void test_xdp(void)
 {
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -1837,6 +1885,7 @@ int main(void)
 	jit_enabled = is_jit_enabled();
 
 	test_pkt_access();
+	test_prog_run_xattr();
 	test_xdp();
 	test_xdp_adjust_tail();
 	test_l4lb_all();
-- 
2.17.1
