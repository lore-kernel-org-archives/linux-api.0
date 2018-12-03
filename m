From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v5 4/4] selftests: add a test for bpf_prog_test_run_xattr
Date: Mon,  3 Dec 2018 11:31:26 +0000
Message-ID: <20181203113126.2591-5-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181203113126.2591-1-lmb@cloudflare.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181203113126.2591-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Make sure that bpf_prog_test_run_xattr returns the correct length
and that the kernel respects the output size hint. Also check
that errno indicates ENOSPC if there is a short output buffer given.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/bpf/test_progs.c | 55 +++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index c1e688f61061..ee827deb948a 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -70,7 +70,7 @@ static struct {
 	.tcp.urg_ptr = 123,
 };
 
-#define CHECK(condition, tag, format...) ({				\
+#define _CHECK(condition, tag, duration, format...) ({			\
 	int __ret = !!(condition);					\
 	if (__ret) {							\
 		error_cnt++;						\
@@ -83,6 +83,11 @@ static struct {
 	__ret;								\
 })
 
+#define CHECK(condition, tag, format...) \
+	_CHECK(condition, tag, duration, format)
+#define CHECK_ATTR(condition, tag, format...) \
+	_CHECK(condition, tag, tattr.duration, format)
+
 static int bpf_find_map(const char *test, struct bpf_object *obj,
 			const char *name)
 {
@@ -124,6 +129,53 @@ static void test_pkt_access(void)
 	bpf_object__close(obj);
 }
 
+static void test_prog_run_xattr(void)
+{
+	const char *file = "./test_pkt_access.o";
+	struct bpf_object *obj;
+	char buf[10];
+	int err;
+	struct bpf_prog_test_run_attr tattr = {
+		.repeat = 1,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.data_out = buf,
+		.data_size_out = 5,
+	};
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_SCHED_CLS, &obj,
+			    &tattr.prog_fd);
+	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
+		return;
+
+	memset(buf, 0, sizeof(buf));
+
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err != -1 || errno != ENOSPC || tattr.retval, "run",
+	      "err %d errno %d retval %d\n", err, errno, tattr.retval);
+
+	CHECK_ATTR(tattr.data_size_out != sizeof(pkt_v4), "data_size_out",
+	      "incorrect output size, want %lu have %u\n",
+	      sizeof(pkt_v4), tattr.data_size_out);
+
+	CHECK_ATTR(buf[5] != 0, "overflow",
+	      "BPF_PROG_TEST_RUN ignored size hint\n");
+
+	tattr.data_out = NULL;
+	tattr.data_size_out = 0;
+	errno = 0;
+
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err || errno || tattr.retval, "run_no_output",
+	      "err %d errno %d retval %d\n", err, errno, tattr.retval);
+
+	tattr.data_size_out = 1;
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err != -EINVAL, "run_wrong_size_out", "err %d\n", err);
+
+	bpf_object__close(obj);
+}
+
 static void test_xdp(void)
 {
 	struct vip key4 = {.protocol = 6, .family = AF_INET};
@@ -1837,6 +1889,7 @@ int main(void)
 	jit_enabled = is_jit_enabled();
 
 	test_pkt_access();
+	test_prog_run_xattr();
 	test_xdp();
 	test_xdp_adjust_tail();
 	test_l4lb_all();
-- 
2.19.1
