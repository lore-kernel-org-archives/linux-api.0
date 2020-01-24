From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 04/33] libbpf: Fix BTF-defined map's __type macro handling of arrays
Date: Thu, 23 Jan 2020 20:16:39 -0500
Message-ID: <20200124011708.18232-4-sashal@kernel.org>
References: <20200124011708.18232-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200124011708.18232-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@kernel.org>, Sasha Levin <sashal@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit a53ba15d81995868651dd28a85d8045aef3d4e20 ]

Due to a quirky C syntax of declaring pointers to array or function
prototype, existing __type() macro doesn't work with map key/value types
that are array or function prototype. One has to create a typedef first
and use it to specify key/value type for a BPF map.  By using typeof(),
pointer to type is now handled uniformly for all kinds of types. Convert
one of self-tests as a demonstration.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191004040211.2434033-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_helpers.h                | 2 +-
 tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 54a50699bbfda..9f77cbaac01c1 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -3,7 +3,7 @@
 #define __BPF_HELPERS__
 
 #define __uint(name, val) int (*name)[val]
-#define __type(name, val) val *name
+#define __type(name, val) typeof(val) *name
 
 /* helper macro to print out debug messages */
 #define bpf_printk(fmt, ...)				\
diff --git a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
index f8ffa3f3d44bb..6cc4479ac9df6 100644
--- a/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
+++ b/tools/testing/selftests/bpf/progs/test_get_stack_rawtp.c
@@ -47,12 +47,11 @@ struct {
  * issue and avoid complicated C programming massaging.
  * This is an acceptable workaround since there is one entry here.
  */
-typedef __u64 raw_stack_trace_t[2 * MAX_STACK_RAWTP];
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__uint(max_entries, 1);
 	__type(key, __u32);
-	__type(value, raw_stack_trace_t);
+	__type(value, __u64[2 * MAX_STACK_RAWTP]);
 } rawdata_map SEC(".maps");
 
 SEC("raw_tracepoint/sys_enter")
-- 
2.20.1
