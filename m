From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas within
 sighandler
Date: Sun, 31 Jan 2016 22:18:41 +0300
Message-ID: <56AE5E11.3050802@list.ru>
References: <56AE5C08.6010403@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56AE5C08.6010403-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


linux implements the sigaltstack() in a way that makes it impossible to
use with swapcontext(). Per the man page, sigaltstack is allowed to return
EPERM if the process is altering its sigaltstack while running on
sigaltstack.
This is likely needed to consistently return oss->ss_flags, that indicates
whether the process is being on sigaltstack or not.
Unfortunately, linux takes that permission to return EPERM too literally:
it returns EPERM even if you don't want to change to another sigaltstack,
but only want to temporarily disable sigaltstack with SS_DISABLE.
You can't use swapcontext() without disabling sigaltstack first, or the
stack will be re-used and overwritten by a subsequent signal.

With this patch, disabling sigaltstack inside a signal handler became
possible, and the swapcontext() can then be used safely. After switching
back to the sighandler, the app can re-enable the sigatlstack.
The oss->ss_flags will correctly indicate the current use of sigaltstack,
even if it is temporarily disabled. Any attempt to modify the sigaltstack
(rather than to disable or re-enable it) within the sighandler, will still
be punished with EPERM as suggested by POSIX.

CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "Amanieu d'Antras" <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
CC: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
CC: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
CC: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
CC: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
CC: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
CC: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
CC: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
  include/linux/sched.h  |  8 ++++++--
  include/linux/signal.h |  2 +-
  kernel/fork.c          |  4 +++-
  kernel/signal.c        | 54 
+++++++++++++++++++++++++++++++++-----------------
  4 files changed, 46 insertions(+), 22 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a10494a..38f67dc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1587,6 +1587,7 @@ struct task_struct {

      unsigned long sas_ss_sp;
      size_t sas_ss_size;
+    int sas_ss_flags;

      struct callback_head *task_works;

@@ -2569,8 +2570,11 @@ static inline int sas_ss_flags(unsigned long sp)
  {
      if (!current->sas_ss_size)
          return SS_DISABLE;
-
-    return on_sig_stack(sp) ? SS_ONSTACK : 0;
+    if (on_sig_stack(sp))
+        return SS_ONSTACK;
+    if (current->sas_ss_flags == SS_DISABLE)
+        return SS_DISABLE;
+    return 0;
  }

  static inline unsigned long sigsp(unsigned long sp, struct ksignal *ksig)
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 92557bb..844b113 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -432,7 +432,7 @@ int __save_altstack(stack_t __user *, unsigned long);
      stack_t __user *__uss = uss; \
      struct task_struct *t = current; \
      put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
-    put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+    put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
      put_user_ex(t->sas_ss_size, &__uss->ss_size); \
  } while (0);

diff --git a/kernel/fork.c b/kernel/fork.c
index 2e391c7..ce840a9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1482,8 +1482,10 @@ static struct task_struct *copy_process(unsigned 
long clone_flags,
      /*
       * sigaltstack should be cleared when sharing the same VM
       */
-    if ((clone_flags & (CLONE_VM|CLONE_VFORK)) == CLONE_VM)
+    if ((clone_flags & (CLONE_VM|CLONE_VFORK)) == CLONE_VM) {
          p->sas_ss_sp = p->sas_ss_size = 0;
+        p->sas_ss_flags = SS_DISABLE;
+    }

      /*
       * Syscall tracing and stepping should be turned off in the
diff --git a/kernel/signal.c b/kernel/signal.c
index f3f1f7a..d19180e 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3101,6 +3101,7 @@ do_sigaltstack (const stack_t __user *uss, stack_t 
__user *uoss, unsigned long s
          void __user *ss_sp;
          size_t ss_size;
          int ss_flags;
+        int onsigstack;

          error = -EFAULT;
          if (!access_ok(VERIFY_READ, uss, sizeof(*uss)))
@@ -3111,32 +3112,49 @@ do_sigaltstack (const stack_t __user *uss, 
stack_t __user *uoss, unsigned long s
          if (error)
              goto out;

-        error = -EPERM;
-        if (on_sig_stack(sp))
-            goto out;
-
          error = -EINVAL;
-        /*
-         * Note - this code used to test ss_flags incorrectly:
-         *        old code may have been written using ss_flags==0
-         *      to mean ss_flags==SS_ONSTACK (as this was the only
-         *      way that worked) - this fix preserves that older
-         *      mechanism.
-         */
          if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && 
ss_flags != 0)
              goto out;

-        if (ss_flags == SS_DISABLE) {
-            ss_size = 0;
-            ss_sp = NULL;
-        } else {
+        onsigstack = on_sig_stack(sp);
+        if (ss_size == 0) {
+            switch (ss_flags) {
+            case 0:
+                error = -EPERM;
+                if (onsigstack)
+                    goto out;
+                current->sas_ss_sp = 0;
+                current->sas_ss_size = 0;
+                current->sas_ss_flags = SS_DISABLE;
+                break;
+            case SS_ONSTACK:
+                /* re-enable previously disabled sas */
+                error = -EINVAL;
+                if (current->sas_ss_size == 0)
+                    goto out;
+                break;
+            default:
+                break;
+            }
+        } else if (ss_flags != SS_DISABLE) {
+            error = -EPERM;
+            if (onsigstack)
+                goto out;
              error = -ENOMEM;
              if (ss_size < MINSIGSTKSZ)
                  goto out;
+            current->sas_ss_sp = (unsigned long) ss_sp;
+            current->sas_ss_size = ss_size;
+            /* unfortunately POSIX forces us to treat 0
+             * as SS_ONSTACK here, and some legacy apps
+             * perhaps used that...
+             */
+            if (ss_flags == 0)
+                ss_flags = SS_ONSTACK;
          }

-        current->sas_ss_sp = (unsigned long) ss_sp;
-        current->sas_ss_size = ss_size;
+        if (ss_flags != 0)
+            current->sas_ss_flags = ss_flags;
      }

      error = 0;
@@ -3168,7 +3186,7 @@ int __save_altstack(stack_t __user *uss, unsigned 
long sp)
  {
      struct task_struct *t = current;
      return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
-        __put_user(sas_ss_flags(sp), &uss->ss_flags) |
+        __put_user(t->sas_ss_flags, &uss->ss_flags) |
          __put_user(t->sas_ss_size, &uss->ss_size);
  }

-- 
2.5.0
