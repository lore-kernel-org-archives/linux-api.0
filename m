From: Thomas Garnier <thgarnie@google.com>
Subject: [RFC] syscalls: Restore address limit after a syscall
Date: Thu,  9 Feb 2017 10:33:58 -0800
Message-ID: <20170209183358.103094-1-thgarnie@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Stephen Bates <stephen.bates@pmcs.com>, Jeff Moyer <jmoyer@redhat.com>, Milosz Tanski <milosz@adfin.com>, Thomas Garnier <thgarnie@google.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

This patch prevents a syscall to modify the address limit of the
caller. The address limit is kept by the syscall wrapper and restored
just after the syscall ends.

For example, it would mitigation this bug:

- https://bugs.chromium.org/p/project-zero/issues/detail?id=990

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170209
---
 include/linux/syscalls.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 91a740f6b884..a1b6a62a9849 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -198,7 +198,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
-		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
+		long ret;						\
+		mm_segment_t fs = get_fs();				\
+		ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
+		set_fs(fs);						\
 		__MAP(x,__SC_TEST,__VA_ARGS__);				\
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
-- 
2.11.0.483.g087da7b7c-goog
