From: Alexei Starovoitov <ast@fb.com>
Subject: [PATCH v6 bpf-next 09/11] libbpf: add bpf_raw_tracepoint_open helper
Date: Mon, 26 Mar 2018 19:47:04 -0700
Message-ID: <20180327024706.2064725-10-ast@fb.com>
References: <20180327024706.2064725-1-ast@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180327024706.2064725-1-ast@fb.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

add bpf_raw_tracepoint_open(const char *name, int prog_fd) api to libbpf

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 tools/lib/bpf/bpf.c            | 11 +++++++++++
 tools/lib/bpf/bpf.h            |  1 +
 3 files changed, 23 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index d245c41213ac..58060bec999d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -94,6 +94,7 @@ enum bpf_cmd {
 	BPF_MAP_GET_FD_BY_ID,
 	BPF_OBJ_GET_INFO_BY_FD,
 	BPF_PROG_QUERY,
+	BPF_RAW_TRACEPOINT_OPEN,
 };
 
 enum bpf_map_type {
@@ -134,6 +135,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_CGROUP_DEVICE,
 	BPF_PROG_TYPE_SK_MSG,
+	BPF_PROG_TYPE_RAW_TRACEPOINT,
 };
 
 enum bpf_attach_type {
@@ -344,6 +346,11 @@ union bpf_attr {
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
 	} query;
+
+	struct {
+		__u64 name;
+		__u32 prog_fd;
+	} raw_tracepoint;
 } __attribute__((aligned(8)));
 
 /* BPF helper function descriptions:
@@ -1151,4 +1158,8 @@ struct bpf_cgroup_dev_ctx {
 	__u32 minor;
 };
 
+struct bpf_raw_tracepoint_args {
+	__u64 args[0];
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 592a58a2b681..e0500055f1a6 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -428,6 +428,17 @@ int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len)
 	return err;
 }
 
+int bpf_raw_tracepoint_open(const char *name, int prog_fd)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.raw_tracepoint.name = ptr_to_u64(name);
+	attr.raw_tracepoint.prog_fd = prog_fd;
+
+	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+}
+
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 {
 	struct sockaddr_nl sa;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8d18fb73d7fb..ee59342c6f42 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -79,4 +79,5 @@ int bpf_map_get_fd_by_id(__u32 id);
 int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len);
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
 		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt);
+int bpf_raw_tracepoint_open(const char *name, int prog_fd);
 #endif
-- 
2.9.5
