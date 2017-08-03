From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5 3/6] seccomp: Filter flag to log all actions except SECCOMP_RET_ALLOW
Date: Thu, 3 Aug 2017 09:51:28 -0700
Message-ID: <CAGXu5jJ_1G0GoV_Gd4YKKO+v=hCwc=Y7NPrz1oHqYWguGJ5fZw@mail.gmail.com>
References: <1501275352-30045-1-git-send-email-tyhicks@canonical.com> <1501275352-30045-4-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501275352-30045-4-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, John Crispin <john@phrozen.org>, linux-audit@redhat.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 28, 2017 at 1:55 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> Add a new filter flag, SECCOMP_FILTER_FLAG_LOG, that enables logging for
> all actions except for SECCOMP_RET_ALLOW for the given filter.
>
> SECCOMP_RET_KILL actions are always logged, when "kill" is in the
> actions_logged sysctl, and SECCOMP_RET_ALLOW actions are never logged,
> regardless of this flag.
>
> This flag can be used to create noisy filters that result in all
> non-allowed actions to be logged. A process may have one noisy filter,
> which is loaded with this flag, as well as a quiet filter that's not
> loaded with this flag. This allows for the actions in a set of filters
> to be selectively conveyed to the admin.
>
> Since a system could have a large number of allocated seccomp_filter
> structs, struct packing was taken in consideration. On 64 bit x86, the
> new log member takes up one byte of an existing four byte hole in the
> struct. On 32 bit x86, the new log member creates a new four byte hole
> (unavoidable) and consumes one of those bytes.

Ah, good note about packing. I'll adjust my other patch to move into
the hole in 64-bit.

FWIW, I would have asked to extract the filter-assignment logic into a
separate patch (since it's a distinct logical piece), but since I've
already stolen it for the kill-process series, that's all done now. ;)
I think it's a good sign that both that and this need similar
functionality, so thank you for implementing that!

> Unfortunately, the tests added for SECCOMP_FILTER_FLAG_LOG are not
> capable of inspecting the audit log to verify that the actions taken in
> the filter were logged.

Strictly speaking, the test could probably do some horrible stuff to
access the kernel log, but yes, I'm fine with this just getting listed
in the test TODO.

>
> Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
> ---
>
> * Changes since v4:
>   - This is a new patch that allows the application to have a say in what gets
>     logged
>
>  include/linux/seccomp.h                       |  3 +-
>  include/uapi/linux/seccomp.h                  |  1 +
>  kernel/seccomp.c                              | 78 ++++++++++++++++-----------
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 66 +++++++++++++++++++++++
>  4 files changed, 116 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index ecc296c..c8bef43 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -3,7 +3,8 @@
>
>  #include <uapi/linux/seccomp.h>
>
> -#define SECCOMP_FILTER_FLAG_MASK       (SECCOMP_FILTER_FLAG_TSYNC)
> +#define SECCOMP_FILTER_FLAG_MASK       (SECCOMP_FILTER_FLAG_TSYNC | \
> +                                        SECCOMP_FILTER_FLAG_LOG)
>
>  #ifdef CONFIG_SECCOMP
>
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 0f238a4..82c823c 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -16,6 +16,7 @@
>
>  /* Valid flags for SECCOMP_SET_MODE_FILTER */
>  #define SECCOMP_FILTER_FLAG_TSYNC      1
> +#define SECCOMP_FILTER_FLAG_LOG                2

I can sort out the flag collision with ..._KILL_PROCESS.

