From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH bpf-next 4/5] libbpf: add bpf_raw_tracepoint_open helper
Date: Wed, 28 Feb 2018 20:19:56 -0800
Message-ID: <20180301041957.399230-5-ast@kernel.org>
References: <20180301041957.399230-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180301041957.399230-1-ast@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org, rostedt@goodmis.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/include/uapi/linux/bpf.h | 11 +++++++++++
 tools/lib/bpf/bpf.c            | 10 ++++++++++
 tools/lib/bpf/bpf.h            |  1 +
 3 files changed, 22 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index db6bdc375126..50bf5f9054da 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -94,6 +94,7 @@ enum bpf_cmd {
 	BPF_MAP_GET_FD_BY_ID,
 	BPF_OBJ_GET_INFO_BY_FD,
 	BPF_PROG_QUERY,
+	BPF_RAW_TRACEPOINT_OPEN,
 };
 
 enum bpf_map_type {
@@ -133,6 +134,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_SOCK_OPS,
 	BPF_PROG_TYPE_SK_SKB,
 	BPF_PROG_TYPE_CGROUP_DEVICE,
+	BPF_PROG_TYPE_RAW_TRACEPOINT,
 };
 
 enum bpf_attach_type {
@@ -143,6 +145,7 @@ enum bpf_attach_type {
 	BPF_SK_SKB_STREAM_PARSER,
 	BPF_SK_SKB_STREAM_VERDICT,
 	BPF_CGROUP_DEVICE,
+	BPF_RAW_TRACEPOINT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -320,6 +323,10 @@ union bpf_attr {
 		__aligned_u64	prog_ids;
 		__u32		prog_cnt;
 	} query;
+
+	struct {
+		__u64 name;
+	} raw_tracepoint;
 } __attribute__((aligned(8)));
 
 /* BPF helper function descriptions:
@@ -1106,4 +1113,8 @@ struct bpf_cgroup_dev_ctx {
 	__u32 minor;
 };
 
+struct bpf_raw_tracepoint_args {
+	__u64 args[0];
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 592a58a2b681..4cbe7b6afcc0 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -428,6 +428,16 @@ int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len)
 	return err;
 }
 
+int bpf_raw_tracepoint_open(const char *name)
+{
+	union bpf_attr attr;
+
+	bzero(&attr, sizeof(attr));
+	attr.raw_tracepoint.name = ptr_to_u64(name);
+
+	return sys_bpf(BPF_RAW_TRACEPOINT_OPEN, &attr, sizeof(attr));
+}
+
 int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags)
 {
 	struct sockaddr_nl sa;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 8d18fb73d7fb..f672d39bd9fa 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -79,4 +79,5 @@ int bpf_map_get_fd_by_id(__u32 id);
 int bpf_obj_get_info_by_fd(int prog_fd, void *info, __u32 *info_len);
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
 		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt);
+int bpf_raw_tracepoint_open(const char *name);
 #endif
-- 
2.9.5
