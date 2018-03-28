From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v8 bpf-next 5/9] macro: introduce COUNT_ARGS() macro
Date: Wed, 28 Mar 2018 12:05:36 -0700
Message-ID: <20180328190540.370956-6-ast@kernel.org>
References: <20180328190540.370956-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180328190540.370956-1-ast@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org, mathieu.desnoyers@efficios.com, netdev@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

move COUNT_ARGS() macro from apparmor to generic header and extend it
to count till twelve.

COUNT() was an alternative name for this logic, but it's used for
different purpose in many other places.

Similarly for CONCATENATE() macro.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/kernel.h           | 7 +++++++
 security/apparmor/include/path.h | 7 +------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3fd291503576..293fa0677fba 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -919,6 +919,13 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
+/* This counts to 12. Any more, it will return 13th argument. */
+#define __COUNT_ARGS(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _n, X...) _n
+#define COUNT_ARGS(X...) __COUNT_ARGS(, ##X, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
+
+#define __CONCAT(a, b) a ## b
+#define CONCATENATE(a, b) __CONCAT(a, b)
+
 /**
  * container_of - cast a member of a structure out to the containing structure
  * @ptr:	the pointer to the member.
diff --git a/security/apparmor/include/path.h b/security/apparmor/include/path.h
index 05fb3305671e..e042b994f2b8 100644
--- a/security/apparmor/include/path.h
+++ b/security/apparmor/include/path.h
@@ -43,15 +43,10 @@ struct aa_buffers {
 
 DECLARE_PER_CPU(struct aa_buffers, aa_buffers);
 
-#define COUNT_ARGS(X...) COUNT_ARGS_HELPER(, ##X, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0)
-#define COUNT_ARGS_HELPER(_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, n, X...) n
-#define CONCAT(X, Y) X ## Y
-#define CONCAT_AFTER(X, Y) CONCAT(X, Y)
-
 #define ASSIGN(FN, X, N) ((X) = FN(N))
 #define EVAL1(FN, X) ASSIGN(FN, X, 0) /*X = FN(0)*/
 #define EVAL2(FN, X, Y...) do { ASSIGN(FN, X, 1);  EVAL1(FN, Y); } while (0)
-#define EVAL(FN, X...) CONCAT_AFTER(EVAL, COUNT_ARGS(X))(FN, X)
+#define EVAL(FN, X...) CONCATENATE(EVAL, COUNT_ARGS(X))(FN, X)
 
 #define for_each_cpu_buffer(I) for ((I) = 0; (I) < MAX_PATH_BUFFERS; (I)++)
 
-- 
2.9.5
