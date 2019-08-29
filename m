From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and CAP_TRACING
Date: Wed, 28 Aug 2019 22:12:51 -0700
Message-ID: <20190829051253.1927291-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: luto@amacapital.net
Cc: davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org, netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

CAP_BPF allows the following BPF operations:
- Loading all types of BPF programs
- Creating all types of BPF maps except:
   - stackmap that needs CAP_TRACING
   - devmap that needs CAP_NET_ADMIN
   - cpumap that needs CAP_SYS_ADMIN
- Advanced verifier features
  - Indirect variable access
  - Bounded loops
  - BPF to BPF function calls
  - Scalar precision tracking
  - Larger complexity limits
  - Dead code elimination
  - And potentially other features
- Use of pointer-to-integer conversions in BPF programs
- Bypassing of speculation attack hardening measures
- Loading BPF Type Format (BTF) data
- Iterate system wide loaded programs, maps, BTF objects
- Retrieve xlated and JITed code of BPF programs
- Access maps and programs via id
- Use bpf_spin_lock() helper

CAP_BPF and CAP_TRACING together allow the following:
- bpf_probe_read to read arbitrary kernel memory
- bpf_trace_printk to print data to ftrace ring buffer
- Attach to raw_tracepoint
- Query association between kprobe/tracepoint and bpf program

CAP_BPF and CAP_NET_ADMIN together allow the following:
- Attach to cgroup-bpf hooks and query
- skb, xdp, flow_dissector test_run command

CAP_NET_ADMIN allows:
- Attach networking bpf programs to xdp, tc, lwt, flow dissector

CAP_TRACING allows:
- Full use of perf_event_open(), similarly to the effect of
  kernel.perf_event_paranoid == -1
- Full use of tracefs
- Creation of [ku][ret]probe
- Accessing arbitrary kernel memory via kprobe + probe_kernel_read
- Attach tracing bpf programs to perf events
- Access to kallsyms

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/capability.h     | 51 ++++++++++++++++++++++++++++-
 security/selinux/include/classmap.h |  4 +--
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 240fdb9a60f6..664e07d12888 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -366,8 +366,57 @@ struct vfs_ns_cap_data {
 
 #define CAP_AUDIT_READ		37
 
+/*
+ * CAP_BPF allows the following BPF operations:
+ * - Loading all types of BPF programs
+ * - Creating all types of BPF maps except:
+ *    - stackmap that needs CAP_TRACING
+ *    - devmap that needs CAP_NET_ADMIN
+ *    - cpumap that needs CAP_SYS_ADMIN
+ * - Advanced verifier features
+ *   - Indirect variable access
+ *   - Bounded loops
+ *   - BPF to BPF function calls
+ *   - Scalar precision tracking
+ *   - Larger complexity limits
+ *   - Dead code elimination
+ *   - And potentially other features
+ * - Use of pointer-to-integer conversions in BPF programs
+ * - Bypassing of speculation attack hardening measures
+ * - Loading BPF Type Format (BTF) data
+ * - Iterate system wide loaded programs, maps, BTF objects
+ * - Retrieve xlated and JITed code of BPF programs
+ * - Access maps and programs via id
+ * - Use bpf_spin_lock() helper
+ *
+ * CAP_BPF and CAP_TRACING together allow the following:
+ * - bpf_probe_read to read arbitrary kernel memory
+ * - bpf_trace_printk to print data to ftrace ring buffer
+ * - Attach to raw_tracepoint
+ * - Query association between kprobe/tracepoint and bpf program
+ *
+ * CAP_BPF and CAP_NET_ADMIN together allow the following:
+ * - Attach to cgroup-bpf hooks and query
+ * - skb, xdp, flow_dissector test_run command
+ *
+ * CAP_NET_ADMIN allows:
+ * - Attach networking bpf programs to xdp, tc, lwt, flow dissector
+ */
+#define CAP_BPF			38
+
+/*
+ * CAP_TRACING allows:
+ * - Full use of perf_event_open(), similarly to the effect of
+ *   kernel.perf_event_paranoid == -1
+ * - Full use of tracefs
+ * - Creation of [ku][ret]probe
+ * - Accessing arbitrary kernel memory via kprobe + probe_kernel_read
+ * - Attach tracing bpf programs to perf events
+ * - Access to kallsyms
+ */
+#define CAP_TRACING		39
 
-#define CAP_LAST_CAP         CAP_AUDIT_READ
+#define CAP_LAST_CAP         CAP_TRACING
 
 #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
 
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 201f7e588a29..0b364e245163 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -26,9 +26,9 @@
 	    "audit_control", "setfcap"
 
 #define COMMON_CAP2_PERMS  "mac_override", "mac_admin", "syslog", \
-		"wake_alarm", "block_suspend", "audit_read"
+		"wake_alarm", "block_suspend", "audit_read", "bpf", "tracing"
 
-#if CAP_LAST_CAP > CAP_AUDIT_READ
+#if CAP_LAST_CAP > CAP_TRACING
 #error New capability defined, please update COMMON_CAP2_PERMS.
 #endif
 
-- 
2.20.0
