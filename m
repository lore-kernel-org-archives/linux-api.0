From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from ptrace
Date: Tue, 9 Oct 2018 14:39:53 +0200
Message-ID: <CAG48ez3PEce4ynRnDk=yfsAOuFGH=YMmuf13CAxEt07Yjk3ZCw@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <20180927151119.9989-4-tycho@tycho.ws>
 <20181008151629.hkgzzsluevwtuclw@brauner.io> <CAG48ez3zaqOXH_jHN8=+jXjOf3vhFyWUkM_6KLPi9T8HcQySeg@mail.gmail.com>
 <20181008162147.ubfxxsv2425l2zsp@brauner.io> <CAG48ez3O+wAkq+0yDfoMt73ybnCOEPpi3Mu-uF57_v=6hA8ZEw@mail.gmail.com>
 <20181008181815.pwnqxngj22mhm2vj@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181008181815.pwnqxngj22mhm2vj@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: christian@brauner.io
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, containers@lists.linux-foundation.org, suda.akihiro@lab.ntt.co.jp, Oleg Nesterov <oleg@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org, Christian Brauner <christian.brauner@ubuntu.com>, Andy Lutomirski <luto@amacapital.net>, linux-security-module <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 8, 2018 at 8:18 PM Christian Brauner <christian@brauner.io> wrote:
> On Mon, Oct 08, 2018 at 06:42:00PM +0200, Jann Horn wrote:
> > On Mon, Oct 8, 2018 at 6:21 PM Christian Brauner <christian@brauner.io> wrote:
> > > On Mon, Oct 08, 2018 at 05:33:22PM +0200, Jann Horn wrote:
> > > > On Mon, Oct 8, 2018 at 5:16 PM Christian Brauner <christian@brauner.io> wrote:
> > > > > On Thu, Sep 27, 2018 at 09:11:16AM -0600, Tycho Andersen wrote:
> > > > > > diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> > > > > > index 44a31ac8373a..17685803a2af 100644
> > > > > > --- a/kernel/seccomp.c
> > > > > > +++ b/kernel/seccomp.c
> > > > > > @@ -1777,4 +1777,35 @@ static struct file *init_listener(struct task_struct *task,
> > > > > >
> > > > > >       return ret;
> > > > > >  }
> > > > > > +
> > > > > > +long seccomp_new_listener(struct task_struct *task,
> > > > > > +                       unsigned long filter_off)
> > > > > > +{
> > > > > > +     struct seccomp_filter *filter;
> > > > > > +     struct file *listener;
> > > > > > +     int fd;
> > > > > > +
> > > > > > +     if (!capable(CAP_SYS_ADMIN))
> > > > > > +             return -EACCES;
> > > > >
> > > > > I know this might have been discussed a while back but why exactly do we
> > > > > require CAP_SYS_ADMIN in init_userns and not in the target userns? What
> > > > > if I want to do a setns()fd, CLONE_NEWUSER) to the target process and
> > > > > use ptrace from in there?
> > > >
> > > > See https://lore.kernel.org/lkml/CAG48ez3R+ZJ1vwGkDfGzKX2mz6f=jjJWsO5pCvnH68P+RKO8Ow@mail.gmail.com/
> > > > . Basically, the problem is that this doesn't just give you capability
> > > > over the target task, but also over every other task that has the same
> > > > filter installed; you need some sort of "is the caller capable over
> > > > the filter and anyone who uses it" check.
> > >
> > > Thanks.
> > > But then this new ptrace feature as it stands is imho currently broken.
> > > If you can install a seccomp filter with SECCOMP_RET_USER_NOTIF if you
> > > are ns_cpabable(CAP_SYS_ADMIN) and also get an fd via seccomp() itself
> > > if you are ns_cpabable(CAP_SYS_ADMIN)

Actually, you don't need CAP_SYS_ADMIN for seccomp() at all as long as
you enable the NNP flag, I think?

> > > then either the new ptrace() api
> > > extension should be fixed to allow for this too or the seccomp() way of
> > > retrieving the pid - which I really think we want - needs to be fixed to
> > > require capable(CAP_SYS_ADMIN) too.
> > > The solution where both require ns_capable(CAP_SYS_ADMIN) is - imho -
> > > the preferred way to solve this.
> > > Everything else will just be confusing.
> >
> > First you say "broken", then you say "confusing". Which one do you mean?
>
> Both. It's broken in so far as it places a seemingly unnecessary
> restriction that could be fixed. You outlined one possible fix yourself
> in the link you provided.

If by "possible fix" you mean "check whether the seccomp filter is
only attached to a single task": That wouldn't fundamentally change
the situation, it would only add an additional special case.

> And it's confusing in so far as there is a way
> via seccomp() to get the fd without said requirement.

I don't find it confusing at all. seccomp() and ptrace() are very
different situations: When you use seccomp(), infrastructure is
already in place for ensuring that your filter is only applied to
processes over which you are capable, and propagation is limited by
inheritance from your task down. When you use ptrace(), you need a
pretty different sort of access check that checks whether you're
privileged over ancestors, siblings and so on of the target task.

But thinking about it more, I think that CAP_SYS_ADMIN over the saved
current->mm->user_ns of the task that installed the filter (stored as
a "struct user_namespace *" in the filter) should be acceptable.
