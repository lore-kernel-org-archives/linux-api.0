From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v10 3/4] seccomp: add a return code to trap to userspace
Date: Tue, 11 Dec 2018 16:46:12 -0800
Message-ID: <CAGXu5jLGFfRPiHpgPiPYJx6XSuQe=b88A+oPv5sAeP7KGq6bww@mail.gmail.com>
References: <20181209182414.30862-1-tycho@tycho.ws> <20181209182414.30862-4-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181209182414.30862-4-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, Jann Horn <jannh@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, Dec 9, 2018 at 10:24 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> This patch introduces a means for syscalls matched in seccomp to notify
> some other task that a particular filter has been triggered.
>
> The motivation for this is primarily for use with containers. For example,
> if a container does an init_module(), we obviously don't want to load this
> untrusted code, which may be compiled for the wrong version of the kernel
> anyway. Instead, we could parse the module image, figure out which module
> the container is trying to load and load it on the host.
>
> As another example, containers cannot mount() in general since various
> filesystems assume a trusted image. However, if an orchestrator knows that
> e.g. a particular block device has not been exposed to a container for
> writing, it want to allow the container to mount that block device (that
> is, handle the mount for it).
>
> This patch adds functionality that is already possible via at least two
> other means that I know about, both of which involve ptrace(): first, one
> could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> Unfortunately this is slow, so a faster version would be to install a
> filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> Since ptrace allows only one tracer, if the container runtime is that
> tracer, users inside the container (or outside) trying to debug it will not
> be able to use ptrace, which is annoying. It also means that older
> distributions based on Upstart cannot boot inside containers using ptrace,
> since upstart itself uses ptrace to monitor services while starting.
>
> The actual implementation of this is fairly small, although getting the
> synchronization right was/is slightly complex.
>
> Finally, it's worth noting that the classic seccomp TOCTOU of reading
> memory data from the task still applies here, but can be avoided with
> careful design of the userspace handler: if the userspace handler reads all
> of the task memory that is necessary before applying its security policy,
> the tracee's subsequent memory edits will not be read by the tracer.
>
> Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> CC: Kees Cook <keescook@chromium.org>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: "Serge E. Hallyn" <serge@hallyn.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> CC: Christian Brauner <christian@brauner.io>
> CC: Tyler Hicks <tyhicks@canonical.com>
> CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>

