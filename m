From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v6 4/5] seccomp: add support for passing fds via USER_NOTIF
Date: Wed, 12 Sep 2018 16:52:38 -0700
Message-ID: <CALCETrWZmN4FeCSwemfMeayupBmQ-NqpVWQuqSU34CLvzdx8gw@mail.gmail.com>
References: <20180906152859.7810-1-tycho@tycho.ws> <20180906152859.7810-5-tycho@tycho.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180906152859.7810-5-tycho@tycho.ws>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Sep 6, 2018 at 8:28 AM, Tycho Andersen <tycho@tycho.ws> wrote:
> The idea here is that the userspace handler should be able to pass an fd
> back to the trapped task, for example so it can be returned from socket().
>
> I've proposed one API here, but I'm open to other options. In particular,
> this only lets you return an fd from a syscall, which may not be enough in
> all cases. For example, if an fd is written to an output parameter instead
> of returned, the current API can't handle this. Another case is that
> netlink takes as input fds sometimes (IFLA_NET_NS_FD, e.g.). If netlink
> ever decides to install an fd and output it, we wouldn't be able to handle
> this either.

An alternative could be to have an API (an ioctl on the listener,
perhaps) that just copies an fd into the tracee.  There would be the
obvious set of options: do we replace an existing fd or allocate a new
one, and is it CLOEXEC.  Then the tracer could add an fd and then
return it just like it's a regular number.

I feel like this would be more flexible and conceptually simpler, but
maybe a little slower for the common cases.  What do you think?
