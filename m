From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v5 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Mon,  3 Dec 2018 11:31:25 +0000
Message-ID: <20181203113126.2591-4-lmb@cloudflare.com>
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

Add a new function, which encourages safe usage of the test interface.
bpf_prog_test_run continues to work as before, but should be considered
unsafe.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/lib/bpf/bpf.c      | 23 +++++++++++++++++++++++
 tools/lib/bpf/bpf.h      | 19 +++++++++++++++++++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 43 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index ce1822194590..6e06484a7a99 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -463,6 +463,29 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 	return ret;
 }
 
+int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
+{
+	union bpf_attr attr;
+	int ret;
+
+	if (!test_attr->data_out && test_attr->data_size_out > 0)
+		return -EINVAL;
+
+	bzero(&attr, sizeof(attr));
+	attr.test.prog_fd = test_attr->prog_fd;
+	attr.test.data_in = ptr_to_u64(test_attr->data_in);
+	attr.test.data_out = ptr_to_u64(test_attr->data_out);
+	attr.test.data_size_in = test_attr->data_size_in;
+	attr.test.data_size_out = test_attr->data_size_out;
+	attr.test.repeat = test_attr->repeat;
+
+	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+	test_attr->data_size_out = attr.test.data_size_out;
+	test_attr->retval = attr.test.retval;
+	test_attr->duration = attr.test.duration;
+	return ret;
+}
+
 int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 09e8bbe111d4..ce6f07399d41 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -118,6 +118,25 @@ LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
 LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
+
+struct bpf_prog_test_run_attr {
+	int prog_fd;
+	int repeat;
+	const void *data_in;
+	__u32 data_size_in;
+	void *data_out;      /* optional */
+	__u32 data_size_out; /* in: max length of data_out
+			      * out: length of data_out */
+	__u32 retval;        /* out: return code of the BPF program */
+	__u32 duration;      /* out: average per repetition in ns */
+};
+
+LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr);
+
+/*
+ * bpf_prog_test_run does not check that data_out is large enough. Consider
+ * using bpf_prog_test_run_xattr instead.
+ */
 LIBBPF_API int bpf_prog_test_run(int prog_fd, int repeat, void *data,
 				 __u32 size, void *data_out, __u32 *size_out,
 				 __u32 *retval, __u32 *duration);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 4fb29f6d7a80..8deff22d61bb 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -65,6 +65,7 @@ LIBBPF_0.0.1 {
 		bpf_prog_load_xattr;
 		bpf_prog_query;
 		bpf_prog_test_run;
+		bpf_prog_test_run_xattr;
 		bpf_program__fd;
 		bpf_program__is_kprobe;
 		bpf_program__is_perf_event;
-- 
2.19.1
