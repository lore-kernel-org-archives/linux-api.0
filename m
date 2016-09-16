From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 3/3] x86,arch_prctl Add ARCH_[GET|SET]_CPUID for
 controlling the CPUID instruction
Date: Thu, 15 Sep 2016 17:07:16 -0700
Message-ID: <CALCETrVzcXHzQotpkFb7kyBn5Q1o0J7TyHezTuO0LDN5xfv5uw@mail.gmail.com>
References: <20160915233324.6060-1-khuey@kylehuey.com> <20160915233324.6060-4-khuey@kylehuey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20160915233324.6060-4-khuey@kylehuey.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kyle Huey <me@kylehuey.com>
Cc: Robert O'Callahan <robert@ocallahan.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Safonov <0x7f454c46@gmail.com>, Borislav Petkov <bp@suse.de>, Linux API <linux-api@vger.kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Shuah Khan <shuah@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Len Brown <len.brown@intel.com>, Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 15, 2016 at 4:33 PM, Kyle Huey <me@kylehuey.com> wrote:
> Intel supports faulting on the CPUID instruction in newer processors. Bit
> 31 of MSR_PLATFORM_INFO advertises support for this feature. It is
> documented in detail in Section 2.3.2 of
> http://www.intel.com/content/dam/www/public/us/en/documents/application-n=
otes/virtualization-technology-flexmigration-application-note.pdf
>
> Support for this is implemented as a new pair of arch_prctls, available o=
n both x86-32 and x86-64.  The structure mirrors PR_[GET|SET]_TSC.  Like th=
e TSC flag, CPUID faulting is propagated across forks.  Unlike the TSC flag=
, it is reset (to CPUID enabled) on exec.
>
> Signed-off-by: Kyle Huey <khuey@kylehuey.com>
> ---
>  arch/x86/include/asm/msr-index.h          |   1 +
>  arch/x86/include/asm/thread_info.h        |   5 +-
>  arch/x86/include/uapi/asm/prctl.h         |   6 +
>  arch/x86/kernel/process.c                 |  98 ++++++++++++-
>  fs/exec.c                                 |   6 +
>  tools/testing/selftests/x86/Makefile      |   2 +-
>  tools/testing/selftests/x86/cpuid-fault.c | 234 ++++++++++++++++++++++++=
++++++
>  7 files changed, 349 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/x86/cpuid-fault.c
>
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-=
index.h
> index 83908d5..4aebec2 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -53,6 +53,7 @@
>  #define MSR_MTRRcap                    0x000000fe
>  #define MSR_IA32_BBL_CR_CTL            0x00000119
>  #define MSR_IA32_BBL_CR_CTL3           0x0000011e
> +#define MSR_MISC_FEATURES_ENABLES      0x00000140
>
>  #define MSR_IA32_SYSENTER_CS           0x00000174
>  #define MSR_IA32_SYSENTER_ESP          0x00000175
> diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/th=
read_info.h
> index 8b7c8d8..e3c40c6 100644
> --- a/arch/x86/include/asm/thread_info.h
> +++ b/arch/x86/include/asm/thread_info.h
> @@ -93,6 +93,7 @@ struct thread_info {
>  #define TIF_SECCOMP            8       /* secure computing */
>  #define TIF_USER_RETURN_NOTIFY 11      /* notify kernel of userspace ret=
urn */
>  #define TIF_UPROBE             12      /* breakpointed or singlestepping=
 */
> +#define TIF_NOCPUID            15      /* CPUID is not accessible in use=
rland */
>  #define TIF_NOTSC              16      /* TSC is not accessible in userl=
and */
>  #define TIF_IA32               17      /* IA32 compatibility process */
>  #define TIF_FORK               18      /* ret_from_fork */
> @@ -117,6 +118,7 @@ struct thread_info {
>  #define _TIF_SECCOMP           (1 << TIF_SECCOMP)
>  #define _TIF_USER_RETURN_NOTIFY        (1 << TIF_USER_RETURN_NOTIFY)
>  #define _TIF_UPROBE            (1 << TIF_UPROBE)
> +#define _TIF_NOCPUID           (1 << TIF_NOCPUID)
>  #define _TIF_NOTSC             (1 << TIF_NOTSC)
>  #define _TIF_IA32              (1 << TIF_IA32)
>  #define _TIF_FORK              (1 << TIF_FORK)
> @@ -146,7 +148,7 @@ struct thread_info {
>
>  /* flags to check in __switch_to() */
>  #define _TIF_WORK_CTXSW                                                 =
       \
> -       (_TIF_IO_BITMAP|_TIF_NOTSC|_TIF_BLOCKSTEP)
> +       (_TIF_IO_BITMAP|_TIF_NOCPUID|_TIF_NOTSC|_TIF_BLOCKSTEP)
>
>  #define _TIF_WORK_CTXSW_PREV (_TIF_WORK_CTXSW|_TIF_USER_RETURN_NOTIFY)
>  #define _TIF_WORK_CTXSW_NEXT (_TIF_WORK_CTXSW)
> @@ -293,6 +295,7 @@ static inline bool in_ia32_syscall(void)
>  extern void arch_task_cache_init(void);
>  extern int arch_dup_task_struct(struct task_struct *dst, struct task_str=
uct *src);
>  extern void arch_release_task_struct(struct task_struct *tsk);
> +extern void arch_post_exec(void);
>  #endif /* !__ASSEMBLY__ */
>
>  #endif /* _ASM_X86_THREAD_INFO_H */
> diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/as=
m/prctl.h
> index 3ac5032..c087e55 100644
> --- a/arch/x86/include/uapi/asm/prctl.h
> +++ b/arch/x86/include/uapi/asm/prctl.h
> @@ -6,4 +6,10 @@
>  #define ARCH_GET_FS 0x1003
>  #define ARCH_GET_GS 0x1004
>
> +/* Get/set the process' ability to use the CPUID instruction */
> +#define ARCH_GET_CPUID 0x1005
> +#define ARCH_SET_CPUID 0x1006
> +# define ARCH_CPUID_ENABLE             1       /* allow the use of the C=
PUID instruction */
> +# define ARCH_CPUID_SIGSEGV            2       /* throw a SIGSEGV instea=
d of reading the CPUID */
> +
>  #endif /* _ASM_X86_PRCTL_H */
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 1421451..f307d5c 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -32,6 +32,7 @@
>  #include <asm/tlbflush.h>
>  #include <asm/mce.h>
>  #include <asm/vm86.h>
> +#include <asm/prctl.h>
>
>  /*
>   * per-CPU TSS segments. Threads are completely 'soft' on Linux,
> @@ -191,6 +192,75 @@ int set_tsc_mode(unsigned int val)
>         return 0;
>  }
>
> +static void switch_cpuid_faulting(bool on)
> +{
> +       if (on)
> +               msr_set_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +       else
> +               msr_clear_bit(MSR_MISC_FEATURES_ENABLES, 0);
> +}
> +
> +static void disable_cpuid(void)
> +{
> +       preempt_disable();
> +       if (!test_and_set_thread_flag(TIF_NOCPUID))
> +               /*
> +                * Must flip the CPU state synchronously with
> +                * TIF_NOCPUID in the current running context.
> +                */
> +               switch_cpuid_faulting(true);
> +       preempt_enable();
> +}
> +
> +static void enable_cpuid(void)
> +{
> +       preempt_disable();
> +       if (test_and_clear_thread_flag(TIF_NOCPUID))
> +               /*
> +                * Must flip the CPU state synchronously with
> +                * TIF_NOCPUID in the current running context.
> +                */
> +               switch_cpuid_faulting(false);
> +       preempt_enable();
> +}
> +
> +int get_cpuid_mode(unsigned long adr)
> +{
> +       unsigned int val;
> +
> +       if (test_thread_flag(TIF_NOCPUID))
> +               val =3D ARCH_CPUID_SIGSEGV;
> +       else
> +               val =3D ARCH_CPUID_ENABLE;
> +
> +       return put_user(val, (unsigned int __user *)adr);
> +}

Can we just do:

if (arg2 !=3D 0)
  return -EINVAL;
else
 return test_thread_flag(TIF_NOCPUID) ? ARCH_CPUID_SIGSEGBV : ARCH_CPUID_EN=
ABLE;


> +
> +int set_cpuid_mode(struct task_struct *task, unsigned long val)
> +{
> +       /* Only disable/enable_cpuid() if it is supported on this hardwar=
e. */
> +       bool cpuid_fault_supported =3D static_cpu_has(X86_FEATURE_CPUID_F=
AULT);
> +
> +       if (val =3D=3D ARCH_CPUID_ENABLE && cpuid_fault_supported)
> +               enable_cpuid();

No need to check cpuid_fault_supported in this branch.

> +/*
> + * Called immediately after a successful exec.
> + */
> +void arch_post_exec()
> +{
> +       /* If cpuid was previously disabled for this task, re-enable it. =
*/
> +       if (test_thread_flag(TIF_NOCPUID))
> +               enable_cpuid();
> +}

Ugh, do we seriously not have anything that does this yet?
start_thread is almost the right thing.  So is elf_common_init.

>  asmlinkage long compat_sys_arch_prctl(int code, unsigned long arg2)
> diff --git a/fs/exec.c b/fs/exec.c
> index 6fcfb3f..a0fca09 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1627,6 +1627,11 @@ static int exec_binprm(struct linux_binprm *bprm)
>         return ret;
>  }
>
> +void __weak arch_post_exec(void)
> +{
> +       /* Do nothing by default */
> +}
> +

I personally prefer:

#ifndef arch_post_exec
static inline void arch_post_exec(void) {}
#endif

in linux/whatever.h and:

#define arch_post_exec arch_post_exec

in arch/x86/include/asm/whatever.h

It avoids bloating other architectures.

>  /*
>   * sys_execve() executes a new program.
>   */
> @@ -1743,6 +1748,7 @@ static int do_execveat_common(int fd, struct filena=
me *filename,
>         /* execve succeeded */
>         current->fs->in_exec =3D 0;
>         current->in_execve =3D 0;
> +       arch_post_exec();

Hrm.  This could also go in setup_new_exec().  I think I prefer that
so that all of this type of stuff stays together.

> diff --git a/tools/testing/selftests/x86/cpuid-fault.c b/tools/testing/se=
lftests/x86/cpuid-fault.c
> new file mode 100644
> index 0000000..a9f3f68
> --- /dev/null
> +++ b/tools/testing/selftests/x86/cpuid-fault.c
> @@ -0,0 +1,234 @@
> +
> +/*
> + * Tests for arch_prctl(ARCH_GET_CPUID, ...) / prctl(ARCH_SET_CPUID, ...=
)
> + *
> + * Basic test to test behaviour of ARCH_GET_CPUID and ARCH_SET_CPUID
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <signal.h>
> +#include <inttypes.h>
> +#include <cpuid.h>
> +#include <errno.h>
> +#include <sys/wait.h>
> +
> +#include <sys/prctl.h>
> +#include <linux/prctl.h>
> +
> +const char *cpuid_names[] =3D {
> +       [0] =3D "[not set]",

Is 0 even possible?

> +       [ARCH_CPUID_ENABLE] =3D "ARCH_CPUID_ENABLE",
> +       [ARCH_CPUID_SIGSEGV] =3D "ARCH_CPUID_SIGSEGV",
> +};
> +
> +int arch_prctl(int code, unsigned long arg2)
> +{
> +       return syscall(SYS_arch_prctl, code, arg2);
> +}
> +
> +int cpuid(unsigned int *eax, unsigned int *ebx, unsigned int *ecx,
> +         unsigned int *edx)
> +{
> +       return __get_cpuid(0, eax, ebx, ecx, edx);
> +}
> +
> +int do_child_exec_test(int eax, int ebx, int ecx, int edx)
> +{
> +       int cpuid_val =3D 0, child =3D 0, status =3D 0;
> +
> +       printf("arch_prctl(ARCH_GET_CPUID, &cpuid_val); ");
> +       fflush(stdout);
> +
> +       if (arch_prctl(ARCH_GET_CPUID, (unsigned long)&cpuid_val) !=3D 0)
> +               exit(42);

Let's exit with 1 and print something informative.  I like using the
errx macro for this -- see some of the other tests in this directory.

> +
> +       printf("cpuid_val =3D=3D %s\n", cpuid_names[cpuid_val]);
> +       if (cpuid_val !=3D ARCH_CPUID_SIGSEGV)
> +               exit(42);
> +
> +       if ((child =3D fork()) =3D=3D 0) {

Please check that we're still ARCH_CPU_SIGSEGV in here.

> +               printf("exec\n");
> +               fflush(stdout);
> +               execl("/proc/self/exe", "cpuid-fault", "-early-return", N=
ULL);
> +       }
> +
> +       if (child !=3D waitpid(child, &status, 0))
> +               exit(42);
> +
> +       if (WEXITSTATUS(status) !=3D 0)
> +               exit(42);
> +
> +       return 0;
> +}
> +


> +       if (arch_prctl(ARCH_SET_CPUID, ARCH_CPUID_ENABLE) !=3D 0)
> +               exit(42);

You are sneaky.  Nice hack to avoid siglongjmp :)

General comment: all of these fflush calls are ugly.  How about
calling setvbuf early in main() instead?
