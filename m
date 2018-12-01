From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] signal: add procfd_signal() syscall
Date: Sat, 1 Dec 2018 11:27:19 +0100
Message-ID: <CAK8P3a2jkG0dMyOxQMor+-u2ganP29RgeeNL2hMYy6pfVpNpTg@mail.gmail.com>
References: <20181120105124.14733-1-christian@brauner.io> <87in0g5aqo.fsf@oldenburg.str.redhat.com>
 <36323361-90BD-41AF-AB5B-EE0D7BA02C21@amacapital.net> <993B98AC-51DF-4131-AF7F-7DA2A7F485F1@brauner.io>
 <CALCETrWnQNMQcCmFZrftVVYgAMW6DT3gyxvVb_v9_enUCUkHiw@mail.gmail.com>
 <20181129195551.woe2bl3z3yaysqb6@brauner.io> <6E21165F-2C76-4877-ABD9-0C86D55FD6AA@amacapital.net>
 <CAK8P3a2i9DFaS9-3A9V_pKwFfwVR0bDqgLosmivge3Cx2VyiuQ@mail.gmail.com>
 <87y39b2lm2.fsf@xmission.com> <20181130065606.kmilbbq46oeycjp5@brauner.io>
 <CAK8P3a0kqPii5TwFAo_JHLX=o_FDMFVKXxgzzbDjLFZ7OQ5QCQ@mail.gmail.com>
 <CALCETrW2aphWwEY4=hUwo_JBCvkQyMjxzxGd9FCW017kMLaMOQ@mail.gmail.com>
 <CAK8P3a1isSRCd-OLJK15C+gSJdpeR=zEXghc8+AMM5QYYw3Tyg@mail.gmail.com>
 <CALCETrWcJCjNGEqgq57Bm8O3qWkfEwau2SiXAv+SNYvNmXnBCA@mail.gmail.com> <CAK8P3a1OX1Hb17=NbTYqZxgEM-sk5-dh_VeKa0bXJpq=k=KxHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK8P3a1OX1Hb17=NbTYqZxgEM-sk5-dh_VeKa0bXJpq=k=KxHA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: christian@brauner.io, "Eric W . Biederman" <ebiederm@xmission.com>, Florian Weimer <fweimer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>, Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, cyphar@cyphar.com, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Daniel Colascione <dancol@google.com>, Tim Murray <timmurray@google.com>, linux-man@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

On Sat, Dec 1, 2018 at 9:51 AM Arnd Bergmann <arnd@arndb.de> wrote:
> On Sat, Dec 1, 2018 at 12:54 AM Andy Lutomirski <luto@kernel.org> wrote:
> > On Fri, Nov 30, 2018 at 2:10 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Fri, Nov 30, 2018 at 5:36 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > > On Fri, Nov 30, 2018 at 3:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
> > > > > siginfo_t as it is now still has a number of other downsides, and Andy in
> > > > > particular didn't like the idea of having three new variants on x86
> > > > > (depending on how you count). His alternative suggestion of having
> > > > > a single syscall entry point that takes a 'signfo_t __user *' but interprets
> > > > > it as compat_siginfo depending on in_compat_syscall()/in_x32_syscall()
> > > > > should work correctly, but feels wrong to me, or at least inconsistent
> > > > > with how we do this elsewhere.
>
> > > The '548 | 0x40000000' part seems to be the only sensible
> > > way to handle x32 here. What exactly would you propose to
> > > avoid defining the other entry points?
> >
> > I would propose that it should be 335 | 0x40000000.  I can't see any
> > reasonable way to teach the kernel to reject 335 | 0x40000000 that
> > wouldn't work just as well to accept it and make it do the right
> > thing.  Currently we accept it and do the *wrong* thing, which is no
> > good.

I guess we could start with something like the change below, which
would unify the entry points for rt_{tg,}sigqueueinfo, so that
e.g. the 129 and 536 syscall numbers do the exact same thing, and
that would be the lp64 or ilp32 behavior, depending on the
0x40000000 bit. For the new syscalls, we can then do the same
thing without assigning another number.

      Arnd

diff --git a/arch/x86/entry/syscall_64.c b/arch/x86/entry/syscall_64.c
index d5252bc1e380..3233fb889a51 100644
--- a/arch/x86/entry/syscall_64.c
+++ b/arch/x86/entry/syscall_64.c
@@ -7,6 +7,11 @@
 #include <asm/asm-offsets.h>
 #include <asm/syscall.h>

