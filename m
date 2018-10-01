From: Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 2/3] tools: sync linux/bpf.h
Date: Mon,  1 Oct 2018 11:45:08 +0100
Message-ID: <20181001104509.24211-3-lmb@cloudflare.com>
References: <20181001104509.24211-1-lmb@cloudflare.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001104509.24211-1-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
To: ast@kernel.org, daniel@iogearbox.net
Cc: netdev@vger.kernel.org, linux-api@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
List-Id: linux-api@vger.kernel.org

---
 tools/include/uapi/linux/bpf.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index aa5ccd2385ed..9d15c8f179ac 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -252,6 +252,8 @@ enum bpf_attach_type {
 #define BPF_F_NO_COMMON_LRU	(1U << 1)
 /* Specify numa node during map creation */
 #define BPF_F_NUMA_NODE		(1U << 2)
+/* Zero-initialize hash function seed */
+#define BPF_F_ZERO_SEED		(1U << 6)
 
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
-- 
2.17.1
