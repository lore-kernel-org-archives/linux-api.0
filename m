From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: [PATCH 2/2] sigaltstack: remove EPERM check to make swapcontext()
 usable
Date: Sat, 9 Jan 2016 04:18:40 +0300
Message-ID: <56905FF0.4040406@list.ru>
References: <56905B90.6060505@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56905B90.6060505-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org


linux implements the sigaltstack() in a way that makes it impossible to
use with swapcontext(). Per the man page, sigaltstack is allowed to return
EPERM if the process is altering its sigaltstack while running on
sigaltstack.
This is likely needed to consistently return oss->ss_flags, that indicates
whether the process is being on sigaltstack or not.
Unfortunately, linux takes that permission to return EPERM too literally:
it returns EPERM even if you don't want to change to another sigaltstack,
but only want to disable sigaltstack with SS_DISABLE.
You can't use swapcontext() without disabling sigaltstack first, or the
stack will be re-used and overwritten by a subsequent signal.

With this patch, disabling sigaltstack inside a signal handler became
possible, and the swapcontext() can then be used safely. The oss->ss_flags
will then return SS_DISABLE, which doesn't seem to contradict the
(very ambiguous) man page wording, namely:
        SS_ONSTACK
               The process is currently executing on the alternate signal
               stack. (Note that it is not possible to change the alternate
               signal stack if the process is currently executing on it.)

        SS_DISABLE
               The alternate signal stack is currently disabled.

It seems both the above cases apply when executing on sigaltstack with
sigaltstack being currently disabled, so hope no one really cares.

CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: "Amanieu d'Antras" <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
CC: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
  kernel/signal.c | 15 +++++----------
  1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index f3f1f7a..0a6af54 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3111,18 +3111,13 @@ do_sigaltstack (const stack_t __user *uss, 
stack_t __user *uoss, unsigned long s
          if (error)
              goto out;

-        error = -EPERM;
-        if (on_sig_stack(sp))
-            goto out;
-
-        error = -EINVAL;
          /*
-         * Note - this code used to test ss_flags incorrectly:
-         *        old code may have been written using ss_flags==0
-         *      to mean ss_flags==SS_ONSTACK (as this was the only
-         *      way that worked) - this fix preserves that older
-         *      mechanism.
+         * Note - this code used to test on_sig_stack(sp) and
+         * return -EPERM. But we need at least SS_DISABLE to
+         * work while on sigaltstack, so the check was removed.
           */
+
+        error = -EINVAL;
          if (ss_flags != SS_DISABLE && ss_flags != SS_ONSTACK && 
ss_flags != 0)
              goto out;

-- 
2.4.3