+#ifdef CONFIG_X86_X32_ABI
+#define __x64_sys_x86_rt_sigqueueinfo  __x64_sys_rt_sigqueueinfo
+#define __x64_sys_x86_rt_tgsigqueueinfo __x64_sys_rt_tgsigqueueinfo
+#endif
+
 /* this is a lie, but it does not hurt as sys_ni_syscall just returns
-EINVAL */
 extern asmlinkage long sys_ni_syscall(const struct pt_regs *);
 #define __SYSCALL_64(nr, sym, qual) extern asmlinkage long sym(const
struct pt_regs *);
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl
b/arch/x86/entry/syscalls/syscall_64.tbl
index 0823eed2b02e..4a7393d34e03 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -137,7 +137,7 @@
 126    common  capset                  __x64_sys_capset
 127    64      rt_sigpending           __x64_sys_rt_sigpending
 128    64      rt_sigtimedwait         __x64_sys_rt_sigtimedwait
-129    64      rt_sigqueueinfo         __x64_sys_rt_sigqueueinfo
+129    64      rt_sigqueueinfo         __x64_sys_x86_rt_sigqueueinfo
 130    common  rt_sigsuspend           __x64_sys_rt_sigsuspend
 131    64      sigaltstack             __x64_sys_sigaltstack
 132    common  utime                   __x64_sys_utime
@@ -305,7 +305,7 @@
 294    common  inotify_init1           __x64_sys_inotify_init1
 295    64      preadv                  __x64_sys_preadv
 296    64      pwritev                 __x64_sys_pwritev
-297    64      rt_tgsigqueueinfo       __x64_sys_rt_tgsigqueueinfo
+297    64      rt_tgsigqueueinfo       __x64_sys_x86_rt_tgsigqueueinfo
 298    common  perf_event_open         __x64_sys_perf_event_open
 299    64      recvmmsg                __x64_sys_recvmmsg
 300    common  fanotify_init           __x64_sys_fanotify_init
@@ -369,7 +369,7 @@
 521    x32     ptrace                  __x32_compat_sys_ptrace
 522    x32     rt_sigpending           __x32_compat_sys_rt_sigpending
 523    x32     rt_sigtimedwait         __x32_compat_sys_rt_sigtimedwait
-524    x32     rt_sigqueueinfo         __x32_compat_sys_rt_sigqueueinfo
+524    x32     rt_sigqueueinfo         __x64_sys_x86_rt_sigqueueinfo
 525    x32     sigaltstack             __x32_compat_sys_sigaltstack
 526    x32     timer_create            __x32_compat_sys_timer_create
 527    x32     mq_notify               __x32_compat_sys_mq_notify
@@ -381,7 +381,7 @@
 533    x32     move_pages              __x32_compat_sys_move_pages
 534    x32     preadv                  __x32_compat_sys_preadv64
 535    x32     pwritev                 __x32_compat_sys_pwritev64
-536    x32     rt_tgsigqueueinfo       __x32_compat_sys_rt_tgsigqueueinfo
+536    x32     rt_tgsigqueueinfo       __x64_sys_x86_rt_tgsigqueueinfo
 537    x32     recvmmsg                __x32_compat_sys_recvmmsg
 538    x32     sendmmsg                __x32_compat_sys_sendmmsg
 539    x32     process_vm_readv        __x32_compat_sys_process_vm_readv
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 92a3b312a53c..2f16330cac83 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -892,4 +892,38 @@ asmlinkage long sys32_x32_rt_sigreturn(void)
        signal_fault(regs, frame, "x32 rt_sigreturn");
        return 0;
 }
+
+SYSCALL_DEFINE3(x86_rt_sigqueueinfo, pid_t, pid, int, sig,
+                siginfo_t __user *, uinfo)
+{
+        kernel_siginfo_t info;
+        int ret;
+
+       if (!in_x32_syscall()
+               ret = __copy_siginfo_from_user(sig, &info, uinfo);
+       else
+               ret = __copy_siginfo_from_user32(sig, &info, uinfo);
+
+        if (unlikely(ret))
+                return ret;
+        return do_rt_sigqueueinfo(pid, sig, &info);
+}
+
+SYSCALL_DEFINE3(x86_rt_tsigqueueinfo, pid_t, tgid, pid_t, pid, int, sig,
+                siginfo_t __user *, uinfo)
+{
+        kernel_siginfo_t info;
+        int ret;
+
+       if (!in_x32_syscall()
+               ret = __copy_siginfo_from_user(sig, &info, uinfo);
+       else
+               ret = __copy_siginfo_from_user32(sig, &info, uinfo);
+
+        if (unlikely(ret))
+                return ret;
+        return do_rt_tsigqueueinfo(tgid, pid, sig, &info);
+}
+
+
 #endif