This takes care of everything I mentioned (and has incorporated LOTS
of people's suggestions), so I think it's ready for -next. I've
applied this and am doing local testing now.

Thanks for keeping with this!

-Kees

> ---
> v2: * make id a u64; the idea here being that it will never overflow,
>       because 64 is huge (one syscall every nanosecond => wrap every 584
>       years) (Andy)
>     * prevent nesting of user notifications: if someone is already attached
>       the tree in one place, nobody else can attach to the tree (Andy)
>     * notify the listener of signals the tracee receives as well (Andy)
>     * implement poll
> v3: * lockdep fix (Oleg)
>     * drop unnecessary WARN()s (Christian)
>     * rearrange error returns to be more rpetty (Christian)
>     * fix build in !CONFIG_SECCOMP_USER_NOTIFICATION case
> v4: * fix implementation of poll to use poll_wait() (Jann)
>     * change listener's fd flags to be 0 (Jann)
>     * hoist filter initialization out of ifdefs to its own function
>       init_user_notification()
>     * add some more testing around poll() and closing the listener while a
>       syscall is in action
>     * s/GET_LISTENER/NEW_LISTENER, since you can't _get_ a listener, but it
>       creates a new one (Matthew)
>     * correctly handle pid namespaces, add some testcases (Matthew)
>     * use EINPROGRESS instead of EINVAL when a notification response is
>       written twice (Matthew)
>     * fix comment typo from older version (SEND vs READ) (Matthew)
>     * whitespace and logic simplification (Tobin)
>     * add some Documentation/ bits on userspace trapping
> v5: * fix documentation typos (Jann)
>     * add signalled field to struct seccomp_notif (Jann)
>     * switch to using ioctls instead of read()/write() for struct passing
>       (Jann)
>     * add an ioctl to ensure an id is still valid
> v6: * docs typo fixes, update docs for ioctl() change (Christian)
> v7: * switch struct seccomp_knotif's id member to a u64 (derp :)
>     * use notify_lock in IS_ID_VALID query to avoid racing
>     * s/signalled/signaled (Tyler)
>     * fix docs to reflect that ids are not globally unique (Tyler)
>     * add a test to check -ERESTARTSYS behavior (Tyler)
>     * drop CONFIG_SECCOMP_USER_NOTIFICATION (Tyler)
>     * reorder USER_NOTIF in seccomp return codes list (Tyler)
>     * return size instead of sizeof(struct user_notif) (Tyler)
>     * ENOENT instead of EINVAL when invalid id is passed (Tyler)
>     * drop CONFIG_SECCOMP_USER_NOTIFICATION guards (Tyler)
>     * s/IS_ID_VALID/ID_VALID and switch ioctl to be "well behaved" (Tyler)
>     * add a new struct notification to minimize the additions to
>       struct seccomp_filter, also pack the necessary additions a bit more
>       cleverly (Tyler)
>     * switch to keeping track of the task itself instead of the pid (we'll
>       use this for implementing PUT_FD)
> v8: * in recv, don't copy_to_user() while holding notify lock, in case
>       userfaultfd blocks and causes all syscalls to block (Kees)
>     * switch ioctl character to something more fun ! (Kees)
>     * switch ioctl defines to use their own SECCOMP_IO* macros (Kees)
>     * rename seccomp ioctls to be SECCOMP_IOCTL_* (Kees)
>     * move comment of notify_lock to the right place (Jann)
>     * drop comment abount reference count bounding in __get_seccomp_filter (Jann)
>     * add lockdep_assert_held() in seccomp_next_notify_id() (Kees)
>     * in seccomp_do_user_notification(), always increment semaphore before
>       releasing lock, to prevent use after free of ->notif (Kees)
>     * add another wake_up_poll() when a signal is received (Jann)
>     * make all listener fds O_CLOEXEC (Jann/Kees)
>     * use memset() instead of = {} initialization for structures (Kees)
>     * move casting of buf pointer to ioctl, instead of in handler functions (Kees)
>     * fix ENOENT testing in seccomp_notify_send() (Jann)
>     * use ENOENT instead of -1 (EPERM) for ID_VALID ioctl (Jann)
>     * use ()s around "nested" bit operations (Kees)
>     * init struct notification members in the order they're declared (Jann)
>     * rearrange things so no forward declaration of init_listener() is
>       required (Kees)
>     * switch to a flags based future-proofing mechanism for struct
>       seccomp_notif and seccomp_notif_resp, thus avoiding version issues
>       with structure length (Kees)
>     * fix a memory leak in init_listener() in a failure case
>     * fix a use-after-free of filter->notif in do_user_notification() when
>       the listener fd is closed after a signal is sent
>     * add a comment about semaphore state in the interrupt case in
>       do_user_notification() + seccomp_notify_recv()
> v9: * add SECCOMP_GET_NOTIF_SIZES to handle when struct seccomp_data
>       changes in size
>     * don't do locking all the way up the seccomp tree (Oleg)
>     * rearrange the tests so that one test tests one thing
>     * avoid an unkillable sleep by dropping the signaled flag (Oleg)
> ---
>  Documentation/ioctl/ioctl-number.txt          |   1 +
>  .../userspace-api/seccomp_filter.rst          |  84 ++++
>  include/linux/seccomp.h                       |   7 +-
>  include/uapi/linux/seccomp.h                  |  40 +-
>  kernel/seccomp.c                              | 448 +++++++++++++++++-
>  tools/testing/selftests/seccomp/seccomp_bpf.c | 447 ++++++++++++++++-
>  6 files changed, 1017 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
> index af6f6ba1fe80..c9558146ac58 100644
> --- a/Documentation/ioctl/ioctl-number.txt
> +++ b/Documentation/ioctl/ioctl-number.txt
> @@ -79,6 +79,7 @@ Code  Seq#(hex)       Include File            Comments
>  0x1b   all     InfiniBand Subsystem    <http://infiniband.sourceforge.net/>
>  0x20   all     drivers/cdrom/cm206.h
>  0x22   all     scsi/sg.h
> +'!'    00-1F   uapi/linux/seccomp.h
>  '#'    00-3F   IEEE 1394 Subsystem     Block for the entire subsystem
>  '$'    00-0F   linux/perf_counter.h, linux/perf_event.h
>  '%'    00-0F   include/uapi/linux/stm.h
> diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
> index 82a468bc7560..b1b846d8a094 100644
> --- a/Documentation/userspace-api/seccomp_filter.rst
> +++ b/Documentation/userspace-api/seccomp_filter.rst
> @@ -122,6 +122,11 @@ In precedence order, they are:
>         Results in the lower 16-bits of the return value being passed
>         to userland as the errno without executing the system call.
>
> +``SECCOMP_RET_USER_NOTIF``:
> +    Results in a ``struct seccomp_notif`` message sent on the userspace
> +    notification fd, if it is attached, or ``-ENOSYS`` if it is not. See below
> +    on discussion of how to handle user notifications.
> +
>  ``SECCOMP_RET_TRACE``:
>         When returned, this value will cause the kernel to attempt to
>         notify a ``ptrace()``-based tracer prior to executing the system
> @@ -183,6 +188,85 @@ The ``samples/seccomp/`` directory contains both an x86-specific example
>  and a more generic example of a higher level macro interface for BPF
>  program generation.
>
> +Userspace Notification
> +======================
> +
> +The ``SECCOMP_RET_USER_NOTIF`` return code lets seccomp filters pass a
> +particular syscall to userspace to be handled. This may be useful for
> +applications like container managers, which wish to intercept particular
> +syscalls (``mount()``, ``finit_module()``, etc.) and change their behavior.
> +
> +To acquire a notification FD, use the ``SECCOMP_FILTER_FLAG_NEW_LISTENER``
> +argument to the ``seccomp()`` syscall:
> +
> +.. code-block:: c
> +
> +    fd = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_NEW_LISTENER, &prog);
> +
> +which (on success) will return a listener fd for the filter, which can then be
> +passed around via ``SCM_RIGHTS`` or similar. Note that filter fds correspond to
> +a particular filter, and not a particular task. So if this task then forks,
> +notifications from both tasks will appear on the same filter fd. Reads and
> +writes to/from a filter fd are also synchronized, so a filter fd can safely
> +have many readers.
> +
> +The interface for a seccomp notification fd consists of two structures:
> +
> +.. code-block:: c
> +
> +    struct seccomp_notif_sizes {
> +        __u16 seccomp_notif;
> +        __u16 seccomp_notif_resp;
> +        __u16 seccomp_data;
> +    };
> +
> +    struct seccomp_notif {
> +        __u64 id;
> +        __u32 pid;
> +        __u32 flags;
> +        struct seccomp_data data;
> +    };
> +
> +    struct seccomp_notif_resp {
> +        __u64 id;
> +        __s64 val;
> +        __s32 error;
> +        __u32 flags;
> +    };
> +
> +The ``struct seccomp_notif_sizes`` structure can be used to determine the size
> +of the various structures used in seccomp notifications. The size of ``struct
> +seccomp_data`` may change in the future, so code should use:
> +
> +.. code-block:: c
> +
> +    struct seccomp_notif_sizes sizes;
> +    seccomp(SECCOMP_GET_NOTIF_SIZES, 0, &sizes);
> +
> +to determine the size of the various structures to allocate. See
> +samples/seccomp/user-trap.c for an example.
> +
> +Users can read via ``ioctl(SECCOMP_IOCTL_NOTIF_RECV)``  (or ``poll()``) on a
> +seccomp notification fd to receive a ``struct seccomp_notif``, which contains
> +five members: the input length of the structure, a unique-per-filter ``id``,
> +the ``pid`` of the task which triggered this request (which may be 0 if the
> +task is in a pid ns not visible from the listener's pid namespace), a ``flags``
> +member which for now only has ``SECCOMP_NOTIF_FLAG_SIGNALED``, representing
> +whether or not the notification is a result of a non-fatal signal, and the
> +``data`` passed to seccomp. Userspace can then make a decision based on this
> +information about what to do, and ``ioctl(SECCOMP_IOCTL_NOTIF_SEND)`` a
> +response, indicating what should be returned to userspace. The ``id`` member of
> +``struct seccomp_notif_resp`` should be the same ``id`` as in ``struct
> +seccomp_notif``.
> +
> +It is worth noting that ``struct seccomp_data`` contains the values of register
> +arguments to the syscall, but does not contain pointers to memory. The task's
> +memory is accessible to suitably privileged traces via ``ptrace()`` or
> +``/proc/pid/mem``. However, care should be taken to avoid the TOCTOU mentioned
> +above in this document: all arguments being read from the tracee's memory
> +should be read into the tracer's memory before any policy decisions are made.
> +This allows for an atomic decision on syscall arguments.
> +
>  Sysctls
>  =======
>
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index b5103c019cf4..84868d37b35d 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -4,9 +4,10 @@
>
>  #include <uapi/linux/seccomp.h>
>
> -#define SECCOMP_FILTER_FLAG_MASK       (SECCOMP_FILTER_FLAG_TSYNC      | \
> -                                        SECCOMP_FILTER_FLAG_LOG        | \
> -                                        SECCOMP_FILTER_FLAG_SPEC_ALLOW)
> +#define SECCOMP_FILTER_FLAG_MASK       (SECCOMP_FILTER_FLAG_TSYNC | \
> +                                        SECCOMP_FILTER_FLAG_LOG | \
> +                                        SECCOMP_FILTER_FLAG_SPEC_ALLOW | \
> +                                        SECCOMP_FILTER_FLAG_NEW_LISTENER)
>
>  #ifdef CONFIG_SECCOMP
>
> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> index 9efc0e73d50b..90734aa5aa36 100644
> --- a/include/uapi/linux/seccomp.h
> +++ b/include/uapi/linux/seccomp.h
> @@ -15,11 +15,13 @@
>  #define SECCOMP_SET_MODE_STRICT                0
>  #define SECCOMP_SET_MODE_FILTER                1
>  #define SECCOMP_GET_ACTION_AVAIL       2
> +#define SECCOMP_GET_NOTIF_SIZES                3
>
>  /* Valid flags for SECCOMP_SET_MODE_FILTER */
> -#define SECCOMP_FILTER_FLAG_TSYNC      (1UL << 0)
> -#define SECCOMP_FILTER_FLAG_LOG                (1UL << 1)
> -#define SECCOMP_FILTER_FLAG_SPEC_ALLOW (1UL << 2)
> +#define SECCOMP_FILTER_FLAG_TSYNC              (1UL << 0)
> +#define SECCOMP_FILTER_FLAG_LOG                        (1UL << 1)
> +#define SECCOMP_FILTER_FLAG_SPEC_ALLOW         (1UL << 2)
> +#define SECCOMP_FILTER_FLAG_NEW_LISTENER       (1UL << 3)
>
>  /*
>   * All BPF programs must return a 32-bit value.
> @@ -35,6 +37,7 @@
>  #define SECCOMP_RET_KILL        SECCOMP_RET_KILL_THREAD
>  #define SECCOMP_RET_TRAP        0x00030000U /* disallow and force a SIGSYS */
>  #define SECCOMP_RET_ERRNO       0x00050000U /* returns an errno */
> +#define SECCOMP_RET_USER_NOTIF  0x7fc00000U /* notifies userspace */
>  #define SECCOMP_RET_TRACE       0x7ff00000U /* pass to a tracer or disallow */
>  #define SECCOMP_RET_LOG                 0x7ffc0000U /* allow after logging */
>  #define SECCOMP_RET_ALLOW       0x7fff0000U /* allow */
> @@ -60,4 +63,35 @@ struct seccomp_data {
>         __u64 args[6];
>  };
>
> +struct seccomp_notif_sizes {
> +       __u16 seccomp_notif;
> +       __u16 seccomp_notif_resp;
> +       __u16 seccomp_data;
> +};
> +
> +struct seccomp_notif {
> +       __u64 id;
> +       __u32 pid;
> +       __u32 flags;
> +       struct seccomp_data data;
> +};
> +
> +struct seccomp_notif_resp {
> +       __u64 id;
> +       __s64 val;
> +       __s32 error;
> +       __u32 flags;
> +};
> +
> +#define SECCOMP_IOC_MAGIC              '!'
> +#define SECCOMP_IO(nr)                 _IO(SECCOMP_IOC_MAGIC, nr)
> +#define SECCOMP_IOR(nr, type)          _IOR(SECCOMP_IOC_MAGIC, nr, type)
> +#define SECCOMP_IOW(nr, type)          _IOW(SECCOMP_IOC_MAGIC, nr, type)
> +#define SECCOMP_IOWR(nr, type)         _IOWR(SECCOMP_IOC_MAGIC, nr, type)
> +
> +/* Flags for seccomp notification fd ioctl. */
> +#define SECCOMP_IOCTL_NOTIF_RECV       SECCOMP_IOWR(0, struct seccomp_notif)
> +#define SECCOMP_IOCTL_NOTIF_SEND       SECCOMP_IOWR(1, \
> +                                               struct seccomp_notif_resp)
> +#define SECCOMP_IOCTL_NOTIF_ID_VALID   SECCOMP_IOR(2, __u64)
>  #endif /* _UAPI_LINUX_SECCOMP_H */
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 393e029f778a..15b6be97fc09 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -33,12 +33,74 @@
>  #endif
>
>  #ifdef CONFIG_SECCOMP_FILTER
> +#include <linux/file.h>
>  #include <linux/filter.h>
>  #include <linux/pid.h>
>  #include <linux/ptrace.h>
>  #include <linux/security.h>
>  #include <linux/tracehook.h>
>  #include <linux/uaccess.h>
> +#include <linux/anon_inodes.h>
> +
> +enum notify_state {
> +       SECCOMP_NOTIFY_INIT,
> +       SECCOMP_NOTIFY_SENT,
> +       SECCOMP_NOTIFY_REPLIED,
> +};
> +
> +struct seccomp_knotif {
> +       /* The struct pid of the task whose filter triggered the notification */
> +       struct task_struct *task;
> +
> +       /* The "cookie" for this request; this is unique for this filter. */
> +       u64 id;
> +
> +       /*
> +        * The seccomp data. This pointer is valid the entire time this
> +        * notification is active, since it comes from __seccomp_filter which
> +        * eclipses the entire lifecycle here.
> +        */
> +       const struct seccomp_data *data;
> +
> +       /*
> +        * Notification states. When SECCOMP_RET_USER_NOTIF is returned, a
> +        * struct seccomp_knotif is created and starts out in INIT. Once the
> +        * handler reads the notification off of an FD, it transitions to SENT.
> +        * If a signal is received the state transitions back to INIT and
> +        * another message is sent. When the userspace handler replies, state
> +        * transitions to REPLIED.
> +        */
> +       enum notify_state state;
> +
> +       /* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
> +       int error;
> +       long val;
> +
> +       /* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
> +       struct completion ready;
> +
> +       struct list_head list;
> +};
> +
> +/**
> + * struct notification - container for seccomp userspace notifications. Since
> + * most seccomp filters will not have notification listeners attached and this
> + * structure is fairly large, we store the notification-specific stuff in a
> + * separate structure.
> + *
> + * @request: A semaphore that users of this notification can wait on for
> + *           changes. Actual reads and writes are still controlled with
> + *           filter->notify_lock.
> + * @next_id: The id of the next request.
> + * @notifications: A list of struct seccomp_knotif elements.
> + * @wqh: A wait queue for poll.
> + */
> +struct notification {
> +       struct semaphore request;
> +       u64 next_id;
> +       struct list_head notifications;
> +       wait_queue_head_t wqh;
> +};
>
>  /**
>   * struct seccomp_filter - container for seccomp BPF programs
> @@ -50,6 +112,8 @@
>   * @log: true if all actions except for SECCOMP_RET_ALLOW should be logged
>   * @prev: points to a previously installed, or inherited, filter
>   * @prog: the BPF program to evaluate
> + * @notif: the struct that holds all notification related information
> + * @notify_lock: A lock for all notification-related accesses.
>   *
>   * seccomp_filter objects are organized in a tree linked via the @prev
>   * pointer.  For any task, it appears to be a singly-linked list starting
> @@ -66,6 +130,8 @@ struct seccomp_filter {
>         bool log;
>         struct seccomp_filter *prev;
>         struct bpf_prog *prog;
> +       struct notification *notif;
> +       struct mutex notify_lock;
>  };
>
>  /* Limit any path through the tree to 256KB worth of instructions. */
> @@ -386,6 +452,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
>         if (!sfilter)
>                 return ERR_PTR(-ENOMEM);
>
> +       mutex_init(&sfilter->notify_lock);
>         ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
>                                         seccomp_check_filter, save_orig);
>         if (ret < 0) {
> @@ -479,7 +546,6 @@ static long seccomp_attach_filter(unsigned int flags,
>
>  static void __get_seccomp_filter(struct seccomp_filter *filter)
>  {
> -       /* Reference count is bounded by the number of total processes. */
>         refcount_inc(&filter->usage);
>  }
>
> @@ -550,11 +616,13 @@ static void seccomp_send_sigsys(int syscall, int reason)
>  #define SECCOMP_LOG_TRACE              (1 << 4)
>  #define SECCOMP_LOG_LOG                        (1 << 5)
>  #define SECCOMP_LOG_ALLOW              (1 << 6)
> +#define SECCOMP_LOG_USER_NOTIF         (1 << 7)
>
>  static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_PROCESS |
>                                     SECCOMP_LOG_KILL_THREAD  |
>                                     SECCOMP_LOG_TRAP  |
>                                     SECCOMP_LOG_ERRNO |
> +                                   SECCOMP_LOG_USER_NOTIF |
>                                     SECCOMP_LOG_TRACE |
>                                     SECCOMP_LOG_LOG;
>
> @@ -575,6 +643,9 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
>         case SECCOMP_RET_TRACE:
>                 log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
>                 break;
> +       case SECCOMP_RET_USER_NOTIF:
> +               log = requested && seccomp_actions_logged & SECCOMP_LOG_USER_NOTIF;
> +               break;
>         case SECCOMP_RET_LOG:
>                 log = seccomp_actions_logged & SECCOMP_LOG_LOG;
>                 break;
> @@ -646,6 +717,68 @@ void secure_computing_strict(int this_syscall)
>  #else
>
>  #ifdef CONFIG_SECCOMP_FILTER
> +static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
> +{
> +       /*
> +        * Note: overflow is ok here, the id just needs to be unique per
> +        * filter.
> +        */
> +       lockdep_assert_held(&filter->notify_lock);
> +       return filter->notif->next_id++;
> +}
> +
> +static void seccomp_do_user_notification(int this_syscall,
> +                                        struct seccomp_filter *match,
> +                                        const struct seccomp_data *sd)
> +{
> +       int err;
> +       long ret = 0;
> +       struct seccomp_knotif n = {};
> +
> +       mutex_lock(&match->notify_lock);
> +       err = -ENOSYS;
> +       if (!match->notif)
> +               goto out;
> +
> +       n.task = current;
> +       n.state = SECCOMP_NOTIFY_INIT;
> +       n.data = sd;
> +       n.id = seccomp_next_notify_id(match);
> +       init_completion(&n.ready);
> +       list_add(&n.list, &match->notif->notifications);
> +
> +       up(&match->notif->request);
> +       wake_up_poll(&match->notif->wqh, EPOLLIN | EPOLLRDNORM);
> +       mutex_unlock(&match->notify_lock);
> +
> +       /*
> +        * This is where we wait for a reply from userspace.
> +        */
> +       err = wait_for_completion_interruptible(&n.ready);
> +       mutex_lock(&match->notify_lock);
> +       if (err == 0) {
> +               ret = n.val;
> +               err = n.error;
> +       }
> +
> +       /*
> +        * Note that it's possible the listener died in between the time when
> +        * we were notified of a respons (or a signal) and when we were able to
> +        * re-acquire the lock, so only delete from the list if the
> +        * notification actually exists.
> +        *
> +        * Also note that this test is only valid because there's no way to
> +        * *reattach* to a notifier right now. If one is added, we'll need to
> +        * keep track of the notif itself and make sure they match here.
> +        */
> +       if (match->notif)
> +               list_del(&n.list);
> +out:
> +       mutex_unlock(&match->notify_lock);
> +       syscall_set_return_value(current, task_pt_regs(current),
> +                                err, ret);
> +}
> +
>  static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>                             const bool recheck_after_trace)
>  {
> @@ -728,6 +861,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>
>                 return 0;
>
> +       case SECCOMP_RET_USER_NOTIF:
> +               seccomp_do_user_notification(this_syscall, match, sd);
> +               goto skip;
> +
>         case SECCOMP_RET_LOG:
>                 seccomp_log(this_syscall, 0, action, true);
>                 return 0;
> @@ -834,6 +971,263 @@ static long seccomp_set_mode_strict(void)
>  }
>
>  #ifdef CONFIG_SECCOMP_FILTER
> +static int seccomp_notify_release(struct inode *inode, struct file *file)
> +{
> +       struct seccomp_filter *filter = file->private_data;
> +       struct seccomp_knotif *knotif;
> +
> +       mutex_lock(&filter->notify_lock);
> +
> +       /*
> +        * If this file is being closed because e.g. the task who owned it
> +        * died, let's wake everyone up who was waiting on us.
> +        */
> +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> +               if (knotif->state == SECCOMP_NOTIFY_REPLIED)
> +                       continue;
> +
> +               knotif->state = SECCOMP_NOTIFY_REPLIED;
> +               knotif->error = -ENOSYS;
> +               knotif->val = 0;
> +
> +               complete(&knotif->ready);
> +       }
> +
> +       kfree(filter->notif);
> +       filter->notif = NULL;
> +       mutex_unlock(&filter->notify_lock);
> +       __put_seccomp_filter(filter);
> +       return 0;
> +}
> +
> +static long seccomp_notify_recv(struct seccomp_filter *filter,
> +                               void __user *buf)
> +{
> +       struct seccomp_knotif *knotif = NULL, *cur;
> +       struct seccomp_notif unotif;
> +       ssize_t ret;
> +
> +       memset(&unotif, 0, sizeof(unotif));
> +
> +       ret = down_interruptible(&filter->notif->request);
> +       if (ret < 0)
> +               return ret;
> +
> +       mutex_lock(&filter->notify_lock);
> +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> +               if (cur->state == SECCOMP_NOTIFY_INIT) {
> +                       knotif = cur;
> +                       break;
> +               }
> +       }
> +
> +       /*
> +        * If we didn't find a notification, it could be that the task was
> +        * interrupted by a fatal signal between the time we were woken and
> +        * when we were able to acquire the rw lock.
> +        */
> +       if (!knotif) {
> +               ret = -ENOENT;
> +               goto out;
> +       }
> +
> +       unotif.id = knotif->id;
> +       unotif.pid = task_pid_vnr(knotif->task);
> +       unotif.data = *(knotif->data);
> +
> +       knotif->state = SECCOMP_NOTIFY_SENT;
> +       wake_up_poll(&filter->notif->wqh, EPOLLOUT | EPOLLWRNORM);
> +       ret = 0;
> +out:
> +       mutex_unlock(&filter->notify_lock);
> +
> +       if (ret == 0 && copy_to_user(buf, &unotif, sizeof(unotif))) {
> +               ret = -EFAULT;
> +
> +               /*
> +                * Userspace screwed up. To make sure that we keep this
> +                * notification alive, let's reset it back to INIT. It
> +                * may have died when we released the lock, so we need to make
> +                * sure it's still around.
> +                */
> +               knotif = NULL;
> +               mutex_lock(&filter->notify_lock);
> +               list_for_each_entry(cur, &filter->notif->notifications, list) {
> +                       if (cur->id == unotif.id) {
> +                               knotif = cur;
> +                               break;
> +                       }
> +               }
> +
> +               if (knotif) {
> +                       knotif->state = SECCOMP_NOTIFY_INIT;
> +                       up(&filter->notif->request);
> +               }
> +               mutex_unlock(&filter->notify_lock);
> +       }
> +
> +       return ret;
> +}
> +
> +static long seccomp_notify_send(struct seccomp_filter *filter,
> +                               void __user *buf)
> +{
> +       struct seccomp_notif_resp resp = {};
> +       struct seccomp_knotif *knotif = NULL, *cur;
> +       long ret;
> +
> +       if (copy_from_user(&resp, buf, sizeof(resp)))
> +               return -EFAULT;
> +
> +       if (resp.flags)
> +               return -EINVAL;
> +
> +       ret = mutex_lock_interruptible(&filter->notify_lock);
> +       if (ret < 0)
> +               return ret;
> +
> +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> +               if (cur->id == resp.id) {
> +                       knotif = cur;
> +                       break;
> +               }
> +       }
> +
> +       if (!knotif) {
> +               ret = -ENOENT;
> +               goto out;
> +       }
> +
> +       /* Allow exactly one reply. */
> +       if (knotif->state != SECCOMP_NOTIFY_SENT) {
> +               ret = -EINPROGRESS;
> +               goto out;
> +       }
> +
> +       ret = 0;
> +       knotif->state = SECCOMP_NOTIFY_REPLIED;
> +       knotif->error = resp.error;
> +       knotif->val = resp.val;
> +       complete(&knotif->ready);
> +out:
> +       mutex_unlock(&filter->notify_lock);
> +       return ret;
> +}
> +
> +static long seccomp_notify_id_valid(struct seccomp_filter *filter,
> +                                   void __user *buf)
> +{
> +       struct seccomp_knotif *knotif = NULL;
> +       u64 id;
> +       long ret;
> +
> +       if (copy_from_user(&id, buf, sizeof(id)))
> +               return -EFAULT;
> +
> +       ret = mutex_lock_interruptible(&filter->notify_lock);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = -ENOENT;
> +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> +               if (knotif->id == id) {
> +                       if (knotif->state == SECCOMP_NOTIFY_SENT)
> +                               ret = 0;
> +                       goto out;
> +               }
> +       }
> +
> +out:
> +       mutex_unlock(&filter->notify_lock);
> +       return ret;
> +}
> +
> +static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> +                                unsigned long arg)
> +{
> +       struct seccomp_filter *filter = file->private_data;
> +       void __user *buf = (void __user *)arg;
> +
> +       switch (cmd) {
> +       case SECCOMP_IOCTL_NOTIF_RECV:
> +               return seccomp_notify_recv(filter, buf);
> +       case SECCOMP_IOCTL_NOTIF_SEND:
> +               return seccomp_notify_send(filter, buf);
> +       case SECCOMP_IOCTL_NOTIF_ID_VALID:
> +               return seccomp_notify_id_valid(filter, buf);
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static __poll_t seccomp_notify_poll(struct file *file,
> +                                   struct poll_table_struct *poll_tab)
> +{
> +       struct seccomp_filter *filter = file->private_data;
> +       __poll_t ret = 0;
> +       struct seccomp_knotif *cur;
> +
> +       poll_wait(file, &filter->notif->wqh, poll_tab);
> +
> +       ret = mutex_lock_interruptible(&filter->notify_lock);
> +       if (ret < 0)
> +               return EPOLLERR;
> +
> +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> +               if (cur->state == SECCOMP_NOTIFY_INIT)
> +                       ret |= EPOLLIN | EPOLLRDNORM;
> +               if (cur->state == SECCOMP_NOTIFY_SENT)
> +                       ret |= EPOLLOUT | EPOLLWRNORM;
> +               if ((ret & EPOLLIN) && (ret & EPOLLOUT))
> +                       break;
> +       }
> +
> +       mutex_unlock(&filter->notify_lock);
> +
> +       return ret;
> +}
> +
> +static const struct file_operations seccomp_notify_ops = {
> +       .poll = seccomp_notify_poll,
> +       .release = seccomp_notify_release,
> +       .unlocked_ioctl = seccomp_notify_ioctl,
> +};
> +
> +static struct file *init_listener(struct seccomp_filter *filter)
> +{
> +       struct file *ret = ERR_PTR(-EBUSY);
> +       struct seccomp_filter *cur;
> +
> +       for (cur = current->seccomp.filter; cur; cur = cur->prev) {
> +               if (cur->notif)
> +                       goto out;
> +       }
> +
> +       ret = ERR_PTR(-ENOMEM);
> +       filter->notif = kzalloc(sizeof(*(filter->notif)), GFP_KERNEL);
> +       if (!filter->notif)
> +               goto out;
> +
> +       sema_init(&filter->notif->request, 0);
> +       filter->notif->next_id = get_random_u64();
> +       INIT_LIST_HEAD(&filter->notif->notifications);
> +       init_waitqueue_head(&filter->notif->wqh);
> +
> +       ret = anon_inode_getfile("seccomp notify", &seccomp_notify_ops,
> +                                filter, O_RDWR);
> +       if (IS_ERR(ret))
> +               goto out_notif;
> +
> +       /* The file has a reference to it now */
> +       __get_seccomp_filter(filter);
> +
> +out_notif:
> +       if (IS_ERR(ret))
> +               kfree(filter->notif);
> +out:
> +       return ret;
> +}
> +
>  /**
>   * seccomp_set_mode_filter: internal function for setting seccomp filter
>   * @flags:  flags to change filter behavior
> @@ -853,6 +1247,8 @@ static long seccomp_set_mode_filter(unsigned int flags,
>         const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
>         struct seccomp_filter *prepared = NULL;
>         long ret = -EINVAL;
> +       int listener = -1;
> +       struct file *listener_f = NULL;
>
>         /* Validate flags. */
>         if (flags & ~SECCOMP_FILTER_FLAG_MASK)
> @@ -863,13 +1259,28 @@ static long seccomp_set_mode_filter(unsigned int flags,
>         if (IS_ERR(prepared))
>                 return PTR_ERR(prepared);
>
> +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> +               listener = get_unused_fd_flags(O_CLOEXEC);
> +               if (listener < 0) {
> +                       ret = listener;
> +                       goto out_free;
> +               }
> +
> +               listener_f = init_listener(prepared);
> +               if (IS_ERR(listener_f)) {
> +                       put_unused_fd(listener);
> +                       ret = PTR_ERR(listener_f);
> +                       goto out_free;
> +               }
> +       }
> +
>         /*
>          * Make sure we cannot change seccomp or nnp state via TSYNC
>          * while another thread is in the middle of calling exec.
>          */
>         if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
>             mutex_lock_killable(&current->signal->cred_guard_mutex))
> -               goto out_free;
> +               goto out_put_fd;
>
>         spin_lock_irq(&current->sighand->siglock);
>
> @@ -887,6 +1298,16 @@ static long seccomp_set_mode_filter(unsigned int flags,
>         spin_unlock_irq(&current->sighand->siglock);
>         if (flags & SECCOMP_FILTER_FLAG_TSYNC)
>                 mutex_unlock(&current->signal->cred_guard_mutex);
> +out_put_fd:
> +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> +               if (ret < 0) {
> +                       fput(listener_f);
> +                       put_unused_fd(listener);
> +               } else {
> +                       fd_install(listener, listener_f);
> +                       ret = listener;
> +               }
> +       }
>  out_free:
>         seccomp_filter_free(prepared);
>         return ret;
> @@ -911,6 +1332,7 @@ static long seccomp_get_action_avail(const char __user *uaction)
>         case SECCOMP_RET_KILL_THREAD:
>         case SECCOMP_RET_TRAP:
>         case SECCOMP_RET_ERRNO:
> +       case SECCOMP_RET_USER_NOTIF:
>         case SECCOMP_RET_TRACE:
>         case SECCOMP_RET_LOG:
>         case SECCOMP_RET_ALLOW:
> @@ -922,6 +1344,20 @@ static long seccomp_get_action_avail(const char __user *uaction)
>         return 0;
>  }
>
> +static long seccomp_get_notif_sizes(void __user *usizes)
> +{
> +       struct seccomp_notif_sizes sizes = {
> +               .seccomp_notif = sizeof(struct seccomp_notif),
> +               .seccomp_notif_resp = sizeof(struct seccomp_notif_resp),
> +               .seccomp_data = sizeof(struct seccomp_data),
> +       };
> +
> +       if (copy_to_user(usizes, &sizes, sizeof(sizes)))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
>  /* Common entry point for both prctl and syscall. */
>  static long do_seccomp(unsigned int op, unsigned int flags,
>                        void __user *uargs)
> @@ -938,6 +1374,11 @@ static long do_seccomp(unsigned int op, unsigned int flags,
>                         return -EINVAL;
>
>                 return seccomp_get_action_avail(uargs);
> +       case SECCOMP_GET_NOTIF_SIZES:
> +               if (flags != 0)
> +                       return -EINVAL;
> +
> +               return seccomp_get_notif_sizes(uargs);
>         default:
>                 return -EINVAL;
>         }
> @@ -1111,6 +1552,7 @@ long seccomp_get_metadata(struct task_struct *task,
>  #define SECCOMP_RET_KILL_THREAD_NAME   "kill_thread"
>  #define SECCOMP_RET_TRAP_NAME          "trap"
>  #define SECCOMP_RET_ERRNO_NAME         "errno"
> +#define SECCOMP_RET_USER_NOTIF_NAME    "user_notif"
>  #define SECCOMP_RET_TRACE_NAME         "trace"
>  #define SECCOMP_RET_LOG_NAME           "log"
>  #define SECCOMP_RET_ALLOW_NAME         "allow"
> @@ -1120,6 +1562,7 @@ static const char seccomp_actions_avail[] =
>                                 SECCOMP_RET_KILL_THREAD_NAME    " "
>                                 SECCOMP_RET_TRAP_NAME           " "
>                                 SECCOMP_RET_ERRNO_NAME          " "
> +                               SECCOMP_RET_USER_NOTIF_NAME     " "
>                                 SECCOMP_RET_TRACE_NAME          " "
>                                 SECCOMP_RET_LOG_NAME            " "
>                                 SECCOMP_RET_ALLOW_NAME;
> @@ -1134,6 +1577,7 @@ static const struct seccomp_log_name seccomp_log_names[] = {
>         { SECCOMP_LOG_KILL_THREAD, SECCOMP_RET_KILL_THREAD_NAME },
>         { SECCOMP_LOG_TRAP, SECCOMP_RET_TRAP_NAME },
>         { SECCOMP_LOG_ERRNO, SECCOMP_RET_ERRNO_NAME },
> +       { SECCOMP_LOG_USER_NOTIF, SECCOMP_RET_USER_NOTIF_NAME },
>         { SECCOMP_LOG_TRACE, SECCOMP_RET_TRACE_NAME },
>         { SECCOMP_LOG_LOG, SECCOMP_RET_LOG_NAME },
>         { SECCOMP_LOG_ALLOW, SECCOMP_RET_ALLOW_NAME },
> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
> index e1473234968d..5c9768a1b8cd 100644
> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
> @@ -5,6 +5,7 @@
>   * Test code for seccomp bpf.
>   */
>
> +#define _GNU_SOURCE
>  #include <sys/types.h>
>
>  /*
> @@ -40,10 +41,12 @@
>  #include <sys/fcntl.h>
>  #include <sys/mman.h>
>  #include <sys/times.h>
> +#include <sys/socket.h>
> +#include <sys/ioctl.h>
>
> -#define _GNU_SOURCE
>  #include <unistd.h>
>  #include <sys/syscall.h>
> +#include <poll.h>
>
>  #include "../kselftest_harness.h"
>
> @@ -133,6 +136,10 @@ struct seccomp_data {
>  #define SECCOMP_GET_ACTION_AVAIL 2
>  #endif
>
> +#ifndef SECCOMP_GET_NOTIF_SIZES
> +#define SECCOMP_GET_NOTIF_SIZES 3
> +#endif
> +
>  #ifndef SECCOMP_FILTER_FLAG_TSYNC
>  #define SECCOMP_FILTER_FLAG_TSYNC (1UL << 0)
>  #endif
> @@ -154,6 +161,44 @@ struct seccomp_metadata {
>  };
>  #endif
>
> +#ifndef SECCOMP_FILTER_FLAG_NEW_LISTENER
> +#define SECCOMP_FILTER_FLAG_NEW_LISTENER       (1UL << 3)
> +
> +#define SECCOMP_RET_USER_NOTIF 0x7fc00000U
> +
> +#define SECCOMP_IOC_MAGIC              '!'
> +#define SECCOMP_IO(nr)                 _IO(SECCOMP_IOC_MAGIC, nr)
> +#define SECCOMP_IOR(nr, type)          _IOR(SECCOMP_IOC_MAGIC, nr, type)
> +#define SECCOMP_IOW(nr, type)          _IOW(SECCOMP_IOC_MAGIC, nr, type)
> +#define SECCOMP_IOWR(nr, type)         _IOWR(SECCOMP_IOC_MAGIC, nr, type)
> +
> +/* Flags for seccomp notification fd ioctl. */
> +#define SECCOMP_IOCTL_NOTIF_RECV       SECCOMP_IOWR(0, struct seccomp_notif)
> +#define SECCOMP_IOCTL_NOTIF_SEND       SECCOMP_IOWR(1, \
> +                                               struct seccomp_notif_resp)
> +#define SECCOMP_IOCTL_NOTIF_ID_VALID   SECCOMP_IOR(2, __u64)
> +
> +struct seccomp_notif {
> +       __u64 id;
> +       __u32 pid;
> +       __u32 flags;
> +       struct seccomp_data data;
> +};
> +
> +struct seccomp_notif_resp {
> +       __u64 id;
> +       __s64 val;
> +       __s32 error;
> +       __u32 flags;
> +};
> +
> +struct seccomp_notif_sizes {
> +       __u16 seccomp_notif;
> +       __u16 seccomp_notif_resp;
> +       __u16 seccomp_data;
> +};
> +#endif
> +
>  #ifndef seccomp
>  int seccomp(unsigned int op, unsigned int flags, void *args)
>  {
> @@ -2077,7 +2122,8 @@ TEST(detect_seccomp_filter_flags)
>  {
>         unsigned int flags[] = { SECCOMP_FILTER_FLAG_TSYNC,
>                                  SECCOMP_FILTER_FLAG_LOG,
> -                                SECCOMP_FILTER_FLAG_SPEC_ALLOW };
> +                                SECCOMP_FILTER_FLAG_SPEC_ALLOW,
> +                                SECCOMP_FILTER_FLAG_NEW_LISTENER };
>         unsigned int flag, all_flags;
>         int i;
>         long ret;
> @@ -2933,6 +2979,403 @@ TEST(get_metadata)
>         ASSERT_EQ(0, kill(pid, SIGKILL));
>  }
>
> +static int user_trap_syscall(int nr, unsigned int flags)
> +{
> +       struct sock_filter filter[] = {
> +               BPF_STMT(BPF_LD+BPF_W+BPF_ABS,
> +                       offsetof(struct seccomp_data, nr)),
> +               BPF_JUMP(BPF_JMP+BPF_JEQ+BPF_K, nr, 0, 1),
> +               BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_USER_NOTIF),
> +               BPF_STMT(BPF_RET+BPF_K, SECCOMP_RET_ALLOW),
> +       };
> +
> +       struct sock_fprog prog = {
> +               .len = (unsigned short)ARRAY_SIZE(filter),
> +               .filter = filter,
> +       };
> +
> +       return seccomp(SECCOMP_SET_MODE_FILTER, flags, &prog);
> +}
> +
> +#define USER_NOTIF_MAGIC 116983961184613L
> +TEST(user_notification_basic)
> +{
> +       pid_t pid;
> +       long ret;
> +       int status, listener;
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +       struct pollfd pollfd;
> +
> +       struct sock_filter filter[] = {
> +               BPF_STMT(BPF_RET|BPF_K, SECCOMP_RET_ALLOW),
> +       };
> +       struct sock_fprog prog = {
> +               .len = (unsigned short)ARRAY_SIZE(filter),
> +               .filter = filter,
> +       };
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       /* Check that we get -ENOSYS with no listener attached */
> +       if (pid == 0) {
> +               if (user_trap_syscall(__NR_getpid, 0) < 0)
> +                       exit(1);
> +               ret = syscall(__NR_getpid);
> +               exit(ret >= 0 || errno != ENOSYS);
> +       }
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +
> +       /* Add some no-op filters so for grins. */
> +       EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
> +       EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
> +       EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
> +       EXPECT_EQ(seccomp(SECCOMP_SET_MODE_FILTER, 0, &prog), 0);
> +
> +       /* Check that the basic notification machinery works */
> +       listener = user_trap_syscall(__NR_getpid,
> +                                    SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       EXPECT_GE(listener, 0);
> +
> +       /* Installing a second listener in the chain should EBUSY */
> +       EXPECT_EQ(user_trap_syscall(__NR_getpid,
> +                                   SECCOMP_FILTER_FLAG_NEW_LISTENER),
> +                 -1);
> +       EXPECT_EQ(errno, EBUSY);
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0) {
> +               ret = syscall(__NR_getpid);
> +               exit(ret != USER_NOTIF_MAGIC);
> +       }
> +
> +       pollfd.fd = listener;
> +       pollfd.events = POLLIN | POLLOUT;
> +
> +       EXPECT_GT(poll(&pollfd, 1, -1), 0);
> +       EXPECT_EQ(pollfd.revents, POLLIN);
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +
> +       pollfd.fd = listener;
> +       pollfd.events = POLLIN | POLLOUT;
> +
> +       EXPECT_GT(poll(&pollfd, 1, -1), 0);
> +       EXPECT_EQ(pollfd.revents, POLLOUT);
> +
> +       EXPECT_EQ(req.data.nr,  __NR_getpid);
> +
> +       resp.id = req.id;
> +       resp.error = 0;
> +       resp.val = USER_NOTIF_MAGIC;
> +
> +       /* check that we make sure flags == 0 */
> +       resp.flags = 1;
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
> +       EXPECT_EQ(errno, EINVAL);
> +
> +       resp.flags = 0;
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
> +TEST(user_notification_kill_in_middle)
> +{
> +       pid_t pid;
> +       long ret;
> +       int listener;
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +
> +       listener = user_trap_syscall(__NR_getpid,
> +                                    SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       EXPECT_GE(listener, 0);
> +
> +       /*
> +        * Check that nothing bad happens when we kill the task in the middle
> +        * of a syscall.
> +        */
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0) {
> +               ret = syscall(__NR_getpid);
> +               exit(ret != USER_NOTIF_MAGIC);
> +       }
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ID_VALID, &req.id), 0);
> +
> +       EXPECT_EQ(kill(pid, SIGKILL), 0);
> +       EXPECT_EQ(waitpid(pid, NULL, 0), pid);
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_ID_VALID, &req.id), -1);
> +
> +       resp.id = req.id;
> +       ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp);
> +       EXPECT_EQ(ret, -1);
> +       EXPECT_EQ(errno, ENOENT);
> +}
> +
> +static int handled = -1;
> +
> +static void signal_handler(int signal)
> +{
> +       if (write(handled, "c", 1) != 1)
> +               perror("write from signal");
> +}
> +
> +TEST(user_notification_signal)
> +{
> +       pid_t pid;
> +       long ret;
> +       int status, listener, sk_pair[2];
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +       char c;
> +
> +       ASSERT_EQ(socketpair(PF_LOCAL, SOCK_SEQPACKET, 0, sk_pair), 0);
> +
> +       listener = user_trap_syscall(__NR_gettid,
> +                                    SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       EXPECT_GE(listener, 0);
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0) {
> +               close(sk_pair[0]);
> +               handled = sk_pair[1];
> +               if (signal(SIGUSR1, signal_handler) == SIG_ERR) {
> +                       perror("signal");
> +                       exit(1);
> +               }
> +               /*
> +                * ERESTARTSYS behavior is a bit hard to test, because we need
> +                * to rely on a signal that has not yet been handled. Let's at
> +                * least check that the error code gets propagated through, and
> +                * hope that it doesn't break when there is actually a signal :)
> +                */
> +               ret = syscall(__NR_gettid);
> +               exit(!(ret == -1 && errno == 512));
> +       }
> +
> +       close(sk_pair[1]);
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +
> +       EXPECT_EQ(kill(pid, SIGUSR1), 0);
> +
> +       /*
> +        * Make sure the signal really is delivered, which means we're not
> +        * stuck in the user notification code any more and the notification
> +        * should be dead.
> +        */
> +       EXPECT_EQ(read(sk_pair[0], &c, 1), 1);
> +
> +       resp.id = req.id;
> +       resp.error = -EPERM;
> +       resp.val = 0;
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), -1);
> +       EXPECT_EQ(errno, ENOENT);
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +
> +       resp.id = req.id;
> +       resp.error = -512; /* -ERESTARTSYS */
> +       resp.val = 0;
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
> +TEST(user_notification_closed_listener)
> +{
> +       pid_t pid;
> +       long ret;
> +       int status, listener;
> +
> +       listener = user_trap_syscall(__NR_getpid,
> +                                    SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       EXPECT_GE(listener, 0);
> +
> +       /*
> +        * Check that we get an ENOSYS when the listener is closed.
> +        */
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +       if (pid == 0) {
> +               close(listener);
> +               ret = syscall(__NR_getpid);
> +               exit(ret != -1 && errno != ENOSYS);
> +       }
> +
> +       close(listener);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
> +/*
> + * Check that a pid in a child namespace still shows up as valid in ours.
> + */
> +TEST(user_notification_child_pid_ns)
> +{
> +       pid_t pid;
> +       int status, listener;
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +
> +       ASSERT_EQ(unshare(CLONE_NEWPID), 0);
> +
> +       listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       ASSERT_GE(listener, 0);
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0)
> +               exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +       EXPECT_EQ(req.pid, pid);
> +
> +       resp.id = req.id;
> +       resp.error = 0;
> +       resp.val = USER_NOTIF_MAGIC;
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +       close(listener);
> +}
> +
> +/*
> + * Check that a pid in a sibling (i.e. unrelated) namespace shows up as 0, i.e.
> + * invalid.
> + */
> +TEST(user_notification_sibling_pid_ns)
> +{
> +       pid_t pid, pid2;
> +       int status, listener;
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +
> +       listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       ASSERT_GE(listener, 0);
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0) {
> +               ASSERT_EQ(unshare(CLONE_NEWPID), 0);
> +
> +               pid2 = fork();
> +               ASSERT_GE(pid2, 0);
> +
> +               if (pid2 == 0)
> +                       exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
> +
> +               EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
> +               EXPECT_EQ(true, WIFEXITED(status));
> +               EXPECT_EQ(0, WEXITSTATUS(status));
> +               exit(WEXITSTATUS(status));
> +       }
> +
> +       /* Create the sibling ns, and sibling in it. */
> +       EXPECT_EQ(unshare(CLONE_NEWPID), 0);
> +       EXPECT_EQ(errno, 0);
> +
> +       pid2 = fork();
> +       EXPECT_GE(pid2, 0);
> +
> +       if (pid2 == 0) {
> +               ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +               /*
> +                * The pid should be 0, i.e. the task is in some namespace that
> +                * we can't "see".
> +                */
> +               ASSERT_EQ(req.pid, 0);
> +
> +               resp.id = req.id;
> +               resp.error = 0;
> +               resp.val = USER_NOTIF_MAGIC;
> +
> +               ASSERT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
> +               exit(0);
> +       }
> +
> +       close(listener);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +
> +       EXPECT_EQ(waitpid(pid2, &status, 0), pid2);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
> +TEST(user_notification_fault_recv)
> +{
> +       pid_t pid;
> +       int status, listener;
> +       struct seccomp_notif req = {};
> +       struct seccomp_notif_resp resp = {};
> +
> +       listener = user_trap_syscall(__NR_getpid, SECCOMP_FILTER_FLAG_NEW_LISTENER);
> +       ASSERT_GE(listener, 0);
> +
> +       pid = fork();
> +       ASSERT_GE(pid, 0);
> +
> +       if (pid == 0)
> +               exit(syscall(__NR_getpid) != USER_NOTIF_MAGIC);
> +
> +       /* Do a bad recv() */
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, NULL), -1);
> +       EXPECT_EQ(errno, EFAULT);
> +
> +       /* We should still be able to receive this notification, though. */
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
> +       EXPECT_EQ(req.pid, pid);
> +
> +       resp.id = req.id;
> +       resp.error = 0;
> +       resp.val = USER_NOTIF_MAGIC;
> +
> +       EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_SEND, &resp), 0);
> +
> +       EXPECT_EQ(waitpid(pid, &status, 0), pid);
> +       EXPECT_EQ(true, WIFEXITED(status));
> +       EXPECT_EQ(0, WEXITSTATUS(status));
> +}
> +
> +TEST(seccomp_get_notif_sizes)
> +{
> +       struct seccomp_notif_sizes sizes;
> +
> +       EXPECT_EQ(seccomp(SECCOMP_GET_NOTIF_SIZES, 0, &sizes), 0);
> +       EXPECT_EQ(sizes.seccomp_notif, sizeof(struct seccomp_notif));
> +       EXPECT_EQ(sizes.seccomp_notif_resp, sizeof(struct seccomp_notif_resp));
> +}
> +
>  /*
>   * TODO:
>   * - add microbenchmarks
> --
> 2.19.1
>


-- 
Kees Cook
