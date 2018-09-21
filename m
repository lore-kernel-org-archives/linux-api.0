From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Fri, 21 Sep 2018 11:27:59 -0700
Message-ID: <CALCETrWxjLw6-pMcOydDxbf6KfMrYZcdriTk5g7U3Ba6cRNJNg@mail.gmail.com>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
 <20180919095536.GM4672@cisco> <C1406292-7496-459F-A76A-20C9EFBB12D6@amacapital.net>
 <20180919143842.GN4672@cisco> <CALCETrVuP0nQ5B01-iWrcQ87hisz7=jA08-Uisqud_r+zc74NQ@mail.gmail.com>
 <20180920234240.GR4672@cisco> <CALCETrWEr_VAtJu1mm1akTigsRUXAA7_7RHb-WGHqnyNy=j17Q@mail.gmail.com>
 <20180921133928.GS4672@cisco>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180921133928.GS4672@cisco>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 21, 2018 at 6:39 AM Tycho Andersen <tycho@tycho.ws> wrote:
>
> On Thu, Sep 20, 2018 at 07:18:45PM -0700, Andy Lutomirski wrote:
> >
> > I think we just want the operation to cover all the cases.  Let PUT_FD
> > take a source fd and a dest fd.  If the source fd is -1, the dest is
> > closed.  If the source is -1 and the dest is -1, return -EINVAL.  If
> > the dest is -1, allocate an fd.  If the dest is >= 0, work like
> > dup2().  (The latter could be necessary to emulate things like, say,
> > dup2 :))
>
> ...then if we're going to allow overwriting fds, we'd need to lift out
> the logic from do_dup2 somewhere? Is this getting too complicated? :)
>

fds are complicated :-p

More seriously, though, I think it's okay if we don't support
everything out of the box.  getting the general semantics I suggested
is kind of nice because the resulting API is conceptually simple, even
if it encapsulates three cases.  But I'd be okay with only supporting
add-an-fd-at-an-unused-position and delete-an-fd out of the box --
more can be added if there's demand.

But I think that exposing an operation that allocates and reserves an
fd without putting anything in the slot is awkward, and it opens us up
to weird corner cases becoming visible that are currently there but
mostly hidden.  For example, what happens if someone overwrites a
reserved fd with dup2()?  (The answer is apparently -EBUSY -- see the
big comment in do_dup2() in fs/file.c.)  But there's a more
significant nastiness: what happens if someone abuses your new
mechanism to overwrite a reserved fd that belongs to a different
thread?  It looks like you'll hit the BUG_ON(fdt->fd[fd] != NULL); in
__fd_install().  So unless you actually track which unused fds you own
and enforce that the final installation installs in the right slot,
you have a problem.

BTW, socketpair() isn't the only thing that can add two fds.
recvmsg() can, too, as can pipe() and pipe2().  Some of the DRM ioctls
may as well for all I know.  But socketpair(), pipe(), and recvmsg()
can be credibly emulated by adding each fd in sequence and then
deleting them all of one fails.  Sure, this could race against dup2(),
but I'm not sure we care.

--Andy
