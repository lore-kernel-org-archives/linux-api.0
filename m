From: Andy Lutomirski <luto@kernel.org>
Subject: Re: On
Date: Thu, 11 Jul 2019 17:32:21 -0700
Message-ID: <CALCETrWkmaB5K4AR0R6CYcdq8mJwKtbWbmYEq6oxeaoqdA3ZWA@mail.gmail.com>
References: <20190712014223.66326995@hikaru>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190712014223.66326995@hikaru>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlo Wood <carlo@alinoe.com>
Cc: wangyun@linux.vnet.ibm.com, palewis@adobe.com, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, jbaron@redhat.com, pholland@adobe.com, Davide Libenzi <davidel@xmailserver.org>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Neal Cardwell <ncardwell@google.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 11, 2019 at 5:01 PM Carlo Wood <carlo@alinoe.com> wrote:
>
> I believe that the only safe solution is to let the Event Loop
> Thread do the deleting. So, if all else fails I'll have to add
> objects that a Worker Thread thinks need to be deleted to a
> FIFO that is processed by the Event Loop Thread before entering
> epoll_wait(). But that is a lot of extra code for something
> that could be achieved with just a small change to epoll:

This doesn't seem so bad at all.

>
>
> I propose to add a new EPOLL event EPOLLCLOSED that will cause
> epoll_wait to return (for that event) whenever a file descriptor is
> closed.

This totally falls apart if you ever want to add a feature to your
library to detach the handler for a given fd without closing the fd.

>
> The Worker Thread then does not remove an object from the
> interest list, but either adds (if it was removed before) or
> modifies the event (using EPOLL_CTL_MOD) to watch that fd
> for closing, and then closes it.
>
> Aka,
>
>   Working Thread:
>
>   epoll_ctl(epoll_fd, EPOLL_CTL_ADD, fd, &event);
>   close(fd);
>
> where event contains the new EPOLLCLOSED (compare EPOLLOUT, EPOLLIN
> etc).
>
> This must then guarantee the event EPOLLCLOSED to be reported
> by exactly one epoll_wait(), the caller thread of which can then
> proceed with deleting the resources.
>
> Note that close(fd) must cause the removal from the interest list
> of any epoll struct before causing the event - and that the
> EPOLLCLOSED event may only be reported after all other events
> for that fd have already been reported (although it would be
> ok to report them at the same time: simply handle the other
> events first).

This is a bunch of subtle semantics in the kernel to support your
particular use case.

>
> I am not sure how this will work when more than one thread
> calls epoll_wait and more than one watch the same fd: in
> that case it is less trivial because then it seems always
> possible that the EPOLLCLOSED event will be reported before
> another event in another thread.

But this case is fairly straightforward with the user mode approach --
for example, add it to the list for all threads calling epoll_wait.
Or otherwise defer the deletion until all epoll_wait threads have
woken.
