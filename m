From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 1/3] bpf: respect size hint to BPF_PROG_TEST_RUN if present
Date: Fri, 16 Nov 2018 12:53:27 +0000
Message-ID: <20181116125329.3974-2-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181116125329.3974-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Use data_size_out as a size hint when copying test output to user space.
A program using BPF_PERF_OUTPUT can compare its own buffer length with
data_size_out after the syscall to detect whether truncation has taken
place. Callers which so far did not set data_size_in are not affected.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 net/bpf/test_run.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c89c22c49015..30c57b7f4ba4 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -74,8 +74,15 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 {
 	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
 	int err = -EFAULT;
+	u32 copy_size = size;
 
-	if (data_out && copy_to_user(data_out, data, size))
+	/* Clamp copy if the user has provided a size hint, but copy the full
+	 * buffer if not to retain old behaviour.
+	 */
+	if (kattr->test.data_size_out && copy_size > kattr->test.data_size_out)
+		copy_size = kattr->test.data_size_out;
+
+	if (data_out && copy_to_user(data_out, data, copy_size))
 		goto out;
 	if (copy_to_user(&uattr->test.data_size_out, &size, sizeof(size)))
 		goto out;
-- 
2.17.1
