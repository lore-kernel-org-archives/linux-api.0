From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 3.17-rc5] Fix confusing PFA_NO_NEW_PRIVS constant.
Date: Sat, 20 Sep 2014 19:40:30 +0900
Message-ID: <201409201940.AHG21834.LJOFFHSFQOtVMO@I-love.SAKURA.ne.jp>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
	<541D16EA.70407@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <541D16EA.70407@huawei.com>
Sender: linux-security-module-owner@vger.kernel.org
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: james.l.morris@oracle.com, oleg@redhat.com, luto@amacapital.net, drysdale@google.com, mtk.manpages@gmail.com, wad@chromium.org, jln@chromium.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Can you apply below patch before new PFA_* are defined?
Cgroups code might want to define PFA_SPREAD_PAGE as 1 and PFA_SPREAD_SLAB as 2.
----------------------------------------
>From 8543e68adb210142fa347d8bc9d83df0bb2c5291 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 20 Sep 2014 19:24:23 +0900
Subject: [PATCH 3.17-rc5] Fix confusing PFA_NO_NEW_PRIVS constant.

Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
because it is used as bit number. Redefine it as decimal bit number.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..4557765 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1957,7 +1957,7 @@ static inline void memalloc_noio_restore(unsigned int flags)
 }
 
 /* Per-process atomic flags. */
-#define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
+#define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
 
 static inline bool task_no_new_privs(struct task_struct *p)
 {
-- 
1.7.1
