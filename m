From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v5 1/4] bpf: respect size hint to BPF_PROG_TEST_RUN if present
Date: Mon,  3 Dec 2018 11:31:23 +0000
Message-ID: <20181203113126.2591-2-lmb@cloudflare.com>
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

Use data_size_out as a size hint when copying test output to user space.
ENOSPC is returned if the output buffer is too small.
Callers which so far did not set data_size_out are not affected.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/uapi/linux/bpf.h |  7 +++++--
 net/bpf/test_run.c       | 15 +++++++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 23e2031a43d4..01b0e5f485c4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -360,8 +360,11 @@ union bpf_attr {
 	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
 		__u32		prog_fd;
 		__u32		retval;
-		__u32		data_size_in;
-		__u32		data_size_out;
+		__u32		data_size_in;	/* input: len of data_in */
+		__u32		data_size_out;	/* input/output: len of data_out
+						 *   returns ENOSPC if data_out
+						 *   is too small.
+						 */
 		__aligned_u64	data_in;
 		__aligned_u64	data_out;
 		__u32		repeat;
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c89c22c49015..7663e6a57280 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -74,8 +74,18 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 {
 	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
 	int err = -EFAULT;
+	u32 copy_size = size;
 
-	if (data_out && copy_to_user(data_out, data, size))
+	/* Clamp copy if the user has provided a size hint, but copy the full
+	 * buffer if not to retain old behaviour.
+	 */
+	if (kattr->test.data_size_out &&
+	    copy_size > kattr->test.data_size_out) {
+		copy_size = kattr->test.data_size_out;
+		err = -ENOSPC;
+	}
+
+	if (data_out && copy_to_user(data_out, data, copy_size))
 		goto out;
 	if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size)))
 		goto out;
@@ -83,7 +93,8 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 		goto out;
 	if (copy_to_user(&uattr->test.duration, &duration, sizeof(duration)))
 		goto out;
-	err = 0;
+	if (err != -ENOSPC)
+		err = 0;
 out:
 	return err;
 }
-- 
2.19.1
