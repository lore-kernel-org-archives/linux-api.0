From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 1/5] Add __designated_init, wrapping
 __attribute__((designated_init))
Date: Thu, 31 Jul 2014 16:47:23 -0700
Message-ID: <3130b0553b15518e3bef6d14c80280beed0f5ff9.1406850006.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@fieldses.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>, Ingo Molnar <mingo@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Michal Marek <mmarek@suse.cz>, Neil Brown <neilb@suse.de>, Steven Rostedt <rostedt@goodmis.org>, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-sparse@vger.kernel.org
List-Id: linux-api@vger.kernel.org

GCC 4.10 and newer, and Sparse, supports
__attribute__((designated_init)), which marks a structure as requiring
a designated initializer rather than a positional one.  This helps
reduce churn and errors when used with _ops structures and similar
structures designed for future extension.

Add a wrapper __designated_init, which turns into
__attribute__((designated_init)) for Sparse or sufficiently new GCC.
Enable the corresponding warning as an error.

The following semantic patch can help mark structures containing
function pointers as requiring designated initializers:

@@
identifier I, f;
type T;
@@

struct I {
	...
	T (*f)(...);
	...
}
+ __designated_init
;

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Makefile                      | 3 +++
 include/linux/compiler-gcc4.h | 4 ++++
 include/linux/compiler.h      | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Makefile b/Makefile
index f6a7794..83773c2 100644
--- a/Makefile
+++ b/Makefile
@@ -744,6 +744,9 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=strict-prototypes)
 # Prohibit date/time macros, which would make the build non-deterministic
 KBUILD_CFLAGS   += $(call cc-option,-Werror=date-time)
 
+# Disallow positional initialization of designated structs
+KBUILD_CFLAGS += $(call cc-option,-Werror=designated-init)
+
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2..5cd3c26 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -85,4 +85,8 @@
 #if GCC_VERSION >= 40800 || (defined(__powerpc__) && GCC_VERSION >= 40600)
 #define __HAVE_BUILTIN_BSWAP16__
 #endif
+
+#if GCC_VERSION >= 41000 || defined(__CHECKER__)
+#define __designated_init __attribute__((designated_init))
+#endif
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..c2334b2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -266,6 +266,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 #define __always_inline inline
 #endif
 
+/* Marks a struct as requiring designated initializers, never positional. */
+#ifndef __designated_init
+#define __designated_init
+#endif
+
 #endif /* __KERNEL__ */
 
 /*
-- 
2.0.1

