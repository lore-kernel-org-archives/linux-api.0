From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via
 USER_NOTIF
Date: Fri, 21 Sep 2018 07:39:28 -0600
Message-ID: <20180921133928.GS4672@cisco>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
 <20180919095536.GM4672@cisco>
 <C1406292-7496-459F-A76A-20C9EFBB12D6@amacapital.net>
 <20180919143842.GN4672@cisco>
 <CALCETrVuP0nQ5B01-iWrcQ87hisz7=jA08-Uisqud_r+zc74NQ@mail.gmail.com>
 <20180920234240.GR4672@cisco>
 <CALCETrWEr_VAtJu1mm1akTigsRUXAA7_7RHb-WGHqnyNy=j17Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWEr_VAtJu1mm1akTigsRUXAA7_7RHb-WGHqnyNy=j17Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 20, 2018 at 07:18:45PM -0700, Andy Lutomirski wrote:
> On Thu, Sep 20, 2018 at 4:42 PM Tycho Andersen <tycho@tycho.ws> wrote:
> >
> > On Wed, Sep 19, 2018 at 12:58:20PM -0700, Andy Lutomirski wrote:
> > > On Wed, Sep 19, 2018 at 7:38 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > > On Wed, Sep 19, 2018 at 07:19:56AM -0700, Andy Lutomirski wrote:
> > > >>
> > > >>
> > > >> > On Sep 19, 2018, at 2:55 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > >> >
> > > >> >> On Wed, Sep 12, 2018 at 04:52:38PM -0700, Andy Lutomirski wrote:
> > > >> >>> On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > >> >>> The idea here is that the userspace handler should be able to pass an fd
> > > >> >>> back to the trapped task, for example so it can be returned from socket().
> > > >> >>>
> > > >> >>> I've proposed one API here, but I'm open to other options. In particular,
> > > >> >>> this only lets you return an fd from a syscall, which may not be enough in
> > > >> >>> all cases. For example, if an fd is written to an output parameter instead
> > > >> >>> of returned, the current API can't handle this. Another case is that
> > > >> >>> netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
> > > >> >>> ever decides to install an fd and output it, we wouldn't be able to handle
> > > >> >>> this either.
> > > >> >>
> > > >> >> An alternative could be to have an API (an ioctl on the listener,
> > > >> >> perhaps) that just copies an fd into the tracee.  There would be the
> > > >> >> obvious set of options: do we replace an existing fd or allocate a new
> > > >> >> one, and is it CLOEXEC.  Then the tracer could add an fd and then
> > > >> >> return it just like it's a regular number.
> > > >> >>
> > > >> >> I feel like this would be more flexible and conceptually simpler, but
> > > >> >> maybe a little slower for the common cases.  What do you think?
> > > >> >
> > > >> > I'm just implementing this now, and there's one question: when do we
> > > >> > actually do the fd install? Should we do it when the user calls
> > > >> > SECCOMP_NOTIF_PUT_FD, or when the actual response is sent? It feels
> > > >> > like we should do it when the response is sent, instead of doing it
> > > >> > right when SECCOMP_NOTIF_PUT_FD is called, since if there's a
> > > >> > subsequent signal and the tracer decides to discard the response,
> > > >> > we'll have to implement some delete mechanism to delete the fd, but it
> > > >> > would have already been visible to the process, etc. So I'll go
> > > >> > forward with this unless there are strong objections, but I thought
> > > >> > I'd point it out just to avoid another round trip.
> > > >> >
> > > >> >
> > > >>
> > > >> Can you do that non-racily?  That is, you need to commit to an fd *number* right away, but what if another thread uses the number before you actually install the fd?
> > > >
> > > > I was thinking we could just do an __alloc_fd() and then do the
> > > > fd_install() when the response is sent or clean up the case that the
> > > > listener or task dies. I haven't actually tried to run the code yet,
> > > > so it's possible the locking won't work :)
> > >
> > > I would be very surprised if the locking works.  How can you run a
> > > thread in a process when another thread has allocated but not
> > > installed an fd and is blocked for an arbitrarily long time?
> >
> > I think the trick is that there's no actual locking required (except
> > for a brief locking of task->files). I've run the patch below and it
> > seems to work. But perhaps that's abusing __alloc_fd a little too
> > hard, I don't really know.
> >
> 
> Hmm.  This makes me highly nervous.  If nothing else, what releases
> the busy-but-not-open fd if the whole process aborts?

