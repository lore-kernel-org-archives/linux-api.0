From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 1/6] seccomp: add a return code to trap to userspace
Date: Mon, 8 Oct 2018 16:58:05 +0200
Message-ID: <20181008145803.ycawjwhc3mwkdogf@brauner.io>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-2-tycho@tycho.ws>
 <CAGXu5jJr3JWLYGrJ+knu3sj4wwJ_irVvs+JRrY5MuYT3voLegg@mail.gmail.com>
 <20180927224839.GF15491@cisco.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180927224839.GF15491@cisco.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W . Biederman" <ebiederm@xmission.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 04:48:39PM -0600, Tycho Andersen wrote:
> On Thu, Sep 27, 2018 at 02:31:24PM -0700, Kees Cook wrote:
> > On Thu, Sep 27, 2018 at 8:11 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > This patch introduces a means for syscalls matched in seccomp to notify
> > > some other task that a particular filter has been triggered.
> > >
> > > The motivation for this is primarily for use with containers. For example,
> > > if a container does an init_module(), we obviously don't want to load this
> > > untrusted code, which may be compiled for the wrong version of the kernel
> > > anyway. Instead, we could parse the module image, figure out which module
> > > the container is trying to load and load it on the host.
> > >
> > > As another example, containers cannot mknod(), since this checks
> > > capable(CAP_SYS_ADMIN). However, harmless devices like /dev/null or
> > > /dev/zero should be ok for containers to mknod, but we'd like to avoid hard
> > > coding some whitelist in the kernel. Another example is mount(), which has
> > > many security restrictions for good reason, but configuration or runtime
> > > knowledge could potentially be used to relax these restrictions.
> > >
> > > This patch adds functionality that is already possible via at least two
> > > other means that I know about, both of which involve ptrace(): first, one
> > > could ptrace attach, and then iterate through syscalls via PTRACE_SYSCALL.
> > > Unfortunately this is slow, so a faster version would be to install a
> > > filter that does SECCOMP_RET_TRACE, which triggers a PTRACE_EVENT_SECCOMP.
> > > Since ptrace allows only one tracer, if the container runtime is that
> > > tracer, users inside the container (or outside) trying to debug it will not
> > > be able to use ptrace, which is annoying. It also means that older
> > > distributions based on Upstart cannot boot inside containers using ptrace,
> > > since upstart itself uses ptrace to start services.
> > >
> > > The actual implementation of this is fairly small, although getting the
> > > synchronization right was/is slightly complex.
> > >
> > > Finally, it's worth noting that the classic seccomp TOCTOU of reading
> > > memory data from the task still applies here, but can be avoided with
> > > careful design of the userspace handler: if the userspace handler reads all
> > > of the task memory that is necessary before applying its security policy,
> > > the tracee's subsequent memory edits will not be read by the tracer.
> > >
> > > v2: * make id a u64; the idea here being that it will never overflow,
> > >       because 64 is huge (one syscall every nanosecond => wrap every 584
> > >       years) (Andy)
> > >     * prevent nesting of user notifications: if someone is already attached
> > >       the tree in one place, nobody else can attach to the tree (Andy)
> > >     * notify the listener of signals the tracee receives as well (Andy)
> > >     * implement poll
> > > v3: * lockdep fix (Oleg)
> > >     * drop unnecessary WARN()s (Christian)
> > >     * rearrange error returns to be more rpetty (Christian)
> > >     * fix build in !CONFIG_SECCOMP_USER_NOTIFICATION case
> > > v4: * fix implementation of poll to use poll_wait() (Jann)
> > >     * change listener's fd flags to be 0 (Jann)
> > >     * hoist filter initialization out of ifdefs to its own function
> > >       init_user_notification()
> > >     * add some more testing around poll() and closing the listener while a
> > >       syscall is in action
> > >     * s/GET_LISTENER/NEW_LISTENER, since you can't _get_ a listener, but it
> > >       creates a new one (Matthew)
> > >     * correctly handle pid namespaces, add some testcases (Matthew)
> > >     * use EINPROGRESS instead of EINVAL when a notification response is
> > >       written twice (Matthew)
> > >     * fix comment typo from older version (SEND vs READ) (Matthew)
> > >     * whitespace and logic simplification (Tobin)
> > >     * add some Documentation/ bits on userspace trapping
> > > v5: * fix documentation typos (Jann)
> > >     * add signalled field to struct seccomp_notif (Jann)
> > >     * switch to using ioctls instead of read()/write() for struct passing
> > >       (Jann)
> > >     * add an ioctl to ensure an id is still valid
> > > v6: * docs typo fixes, update docs for ioctl() change (Christian)
> > > v7: * switch struct seccomp_knotif's id member to a u64 (derp :)
> > >     * use notify_lock in IS_ID_VALID query to avoid racing
> > >     * s/signalled/signaled (Tyler)
> > >     * fix docs to reflect that ids are not globally unique (Tyler)
> > >     * add a test to check -ERESTARTSYS behavior (Tyler)
> > >     * drop CONFIG_SECCOMP_USER_NOTIFICATION (Tyler)
> > >     * reorder USER_NOTIF in seccomp return codes list (Tyler)
> > >     * return size instead of sizeof(struct user_notif) (Tyler)
> > >     * ENOENT instead of EINVAL when invalid id is passed (Tyler)
> > >     * drop CONFIG_SECCOMP_USER_NOTIFICATION guards (Tyler)
> > >     * s/IS_ID_VALID/ID_VALID and switch ioctl to be "well behaved" (Tyler)
> > >     * add a new struct notification to minimize the additions to
> > >       struct seccomp_filter, also pack the necessary additions a bit more
> > >       cleverly (Tyler)
> > >     * switch to keeping track of the task itself instead of the pid (we'll
> > >       use this for implementing PUT_FD)
> > 
> > Patch-sending nit: can you put the versioning below the "---" line so
> > it isn't included in the final commit? (And I normally read these
> > backwards, so I'd expect v7 at the top, but that's not a big deal. I
> > mean... neither is the --- thing, but it makes "git am" easier for me
> > since I don't have to go edit the versioning out of the log.)
> 
> Sure, will do.
> 
> > > diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> > > index 9efc0e73d50b..d4ccb32fe089 100644
> > > --- a/include/uapi/linux/seccomp.h
> > > +++ b/include/uapi/linux/seccomp.h
> > > @@ -17,9 +17,10 @@
> > >  #define SECCOMP_GET_ACTION_AVAIL       2
> > >
> > >  /* Valid flags for SECCOMP_SET_MODE_FILTER */
> > > -#define SECCOMP_FILTER_FLAG_TSYNC      (1UL << 0)
> > > -#define SECCOMP_FILTER_FLAG_LOG                (1UL << 1)
> > > -#define SECCOMP_FILTER_FLAG_SPEC_ALLOW (1UL << 2)
> > > +#define SECCOMP_FILTER_FLAG_TSYNC              (1UL << 0)
> > > +#define SECCOMP_FILTER_FLAG_LOG                        (1UL << 1)
> > > +#define SECCOMP_FILTER_FLAG_SPEC_ALLOW         (1UL << 2)
> > > +#define SECCOMP_FILTER_FLAG_NEW_LISTENER       (1UL << 3)
> > 
> > Since these are all getting indentation updates, can you switch them
> > to BIT(0), BIT(1), etc?
> 
> Will do.
> 
> > >  /*
> > >   * All BPF programs must return a 32-bit value.
> > > @@ -35,6 +36,7 @@
> > >  #define SECCOMP_RET_KILL        SECCOMP_RET_KILL_THREAD
> > >  #define SECCOMP_RET_TRAP        0x00030000U /* disallow and force a SIGSYS */
> > >  #define SECCOMP_RET_ERRNO       0x00050000U /* returns an errno */
> > > +#define SECCOMP_RET_USER_NOTIF   0x7fc00000U /* notifies userspace */
> > >  #define SECCOMP_RET_TRACE       0x7ff00000U /* pass to a tracer or disallow */
> > >  #define SECCOMP_RET_LOG                 0x7ffc0000U /* allow after logging */
> > >  #define SECCOMP_RET_ALLOW       0x7fff0000U /* allow */
> > > @@ -60,4 +62,29 @@ struct seccomp_data {
> > >         __u64 args[6];
> > >  };
> > >
> > > +struct seccomp_notif {
> > > +       __u16 len;
> > > +       __u64 id;
> > > +       __u32 pid;
> > > +       __u8 signaled;
> > > +       struct seccomp_data data;
> > > +};
> > > +
> > > +struct seccomp_notif_resp {
> > > +       __u16 len;
> > > +       __u64 id;
> > > +       __s32 error;
> > > +       __s64 val;
> > > +};
> > 
> > So, len has to come first, for versioning. However, since it's ahead
> > of a u64, this leaves a struct padding hole. pahole output:
> > 
> > struct seccomp_notif {
> >         __u16                      len;                  /*     0     2 */
> > 
> >         /* XXX 6 bytes hole, try to pack */
> > 
> >         __u64                      id;                   /*     8     8 */
> >         __u32                      pid;                  /*    16     4 */
> >         __u8                       signaled;             /*    20     1 */
> > 
> >         /* XXX 3 bytes hole, try to pack */
> > 
> >         struct seccomp_data        data;                 /*    24    64 */
> >         /* --- cacheline 1 boundary (64 bytes) was 24 bytes ago --- */
> > 
> >         /* size: 88, cachelines: 2, members: 5 */
> >         /* sum members: 79, holes: 2, sum holes: 9 */
> >         /* last cacheline: 24 bytes */
> > };
> > struct seccomp_notif_resp {
> >         __u16                      len;                  /*     0     2 */
> > 
> >         /* XXX 6 bytes hole, try to pack */
> > 
> >         __u64                      id;                   /*     8     8 */
> >         __s32                      error;                /*    16     4 */
> > 
> >         /* XXX 4 bytes hole, try to pack */
> > 
> >         __s64                      val;                  /*    24     8 */
> > 
> >         /* size: 32, cachelines: 1, members: 4 */
> >         /* sum members: 22, holes: 2, sum holes: 10 */
> >         /* last cacheline: 32 bytes */
> > };
> > 
> > How about making len u32, and moving pid and error above "id"? This
> > leaves a hole after signaled, so changing "len" won't be sufficient
> > for versioning here. Perhaps move it after data?
> 
> I'm not sure what you mean by "len won't be sufficient for versioning
> here"? Anyway, I can do some packing on these; I didn't bother before
> since I figured it's a userspace interface, so saving a few bytes
> isn't a huge deal.
> 
> > > +
> > > +#define SECCOMP_IOC_MAGIC              0xF7
> > 
> > Was there any specific reason for picking this value? There are lots
> > of fun ASCII code left like '!' or '*'. :)
> 
> No, ! it is :)
> 
> > > +
> > > +/* Flags for seccomp notification fd ioctl. */
> > > +#define SECCOMP_NOTIF_RECV     _IOWR(SECCOMP_IOC_MAGIC, 0,     \
> > > +                                       struct seccomp_notif)
> > > +#define SECCOMP_NOTIF_SEND     _IOWR(SECCOMP_IOC_MAGIC, 1,     \
> > > +                                       struct seccomp_notif_resp)
> > > +#define SECCOMP_NOTIF_ID_VALID _IOR(SECCOMP_IOC_MAGIC, 2,      \
> > > +                                       __u64)
> > 
> > To match other UAPI ioctl, can these have a prefix of "SECCOMP_IOCTOL_..."?
> > 
> > It may also be useful to match how other uapis do this, like for DRM:
> > 
> > #define DRM_IOCTL_BASE                  'd'
> > #define DRM_IO(nr)                      _IO(DRM_IOCTL_BASE,nr)
> > #define DRM_IOR(nr,type)                _IOR(DRM_IOCTL_BASE,nr,type)
> > #define DRM_IOW(nr,type)                _IOW(DRM_IOCTL_BASE,nr,type)
> > #define DRM_IOWR(nr,type)               _IOWR(DRM_IOCTL_BASE,nr,type)
> > 
> > #define DRM_IOCTL_VERSION               DRM_IOWR(0x00, struct drm_version)
> > #define DRM_IOCTL_GET_UNIQUE            DRM_IOWR(0x01, struct drm_unique)
> > #define DRM_IOCTL_GET_MAGIC             DRM_IOR( 0x02, struct drm_auth)
> > ...
> 
> Will do.
> 
> > 
> > > +
> > >  #endif /* _UAPI_LINUX_SECCOMP_H */
> > > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > > index fd023ac24e10..fa6fe9756c80 100644
> > > --- a/kernel/seccomp.c
> > > +++ b/kernel/seccomp.c
> > > @@ -33,12 +33,78 @@
> > >  #endif
> > >
> > >  #ifdef CONFIG_SECCOMP_FILTER
> > > +#include <linux/file.h>
> > >  #include <linux/filter.h>
> > >  #include <linux/pid.h>
> > >  #include <linux/ptrace.h>
> > >  #include <linux/security.h>
> > >  #include <linux/tracehook.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/anon_inodes.h>
> > > +
> > > +enum notify_state {
> > > +       SECCOMP_NOTIFY_INIT,
> > > +       SECCOMP_NOTIFY_SENT,
> > > +       SECCOMP_NOTIFY_REPLIED,
> > > +};
> > > +
> > > +struct seccomp_knotif {
> > > +       /* The struct pid of the task whose filter triggered the notification */
> > > +       struct task_struct *task;
> > > +
> > > +       /* The "cookie" for this request; this is unique for this filter. */
> > > +       u64 id;
> > > +
> > > +       /* Whether or not this task has been given an interruptible signal. */
> > > +       bool signaled;
> > > +
> > > +       /*
> > > +        * The seccomp data. This pointer is valid the entire time this
> > > +        * notification is active, since it comes from __seccomp_filter which
> > > +        * eclipses the entire lifecycle here.
> > > +        */
> > > +       const struct seccomp_data *data;
> > > +
> > > +       /*
> > > +        * Notification states. When SECCOMP_RET_USER_NOTIF is returned, a
> > > +        * struct seccomp_knotif is created and starts out in INIT. Once the
> > > +        * handler reads the notification off of an FD, it transitions to SENT.
> > > +        * If a signal is received the state transitions back to INIT and
> > > +        * another message is sent. When the userspace handler replies, state
> > > +        * transitions to REPLIED.
> > > +        */
> > > +       enum notify_state state;
> > > +
> > > +       /* The return values, only valid when in SECCOMP_NOTIFY_REPLIED */
> > > +       int error;
> > > +       long val;
> > > +
> > > +       /* Signals when this has entered SECCOMP_NOTIFY_REPLIED */
> > > +       struct completion ready;
> > > +
> > > +       struct list_head list;
> > > +};
> > > +
> > > +/**
> > > + * struct notification - container for seccomp userspace notifications. Since
> > > + * most seccomp filters will not have notification listeners attached and this
> > > + * structure is fairly large, we store the notification-specific stuff in a
> > > + * separate structure.
> > > + *
> > > + * @request: A semaphore that users of this notification can wait on for
> > > + *           changes. Actual reads and writes are still controlled with
> > > + *           filter->notify_lock.
> > > + * @notify_lock: A lock for all notification-related accesses.
> > > + * @next_id: The id of the next request.
> > > + * @notifications: A list of struct seccomp_knotif elements.
> > > + * @wqh: A wait queue for poll.
> > > + */
> > > +struct notification {
> > > +       struct semaphore request;
> > > +       u64 next_id;
> > > +       struct list_head notifications;
> > > +       wait_queue_head_t wqh;
> > > +};
> > >
> > >  /**
> > >   * struct seccomp_filter - container for seccomp BPF programs
> > > @@ -66,6 +132,8 @@ struct seccomp_filter {
> > >         bool log;
> > >         struct seccomp_filter *prev;
> > >         struct bpf_prog *prog;
> > > +       struct notification *notif;
> > > +       struct mutex notify_lock;
> > >  };
> > >
> > >  /* Limit any path through the tree to 256KB worth of instructions. */
> > > @@ -392,6 +460,7 @@ static struct seccomp_filter *seccomp_prepare_filter(struct sock_fprog *fprog)
> > >         if (!sfilter)
> > >                 return ERR_PTR(-ENOMEM);
> > >
> > > +       mutex_init(&sfilter->notify_lock);
> > >         ret = bpf_prog_create_from_user(&sfilter->prog, fprog,
> > >                                         seccomp_check_filter, save_orig);
> > >         if (ret < 0) {
> > > @@ -556,11 +625,13 @@ static void seccomp_send_sigsys(int syscall, int reason)
> > >  #define SECCOMP_LOG_TRACE              (1 << 4)
> > >  #define SECCOMP_LOG_LOG                        (1 << 5)
> > >  #define SECCOMP_LOG_ALLOW              (1 << 6)
> > > +#define SECCOMP_LOG_USER_NOTIF         (1 << 7)
> > >
> > >  static u32 seccomp_actions_logged = SECCOMP_LOG_KILL_PROCESS |
> > >                                     SECCOMP_LOG_KILL_THREAD  |
> > >                                     SECCOMP_LOG_TRAP  |
> > >                                     SECCOMP_LOG_ERRNO |
> > > +                                   SECCOMP_LOG_USER_NOTIF |
> > >                                     SECCOMP_LOG_TRACE |
> > >                                     SECCOMP_LOG_LOG;
> > >
> > > @@ -581,6 +652,9 @@ static inline void seccomp_log(unsigned long syscall, long signr, u32 action,
> > >         case SECCOMP_RET_TRACE:
> > >                 log = requested && seccomp_actions_logged & SECCOMP_LOG_TRACE;
> > >                 break;
> > > +       case SECCOMP_RET_USER_NOTIF:
> > > +               log = requested && seccomp_actions_logged & SECCOMP_LOG_USER_NOTIF;
> > > +               break;
> > >         case SECCOMP_RET_LOG:
> > >                 log = seccomp_actions_logged & SECCOMP_LOG_LOG;
> > >                 break;
> > > @@ -652,6 +726,73 @@ void secure_computing_strict(int this_syscall)
> > >  #else
> > >
> > >  #ifdef CONFIG_SECCOMP_FILTER
> > > +static u64 seccomp_next_notify_id(struct seccomp_filter *filter)
> > > +{
> > > +       /* Note: overflow is ok here, the id just needs to be unique */
> > 
> > Maybe just clarify in the comment: unique to the filter.
> > 
> > > +       return filter->notif->next_id++;
> > 
> > Also, it might be useful to add for both documentation and lockdep:
> > 
> > lockdep_assert_held(filter->notif->notify_lock);
> > 
> > into this function?
> 
> Will do.
> 
> > 
> > > +}
> > > +
> > > +static void seccomp_do_user_notification(int this_syscall,
> > > +                                        struct seccomp_filter *match,
> > > +                                        const struct seccomp_data *sd)
> > > +{
> > > +       int err;
> > > +       long ret = 0;
> > > +       struct seccomp_knotif n = {};
> > > +
> > > +       mutex_lock(&match->notify_lock);
> > > +       err = -ENOSYS;
> > > +       if (!match->notif)
> > > +               goto out;
> > > +
> > > +       n.task = current;
> > > +       n.state = SECCOMP_NOTIFY_INIT;
> > > +       n.data = sd;
> > > +       n.id = seccomp_next_notify_id(match);
> > > +       init_completion(&n.ready);
> > > +
> > > +       list_add(&n.list, &match->notif->notifications);
> > > +       wake_up_poll(&match->notif->wqh, EPOLLIN | EPOLLRDNORM);
> > > +
> > > +       mutex_unlock(&match->notify_lock);
> > > +       up(&match->notif->request);
> > > +
> > 
> > Maybe add a big comment here saying this is where we're waiting for a reply?
> 
> Will do.
> 
> > > +       err = wait_for_completion_interruptible(&n.ready);
> > > +       mutex_lock(&match->notify_lock);
> > > +
> > > +       /*
> > > +        * Here it's possible we got a signal and then had to wait on the mutex
> > > +        * while the reply was sent, so let's be sure there wasn't a response
> > > +        * in the meantime.
> > > +        */
> > > +       if (err < 0 && n.state != SECCOMP_NOTIFY_REPLIED) {
> > > +               /*
> > > +                * We got a signal. Let's tell userspace about it (potentially
> > > +                * again, if we had already notified them about the first one).
> > > +                */
> > > +               n.signaled = true;
> > > +               if (n.state == SECCOMP_NOTIFY_SENT) {
> > > +                       n.state = SECCOMP_NOTIFY_INIT;
> > > +                       up(&match->notif->request);
> > > +               }
> > > +               mutex_unlock(&match->notify_lock);
> > > +               err = wait_for_completion_killable(&n.ready);
> > > +               mutex_lock(&match->notify_lock);
> > > +               if (err < 0)
> > > +                       goto remove_list;
> > > +       }
> > > +
> > > +       ret = n.val;
> > > +       err = n.error;
> > > +
> > > +remove_list:
> > > +       list_del(&n.list);
> > > +out:
> > > +       mutex_unlock(&match->notify_lock);
> > > +       syscall_set_return_value(current, task_pt_regs(current),
> > > +                                err, ret);
> > > +}
> > > +
> > >  static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
> > >                             const bool recheck_after_trace)
> > >  {
> > > @@ -728,6 +869,9 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
> > >
> > >                 return 0;
> > >
> > > +       case SECCOMP_RET_USER_NOTIF:
> > > +               seccomp_do_user_notification(this_syscall, match, sd);
> > > +               goto skip;
> > 
> > Nit: please add a blank line here (to match the other cases).
> > 
> > >         case SECCOMP_RET_LOG:
> > >                 seccomp_log(this_syscall, 0, action, true);
> > >                 return 0;
> > > @@ -834,6 +978,9 @@ static long seccomp_set_mode_strict(void)
> > >  }
> > >
> > >  #ifdef CONFIG_SECCOMP_FILTER
> > > +static struct file *init_listener(struct task_struct *,
> > > +                                 struct seccomp_filter *);
> > 
> > Why is the forward declaration needed instead of just moving the
> > function here? I didn't see anything in it that looked like it
> > couldn't move.
> 
> I think there was a cycle in some earlier version, but I agree there
> isn't now. I'll fix it.
> 
> > > +
> > >  /**
> > >   * seccomp_set_mode_filter: internal function for setting seccomp filter
> > >   * @flags:  flags to change filter behavior
> > > @@ -853,6 +1000,8 @@ static long seccomp_set_mode_filter(unsigned int flags,
> > >         const unsigned long seccomp_mode = SECCOMP_MODE_FILTER;
> > >         struct seccomp_filter *prepared = NULL;
> > >         long ret = -EINVAL;
> > > +       int listener = 0;
> > 
> > Nit: "invalid fd" should be -1, not 0.
> > 
> > > +       struct file *listener_f = NULL;
> > >
> > >         /* Validate flags. */
> > >         if (flags & ~SECCOMP_FILTER_FLAG_MASK)
> > > @@ -863,13 +1012,28 @@ static long seccomp_set_mode_filter(unsigned int flags,
> > >         if (IS_ERR(prepared))
> > >                 return PTR_ERR(prepared);
> > >
> > > +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> > > +               listener = get_unused_fd_flags(0);
> > 
> > As with the other place pointed out by Jann, this should maybe be O_CLOEXEC too?
> 
> Yep, will do.
> 
> > > +               if (listener < 0) {
> > > +                       ret = listener;
> > > +                       goto out_free;
> > > +               }
> > > +
> > > +               listener_f = init_listener(current, prepared);
> > > +               if (IS_ERR(listener_f)) {
> > > +                       put_unused_fd(listener);
> > > +                       ret = PTR_ERR(listener_f);
> > > +                       goto out_free;
> > > +               }
> > > +       }
> > > +
> > >         /*
> > >          * Make sure we cannot change seccomp or nnp state via TSYNC
> > >          * while another thread is in the middle of calling exec.
> > >          */
> > >         if (flags & SECCOMP_FILTER_FLAG_TSYNC &&
> > >             mutex_lock_killable(&current->signal->cred_guard_mutex))
> > > -               goto out_free;
> > > +               goto out_put_fd;
> > >
> > >         spin_lock_irq(&current->sighand->siglock);
> > >
> > > @@ -887,6 +1051,16 @@ static long seccomp_set_mode_filter(unsigned int flags,
> > >         spin_unlock_irq(&current->sighand->siglock);
> > >         if (flags & SECCOMP_FILTER_FLAG_TSYNC)
> > >                 mutex_unlock(&current->signal->cred_guard_mutex);
> > > +out_put_fd:
> > > +       if (flags & SECCOMP_FILTER_FLAG_NEW_LISTENER) {
> > > +               if (ret < 0) {
> > > +                       fput(listener_f);
> > > +                       put_unused_fd(listener);
> > > +               } else {
> > > +                       fd_install(listener, listener_f);
> > > +                       ret = listener;
> > > +               }
> > > +       }
> > 
> > Can you update the kern-docs for seccomp_set_mode_filter(), since we
> > can now return positive values?
> > 
> >  * Returns 0 on success or -EINVAL on failure.
> > 
> > (this shoudln't say only -EINVAL, I realize too)
> 
> Sure, I can fix both of these.
> 
> > I have to say, I'm vaguely nervous about changing the semantics here
> > for passing back the fd as the return code from the seccomp() syscall.
> > Alternatives seem less appealing, though: changing the meaning of the
> > uargs parameter when SECCOMP_FILTER_FLAG_NEW_LISTENER is set, for
> > example. Hmm.
> 
> From my perspective we can drop this whole thing. The only thing I'll
> ever use is the ptrace version. Someone at some point (I don't
> remember who, maybe stgraber) suggested this version would be useful
> as well.

So I think we want to have the ability to get an fd via seccomp().
Especially, if we all we worry about are weird semantics. When we
discussed this we knew the whole patchset was going to be weird. :)

This is a seccomp feature so seccomp should - if feasible - equip you
with everything to use it in a meaningful way without having to go
through a different kernel api. I know ptrace and seccomp are
already connected but I still find this cleaner. :)

Another thing is that the container itself might be traced for some
reason while you still might want to get an fd out.

Also, I wonder what happens if you want to filter the ptrace() syscall
itself? Then you'd deadlock?

Also, it seems that getting an fd via ptrace requires CAP_SYS_ADMIN in
the inital user namespace (which I just realized now) whereas getting
the fd via seccomp() doesn't seem to.

> 
> Anyway, let me know if your nervousness outweighs this, I'm happy to
> drop it.
> 
> > > @@ -1342,3 +1520,259 @@ static int __init seccomp_sysctl_init(void)
> > >  device_initcall(seccomp_sysctl_init)
> > >
> > >  #endif /* CONFIG_SYSCTL */
> > > +
> > > +#ifdef CONFIG_SECCOMP_FILTER
> > > +static int seccomp_notify_release(struct inode *inode, struct file *file)
> > > +{
> > > +       struct seccomp_filter *filter = file->private_data;
> > > +       struct seccomp_knotif *knotif;
> > > +
> > > +       mutex_lock(&filter->notify_lock);
> > > +
> > > +       /*
> > > +        * If this file is being closed because e.g. the task who owned it
> > > +        * died, let's wake everyone up who was waiting on us.
> > > +        */
> > > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > > +               if (knotif->state == SECCOMP_NOTIFY_REPLIED)
> > > +                       continue;
> > > +
> > > +               knotif->state = SECCOMP_NOTIFY_REPLIED;
> > > +               knotif->error = -ENOSYS;
> > > +               knotif->val = 0;
> > > +
> > > +               complete(&knotif->ready);
> > > +       }
> > > +
> > > +       wake_up_all(&filter->notif->wqh);
> > > +       kfree(filter->notif);
> > > +       filter->notif = NULL;
> > > +       mutex_unlock(&filter->notify_lock);
> > 
> > It looks like that means nothing waiting on knotif->ready can access
> > filter->notif without rechecking it, yes?
> > 
> > e.g. in seccomp_do_user_notification() I see:
> > 
> >                         up(&match->notif->request);
> > 
> > I *think* this isn't reachable due to the test for n.state !=
> > SECCOMP_NOTIFY_REPLIED, though. Perhaps, just for sanity and because
> > it's not fast-path, we could add a WARN_ON() while checking for
> > unreplied signal death?
> > 
> >                 n.signaled = true;
> >                 if (n.state == SECCOMP_NOTIFY_SENT) {
> >                         n.state = SECCOMP_NOTIFY_INIT;
> >                         if (!WARN_ON(match->notif))
> >                             up(&match->notif->request);
> >                 }
> >                 mutex_unlock(&match->notify_lock);
> 
> So this code path should actually be safe, since notify_lock is held
> throughout, as it is in the release handler. However, there is one just above
> it that is not, because we do:
> 
>         mutex_unlock(&match->notify_lock);
>         up(&match->notif->request);
> 
> When this was all a member of struct seccomp_filter the order didn't matter,
> but now it very much does, and I think you're right that these statements need
> to be reordered. There maybe others, I'll check everything else as well.
> 
> > 
> > > +       __put_seccomp_filter(filter);
> > > +       return 0;
> > > +}
> > > +
> > > +static long seccomp_notify_recv(struct seccomp_filter *filter,
> > > +                               unsigned long arg)
> > > +{
> > > +       struct seccomp_knotif *knotif = NULL, *cur;
> > > +       struct seccomp_notif unotif = {};
> > > +       ssize_t ret;
> > > +       u16 size;
> > > +       void __user *buf = (void __user *)arg;
> > 
> > I'd prefer this casting happen in seccomp_notify_ioctl(). This keeps
> > anything from accidentally using "arg" directly here.
> 
> Will do.
> 
> > > +
> > > +       if (copy_from_user(&size, buf, sizeof(size)))
> > > +               return -EFAULT;
> > > +
> > > +       ret = down_interruptible(&filter->notif->request);
> > > +       if (ret < 0)
> > > +               return ret;
> > > +
> > > +       mutex_lock(&filter->notify_lock);
> > > +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> > > +               if (cur->state == SECCOMP_NOTIFY_INIT) {
> > > +                       knotif = cur;
> > > +                       break;
> > > +               }
> > > +       }
> > > +
> > > +       /*
> > > +        * If we didn't find a notification, it could be that the task was
> > > +        * interrupted between the time we were woken and when we were able to
> > > +        * acquire the rw lock.
> > > +        */
> > > +       if (!knotif) {
> > > +               ret = -ENOENT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       size = min_t(size_t, size, sizeof(unotif));
> > > +
> > 
> > It is possible (though unlikely given the type widths involved here)
> > for unotif = {} to not initialize padding, so I would recommend an
> > explicit memset(&unotif, 0, sizeof(unotif)) here.
> 
> Orly? I didn't know that, thanks.
> 
> > > +       unotif.len = size;
> > > +       unotif.id = knotif->id;
> > > +       unotif.pid = task_pid_vnr(knotif->task);
> > > +       unotif.signaled = knotif->signaled;
> > > +       unotif.data = *(knotif->data);
> > > +
> > > +       if (copy_to_user(buf, &unotif, size)) {
> > > +               ret = -EFAULT;
> > > +               goto out;
> > > +       }
> > > +
> > > +       ret = size;
> > > +       knotif->state = SECCOMP_NOTIFY_SENT;
> > > +       wake_up_poll(&filter->notif->wqh, EPOLLOUT | EPOLLWRNORM);
> > > +
> > > +
> > > +out:
> > > +       mutex_unlock(&filter->notify_lock);
> > 
> > Is there some way to rearrange the locking here to avoid holding the
> > mutex while doing copy_to_user() (which userspace could block with
> > userfaultfd, and then stall all the other notifications for this
> > filter)?
> 
> Yes, I don't think it'll cause any problems to release the lock earlier.
> 
> > > +       return ret;
> > > +}
> > > +
> > > +static long seccomp_notify_send(struct seccomp_filter *filter,
> > > +                               unsigned long arg)
> > > +{
> > > +       struct seccomp_notif_resp resp = {};
> > > +       struct seccomp_knotif *knotif = NULL;
> > > +       long ret;
> > > +       u16 size;
> > > +       void __user *buf = (void __user *)arg;
> > 
> > Same cast note as above.
> > 
> > > +
> > > +       if (copy_from_user(&size, buf, sizeof(size)))
> > > +               return -EFAULT;
> > > +       size = min_t(size_t, size, sizeof(resp));
> > > +       if (copy_from_user(&resp, buf, size))
> > > +               return -EFAULT;
> > 
> > For sanity checking on a double-read from userspace, please add:
> > 
> >     if (resp.len != size)
> >         return -EINVAL;
> 
> Won't that fail if sizeof(resp) < resp.len, because of the min_t()?
> 
> > > +static long seccomp_notify_id_valid(struct seccomp_filter *filter,
> > > +                                   unsigned long arg)
> > > +{
> > > +       struct seccomp_knotif *knotif = NULL;
> > > +       void __user *buf = (void __user *)arg;
> > > +       u64 id;
> > > +       long ret;
> > > +
> > > +       if (copy_from_user(&id, buf, sizeof(id)))
> > > +               return -EFAULT;
> > > +
> > > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > > +       if (ret < 0)
> > > +               return ret;
> > > +
> > > +       ret = -1;
> > 
> > Isn't this EPERM? Shouldn't it be -ENOENT?
> 
> Yes, I wasn't thinking of errno here, I'll switch it.
> 
> > > +       list_for_each_entry(knotif, &filter->notif->notifications, list) {
> > > +               if (knotif->id == id) {
> > > +                       ret = 0;
> > > +                       goto out;
> > > +               }
> > > +       }
> > > +
> > > +out:
> > > +       mutex_unlock(&filter->notify_lock);
> > > +       return ret;
> > > +}
> > > +
> > > +static long seccomp_notify_ioctl(struct file *file, unsigned int cmd,
> > > +                                unsigned long arg)
> > > +{
> > > +       struct seccomp_filter *filter = file->private_data;
> > > +
> > > +       switch (cmd) {
> > > +       case SECCOMP_NOTIF_RECV:
> > > +               return seccomp_notify_recv(filter, arg);
> > > +       case SECCOMP_NOTIF_SEND:
> > > +               return seccomp_notify_send(filter, arg);
> > > +       case SECCOMP_NOTIF_ID_VALID:
> > > +               return seccomp_notify_id_valid(filter, arg);
> > > +       default:
> > > +               return -EINVAL;
> > > +       }
> > > +}
> > > +
> > > +static __poll_t seccomp_notify_poll(struct file *file,
> > > +                                   struct poll_table_struct *poll_tab)
> > > +{
> > > +       struct seccomp_filter *filter = file->private_data;
> > > +       __poll_t ret = 0;
> > > +       struct seccomp_knotif *cur;
> > > +
> > > +       poll_wait(file, &filter->notif->wqh, poll_tab);
> > > +
> > > +       ret = mutex_lock_interruptible(&filter->notify_lock);
> > > +       if (ret < 0)
> > > +               return ret;
> > > +
> > > +       list_for_each_entry(cur, &filter->notif->notifications, list) {
> > > +               if (cur->state == SECCOMP_NOTIFY_INIT)
> > > +                       ret |= EPOLLIN | EPOLLRDNORM;
> > > +               if (cur->state == SECCOMP_NOTIFY_SENT)
> > > +                       ret |= EPOLLOUT | EPOLLWRNORM;
> > > +               if (ret & EPOLLIN && ret & EPOLLOUT)
> > 
> > My eyes! :) Can you wrap the bit operations in parens here?
> > 
> > > +                       break;
> > > +       }
> > 
> > Should POLLERR be handled here too? I don't quite see the conditions
> > that might be exposed? All the processes die for the filter, which
> > does what here?
> 
> I think it shouldn't do anything, because I was thinking of the semantics of
> poll() as "when a tracee does a syscall that matches, fire". So a task could
> start, never make a targeted syscall, and exit, and poll() shouldn't return a
> value. Maybe it's useful to write that down somewhere, though.
> 
> > > +       EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_RECV, &req), sizeof(req));
> > > +       EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_ID_VALID, &req.id), 0);
> > > +
> > > +       EXPECT_EQ(kill(pid, SIGKILL), 0);
> > > +       EXPECT_EQ(waitpid(pid, NULL, 0), pid);
> > > +
> > > +       EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_ID_VALID, &req.id), -1);
> > 
> > Please document SECCOMP_NOTIF_ID_VALID in seccomp_filter.rst. I had
> > been wondering what it's for, and now I see it's kind of an advisory
> > "is the other end still alive?" test.
> 
> Yes, in fact it's necessary for avoiding races. There's some comments in the
> sample code, but I'll update seccomp_filter.rst too.
> 
> > > +
> > > +       resp.id = req.id;
> > > +       ret = ioctl(listener, SECCOMP_NOTIF_SEND, &resp);
> > > +       EXPECT_EQ(ret, -1);
> > > +       EXPECT_EQ(errno, ENOENT);
> > > +
> > > +       /*
> > > +        * Check that we get another notification about a signal in the middle
> > > +        * of a syscall.
> > > +        */
> > > +       pid = fork();
> > > +       ASSERT_GE(pid, 0);
> > > +
> > > +       if (pid == 0) {
> > > +               if (signal(SIGUSR1, signal_handler) == SIG_ERR) {
> > > +                       perror("signal");
> > > +                       exit(1);
> > > +               }
> > > +               ret = syscall(__NR_getpid);
> > > +               exit(ret != USER_NOTIF_MAGIC);
> > > +       }
> > > +
> > > +       ret = read_notif(listener, &req);
> > > +       EXPECT_EQ(ret, sizeof(req));
> > > +       EXPECT_EQ(errno, 0);
> > > +
> > > +       EXPECT_EQ(kill(pid, SIGUSR1), 0);
> > > +
> > > +       ret = read_notif(listener, &req);
> > > +       EXPECT_EQ(req.signaled, 1);
> > > +       EXPECT_EQ(ret, sizeof(req));
> > > +       EXPECT_EQ(errno, 0);
> > > +
> > > +       resp.len = sizeof(resp);
> > > +       resp.id = req.id;
> > > +       resp.error = -512; /* -ERESTARTSYS */
> > > +       resp.val = 0;
> > > +
> > > +       EXPECT_EQ(ioctl(listener, SECCOMP_NOTIF_SEND, &resp), sizeof(resp));
> > > +
> > > +       ret = read_notif(listener, &req);
> > > +       resp.len = sizeof(resp);
> > > +       resp.id = req.id;
> > > +       resp.error = 0;
> > > +       resp.val = USER_NOTIF_MAGIC;
> > > +       ret = ioctl(listener, SECCOMP_NOTIF_SEND, &resp);
> > 
> > I was slightly confused here: why have there been 3 reads? I was
> > expecting one notification for hitting getpid and one from catching a
> > signal. But in rereading, I see that NOTIF_RECV will return the most
> > recently unresponded notification, yes?
> 
> The three reads are:
> 
> 1. original syscall
> # send SIGUSR1
> 2. another notif with signaled is set
> # respond with -ERESTARTSYS to make sure that works
> 3. this is the result of -ERESTARTSYS
> 
> > But... catching a signal replaces the existing seccomp_knotif? I
> > remain confused about how signal handling is meant to work here. What
> > happens if two signals get sent? It looks like you just block without
> > allowing more signals? (Thank you for writing the tests!)
> 
> Yes, that's the idea. This is an implementation of Andy's pseudocode:
> https://lkml.org/lkml/2018/3/15/1122
> 
> > (And can you document the expected behavior in the seccomp_filter.rst too?)
> 
> Will do.
> 
> > 
> > Looking good!
> 
> Thanks for your review!
> 
> Tycho
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
