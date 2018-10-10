From: Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v7 3/6] seccomp: add a way to get a listener fd from
 ptrace
Date: Wed, 10 Oct 2018 20:26:30 +0200
Message-ID: <20181010182628.hgprnywup4wgmycg@brauner.io>
References: <20180927151119.9989-1-tycho@tycho.ws>
 <20180927151119.9989-4-tycho@tycho.ws>
 <20181008151629.hkgzzsluevwtuclw@brauner.io>
 <20181008180043.GE28238@cisco.lan>
 <CALCETrVtkvG1NihqMF4qMhhtcXFuLbwS2DW=C5F=Lp5riMa9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVtkvG1NihqMF4qMhhtcXFuLbwS2DW=C5F=Lp5riMa9dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Linux API <linux-api@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>
List-Id: linux-api@vger.kernel.org

On Wed, Oct 10, 2018 at 10:45:29AM -0700, Andy Lutomirski wrote:
> On Mon, Oct 8, 2018 at 11:00 AM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Mon, Oct 08, 2018 at 05:16:30PM +0200, Christian Brauner wrote:
> > > On Thu, Sep 27, 2018 at 09:11:16AM -0600, Tycho Andersen wrote:
> > > > As an alternative to SECCOMP_FILTER_FLAG_GET_LISTENER, perhaps a ptrace()
> > > > version which can acquire filters is useful. There are at least two reasons
> > > > this is preferable, even though it uses ptrace:
> > > >
> > > > 1. You can control tasks that aren't cooperating with you
> > > > 2. You can control tasks whose filters block sendmsg() and socket(); if the
> > > >    task installs a filter which blocks these calls, there's no way with
> > > >    SECCOMP_FILTER_FLAG_GET_LISTENER to get the fd out to the privileged task.
> > >
> > > So for the slow of mind aka me:
> > > I'm not sure I completely understand this problem. Can you outline how
> > > sendmsg() and socket() are involved in this?
> > >
> > > I'm also not sure that this holds (but I might misunderstand the
> > > problem) afaict, you could do try to get the fd out via CLONE_FILES and
> > > other means so something like:
> > >
> > > // let's pretend the libc wrapper for clone actually has sane semantics
> > > pid = clone(CLONE_FILES);
> > > if (pid == 0) {
> > >         fd = seccomp(SECCOMP_SET_MODE_FILTER, SECCOMP_FILTER_FLAG_NEW_LISTENER, &prog);
> > >
> > >         // Now this fd will be valid in both parent and child.
> > >         // If you haven't blocked it you can inform the parent what
> > >         // the fd number is via pipe2(). If you have blocked it you can
> > >         // use dup2() and dup to a known fd number.
> > > }
> >
> > But what if your seccomp filter wants to block both pipe2() and
> > dup2()? Whatever syscall you want to use to do this could be blocked
> > by some seccomp policy, which means you might not be able to use this
> > feature in some cases.
> 
> You don't need a syscall at all. You can use shared memory.

Yeah, I pointed that out too in the next mail. :)

> 
> >
> > Perhaps it's unlikely, and we can just go forward knowing this. But it
> > seems like it is worth at least acknowledging that you can wedge
> > yourself into a corner.
> >
> 
> I think that what we *really* want is a way to create a seccomp fitter

I thought about this exact thing when discussing my reservations about
ptrace() but I didn't want to defer this patchset any longer. But I
really like this idea of being able to get an fd *before* the filter is
loaded.

> and activate it later (on execve or via another call to seccomp(),
> perhaps).  And we already sort of have that using ptrace() but a
> better interface would be nice when a real use case gets figured out.