Nothing right now, it gets installed even though the syscall gets
-ENOSYS. So not ideal, but that's why I was thinking we needed some
form of delete support. But,

> > > >
> > > >> Do we really allow non-“kill” signals to interrupt the whole process?  It might be the case that we don’t really need to clean up from signals if there’s a guarantee that the thread dies.
> > > >
> > > > Yes, we do, because of this: https://lkml.org/lkml/2018/3/15/1122
> > > >
> > >
> > > I'm still not sure I see the problem.  Suppose I'm implementing a user
> > > notifier for a nasty syscall like recvmsg().  If I'm the tracer, by
> > > the time I decide to install an fd, I've committed to returning
> > > something other than -EINTR, even if a non-fatal signal is sent before
> > > I finish.  No rollback should be necessary.
> >
> > I don't understand why this is true. Surely you could stop a handler
> > on receipt of a new signal, and have it do something else entirely?
> 
> I think you *could*, but I'm not sure why you would.  In general,
> syscalls never execute signal handlers mid-syscall.  There is a very
> small number of syscalls that use sys_restart_syscall(), but I don't
> think any of them allocate fds, and I'm not sure we need or want to
> support them with user notifiers.  The rest of the syscalls will, if
> they're behaving correct, either do *something* (like reading some or
> all of a buffer) and return success or they'll do nothing and return
> -EINTR.  Or they return an -ERESTARTSYS variant.  And then, only
> *after* the syscall logically returns (i.e. completely finishes
> processing and puts its return code into the relevant register) will a
> signal be delivered.  In other words, the case where something like
> recv() gets interrupted but still returns a success code does not mean
> that a signal handler was called and then recv() resumed.  It means
> that recv() noticed the signal, stopped receiving, returned the number
> of bytes read, and then allowed the signal to be delivered.
> 
> In the -ERESTARTSYS case, the syscall returns -ERESTARTSYS (or a
> variant) and returns without doing anything.  But it returns in a
> special case where, after the signal returns, the syscall will happen
> again.
> 
> So, for user notifiers, I think that any sane handler that notices a
> non-fatal signal will do one of these things:
> 
>  - Return -EINTR without changing any tracee state.
> 
>  - Return success, possibly without blocking as long as it would have
> without the signal.
> 
>  - Return -ERESTARTSYS without changing any tracee state.
> 
>  - Kill the tracee.
> 
> None of these would involve backing out an fd that was already
> installed.  I suppose another way of looking at this is that.
> 
> Although... now that I think about it, there are some special cases,
> like socketpair().  Look for put_unused_fd().  So maybe we need to
> expose get_unused_fd_flags() and put_unused_fd(), but I think that
> these are exceptions and will be very uncommon in the context of
> seccomp user notifiers.  (For example, socketpair() can be implemented
> almost correctly without put_unused_fd().)

socketpair() is a good point. In particular, if we use this queuing
thing I've done above, then you can only ever send one fd, and you'll
need to send two here. So perhaps we really do need to do this as soon
as the tracer calls ioctl(), vs queuing and waiting.

> Hmm.  This does mean that we need a test case for a user notifier
> returning -ERESTARTSYS.  It should Just Work (tm), but those are
> famous last words.
> 
> -ERESTARTSYS_RESTARTBLOCK is the case that I don't think we need to worry about.
> 
> >
> > > In the (unlikely?) event that some tracer needs to be able to rollback
> > > an fd installation to return -EINTR, a SECCOMP_NOTIF_CLOSE_FD
> > > operation should be good enough, I think.  Or maybe PUT_FD can put -1
> > > to delete an fd.
> >
> > Yes, I think even with something like what I did below we'd need some
> > sort of REMOVE_FD option, because otherwise there's no way to change
> > your mind and send -EINTR without the fd you just PUT_FD'd.
> >
> 
> I think we just want the operation to cover all the cases.  Let PUT_FD
> take a source fd and a dest fd.  If the source fd is -1, the dest is
> closed.  If the source is -1 and the dest is -1, return -EINVAL.  If
> the dest is -1, allocate an fd.  If the dest is >= 0, work like
> dup2().  (The latter could be necessary to emulate things like, say,
> dup2 :))

...then if we're going to allow overwriting fds, we'd need to lift out
the logic from do_dup2 somewhere? Is this getting too complicated? :)

Tycho
