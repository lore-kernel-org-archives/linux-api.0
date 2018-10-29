From: Kees Cook <keescook@chromium.org>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 09:25:15 -0700
Message-ID: <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20181029112343.27454-1-msammler@mpi-sws.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Michael Sammler <msammler@mpi-sws.org>
Cc: Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>, PowerPC <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 29, 2018 at 4:23 AM, Michael Sammler <msammler@mpi-sws.org> wrote:
> Add the current value of an architecture specific protection keys
> register (currently PKRU on x86) to data available for seccomp-bpf
> programs to work on. This allows filters based on the currently
> enabled protection keys.
>
> Support for protection keys on the POWER architecture is not part of
> this patch since I do not have access to a PowerPC, but adding support
> for it can be achieved by setting sd->pkeys to the AMR register in
> populate_seccomp_data.
>
> One use case for this patch is disabling unnecessary system calls for a
> library (e.g. network i/o for a crypto library) while the library runs
> without disabling the system calls for the whole program (by changing
> the protection keys before and after the library executes). Using this
> one could ensure that the library behaves a expected (e.g. the crypto
> library not sending private keys to a malicious server).
>
> This patch also enables lightweight sandboxing of untrusted code using
> memory protection keys: Protection keys provide memory isolation but
> for a sandbox system call isolation is needed as well. This patch
> allows writing a seccomp filter to prevent system calls by the
> untrusted code while still allowing system calls for the trusted code.

Isn't PKU instruction based? Couldn't a malicious library just change
the state of the MPK registers? This seems like an easy way to bypass
any filters that used PKU. I'm not convinced this is a meaningful
barrier that should be enforced by seccomp.

This can also be done with a signal handler with SECCOMP_RET_TRAP and
check instruction pointer vs PKU state.

-Kees

