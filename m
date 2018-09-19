From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via
 USER_NOTIF
Date: Wed, 19 Sep 2018 03:55:36 -0600
Message-ID: <20180919095536.GM4672@cisco>
References: <20180906152859.7810-1-tycho@tycho.ws>
 <20180906152859.7810-5-tycho@tycho.ws>
 <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 12, 2018 at 04:52:38PM -0700, Andy Lutomirski wrote:
> On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> > The idea here is that the userspace handler should be able to pass an fd
> > back to the trapped task, for example so it can be returned from socket().
> >
> > I've proposed one API here, but I'm open to other options. In particular,
> > this only lets you return an fd from a syscall, which may not be enough in
> > all cases. For example, if an fd is written to an output parameter instead
> > of returned, the current API can't handle this. Another case is that
> > netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
> > ever decides to install an fd and output it, we wouldn't be able to handle
> > this either.
> 
> An alternative could be to have an API (an ioctl on the listener,
> perhaps) that just copies an fd into the tracee.  There would be the
> obvious set of options: do we replace an existing fd or allocate a new
> one, and is it CLOEXEC.  Then the tracer could add an fd and then
> return it just like it's a regular number.
> 
> I feel like this would be more flexible and conceptually simpler, but
> maybe a little slower for the common cases.  What do you think?

I'm just implementing this now, and there's one question: when do we
actually do the fd install? Should we do it when the user calls
SECCOMP_NOTIF_PUT_FD, or when the actual response is sent? It feels
like we should do it when the response is sent, instead of doing it
right when SECCOMP_NOTIF_PUT_FD is called, since if there's a
subsequent signal and the tracer decides to discard the response,
we'll have to implement some delete mechanism to delete the fd, but it
would have already been visible to the process, etc. So I'll go
forward with this unless there are strong objections, but I thought
I'd point it out just to avoid another round trip.

Tycho
