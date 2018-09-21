From: Jann Horn <jannh@google.com>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Fri, 21 Sep 2018 22:46:15 +0200
Message-ID: <CAG48ez2r_q9717myRkjCeK1PQSX9q+=Xn28c0WZSBi+wFphGjA@mail.gmail.com>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
 <20180919095536.GM4672@cisco> <C1406292-7496-459F-A76A-20C9EFBB12D6@amacapital.net>
 <20180919143842.GN4672@cisco> <CALCETrVuP0nQ5B01-iWrcQ87hisz7=jA08-Uisqud_r+zc74NQ@mail.gmail.com>
 <20180920234240.GR4672@cisco> <CALCETrWEr_VAtJu1mm1akTigsRUXAA7_7RHb-WGHqnyNy=j17Q@mail.gmail.com>
 <20180921133928.GS4672@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921133928.GS4672@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, kernel list <linux-kernel@vger.kernel.org>, containers@lists.linux-foundation.org, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, suda.akihiro@lab.ntt.co.jp
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 3:39 PM Tycho Andersen <tycho@tycho.ws> wrote:
> On Thu, Sep 20, 2018 at 07:18:45PM -0700, Andy Lutomirski wrote:
> > On Thu, Sep 20, 2018 at 4:42 PM Tycho Andersen <tycho@tycho.ws> wrote:
> > > On Wed, Sep 19, 2018 at 12:58:20PM -0700, Andy Lutomirski wrote:
> > > > On Wed, Sep 19, 2018 at 7:38 AM, Tycho Andersen <tycho@tycho.ws> wr=
ote:
> > > > > On Wed, Sep 19, 2018 at 07:19:56AM -0700, Andy Lutomirski wrote:
> > > > >> Do we really allow non-=E2=80=9Ckill=E2=80=9D signals to interru=
pt the whole process?  It might be the case that we don=E2=80=99t really ne=
ed to clean up from signals if there=E2=80=99s a guarantee that the thread =
dies.
> > > > >
> > > > > Yes, we do, because of this: https://lkml.org/lkml/2018/3/15/1122
> > > > >
> > > >
> > > > I'm still not sure I see the problem.  Suppose I'm implementing a u=
ser
> > > > notifier for a nasty syscall like recvmsg().  If I'm the tracer, by
> > > > the time I decide to install an fd, I've committed to returning
> > > > something other than -EINTR, even if a non-fatal signal is sent bef=
ore
> > > > I finish.  No rollback should be necessary.
> > >
> > > I don't understand why this is true. Surely you could stop a handler
> > > on receipt of a new signal, and have it do something else entirely?
> >
> > I think you *could*, but I'm not sure why you would.  In general,
> > syscalls never execute signal handlers mid-syscall.  There is a very
> > small number of syscalls that use sys_restart_syscall(), but I don't
> > think any of them allocate fds, and I'm not sure we need or want to
> > support them with user notifiers.  The rest of the syscalls will, if
> > they're behaving correct, either do *something* (like reading some or
> > all of a buffer) and return success or they'll do nothing and return
> > -EINTR.  Or they return an -ERESTARTSYS variant.  And then, only
> > *after* the syscall logically returns (i.e. completely finishes
> > processing and puts its return code into the relevant register) will a
> > signal be delivered.  In other words, the case where something like
> > recv() gets interrupted but still returns a success code does not mean
> > that a signal handler was called and then recv() resumed.  It means
> > that recv() noticed the signal, stopped receiving, returned the number
> > of bytes read, and then allowed the signal to be delivered.
> >
> > In the -ERESTARTSYS case, the syscall returns -ERESTARTSYS (or a
> > variant) and returns without doing anything.  But it returns in a
> > special case where, after the signal returns, the syscall will happen
> > again.
> >
> > So, for user notifiers, I think that any sane handler that notices a
> > non-fatal signal will do one of these things:
> >
> >  - Return -EINTR without changing any tracee state.
> >
> >  - Return success, possibly without blocking as long as it would have
> > without the signal.
> >
> >  - Return -ERESTARTSYS without changing any tracee state.
> >
> >  - Kill the tracee.
> >
> > None of these would involve backing out an fd that was already
> > installed.  I suppose another way of looking at this is that.
> >
> > Although... now that I think about it, there are some special cases,
> > like socketpair().  Look for put_unused_fd().  So maybe we need to
> > expose get_unused_fd_flags() and put_unused_fd(), but I think that
> > these are exceptions and will be very uncommon in the context of
> > seccomp user notifiers.  (For example, socketpair() can be implemented
> > almost correctly without put_unused_fd().)
>
> socketpair() is a good point. In particular, if we use this queuing
> thing I've done above, then you can only ever send one fd, and you'll
> need to send two here. So perhaps we really do need to do this as soon
> as the tracer calls ioctl(), vs queuing and waiting.
>
> > Hmm.  This does mean that we need a test case for a user notifier
> > returning -ERESTARTSYS.  It should Just Work (tm), but those are
> > famous last words.
> >
> > -ERESTARTSYS_RESTARTBLOCK is the case that I don't think we need to wor=
ry about.
> >
> > >
> > > > In the (unlikely?) event that some tracer needs to be able to rollb=
ack
> > > > an fd installation to return -EINTR, a SECCOMP_NOTIF_CLOSE_FD
> > > > operation should be good enough, I think.  Or maybe PUT_FD can put =
-1
> > > > to delete an fd.
> > >
> > > Yes, I think even with something like what I did below we'd need some
> > > sort of REMOVE_FD option, because otherwise there's no way to change
> > > your mind and send -EINTR without the fd you just PUT_FD'd.
> > >
> >
> > I think we just want the operation to cover all the cases.  Let PUT_FD
> > take a source fd and a dest fd.  If the source fd is -1, the dest is
> > closed.  If the source is -1 and the dest is -1, return -EINVAL.  If
> > the dest is -1, allocate an fd.  If the dest is >=3D 0, work like
> > dup2().  (The latter could be necessary to emulate things like, say,
> > dup2 :))
>
> ...then if we're going to allow overwriting fds, we'd need to lift out
> the logic from do_dup2 somewhere? Is this getting too complicated? :)

In particular if you end up allowing overwriting fds of a remote task,
please add a scary warning to the code that does that, informing the
reader that that's only safe because you know that the target task is
stopped outside syscall context, and that it would be a very bad idea
to just copypaste that code to somewhere else. If someone tried doing
that to a single-threaded task that's in the middle of a syscall, the
results would be interesting - and by "interesting", I mean
"use-after-free on a struct file".
