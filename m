From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Thu, 28 Jan 2016 08:16:11 +0100
Message-ID: <56A9C03B.7020104@gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1449523436.git.jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, normalperson-rMlxZR9MS24@public.gmane.org, m@silodev.com, corbet-T1hC0tSOHrs@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hagen-GvnIQ6b/HdU@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Jason,

On 12/08/2015 04:23 AM, Jason Baron wrote:
> Hi,
> 
> Re-post of an old series addressing thundering herd issues when sharing
> an event source fd amongst multiple epoll fds. Last posting was here
> for reference: https://lkml.org/lkml/2015/2/25/56
>  
> The patch herein drops the core scheduler 'rotate' changes I had previously
> proposed as this patch seems performant without those.
> 
> I was prompted to re-post this because Madars Vitolins reported some good
> speedups with this patch using Enduro/X application. His writeup is here:
> https://mvitolin.wordpress.com/2015/12/05/endurox-testing-epollexclusive-flag/
> 
> Thanks,
> 
> -Jason
> 
> Sample epoll_clt text:

Thanks for the proposed text. I have some questions about points
that are not quite clear to me.

> EPOLLEXCLUSIVE
>         Sets an exclusive wakeup mode for the epfd file descriptor that is
> 	being attached to the target file descriptor, fd. Thus, when an
> 	event occurs and multiple epfd file descriptors are attached to the
> 	same target file using EPOLLEXCLUSIVE, one or more epfds will receive
> 	an event with epoll_wait(2). The default in this scenario (when
> 	EPOLLEXCLUSIVE is not set) is for all epfds to receive an event.
> 	EPOLLEXLUSVIE may only be specified with the op EPOLL_CTL_ADD.

So, assuming an FD is present in the interest list of multiple (say 6)
epoll FDs, and some (say 3) of those attachments were done using
EPOLLEXCLUSVE. Which of the following statements are correct:

(a) It's guaranteed that *none* of the epoll FDs that did NOT specify
    EPOLLEXCLUSIVE will receive an event.

(b) It's guaranteed that *all* of the epoll FDs that did NOT specify
    EPOLLEXCLUSIVE will receive an event.

(c) From 1 to 3 of the epoll FDs that did specify EPOLLEXCLUSIVE
    will receive an event.

(d) Exactly one epoll FD that did specify EPOLLEXCLUSIVE will get
    an event, and it is indeterminate which one.

I suppose one point I'm trying to uncover in the above is: what is
the scope of EPOLLEXCLUSIVE? Is it just applicable for one process's
FD, or is it setting an attribute in the epoll "interest list" record
for that FD that affects notification behavior across all processes?

And then:

(1) What are the semantics of EPOLLEXCLUSIVE if the added FD becomes
    disabled via EPOLLONESHOT (or explicitly via EPOLL_CTL_MOD with
    the 'events' field set to 0)?

(2) The source code contains a comment "we do not currently supported 
    nested exclusive wakeups". Could you elaborate on this point? It
    sounds like something that should be documented.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
