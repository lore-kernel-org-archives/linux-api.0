From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from
 ptrace
Date: Mon, 8 Oct 2018 18:21:48 +0200
Message-ID: <20181008162147.ubfxxsv2425l2zsp@brauner.io>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-4-tycho@tycho.ws>
 <20181008151629.hkgzzsluevwtuclw@brauner.io>
 <CAG48ez3zaqOXH_jHN8=+jXjOf3vhFyWUkM_6KLPi9T8HcQySeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3zaqOXH_jHN8=+jXjOf3vhFyWUkM_6KLPi9T8HcQySeg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 08, 2018 at 05:33:22PM +0200, Jann Horn wrote:
> On Mon, Oct 8, 2018 at 5:16 PM Christian Brauner <christian@brauner.io> wrote:
> >
> > On Thu, Sep 27, 2018 at 09:11:16AM -0600, Tycho Andersen wrote:
> > > As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> > > version which can acquire filters is useful. There are at least two reasons
> > > this is preferable, even though it uses ptrace:
> > >
> > > 1. You can control tasks that aren't cooperating with you
> > > 2. You can control tasks whose filters block sendmsg() and socket(); if the
> > >    task installs a filter which blocks these calls, there's no way with
> > >    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.
> >
> > So for the slow of mind aka me:
> > I'm not sure I completely understand this problem. Can you outline how
> > sendmsg() and socket() are involved in this?
> >
> > I'm also not sure that this holds (but I might misunderstand the
> > problem) afaict, you could do try to get the fd out via CLONE_FILES and
> > other means so something like:
> >
> > // let's pretend the libc wrapper for clone actually has sane semantics
> > pid = clone(CLONE_FILES);
> > if (pid == 0) {
> >         fd = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_NEW_LISTENER, &prog);
> >
> >         // Now this fd will be valid in both parent and child.
> >         // If you haven't blocked it you can inform the parent what
> >         // the fd number is via pipe2(). If you have blocked it you can
> >         // use dup2() and dup to a known fd number.
> > }
> >
> > >
> > > v2: fix a bug where listener mode was not unset when an unused fd was not
> > >     available
> > > v3: fix refcounting bug (Oleg)
> > > v4: * change the listener's fd flags to be 0
> > >     * rename GET_LISTENER to NEW_LISTENER (Matthew)
> > > v5: * add capable(CAP_SYS_ADMIN) requirement
> > > v7: * point the new listener at the right filter (Jann)
> > >
> > > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > > CC: Kees Cook <keescook@chromium.org>
> > > CC: Andy Lutomirski <luto@amacapital.net>
> > > CC: Oleg Nesterov <oleg@redhat.com>
> > > CC: Eric W. Biederman <ebiederm@xmission.com>
> > > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > > CC: Christian Brauner <christian.brauner@ubuntu.com>
> > > CC: Tyler Hicks <tyhicks@canonical.com>
> > > CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> > > ---
> > >  include/linux/seccomp.h                       |  7 ++
> > >  include/uapi/linux/ptrace.h                   |  2 +
> > >  kernel/ptrace.c                               |  4 ++
> > >  kernel/seccomp.c                              | 31 +++++++++
> > >  tools/testing/selftests/seccomp/seccomp_bpf.c | 68 +++++++++++++++++++
> > >  5 files changed, 112 insertions(+)
> > >
> > > diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> > > index 017444b5efed..234c61b37405 100644
> > > --- a/include/linux/seccomp.h
> > > +++ b/include/linux/seccomp.h
> > > @@ -83,6 +83,8 @@ static inline int seccomp_mode(struct seccomp *s)
> > >  #ifdef CONFIG_SECCOMP_FILTER
> > >  extern void put_seccomp_filter(struct task_struct *tsk);
> > >  extern void get_seccomp_filter(struct task_struct *tsk);
> > > +extern long seccomp_new_listener(struct task_struct *task,
> > > +                              unsigned long filter_off);
> > >  #else  /* CONFIG_SECCOMP_FILTER */
> > >  static inline void put_seccomp_filter(struct task_struct *tsk)
> > >  {
> > > @@ -92,6 +94,11 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
> > >  {
> > >       return;
> > >  }
> > > +static inline long seccomp_new_listener(struct task_struct *task,
> > > +                                     unsigned long filter_off)
> > > +{
> > > +     return -EINVAL;
> > > +}
> > >  #endif /* CONFIG_SECCOMP_FILTER */
> > >
> > >  #if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> > > diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> > > index d5a1b8a492b9..e80ecb1bd427 100644
> > > --- a/include/uapi/linux/ptrace.h
> > > +++ b/include/uapi/linux/ptrace.h
> > > @@ -73,6 +73,8 @@ struct seccomp_metadata {
> > >       __u64 flags;            /* Output: filter's flags */
> > >  };
> > >
> > > +#define PTRACE_SECCOMP_NEW_LISTENER  0x420e
> > > +
> > >  /* Read signals from a shared (process wide) queue */
> > >  #define PTRACE_PEEKSIGINFO_SHARED    (1 << 0)
> > >
> > > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > > index 21fec73d45d4..289960ac181b 100644
> > > --- a/kernel/ptrace.c
> > > +++ b/kernel/ptrace.c
> > > @@ -1096,6 +1096,10 @@ int ptrace_request(struct task_struct *child, long request,
> > >               ret = seccomp_get_metadata(child, addr, datavp);
> > >               break;
> > >
> > > +     case PTRACE_SECCOMP_NEW_LISTENER:
> > > +             ret = seccomp_new_listener(child, addr);
> > > +             break;
> > > +
> > >       default:
> > >               break;
> > >       }
> > > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > > index 44a31ac8373a..17685803a2af 100644
> > > --- a/kernel/seccomp.c
> > > +++ b/kernel/seccomp.c
> > > @@ -1777,4 +1777,35 @@ static struct file *init_listener(struct task_struct *task,
> > >
> > >       return ret;
> > >  }
> > > +
> > > +long seccomp_new_listener(struct task_struct *task,
> > > +                       unsigned long filter_off)
> > > +{
> > > +     struct seccomp_filter *filter;
> > > +     struct file *listener;
> > > +     int fd;
> > > +
> > > +     if (!capable(CAP_SYS_ADMIN))
> > > +             return -EACCES;
> >
> > I know this might have been discussed a while back but why exactly do we
> > require CAP_SYS_ADMIN in init_userns and not in the target userns? What
> > if I want to do a setns()fd, CLONE_NEWUSER) to the target process and
> > use ptrace from in there?
> 
> See https://lore.kernel.org/lkml/CAG48ez3R+ZJ1vwGkDfGzKX2mz6f=jjJWsO5pCvnH68P+RKO8Ow@mail.gmail.com/
> . Basically, the problem is that this doesn't just give you capability
> over the target task, but also over every other task that has the same
> filter installed; you need some sort of "is the caller capable over
> the filter and anyone who uses it" check.

Thanks.
But then this new ptrace feature as it stands is imho currently broken.
If you can install a seccomp filter with SECCOMP_RET_USER_NOTIF if you
are ns_cpabable(CAP_SYS_ADMIN) and also get an fd via seccomp() itself
if you are ns_cpabable(CAP_SYS_ADMIN) then either the new ptrace() api
extension should be fixed to allow for this too or the seccomp() way of
retrieving the pid - which I really think we want - needs to be fixed to
require capable(CAP_SYS_ADMIN) too.
The solution where both require ns_capable(CAP_SYS_ADMIN) is - imho -
the preferred way to solve this.
Everything else will just be confusing.
