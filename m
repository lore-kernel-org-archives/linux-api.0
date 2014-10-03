From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86,seccomp,prctl: Remove PR_TSC_SIGSEGV and seccomp TSC filtering
Date: Fri, 3 Oct 2014 10:27:47 -0700
Message-ID: <CALCETrUfCrvidOS6VvUpWFAcHUrPUs58zSQqGRC5UOTS=E37rw@mail.gmail.com>
References: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <fc0c2447cbc39257941c6b118388c024b719353a.1412356529.git.luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Erik Bosman <ebn310-vHs5IaWfoDhmR6Xm/wNWPw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[adding linux-api.  whoops.]

On Fri, Oct 3, 2014 at 10:18 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> PR_SET_TSC / PR_TSC_SIGSEGV is a security feature to prevent heavily
> sandboxed programs from learning the time, presumably to avoid
> disclosing the wall clock and to make timing attacks much harder to
> exploit.
>
> Unfortunately, this feature is very insecure, for multiple reasons,
> and has probably been insecure since before it was written.
>
> Weakness 1: Before Linux 3.16, the vvar page and the HPET (!) were
> part of the kernel's fixmap, so any user process could read them.
> The vvar page contains low-resolution timing information (with real
> wall clock and frequency data), and the HPET can be used for high
> precision timing.  Even in Linux 3.16, there clean way to disable
> access to these pages.
>
> Weakness 2: On most configurations, most or all userspace processes
> have unrestricted access to RDPMC, which is even better than RDTSC
> for exploiting timing attacks.
>
> I would like to fix both of these issues.  I want to deny access to
> RDPMC to processes that haven't asked for access via
> perf_event_open.  I also want to implement real TSC blocking, which
> will require some vdso enhancements
>
> The problem is that both of these fixes will be per-mm, not per
> task.  So PR_SET_TSC will be barely supportable.
>
> Therefore, I'm proposing the radical solution of ripping out the old
> ABI to make room for the new.
>
> Enabling strict seccomp mode no longer disables the TSC.
>
> PR_GET_TSC still works and returns PR_TSC_ENABLED.  PR_SET_TSC now
> return -EINVAL if you try to set PR_TSC_SIGSEGV.
>
> Signed-off-by: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> ---
>  .../prctl/disable-tsc-ctxt-sw-stress-test.c        | 96 ----------------------
>  .../prctl/disable-tsc-on-off-stress-test.c         | 95 ---------------------
>  Documentation/prctl/disable-tsc-test.c             | 94 ---------------------
>  arch/x86/include/asm/processor.h                   |  7 --
>  arch/x86/include/asm/thread_info.h                 |  4 +-
>  arch/x86/include/asm/tsc.h                         |  2 -
>  arch/x86/kernel/process.c                          | 67 ---------------
>  include/uapi/linux/prctl.h                         |  7 +-
>  kernel/seccomp.c                                   |  3 -
>  kernel/sys.c                                       | 12 +--
>  10 files changed, 14 insertions(+), 373 deletions(-)
>  delete mode 100644 Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
>  delete mode 100644 Documentation/prctl/disable-tsc-on-off-stress-test.c
>  delete mode 100644 Documentation/prctl/disable-tsc-test.c
>
> diff --git a/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c b/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
> deleted file mode 100644
> index f8e8e95e81fd..000000000000
> --- a/Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c
> +++ /dev/null
> @@ -1,96 +0,0 @@
> -/*
> - * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
> - *
> - * Tests if the control register is updated correctly
> - * at context switches
> - *
> - * Warning: this test will cause a very high load for a few seconds
> - *
> - */
> -
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <unistd.h>
> -#include <signal.h>
> -#include <inttypes.h>
> -#include <wait.h>
> -
> -
> -#include <sys/prctl.h>
> -#include <linux/prctl.h>
> -
> -/* Get/set the process' ability to use the timestamp counter instruction */
> -#ifndef PR_GET_TSC
> -#define PR_GET_TSC 25
> -#define PR_SET_TSC 26
> -# define PR_TSC_ENABLE         1   /* allow the use of the timestamp counter */
> -# define PR_TSC_SIGSEGV                2   /* throw a SIGSEGV instead of reading the TSC */
> -#endif
> -
> -uint64_t rdtsc() {
> -uint32_t lo, hi;
> -/* We cannot use "=A", since this would use %rax on x86_64 */
> -__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
> -return (uint64_t)hi << 32 | lo;
> -}
> -
> -void sigsegv_expect(int sig)
> -{
> -       /* */
> -}
> -
> -void segvtask(void)
> -{
> -       if (prctl(PR_SET_TSC, PR_TSC_SIGSEGV) < 0)
> -       {
> -               perror("prctl");
> -               exit(0);
> -       }
> -       signal(SIGSEGV, sigsegv_expect);
> -       alarm(10);
> -       rdtsc();
> -       fprintf(stderr, "FATAL ERROR, rdtsc() succeeded while disabled\n");
> -       exit(0);
> -}
> -
> -
> -void sigsegv_fail(int sig)
> -{
> -       fprintf(stderr, "FATAL ERROR, rdtsc() failed while enabled\n");
> -       exit(0);
> -}
> -
> -void rdtsctask(void)
> -{
> -       if (prctl(PR_SET_TSC, PR_TSC_ENABLE) < 0)
> -       {
> -               perror("prctl");
> -               exit(0);
> -       }
> -       signal(SIGSEGV, sigsegv_fail);
> -       alarm(10);
> -       for(;;) rdtsc();
> -}
> -
> -
> -int main(int argc, char **argv)
> -{
> -       int n_tasks = 100, i;
> -
> -       fprintf(stderr, "[No further output means we're allright]\n");
> -
> -       for (i=0; i<n_tasks; i++)
> -               if (fork() == 0)
> -               {
> -                       if (i & 1)
> -                               segvtask();
> -                       else
> -                               rdtsctask();
> -               }
> -
> -       for (i=0; i<n_tasks; i++)
> -               wait(NULL);
> -
> -       exit(0);
> -}
> -
> diff --git a/Documentation/prctl/disable-tsc-on-off-stress-test.c b/Documentation/prctl/disable-tsc-on-off-stress-test.c
> deleted file mode 100644
> index 1fcd91445375..000000000000
> --- a/Documentation/prctl/disable-tsc-on-off-stress-test.c
> +++ /dev/null
> @@ -1,95 +0,0 @@
> -/*
> - * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
> - *
> - * Tests if the control register is updated correctly
> - * when set with prctl()
> - *
> - * Warning: this test will cause a very high load for a few seconds
> - *
> - */
> -
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <unistd.h>
> -#include <signal.h>
> -#include <inttypes.h>
> -#include <wait.h>
> -
> -
> -#include <sys/prctl.h>
> -#include <linux/prctl.h>
> -
> -/* Get/set the process' ability to use the timestamp counter instruction */
> -#ifndef PR_GET_TSC
> -#define PR_GET_TSC 25
> -#define PR_SET_TSC 26
> -# define PR_TSC_ENABLE         1   /* allow the use of the timestamp counter */
> -# define PR_TSC_SIGSEGV                2   /* throw a SIGSEGV instead of reading the TSC */
> -#endif
> -
> -/* snippet from wikipedia :-) */
> -
> -uint64_t rdtsc() {
> -uint32_t lo, hi;
> -/* We cannot use "=A", since this would use %rax on x86_64 */
> -__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
> -return (uint64_t)hi << 32 | lo;
> -}
> -
> -int should_segv = 0;
> -
> -void sigsegv_cb(int sig)
> -{
> -       if (!should_segv)
> -       {
> -               fprintf(stderr, "FATAL ERROR, rdtsc() failed while enabled\n");
> -               exit(0);
> -       }
> -       if (prctl(PR_SET_TSC, PR_TSC_ENABLE) < 0)
> -       {
> -               perror("prctl");
> -               exit(0);
> -       }
> -       should_segv = 0;
> -
> -       rdtsc();
> -}
> -
> -void task(void)
> -{
> -       signal(SIGSEGV, sigsegv_cb);
> -       alarm(10);
> -       for(;;)
> -       {
> -               rdtsc();
> -               if (should_segv)
> -               {
> -                       fprintf(stderr, "FATAL ERROR, rdtsc() succeeded while disabled\n");
> -                       exit(0);
> -               }
> -               if (prctl(PR_SET_TSC, PR_TSC_SIGSEGV) < 0)
> -               {
> -                       perror("prctl");
> -                       exit(0);
> -               }
> -               should_segv = 1;
> -       }
> -}
> -
> -
> -int main(int argc, char **argv)
> -{
> -       int n_tasks = 100, i;
> -
> -       fprintf(stderr, "[No further output means we're allright]\n");
> -
> -       for (i=0; i<n_tasks; i++)
> -               if (fork() == 0)
> -                       task();
> -
> -       for (i=0; i<n_tasks; i++)
> -               wait(NULL);
> -
> -       exit(0);
> -}
> -
> diff --git a/Documentation/prctl/disable-tsc-test.c b/Documentation/prctl/disable-tsc-test.c
> deleted file mode 100644
> index 843c81eac235..000000000000
> --- a/Documentation/prctl/disable-tsc-test.c
> +++ /dev/null
> @@ -1,94 +0,0 @@
> -/*
> - * Tests for prctl(PR_GET_TSC, ...) / prctl(PR_SET_TSC, ...)
> - *
> - * Basic test to test behaviour of PR_GET_TSC and PR_SET_TSC
> - */
> -
> -#include <stdio.h>
> -#include <stdlib.h>
> -#include <unistd.h>
> -#include <signal.h>
> -#include <inttypes.h>
> -
> -
> -#include <sys/prctl.h>
> -#include <linux/prctl.h>
> -
> -/* Get/set the process' ability to use the timestamp counter instruction */
> -#ifndef PR_GET_TSC
> -#define PR_GET_TSC 25
> -#define PR_SET_TSC 26
> -# define PR_TSC_ENABLE         1   /* allow the use of the timestamp counter */
> -# define PR_TSC_SIGSEGV                2   /* throw a SIGSEGV instead of reading the TSC */
> -#endif
> -
> -const char *tsc_names[] =
> -{
> -       [0] = "[not set]",
> -       [PR_TSC_ENABLE] = "PR_TSC_ENABLE",
> -       [PR_TSC_SIGSEGV] = "PR_TSC_SIGSEGV",
> -};
> -
> -uint64_t rdtsc() {
> -uint32_t lo, hi;
> -/* We cannot use "=A", since this would use %rax on x86_64 */
> -__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
> -return (uint64_t)hi << 32 | lo;
> -}
> -
> -void sigsegv_cb(int sig)
> -{
> -       int tsc_val = 0;
> -
> -       printf("[ SIG_SEGV ]\n");
> -       printf("prctl(PR_GET_TSC, &tsc_val); ");
> -       fflush(stdout);
> -
> -       if ( prctl(PR_GET_TSC, &tsc_val) == -1)
> -               perror("prctl");
> -
> -       printf("tsc_val == %s\n", tsc_names[tsc_val]);
> -       printf("prctl(PR_SET_TSC, PR_TSC_ENABLE)\n");
> -       fflush(stdout);
> -       if ( prctl(PR_SET_TSC, PR_TSC_ENABLE) == -1)
> -               perror("prctl");
> -
> -       printf("rdtsc() == ");
> -}
> -
> -int main(int argc, char **argv)
> -{
> -       int tsc_val = 0;
> -
> -       signal(SIGSEGV, sigsegv_cb);
> -
> -       printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
> -       printf("prctl(PR_GET_TSC, &tsc_val); ");
> -       fflush(stdout);
> -
> -       if ( prctl(PR_GET_TSC, &tsc_val) == -1)
> -               perror("prctl");
> -
> -       printf("tsc_val == %s\n", tsc_names[tsc_val]);
> -       printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
> -       printf("prctl(PR_SET_TSC, PR_TSC_ENABLE)\n");
> -       fflush(stdout);
> -
> -       if ( prctl(PR_SET_TSC, PR_TSC_ENABLE) == -1)
> -               perror("prctl");
> -
> -       printf("rdtsc() == %llu\n", (unsigned long long)rdtsc());
> -       printf("prctl(PR_SET_TSC, PR_TSC_SIGSEGV)\n");
> -       fflush(stdout);
> -
> -       if ( prctl(PR_SET_TSC, PR_TSC_SIGSEGV) == -1)
> -               perror("prctl");
> -
> -       printf("rdtsc() == ");
> -       fflush(stdout);
> -       printf("%llu\n", (unsigned long long)rdtsc());
> -       fflush(stdout);
> -
> -       exit(EXIT_SUCCESS);
> -}
> -
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index eb71ec794732..d9ed8489bc04 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -946,13 +946,6 @@ extern void start_thread(struct pt_regs *regs, unsigned long new_ip,
>
>  #define KSTK_EIP(task)         (task_pt_regs(task)->ip)
>
> -/* Get/set a process' ability to use the timestamp counter instruction */
> -#define GET_TSC_CTL(adr)       get_tsc_mode((adr))
> -#define SET_TSC_CTL(val)       set_tsc_mode((val))
> -
> -extern int get_tsc_mode(unsigned long adr);
> -extern int set_tsc_mode(unsigned int val);
> -
>  extern u16 amd_get_nb_id(int cpu);
>
>  static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
> index 854053889d4d..ac9ed8b13aa8 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -78,7 +78,6 @@ struct thread_info {
>  #define TIF_MCE_NOTIFY         10      /* notify userspace of an MCE */
>  #define TIF_USER_RETURN_NOTIFY 11      /* notify kernel of userspace return */
>  #define TIF_UPROBE             12      /* breakpointed or singlestepping */
> -#define TIF_NOTSC              16      /* TSC is not accessible in userland */
>  #define TIF_IA32               17      /* IA32 compatibility process */
>  #define TIF_FORK               18      /* ret_from_fork */
>  #define TIF_NOHZ               19      /* in adaptive nohz mode */
> @@ -103,7 +102,6 @@ struct thread_info {
>  #define _TIF_MCE_NOTIFY                (1 << TIF_MCE_NOTIFY)
>  #define _TIF_USER_RETURN_NOTIFY        (1 << TIF_USER_RETURN_NOTIFY)
>  #define _TIF_UPROBE            (1 << TIF_UPROBE)
> -#define _TIF_NOTSC             (1 << TIF_NOTSC)
>  #define _TIF_IA32              (1 << TIF_IA32)
>  #define _TIF_FORK              (1 << TIF_FORK)
>  #define _TIF_NOHZ              (1 << TIF_NOHZ)
> @@ -145,7 +143,7 @@ struct thread_info {
>
>  /* flags to check in __switch_to() */
>  #define _TIF_WORK_CTXSW                                                        \
> -       (_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
> +       (_TIF_IO_BITMAP|_TIF_BLOCKSTEP)
>
>  #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
>  #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
> diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
> index 94605c0e9cee..dc8fefa8b672 100644
> --- a/arch/x86/include/asm/tsc.h
> +++ b/arch/x86/include/asm/tsc.h
> @@ -17,8 +17,6 @@ typedef unsigned long long cycles_t;
>  extern unsigned int cpu_khz;
>  extern unsigned int tsc_khz;
>
> -extern void disable_TSC(void);
> -
>  static inline cycles_t get_cycles(void)
>  {
>         unsigned long long ret = 0;
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index f804dc935d2a..73e6a57e24d9 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -137,64 +137,6 @@ void flush_thread(void)
>                 free_thread_xstate(tsk);
>  }
>
> -static void hard_disable_TSC(void)
> -{
> -       write_cr4(read_cr4() | X86_CR4_TSD);
> -}
> -
> -void disable_TSC(void)
> -{
> -       preempt_disable();
> -       if (!test_and_set_thread_flag(TIF_NOTSC))
> -               /*
> -                * Must flip the CPU state synchronously with
> -                * TIF_NOTSC in the current running context.
> -                */
> -               hard_disable_TSC();
> -       preempt_enable();
> -}
> -
> -static void hard_enable_TSC(void)
> -{
> -       write_cr4(read_cr4() & ~X86_CR4_TSD);
> -}
> -
> -static void enable_TSC(void)
> -{
> -       preempt_disable();
> -       if (test_and_clear_thread_flag(TIF_NOTSC))
> -               /*
> -                * Must flip the CPU state synchronously with
> -                * TIF_NOTSC in the current running context.
> -                */
> -               hard_enable_TSC();
> -       preempt_enable();
> -}
> -
> -int get_tsc_mode(unsigned long adr)
> -{
> -       unsigned int val;
> -
> -       if (test_thread_flag(TIF_NOTSC))
> -               val = PR_TSC_SIGSEGV;
> -       else
> -               val = PR_TSC_ENABLE;
> -
> -       return put_user(val, (unsigned int __user *)adr);
> -}
> -
> -int set_tsc_mode(unsigned int val)
> -{
> -       if (val == PR_TSC_SIGSEGV)
> -               disable_TSC();
> -       else if (val == PR_TSC_ENABLE)
> -               enable_TSC();
> -       else
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
>  void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>                       struct tss_struct *tss)
>  {
> @@ -214,15 +156,6 @@ void __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
>                 update_debugctlmsr(debugctl);
>         }
>
> -       if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
> -           test_tsk_thread_flag(next_p, TIF_NOTSC)) {
> -               /* prev and next are different */
> -               if (test_tsk_thread_flag(next_p, TIF_NOTSC))
> -                       hard_disable_TSC();
> -               else
> -                       hard_enable_TSC();
> -       }
> -
>         if (test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
>                 /*
>                  * Copy the relevant range of the IO bitmap.
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index 58afc04c107e..9a2fea65c965 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -68,7 +68,12 @@
>  #define PR_CAPBSET_READ 23
>  #define PR_CAPBSET_DROP 24
>
> -/* Get/set the process' ability to use the timestamp counter instruction */
> +/*
> + * Get/set the process' ability to use the timestamp counter instruction
> + * Deprecated: PR_GET_TSC always reports PR_TSC_ENABLE, and PR_SET_TSC can
> + * only be used to set PR_TSC_ENABLE.  On non-x86 systems, neither of these
> + * prctls exists at all.
> + */
>  #define PR_GET_TSC 25
>  #define PR_SET_TSC 26
>  # define PR_TSC_ENABLE         1       /* allow the use of the timestamp counter */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 44eb005c6695..bdc60dc68e56 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -678,9 +678,6 @@ static long seccomp_set_mode_strict(void)
>         if (!seccomp_may_assign_mode(seccomp_mode))
>                 goto out;
>
> -#ifdef TIF_NOTSC
> -       disable_TSC();
> -#endif
>         seccomp_assign_mode(current, seccomp_mode);
>         ret = 0;
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index ce8129192a26..5dd1dedb7bf9 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -88,9 +88,6 @@
>  #ifndef GET_TSC_CTL
>  # define GET_TSC_CTL(a)                (-EINVAL)
>  #endif
> -#ifndef SET_TSC_CTL
> -# define SET_TSC_CTL(a)                (-EINVAL)
> -#endif
>
>  /*
>   * this is where the system-wide overflow UID and GID are defined, for
> @@ -1917,12 +1914,17 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
>         case PR_SET_SECCOMP:
>                 error = prctl_set_seccomp(arg2, (char __user *)arg3);
>                 break;
> +#ifdef CONFIG_X86
>         case PR_GET_TSC:
> -               error = GET_TSC_CTL(arg2);
> +               error = put_user(PR_TSC_ENABLE, (int __user *)arg2);
>                 break;
>         case PR_SET_TSC:
> -               error = SET_TSC_CTL(arg2);
> +               if (arg2 == PR_TSC_ENABLE)
> +                       error = 0;
> +               else
> +                       error = -EINVAL;
>                 break;
> +#endif
>         case PR_TASK_PERF_EVENTS_DISABLE:
>                 error = perf_event_task_disable();
>                 break;
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
