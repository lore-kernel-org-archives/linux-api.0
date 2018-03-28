From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v8 bpf-next 8/9] samples/bpf: raw tracepoint test
Date: Wed, 28 Mar 2018 12:05:39 -0700
Message-ID: <20180328190540.370956-9-ast@kernel.org>
References: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

add empty raw_tracepoint bpf program to test overhead similar
to kprobe and traditional tracepoint tests

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 samples/bpf/Makefile                    |  1 +
 samples/bpf/bpf_load.c                  | 14 ++++++++++++++
 samples/bpf/test_overhead_raw_tp_kern.c | 17 +++++++++++++++++
 samples/bpf/test_overhead_user.c        | 12 ++++++++++++
 4 files changed, 44 insertions(+)
 create mode 100644 samples/bpf/test_overhead_raw_tp_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 2c2a587e0942..4d6a6edd4bf6 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -119,6 +119,7 @@ always += offwaketime_kern.o
 always += spintest_kern.o
 always += map_perf_test_kern.o
 always += test_overhead_tp_kern.o
+always += test_overhead_raw_tp_kern.o
 always += test_overhead_kprobe_kern.o
 always += parse_varlen.o parse_simple.o parse_ldabs.o
 always += test_cgrp2_tc_kern.o
diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index b1a310c3ae89..bebe4188b4b3 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -61,6 +61,7 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 	bool is_kprobe = strncmp(event, "kprobe/", 7) == 0;
 	bool is_kretprobe = strncmp(event, "kretprobe/", 10) == 0;
 	bool is_tracepoint = strncmp(event, "tracepoint/", 11) == 0;
+	bool is_raw_tracepoint = strncmp(event, "raw_tracepoint/", 15) == 0;
 	bool is_xdp = strncmp(event, "xdp", 3) == 0;
 	bool is_perf_event = strncmp(event, "perf_event", 10) == 0;
 	bool is_cgroup_skb = strncmp(event, "cgroup/skb", 10) == 0;
@@ -85,6 +86,8 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		prog_type = BPF_PROG_TYPE_KPROBE;
 	} else if (is_tracepoint) {
 		prog_type = BPF_PROG_TYPE_TRACEPOINT;
+	} else if (is_raw_tracepoint) {
+		prog_type = BPF_PROG_TYPE_RAW_TRACEPOINT;
 	} else if (is_xdp) {
 		prog_type = BPF_PROG_TYPE_XDP;
 	} else if (is_perf_event) {
@@ -131,6 +134,16 @@ static int load_and_attach(const char *event, struct bpf_insn *prog, int size)
 		return populate_prog_array(event, fd);
 	}
 
+	if (is_raw_tracepoint) {
+		efd = bpf_raw_tracepoint_open(event + 15, fd);
+		if (efd < 0) {
+			printf("tracepoint %s %s\n", event + 15, strerror(errno));
+			return -1;
+		}
+		event_fd[prog_cnt - 1] = efd;
+		return 0;
+	}
+
 	if (is_kprobe || is_kretprobe) {
 		if (is_kprobe)
 			event += 7;
@@ -587,6 +600,7 @@ static int do_load_bpf_file(const char *path, fixup_map_cb fixup_map)
 		if (memcmp(shname, "kprobe/", 7) == 0 ||
 		    memcmp(shname, "kretprobe/", 10) == 0 ||
 		    memcmp(shname, "tracepoint/", 11) == 0 ||
+		    memcmp(shname, "raw_tracepoint/", 15) == 0 ||
 		    memcmp(shname, "xdp", 3) == 0 ||
 		    memcmp(shname, "perf_event", 10) == 0 ||
 		    memcmp(shname, "socket", 6) == 0 ||
diff --git a/samples/bpf/test_overhead_raw_tp_kern.c b/samples/bpf/test_overhead_raw_tp_kern.c
new file mode 100644
index 000000000000..d2af8bc1c805
--- /dev/null
+++ b/samples/bpf/test_overhead_raw_tp_kern.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Facebook */
+#include <uapi/linux/bpf.h>
+#include "bpf_helpers.h"
+
+SEC("raw_tracepoint/task_rename")
+int prog(struct bpf_raw_tracepoint_args *ctx)
+{
+	return 0;
+}
+
+SEC("raw_tracepoint/urandom_read")
+int prog2(struct bpf_raw_tracepoint_args *ctx)
+{
+	return 0;
+}
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/test_overhead_user.c b/samples/bpf/test_overhead_user.c
index d291167fd3c7..e1d35e07a10e 100644
--- a/samples/bpf/test_overhead_user.c
+++ b/samples/bpf/test_overhead_user.c
@@ -158,5 +158,17 @@ int main(int argc, char **argv)
 		unload_progs();
 	}
 
+	if (test_flags & 0xC0) {
+		snprintf(filename, sizeof(filename),
+			 "%s_raw_tp_kern.o", argv[0]);
+		if (load_bpf_file(filename)) {
+			printf("%s", bpf_log_buf);
+			return 1;
+		}
+		printf("w/RAW_TRACEPOINT\n");
+		run_perf_test(num_cpu, test_flags >> 6);
+		unload_progs();
+	}
+
 	return 0;
 }
-- 
2.9.5
