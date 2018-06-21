From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v4 3/4] seccomp: add a way to get a listener fd from
 ptrace
Date: Thu, 21 Jun 2018 17:07:55 -0600
Message-ID: <20180621230755.GI3992@cisco>
References: <20180621220416.5412-1-tycho@tycho.ws>
 <20180621220416.5412-4-tycho@tycho.ws>
 <CAG48ez3R+ZJ1vwGkDfGzKX2mz6f=jjJWsO5pCvnH68P+RKO8Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG48ez3R+ZJ1vwGkDfGzKX2mz6f=jjJWsO5pCvnH68P+RKO8Ow@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp, "Tobin C. Harding" <me@tobin.cc>
List-Id: linux-api@vger.kernel.org

Hi Jann,

On Fri, Jun 22, 2018 at 12:48:09AM +0200, Jann Horn wrote:
> On Fri, Jun 22, 2018 at 12:04 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> > version which can acquire filters is useful. There are at least two reasons
> > this is preferable, even though it uses ptrace:
> >
> > 1. You can control tasks that aren't cooperating with you
> > 2. You can control tasks whose filters block sendmsg() and socket(); if the
> >    task installs a filter which blocks these calls, there's no way with
> >    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.
> [...]
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > index bbc24938c51d..b68a5d4a15cd 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -1743,6 +1743,34 @@ static struct file *init_listener(struct task_struct *task,
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
> > +       filter = get_nth_filter(task, filter_off);
> > +       if (IS_ERR(filter))
> > +               return PTR_ERR(filter);
> > +
> > +       fd = get_unused_fd_flags(0);
> > +       if (fd < 0) {
> > +               __put_seccomp_filter(filter);
> > +               return fd;
> > +       }
> > +
> > +       listener = init_listener(task, task->seccomp.filter);
> > +       __put_seccomp_filter(filter);
> > +       if (IS_ERR(listener)) {
> > +               put_unused_fd(fd);
> > +               return PTR_ERR(listener);
> > +       }
> > +
> > +       fd_install(fd, listener);
> > +       return fd;
> > +}
> 
> I think there's a security problem here. Imagine the following scenario:
> 
> 1. task A (uid==0) sets up a seccomp filter that uses SECCOMP_RET_USER_NOTIF
> 2. task A forks off a child B
> 3. task B uses setuid(1) to drop its privileges
> 4. task B becomes dumpable again, either via prctl(PR_SET_DUMPABLE, 1)
> or via execve()
> 5. task C (the attacker, uid==1) attaches to task B via ptrace
> 6. task C uses PTRACE_SECCOMP_NEW_LISTENER on task B
> 7. because the seccomp filter is shared by task A and task B, task C
> is now able to influence syscall results for syscalls performed by
> task A
> 
> Unless I'm missing something, you might have to add some extra
> security check here: Either a check to ensure that no other task is
> using the same seccomp filter, or (as a last resort) a check for
> capable(CAP_SYS_ADMIN).

I guess my first thought is "don't do that". But I am also not opposed
to adding a check for capable(CAP_SYS_ADMIN) to prevent the footgun,
so I can do that for v5. I think checking whether other tasks are
using a filter would be hard without adding some additional counter
logic or something, and at least for the use cases I know of,
capable(CAP_SYS_ADMIN) is fine.

Tycho
