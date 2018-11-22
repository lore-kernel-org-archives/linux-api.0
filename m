From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 3/4] libbpf: add bpf_prog_test_run_xattr
Date: Thu, 22 Nov 2018 14:09:09 +0000
Message-ID: <20181122140910.1079-4-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181122140910.1079-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181122140910.1079-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Add a new function, which encourages safe usage of the test interface.
bpf_prog_test_run continues to work as before, but should be considered
unsafe.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/lib/bpf/bpf.c | 27 +++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h | 13 +++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 961e1b9fc592..f8518bef6886 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -424,6 +424,33 @@ int bpf_prog_test_run(int prog_fd, int repeat, void *data, __u32 size,
 	return ret;
 }
 
+int bpf_prog_test_run_xattr(const struct bpf_prog_test_run_attr *test_attr,
+			    __u32 *size_out, __u32 *retval, __u32 *duration)
+{
+	union bpf_attr attr;
+	int ret;
+
+	if (!test_attr->data_out && test_attr->size_out > 0)
+		return -EINVAL;
+
+	bzero(&attr, sizeof(attr));
+	attr.test.prog_fd = test_attr->prog_fd;
+	attr.test.data_in = ptr_to_u64(test_attr->data);
+	attr.test.data_out = ptr_to_u64(test_attr->data_out);
+	attr.test.data_size_in = test_attr->size;
+	attr.test.data_size_out = test_attr->size_out;
+	attr.test.repeat = test_attr->repeat;
+
+	ret = sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
+	if (size_out)
+		*size_out = attr.test.data_size_out;
+	if (retval)
+		*retval = attr.test.retval;
+	if (duration)
+		*duration = attr.test.duration;
+	return ret;
+}
+
 int bpf_prog_get_next_id(__u32 start_id, __u32 *next_id)
 {
 	union bpf_attr attr;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 26a51538213c..570f19f77f42 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -110,6 +110,19 @@ LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
 LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
+
+struct bpf_prog_test_run_attr {
+	int prog_fd;
+	int repeat;
+	const void *data;
+	__u32 size;
+	void *data_out; /* optional */
+	__u32 size_out;
+};
+
+LIBBPF_API int bpf_prog_test_run_xattr(const struct bpf_prog_test_run_attr *test_attr,
+				       __u32 *size_out, __u32 *retval,
+				       __u32 *duration);
 LIBBPF_API int bpf_prog_test_run(int prog_fd, int repeat, void *data,
 				 __u32 size, void *data_out, __u32 *size_out,
 				 __u32 *retval, __u32 *duration);
-- 
2.17.1
