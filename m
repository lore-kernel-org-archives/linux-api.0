From: Stas Sergeev <stsp@list.ru>
Subject: [PATCH 2/4] sigaltstack: preparations for adding new SS_xxx flags
Date: Thu, 14 Apr 2016 23:20:03 +0300
Message-ID: <1460665206-13646-3-git-send-email-stsp@list.ru>
References: <1460665206-13646-1-git-send-email-stsp@list.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460665206-13646-1-git-send-email-stsp@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: stsp@list.ru
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Amanieu d'Antras <amanieu@gmail.com>, Michal Hocko <mhocko@suse.com>, Richard Weinberger <richard@nod.at>, Vladimir Davydov <vdavydov@parallels.com>, Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Shuah Khan <shuahkh@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

This patch adds SS_FLAG_BITS - the mask that splits sigaltstack
mode values and bit-flags. Since there is no bit-flags yet, the
mask is defined to 0. The flags are added by subsequent patches.
With every new flag, the mask should have the appropriate bit cleared.

This makes sure if some flag is tried on a kernel that doesn't
support it, the EINVAL error will be returned, because such a
flag will be treated as an invalid mode rather than the bit-flag.
That way the existence of the particular features can be probed
at run-time.

This change was suggested by Andy Lutomirski:
https://lkml.org/lkml/2016/3/6/158

Signed-off-by: Stas Sergeev <stsp@list.ru>

CC: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "Peter Zijlstra (Intel)" <peterz@infradead.org>
CC: "Amanieu d'Antras" <amanieu@gmail.com>
CC: Michal Hocko <mhocko@suse.com>
CC: Richard Weinberger <richard@nod.at>
CC: Vladimir Davydov <vdavydov@parallels.com>
CC: Sasha Levin <sasha.levin@oracle.com>
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Shuah Khan <shuahkh@osg.samsung.com>
---
 include/uapi/linux/signal.h |  3 +++
 kernel/signal.c             | 16 ++++++----------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/signal.h b/include/uapi/linux/signal.h
index e1bd50c2..7c73165 100644
--- a/include/uapi/linux/signal.h
+++ b/include/uapi/linux/signal.h
@@ -7,4 +7,7 @@
 #define SS_ONSTACK	1
 #define SS_DISABLE	2
 
+/* mask for all SS_xxx flags */
+#define SS_FLAG_BITS	0
+
 #endif /* _UAPI_LINUX_SIGNAL_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index 0508544..9a24bc3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3100,7 +3100,8 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 	if (uss) {
 		void __user *ss_sp;
 		size_t ss_size;
-		int ss_flags;
+		unsigned ss_flags;
+		int ss_mode;
 
 		error = -EFAULT;
 		if (!access_ok(VERIFY_READ, uss, sizeof(*uss)))
@@ -3115,18 +3116,13 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 		if (on_sig_stack(sp))
 			goto out;
 
+		ss_mode = ss_flags & ~SS_FLAG_BITS;
 		error = -EINVAL;
-		/*
-		 * Note - this code used to test ss_flags incorrectly:
-		 *  	  old code may have been written using ss_flags==0
-		 *	  to mean ss_flags==SS_ONSTACK (as this was the only
-		 *	  way that worked) - this fix preserves that older
-		 *	  mechanism.
-		 */
-		if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && ss_flags != 0)
+		if (ss_mode != SS_DISABLE && ss_mode != SS_ONSTACK &&
+				ss_mode != 0)
 			goto out;
 
-		if (ss_flags == SS_DISABLE) {
+		if (ss_mode == SS_DISABLE) {
 			ss_size = 0;
 			ss_sp = NULL;
 		} else {
-- 
2.7.2
