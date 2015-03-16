From: josh@joshtriplett.org
Subject: Re: [PATCH v2 0/7] CLONE_FD: Task exit notification via file
 descriptor
Date: Mon, 16 Mar 2015 16:35:34 -0700
Message-ID: <20150316233533.GC31751@cloud>
References: <cover.1426376419.git.josh@joshtriplett.org>
 <CAGXu5jLmLLgVNCP=cyUiXuiszVXsS88SNUK2iBqArbA2V6vdHA@mail.gmail.com>
 <2381173.VxaIO6vGG3@tjmaciei-mobl4>
 <CAGXu5jJr_DieZ281=H0ZNtNvOagO0pm8PRfNvRWKp4YwS=55GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJr_DieZ281=H0ZNtNvOagO0pm8PRfNvRWKp4YwS=55GA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Thiago Macieira <thiago.macieira@intel.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 16, 2015 at 03:36:16PM -0700, Kees Cook wrote:
> On Mon, Mar 16, 2015 at 3:14 PM, Thiago Macieira
> <thiago.macieira@intel.com> wrote:
> > On Monday 16 March 2015 14:44:20 Kees Cook wrote:
> >> >               O_CLOEXEC
> >> >                      Set  the  close-on-exec  flag on the new file
> >> >descriptor. See the description of the O_CLOEXEC flag in open(2)  for
> >> >reasons why this may be useful.
> >>
> >> This begs the question: what happens when all CLONE_FD fds for a
> >> process are closed? Will the parent get SIGCHLD instead, will it
> >> auto-reap, or will it be un-wait-able (I assume not this...)
> >
> > Depends on CLONE_AUTOREAP. If it's on, then no one gets SIGCHLD, no one can
> > wait() on it and the process autoreaps itself.
> >
> > If it's no active, then the old rules apply: parent gets SIGCHILD and can
> > wait(). If the parent exited first, then the child gets reparented to init,
> > which can do the wait().
> >
> > A child without CLONE_AUTOREAP should be wait()able. If it gets wait()ed
> > before the clonefd is read, the clonefd() will return a 0 read. If it gets
> > read before wait, then wait() reaps another child or returns -ECHILD. That's
> > no different than two threads doing simultaneous wait() on the same child.
> 
> Cool. I think detailing this in the manpage would be helpful.
> 
> And just so I understand the races here, what happens in CLONE_FD
> (without CLONE_AUTOREAP) case where the child dies, but the parent
> never reads from the CLONE_FD fd, and closes it (or dies)? Will the
> modes switch that late in the child's lifetime? (i.e. even though the
> details were written to the fd, they were never read, yet it'll still
> switch and generate a SIGCHLD, etc?)

This doesn't actually work like a pipe; the details aren't "written" to
the fd.  The data is generated at read time, and if you never read,
that's fine.  There's no semantic meaning attached to reading from the
clonefd; you still have to wait on the process if you don't pass
CLONE_AUTOREAP.  (Or you can block SIGCHLD or use SA_NOCLDWAIT, if you
control the calling process's signal handling; AUTOREAP just lets you
avoid interacting with the calling process's signal handling.)

See my previous response for the rest.

- Josh Triplett