>
>  /*
>   * All BPF programs must return a 32-bit value.
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 87257f2..1c4c496 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -44,6 +44,7 @@
>   *         get/put helpers should be used when accessing an instance
>   *         outside of a lifetime-guarded section.  In general, this
>   *         is only needed for handling filters shared across tasks.
> + * @log: true if all actions except for SECCOMP_RET_ALLOW should be logged
>   * @prev: points to a previously installed, or inherited, filter
>   * @prog: the BPF program to evaluate
>   *
> @@ -59,6 +60,7 @@
>   */
>  struct seccomp_filter {
>         refcount_t usage;
> +       bool log;
>         struct seccomp_filter *prev;
>         struct bpf_prog *prog;
>  };
> @@ -172,11 +174,14 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
>
>  /**
>   * seccomp_run_filters - evaluates all seccomp filters against @sd
> + * @filter: upon return, points to the matched filter but may be NULL in some
> + *          unexpected situations
>   * @sd: optional seccomp data to be passed to filters
>   *
>   * Returns valid seccomp BPF response codes.
>   */
> -static u32 seccomp_run_filters(const struct seccomp_data *sd)
> +static u32 seccomp_run_filters(struct seccomp_filter **filter,
> +                              const struct seccomp_data *sd)
>  {
>         struct seccomp_data sd_local;
>         u32 ret = SECCOMP_RET_ALLOW;
> @@ -184,6 +189,8 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd)
>         struct seccomp_filter *f =
>                         lockless_dereference(current->seccomp.filter);
>
> +       *filter = f;
> +
>         /* Ensure unexpected behavior doesn't result in failing open. */
>         if (unlikely(WARN_ON(f == NULL)))
>                 return SECCOMP_RET_KILL;
> @@ -200,8 +207,10 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd)
>         for (; f; f = f->prev) {
>                 u32 cur_ret = BPF_PROG_RUN(f->prog, sd);
>
> -               if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
> +               if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION)) {
>                         ret = cur_ret;
> +                       *filter = f;
> +               }
>         }
>         return ret;
>  }
> @@ -446,6 +455,9 @@ static long seccomp_attach_filter(unsigned int flags,
>                         return ret;
>         }
>
> +       if (flags & SECCOMP_FILTER_FLAG_LOG)
> +               filter->log = true;
> +
>         /*
>          * If there is an existing filter, make it the prev and don't drop its
>          * task reference.
> @@ -526,36 +538,39 @@ static void seccomp_send_sigsys(int syscall, int reason)
>  static u32 seccomp_actions_logged = SECCOMP_LOG_KILL  | SECCOMP_LOG_TRAP  |
>                                     SECCOMP_LOG_ERRNO | SECCOMP_LOG_TRACE;
>
> -static inline void seccomp_log(unsigned long syscall, long signr, u32 action)
> +static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
> +                              bool requested)
>  {
> -       bool log;
> +       if (requested) {
> +               bool log;
> +
> +               switch (action) {
> +               case SECCOMP_RET_TRAP:
> +                       log = seccomp_actions_logged & SECCOMP_LOG_TRAP;
> +                       break;
> +               case SECCOMP_RET_ERRNO:
> +                       log = seccomp_actions_logged & SECCOMP_LOG_ERRNO;
> +                       break;
> +               case SECCOMP_RET_TRACE:
> +                       log = seccomp_actions_logged & SECCOMP_LOG_TRACE;
> +                       break;
> +               case SECCOMP_RET_ALLOW:
> +                       log = false;
> +                       break;
> +               case SECCOMP_RET_KILL:
> +               default:
> +                       log = seccomp_actions_logged & SECCOMP_LOG_KILL;
> +               }
>
> -       switch (action) {
> -       case SECCOMP_RET_TRAP:
> -               log = seccomp_actions_logged & SECCOMP_LOG_TRAP;
> -               break;
> -       case SECCOMP_RET_ERRNO:
> -               log = seccomp_actions_logged & SECCOMP_LOG_ERRNO;
> -               break;
> -       case SECCOMP_RET_TRACE:
> -               log = seccomp_actions_logged & SECCOMP_LOG_TRACE;
> -               break;
> -       case SECCOMP_RET_ALLOW:
> -               log = false;
> -               break;
> -       case SECCOMP_RET_KILL:
> -       default:
> -               log = seccomp_actions_logged & SECCOMP_LOG_KILL;
> +               /*
> +                * Force an audit message to be emitted when the action is
> +                * allowed to be logged by the admin.
> +                */
> +               if (log)
> +                       return __audit_seccomp(syscall, signr, action);
>         }
>
>         /*
> -        * Force an audit message to be emitted when the action is allowed to
> -        * be logged by the admin.
> -        */
> -       if (log)
> -               return __audit_seccomp(syscall, signr, action);
> -
> -       /*
>          * Let the audit subsystem decide if the action should be audited based
>          * on whether the current task itself is being audited.
>          */
> @@ -587,7 +602,7 @@ static void __secure_computing_strict(int this_syscall)
>  #ifdef SECCOMP_DEBUG
>         dump_stack();
>  #endif
> -       seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL);
> +       seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL, true);