>
> An alternative design would be to extend (c)BPF with a new instruction
> to read the state of a protection key. This alternate design would
> provide a simpler interface to the user space since the BPF program
> would not need to deal with the architecture specific pkeys field in
> seccomp_data, but the question is, how much of an advantage this would
> be as the nr field in seccomp_data is already architecture specific.
> Adding a new instruction for BPF programs is more complicated than
> this patch and might be a breaking change.
>
> Results of selftests/seccomp_benchmark.c on a x86 machine with pkeys
> support:
>
> With patch:
> Benchmarking 33554432 samples...
> 28.019505558 - 18.676858522 = 9342647036
> getpid native: 278 ns
> 42.279109885 - 28.019657031 = 14259452854
> getpid RET_ALLOW: 424 ns
> Estimated seccomp overhead per syscall: 146 ns
>
> Without patch:
> Benchmarking 33554432 samples...
> 28.059619466 - 18.706769155 = 9352850311
> getpid native: 278 ns
> 42.299228279 - 28.059761804 = 14239466475
> getpid RET_ALLOW: 424 ns
> Estimated seccomp overhead per syscall: 146 ns
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Ram Pai <linuxram@us.ibm.com>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Michael Sammler <msammler@mpi-sws.org>
> ---
> Changes to the previous version:
> - added motivation, notes about POWER, alternative design and benchmark results to the commit log
> - renamed pkru field in seccomp_data to pkeys
> - changed size of pkru field to __u64 and removed reserved field
> - added test for x86
>
>  arch/mips/kernel/ptrace.c                     |   1 +
>  arch/x86/entry/common.c                       |   1 +
>  include/uapi/linux/seccomp.h                  |   3 +
>  kernel/seccomp.c                              |   1 +
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 107 +++++++++++++++++++++++++-
>  5 files changed, 112 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
> index e5ba56c0..a58dd04d 100644
> --- a/arch/mips/kernel/ptrace.c
> +++ b/arch/mips/kernel/ptrace.c
> @@ -1277,6 +1277,7 @@ asmlinkage long syscall_trace_enter(struct pt_regs *regs, long syscall)
>                 for (i = 0; i < 6; i++)
>                         sd.args[i] = args[i];
>                 sd.instruction_pointer = KSTK_EIP(current);
> +               sd.pkeys = 0;
>
>                 ret = __secure_computing(&sd);
>                 if (ret == -1)
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 3b2490b8..20c51bf2 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -98,6 +98,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
>                 sd.arch = arch;
>                 sd.nr = regs->orig_ax;
>                 sd.instruction_pointer = regs->ip;
> +               sd.pkeys = read_pkru();
>  #ifdef CONFIG_X86_64
>                 if (arch == AUDIT_ARCH_X86_64) {
>                         sd.args[0] = regs->di;
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 9efc0e73..3aa2d934 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -52,12 +52,15 @@
>   * @instruction_pointer: at the time of the system call.
>   * @args: up to 6 system call arguments always stored as 64-bit values
>   *        regardless of the architecture.
> + * @pkeys: value of an architecture specific protection keys register
> + *         (currently PKRU on x86)
>   */
>  struct seccomp_data {
>         int nr;
>         __u32 arch;
>         __u64 instruction_pointer;
>         __u64 args[6];
> +       __u64 pkeys;
>  };
>
>  #endif /* _UAPI_LINUX_SECCOMP_H */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index fd023ac2..dfb8b0d6 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -91,6 +91,7 @@ static void populate_seccomp_data(struct seccomp_data *sd)
>         sd->args[4] = args[4];
>         sd->args[5] = args[5];
>         sd->instruction_pointer = KSTK_EIP(task);
> +       sd->pkeys = 0;
>  }
>
>  /**
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index e1473234..f7f8fa6f 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -82,6 +82,7 @@ struct seccomp_data {
>         __u32 arch;
>         __u64 instruction_pointer;
>         __u64 args[6];
> +       __u64 pkeys;
>  };
>  #endif
>
> @@ -732,7 +733,9 @@ TEST(KILL_process)
>  TEST(arg_out_of_range)
>  {
>         struct sock_filter filter[] = {
> -               BPF_STMT(BPF_LD|BPF_W|BPF_ABS, syscall_arg(6)),
> +               BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
> +                       offsetof(struct seccomp_data, pkeys)
> +                               + sizeof(__u64)),
>                 BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
>         };
>         struct sock_fprog prog = {
> @@ -2933,6 +2936,108 @@ skip:
>         ASSERT_EQ(0, kill(pid, SIGKILL));
>  }
>
> +#if defined(__i386__) || defined(__x86_64__)
> +static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
> +               unsigned int *ecx, unsigned int *edx)
> +{
> +       /* ecx is often an input as well as an output. */
> +       asm volatile(
> +               "cpuid;"
> +               : "=a" (*eax),
> +                 "=b" (*ebx),
> +                 "=c" (*ecx),
> +                 "=d" (*edx)
> +               : "0" (*eax), "2" (*ecx));
> +}
> +
> +/* Intel-defined CPU features, CPUID level 0x00000007:0 (ecx) */
> +#define X86_FEATURE_PKU        (1<<3) /* Protection Keys for Userspace */
> +#define X86_FEATURE_OSPKE      (1<<4) /* OS Protection Keys Enable */
> +
> +static inline int cpu_has_pku(void)
> +{
> +       unsigned int eax;
> +       unsigned int ebx;
> +       unsigned int ecx;
> +       unsigned int edx;
> +
> +       eax = 0x7;
> +       ecx = 0x0;
> +       __cpuid(&eax, &ebx, &ecx, &edx);
> +
> +       if (!(ecx & X86_FEATURE_PKU))
> +               return 0;
> +       if (!(ecx & X86_FEATURE_OSPKE))
> +               return 0;
> +       return 1;
> +}
> +
> +static inline __u32 read_pkru(void)
> +{
> +       if (!cpu_has_pku())
> +               return 0;
> +
> +       __u32 ecx = 0;
> +       __u32 edx, pkru;
> +
> +       /*
> +        * "rdpkru" instruction.  Places PKRU contents in to EAX,
> +        * clears EDX and requires that ecx=0.
> +        */
> +       asm volatile(".byte 0x0f,0x01,0xee\n\t"
> +                    : "=a" (pkru), "=d" (edx)
> +                    : "c" (ecx));
> +       return pkru;
> +}
> +
> +static inline void write_pkru(__u32 pkru)
> +{
> +       if (!cpu_has_pku())
> +               return;
> +
> +       __u32 ecx = 0, edx = 0;
> +
> +       /*
> +        * "wrpkru" instruction.  Loads contents in EAX to PKRU,
> +        * requires that ecx = edx = 0.
> +        */
> +       asm volatile(".byte 0x0f,0x01,0xef\n\t"
> +                    : : "a" (pkru), "c"(ecx), "d"(edx));
> +}
> +
> +#define TEST_PKRU 0x55555550
> +
> +TEST_SIGNAL(pkeys_set, SIGSYS)
> +{
> +       write_pkru(TEST_PKRU);
> +       /* read back the written value because pkru might not be supported */
> +       __u32 pkru = read_pkru();
> +
> +       struct sock_filter filter[] = {
> +               BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
> +                       offsetof(struct seccomp_data, pkeys)),
> +               BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, pkru, 1, 0),
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
> +       };
> +       struct sock_fprog prog = {
> +               .len = (unsigned short)ARRAY_SIZE(filter),
> +               .filter = filter,
> +       };
> +       long ret;
> +
> +       ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> +       ASSERT_EQ(0, ret);
> +
> +       ret = prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
> +       ASSERT_EQ(0, ret);
> +
> +       /* should never return. */
> +       EXPECT_EQ(0, syscall(__NR_getpid));
> +}
> +#endif
> +
> +
>  /*
>   * TODO:
>   * - add microbenchmarks
> --
> 2.11.0



-- 
Kees Cook
