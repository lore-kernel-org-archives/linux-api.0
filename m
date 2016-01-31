From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 2/2] sigaltstack: remove EPERM check to make swapcontext()
 usable
Date: Sun, 31 Jan 2016 05:53:56 +0300
Message-ID: <56AD7744.5020804@list.ru>
References: <56905B90.6060505@list.ru> <56905FF0.4040406@list.ru>
 <CALCETrUAPqhrt9UjKt5=n=R-Ao7g-emDtt34YXZgyhr3TuFu9w@mail.gmail.com>
 <56907546.2050706@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56907546.2050706-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[re-sending with better formatting]

09.01.2016 05:49, Stas Sergeev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 09.01.2016 05:03, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> On Fri, Jan 8, 2016 at 5:18 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>>> linux implements the sigaltstack() in a way that makes it
 >>> impossible to
 >>> use with swapcontext(). Per the man page, sigaltstack is allowed t=
o
 >>> return
 >>> EPERM if the process is altering its sigaltstack while running on
 >>> sigaltstack.
 >>> This is likely needed to consistently return oss->ss_flags, that
 >>> indicates
 >>> whether the process is being on sigaltstack or not.
 >>> Unfortunately, linux takes that permission to return EPERM too
 >>> literally:
 >>> it returns EPERM even if you don't want to change to another
 >>> sigaltstack,
 >>> but only want to disable sigaltstack with SS_DISABLE.
 >>> You can't use swapcontext() without disabling sigaltstack first, o=
r
 >>> the
 >>> stack will be re-used and overwritten by a subsequent signal.
 >>> With this patch, disabling sigaltstack inside a signal handler
 >>> became
 >>> possible, and the swapcontext() can then be used safely. The
 >>> oss->ss_flags
 >>> will then return SS_DISABLE, which doesn't seem to contradict the
 >>> (very ambiguous) man page wording, namely:
 >>>         SS_ONSTACK
 >>>                The process is currently executing on the alternate
 >>> signal
 >>>                stack. (Note that it is not possible to change the
 >>> alternate
 >>>                signal stack if the process is currently executing
 >>> on it.)
 >>>
 >> You're definitely contradicting the "Note" part, though.  POSIX is
 >> quite clear, too:
 >> "Attempts to modify the alternate signal stack while the process is
 >> executing on it fail."
 > "modify" may not include "disable".
 > You don't modify the stack's location or size, just temporary disabl=
e
 > its use.
 > So I believe SS_DISABLE should be fine.
 > Of course this is just one of the possible interpretations.
 > But it is the one that looks simple and satisfies everyone.

I've finally made the patch to demonstrate that.
It has the nasty disadvantage of touching the arch-specific
code, but it has the advantages too:
- seems compatible with both posix and swapcontext()
   (before using swapcontext() in a sighandler, the sigaltstack
   have to be disabled - this is what this patch makes possible)
- doesn't require the new flag to paper around one of the
   possible posix interpretation
- consistently returns oss->ss_flags=3D=3DSS_ONSTACK while in
   sighandler, even after setting flags to SS_DISABLE
- allows someone (like glibc), if need be, to implement the old
   behaviour: it can check for oss->ss_flags first, and if it is
   SS_ONSTACK, return EPERM without trying to set the new value.

So since this patch demonstrates the way of solving the
swapcontext() problem without adding the SS_FORCE flag
to sigaltstack(), I believe we shouldn't be adding it. That flag
will only allow us to have a smaller patch that doesn't touch
the arch code, but is that a good enough justification?

So if there are no objections, I'll probably have to add an
arch-specific ifdefs to this patch to make other arches
unaffected, and submit it.
Of course we can still just remove the EPERM check.
Thoughts?


diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cb6282c..06e2591 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -216,7 +216,7 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs=
=20
*regs, size_t frame_size,
      if (!onsigstack) {
          /* This is the X/Open sanctioned signal stack switching. */
          if (ka->sa.sa_flags & SA_ONSTACK) {
-            if (current->sas_ss_size)
+            if (sas_ss_enabled())
                  sp =3D current->sas_ss_sp + current->sas_ss_size;
          } else if (config_enabled(CONFIG_X86_32) &&
                 (regs->ss & 0xffff) !=3D __USER_DS &&
diff --git a/include/linux/sched.h b/include/linux/sched.h
index edad7a4..f7e7026 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1572,6 +1572,7 @@ struct task_struct {

      unsigned long sas_ss_sp;
      size_t sas_ss_size;
+    int sas_ss_flags;

      struct callback_head *task_works;

@@ -2550,8 +2551,16 @@ static inline int sas_ss_flags(unsigned long sp)
  {
      if (!current->sas_ss_size)
          return SS_DISABLE;
+    if (on_sig_stack(sp))
+        return SS_ONSTACK;
+    if (current->sas_ss_flags =3D=3D SS_DISABLE)
+        return SS_DISABLE;
+    return 0;
+}

-    return on_sig_stack(sp) ? SS_ONSTACK : 0;
+static inline int sas_ss_enabled(void)
+{
+    return (current->sas_ss_size && current->sas_ss_flags !=3D SS_DISA=
BLE);
  }

  static inline unsigned long sigsp(unsigned long sp, struct ksignal *k=
sig)
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 92557bb..844b113 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -432,7 +432,7 @@ int __save_altstack(stack_t __user *, unsigned long=
);
      stack_t __user *__uss =3D uss; \
      struct task_struct *t =3D current; \
      put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
-    put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
+    put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
      put_user_ex(t->sas_ss_size, &__uss->ss_size); \
  } while (0);

diff --git a/kernel/fork.c b/kernel/fork.c
index fce002e..e5edc5c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1483,8 +1483,10 @@ static struct task_struct *copy_process(unsigned=
=20
long clone_flags,
      /*
       * sigaltstack should be cleared when sharing the same VM
       */
-    if ((clone_flags & (CLONE_VM|CLONE_VFORK)) =3D=3D CLONE_VM)
+    if ((clone_flags & (CLONE_VM|CLONE_VFORK)) =3D=3D CLONE_VM) {
          p->sas_ss_sp =3D p->sas_ss_size =3D 0;
+        p->sas_ss_flags =3D SS_DISABLE;
+    }

      /*
       * Syscall tracing and stepping should be turned off in the
diff --git a/kernel/signal.c b/kernel/signal.c
index f3f1f7a..ef537d8 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3101,6 +3101,7 @@ do_sigaltstack (const stack_t __user *uss, stack_=
t=20
__user *uoss, unsigned long s
          void __user *ss_sp;
          size_t ss_size;
          int ss_flags;
+        int onsigstack;

          error =3D -EFAULT;
          if (!access_ok(VERIFY_READ, uss, sizeof(*uss)))
@@ -3111,32 +3112,48 @@ do_sigaltstack (const stack_t __user *uss,=20
stack_t __user *uoss, unsigned long s
          if (error)
              goto out;

-        error =3D -EPERM;
-        if (on_sig_stack(sp))
-            goto out;
-
          error =3D -EINVAL;
-        /*
-         * Note - this code used to test ss_flags incorrectly:
-         *        old code may have been written using ss_flags=3D=3D0
-         *      to mean ss_flags=3D=3DSS_ONSTACK (as this was the only
-         *      way that worked) - this fix preserves that older
-         *      mechanism.
-         */
          if (ss_flags !=3D SS_DISABLE && ss_flags !=3D SS_ONSTACK &&=20
ss_flags !=3D 0)
              goto out;

-        if (ss_flags =3D=3D SS_DISABLE) {
-            ss_size =3D 0;
-            ss_sp =3D NULL;
-        } else {
+        onsigstack =3D on_sig_stack(sp);
+        if (ss_size =3D=3D 0) {
+            switch (ss_flags) {
+            case 0:
+                error =3D -EPERM;
+                if (onsigstack)
+                    goto out;
+                current->sas_ss_sp =3D 0;
+                current->sas_ss_size =3D 0;
+                current->sas_ss_flags =3D SS_DISABLE;
+                break;
+            case SS_ONSTACK:
+                /* re-enable previously disabled sas */
+                error =3D -EINVAL;
+                if (current->sas_ss_size =3D=3D 0)
+                    goto out;
+                break;
+            default:
+                break;
+            }
+        } else if (ss_flags !=3D SS_DISABLE) {
+            error =3D -EPERM;
+            if (onsigstack)
+                goto out;
              error =3D -ENOMEM;
              if (ss_size < MINSIGSTKSZ)
                  goto out;
+            current->sas_ss_sp =3D (unsigned long) ss_sp;
+            current->sas_ss_size =3D ss_size;
+            /* unfortunately POSIX forces us to treat 0
+             * as SS_ONSTACK here, and some legacy apps
+             * perhaps used that... */
+            if (ss_flags =3D=3D 0)
+                ss_flags =3D SS_ONSTACK;
          }

-        current->sas_ss_sp =3D (unsigned long) ss_sp;
-        current->sas_ss_size =3D ss_size;
+        if (ss_flags !=3D 0)
+            current->sas_ss_flags =3D ss_flags;
      }

      error =3D 0;
@@ -3168,7 +3185,7 @@ int __save_altstack(stack_t __user *uss, unsigned=
=20
long sp)
  {
      struct task_struct *t =3D current;
      return  __put_user((void __user *)t->sas_ss_sp, &uss->ss_sp) |
-        __put_user(sas_ss_flags(sp), &uss->ss_flags) |
+        __put_user(t->sas_ss_flags, &uss->ss_flags) |
          __put_user(t->sas_ss_size, &uss->ss_size);
  }