I had to read these patches a few times to convince myself that the
logic was correct for RET_KILL logging, etc. As it stands, I'd kind of
like to rearrange the checks in seccomp_log() so the action stays at
the top-level, so it's slightly easier to scan for the logic of how an
action is logged. For example:

       bool log = false;

       switch (action) {
       case SECCOMP_RET_ALLOW:
               break;
       case SECCOMP_RET_TRAP:
               log = requested && seccomp_actions_logged & SECCOMP_LOG_TRAP;
               break;
       case SECCOMP_RET_ERRNO:
               log = requested && seccomp_actions_logged & SECCOMP_LOG_ERRNO;
               break;
       case SECCOMP_RET_TRACE:
               log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
               break;       case SECCOMP_RET_KILL:
       default:
               log = seccomp_actions_logged & SECCOMP_LOG_KILL;

i.e. ALLOW and KILL are clear about how they're special. ALLOW is
never logged, and KILL is only logged if admin wants it (which is the
default sysctl value).



>         do_exit(SIGKILL);
>  }
>
> @@ -613,6 +628,7 @@ void secure_computing_strict(int this_syscall)
>  static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>                             const bool recheck_after_trace)
>  {
> +       struct seccomp_filter *filter;

Out of paranoia I set this to NULL by default in the extracted
filter-assignment patch.

>         u32 filter_ret, action;
>         int data;
>
> @@ -622,7 +638,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>          */
>         rmb();
>
> -       filter_ret = seccomp_run_filters(sd);
> +       filter_ret = seccomp_run_filters(&filter, sd);
>         data = filter_ret & SECCOMP_RET_DATA;
>         action = filter_ret & SECCOMP_RET_ACTION;
>
> @@ -690,7 +706,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>
>         case SECCOMP_RET_KILL:
>         default:
> -               seccomp_log(this_syscall, SIGSYS, action);
> +               seccomp_log(this_syscall, SIGSYS, action, true);
>                 /* Dump core only if this is the last remaining thread. */
>                 if (get_nr_threads(current) == 1) {
>                         siginfo_t info;
> @@ -707,7 +723,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>         unreachable();
>
>  skip:
> -       seccomp_log(this_syscall, 0, action);
> +       seccomp_log(this_syscall, 0, action, filter ? filter->log : false);

Yes, thanks for the double-check on the filter being non-NULL! :)

>         return -1;
>  }
>  #else
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index 73f5ea6..eeb4f7a 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -1687,6 +1687,10 @@ TEST_F_SIGNAL(TRACE_syscall, kill_after_ptrace, SIGSYS)
>  #define SECCOMP_FILTER_FLAG_TSYNC 1
>  #endif
>
> +#ifndef SECCOMP_FILTER_FLAG_LOG
> +#define SECCOMP_FILTER_FLAG_LOG 2
> +#endif
> +
>  #ifndef seccomp
>  int seccomp(unsigned int op, unsigned int flags, void *args)
>  {
> @@ -2421,6 +2425,67 @@ TEST(syscall_restart)
>                 _metadata->passed = 0;
>  }
>
> +TEST_SIGNAL(filter_flag_log, SIGSYS)
> +{
> +       struct sock_filter allow_filter[] = {
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
> +       };
> +       struct sock_filter kill_filter[] = {
> +               BPF_STMT(BPF_LD|BPF_W|BPF_ABS,
> +                       offsetof(struct seccomp_data, nr)),
> +               BPF_JUMP(BPF_JMP|BPF_JEQ|BPF_K, __NR_getpid, 0, 1),
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_KILL),
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
> +       };
> +       struct sock_fprog allow_prog = {
> +               .len = (unsigned short)ARRAY_SIZE(allow_filter),
> +               .filter = allow_filter,
> +       };
> +       struct sock_fprog kill_prog = {
> +               .len = (unsigned short)ARRAY_SIZE(kill_filter),
> +               .filter = kill_filter,
> +       };
> +       long ret;
> +       pid_t parent = getppid();
> +
> +       ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
> +       ASSERT_EQ(0, ret);
> +
> +       /* Verify that the FILTER_FLAG_LOG flag isn't accepted in strict mode */
> +       ret = seccomp(SECCOMP_SET_MODE_STRICT, SECCOMP_FILTER_FLAG_LOG,
> +                     &allow_prog);
> +       ASSERT_NE(ENOSYS, errno) {
> +               TH_LOG("Kernel does not support seccomp syscall!");
> +       }
> +       EXPECT_NE(0, ret) {
> +               TH_LOG("Kernel accepted FILTER_FLAG_LOG flag in strict mode!");
> +       }
> +       EXPECT_EQ(EINVAL, errno) {
> +               TH_LOG("Kernel returned unexpected errno for FILTER_FLAG_LOG flag in strict mode!");
> +       }
> +
> +       /* Verify that a simple, permissive filter can be added with no flags */
> +       ret = seccomp(SECCOMP_SET_MODE_FILTER, 0, &allow_prog);
> +       EXPECT_EQ(0, ret);
> +
> +       /* See if the same filter can be added with the FILTER_FLAG_LOG flag */
> +       ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG,
> +                     &allow_prog);
> +       ASSERT_NE(EINVAL, errno) {
> +               TH_LOG("Kernel does not support the FILTER_FLAG_LOG flag!");
> +       }
> +       EXPECT_EQ(0, ret);
> +
> +       /* Ensure that the kill filter works with the FILTER_FLAG_LOG flag */
> +       ret = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_LOG,
> +                     &kill_prog);
> +       EXPECT_EQ(0, ret);
> +
> +       EXPECT_EQ(parent, syscall(__NR_getppid));
> +       /* getpid() should never return. */
> +       EXPECT_EQ(0, syscall(__NR_getpid));
> +}
> +
>  /*
>   * TODO:
>   * - add microbenchmarks
> @@ -2429,6 +2494,7 @@ TEST(syscall_restart)
>   * - endianness checking when appropriate
>   * - 64-bit arg prodding
>   * - arch value testing (x86 modes especially)
> + * - verify that FILTER_FLAG_LOG filters generate log messages
>   * - ...
>   */
>
> --
> 2.7.4
>

Test looks good, thanks!

-Kees

-- 
Kees Cook
Pixel Security
