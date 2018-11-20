From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 2/4] tools: sync uapi/linux/bpf.h
Date: Tue, 20 Nov 2018 15:43:04 +0000
Message-ID: <20181120154306.16657-3-lmb@cloudflare.com>
References: <20181116125329.3974-1-lmb@cloudflare.com>
 <20181120154306.16657-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181120154306.16657-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, ys114321@gmail.com, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

Pull changes from "bpf: respect size hint to BPF_PROG_TEST_RUN if present".

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 05d95290b848..7f5a7d032cd1 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -356,8 +356,11 @@ union bpf_attr {
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
-- 
2.17.1
