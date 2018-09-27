From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from
 ptrace
Date: Thu, 27 Sep 2018 10:34:37 -0600
Message-ID: <20180927163437.GA30761@cisco.cisco.com>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-4-tycho@tycho.ws>
 <CAG48ez0V--kdYh5-tqLJxu=+jOLLjJ65QdGoqoJMdySCDw2CzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez0V--kdYh5-tqLJxu=+jOLLjJ65QdGoqoJMdySCDw2CzQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 27, 2018 at 06:20:23PM +0200, Jann Horn wrote:
> On Thu, Sep 27, 2018 at 5:11 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> > version which can acquire filters is useful. There are at least two reasons
> > this is preferable, even though it uses ptrace:
> >
> > 1. You can control tasks that aren't cooperating with you
> > 2. You can control tasks whose filters block sendmsg() and socket(); if the
> >    task installs a filter which blocks these calls, there's no way with
> >    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.
> >
> > v2: fix a bug where listener mode was not unset when an unused fd was not
> >     available
> > v3: fix refcounting bug (Oleg)
> > v4: * change the listener's fd flags to be 0
> >     * rename GET_LISTENER to NEW_LISTENER (Matthew)
> > v5: * add capable(CAP_SYS_ADMIN) requirement
> > v7: * point the new listener at the right filter (Jann)
> >
> > Signed-off-by: Tycho Andersen <tycho@tycho.ws>
> > CC: Kees Cook <keescook@chromium.org>
> > CC: Andy Lutomirski <luto@amacapital.net>
> > CC: Oleg Nesterov <oleg@redhat.com>
> > CC: Eric W. Biederman <ebiederm@xmission.com>
> > CC: "Serge E. Hallyn" <serge@hallyn.com>
> > CC: Christian Brauner <christian.brauner@ubuntu.com>
> > CC: Tyler Hicks <tyhicks@canonical.com>
> > CC: Akihiro Suda <suda.akihiro@lab.ntt.co.jp>
> 
> If you address the two nits below, you can add:
> Reviewed-by: Jann Horn <jannh@google.com>

Thanks!

> >  include/linux/seccomp.h                       |  7 ++
> >  include/uapi/linux/ptrace.h                   |  2 +
> >  kernel/ptrace.c                               |  4 ++
> >  kernel/seccomp.c                              | 31 +++++++++
> >  tools/testing/selftests/seccomp/seccomp_bpf.c | 68 +++++++++++++++++++
> >  5 files changed, 112 insertions(+)
> >
> > diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> > index 017444b5efed..234c61b37405 100644
> > --- a/include/linux/seccomp.h
> > +++ b/include/linux/seccomp.h
> > @@ -83,6 +83,8 @@ static inline int seccomp_mode(struct seccomp *s)
> >  #ifdef CONFIG_SECCOMP_FILTER
> >  extern void put_seccomp_filter(struct task_struct *tsk);
> >  extern void get_seccomp_filter(struct task_struct *tsk);
> > +extern long seccomp_new_listener(struct task_struct *task,
> > +                                unsigned long filter_off);
> 
> Nit: Sorry, I only noticed this just now, but this should have return
> type int, not long. ptrace_request() returns an int, and an fd is also
> normally represented as an int, not a long.

Ugh, I could have sworn I checked this. In particular because the
other seccomp code that's called from ptrace returns a long too :)

I'll fix that for the next version, and send a different patch for the
other two.

> >  #else  /* CONFIG_SECCOMP_FILTER */
> >  static inline void put_seccomp_filter(struct task_struct *tsk)
> >  {
> > @@ -92,6 +94,11 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
> >  {
> >         return;
> >  }
> > +static inline long seccomp_new_listener(struct task_struct *task,
> > +                                       unsigned long filter_off)
> > +{
> > +       return -EINVAL;
> > +}
> >  #endif /* CONFIG_SECCOMP_FILTER */
> >
> >  #if defined(CONFIG_SECCOMP_FILTER) && defined(CONFIG_CHECKPOINT_RESTORE)
> > diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
> > index d5a1b8a492b9..e80ecb1bd427 100644
> > --- a/include/uapi/linux/ptrace.h
> > +++ b/include/uapi/linux/ptrace.h
> > @@ -73,6 +73,8 @@ struct seccomp_metadata {
> >         __u64 flags;            /* Output: filter's flags */
> >  };
> >
> > +#define PTRACE_SECCOMP_NEW_LISTENER    0x420e
> > +
> >  /* Read signals from a shared (process wide) queue */
> >  #define PTRACE_PEEKSIGINFO_SHARED      (1 << 0)
> >
> > diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> > index 21fec73d45d4..289960ac181b 100644
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -1096,6 +1096,10 @@ int ptrace_request(struct task_struct *child, long request,
> >                 ret = seccomp_get_metadata(child, addr, datavp);
> >                 break;
> >
> > +       case PTRACE_SECCOMP_NEW_LISTENER:
> > +               ret = seccomp_new_listener(child, addr);
> > +               break;
> > +
> >         default:
> >                 break;
> >         }
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index 44a31ac8373a..17685803a2af 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -1777,4 +1777,35 @@ static struct file *init_listener(struct task_struct *task,
> >
> >         return ret;
> >  }
> > +
> > +long seccomp_new_listener(struct task_struct *task,
> > +                         unsigned long filter_off)
> > +{
> > +       struct seccomp_filter *filter;
> > +       struct file *listener;
> > +       int fd;
> > +
> > +       if (!capable(CAP_SYS_ADMIN))
> > +               return -EACCES;
> > +
> > +       filter = get_nth_filter(task, filter_off);
> > +       if (IS_ERR(filter))
> > +               return PTR_ERR(filter);
> > +
> > +       fd = get_unused_fd_flags(0);
> 
> s/0/O_CLOEXEC/ ? If userspace needs a non-cloexec fd, userspace can
> easily unset O_CLOEXEC; but the reverse isn't true, because it'd be
> racy.

Sure, will do.

Tycho
