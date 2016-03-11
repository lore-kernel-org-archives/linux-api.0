From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] epoll: add exclusive wakeups flag
Date: Fri, 11 Mar 2016 21:30:49 +0100
Message-ID: <CAKgNAkgb-2omfCc=oBr66_CViJjBQ6=3vNfES99m6ZQ7g36p2Q@mail.gmail.com>
References: <cover.1449523436.git.jbaron@akamai.com> <56A9C03B.7020104@gmail.com>
 <56AA56A2.3000700@akamai.com> <56AB1F6C.7000609@gmail.com>
 <56E1C2B5.2040905@akamai.com> <56E1D1D7.8040000@gmail.com> <56E1DBC2.6040109@akamai.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56E1DBC2.6040109-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Baron <jbaron-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Al Viro <viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org>, Eric Wong <normalperson-rMlxZR9MS24@public.gmane.org>, Madars Vitolins <m@silodev.com>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hagen Paul Pfeifer <hagen-GvnIQ6b/HdU@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>> By the way, in the code you have
>>
>>         case EPOLL_CTL_MOD:
>>                 if (epi) {
>>                         if (!(epi->event.events & EPOLLEXCLUSIVE)) {
>>                                 epds.events |= POLLERR | POLLHUP;
>>                                 error = ep_modify(ep, epi, &epds);
>>                         }
>>
>> I think the "if" here is redundant. IIUC, earlier in the code you
>> disallow EPOLL_CTL_MOD with EPOLLEXCLUSIVE.
>>
>> Cheers,
>>
>> Michael
>>
>>
>
> Hi Michael,
>
> So the previous check ensures that you can not add the EPOLLEXCLUSIVE
> flag to the events via an EPOLL_CTL_MOD operation, where EPOLLEXCLUSIVE
> may not be the existing events set. While this check here ensure you
> can't modify an existing set that already has the EPOLLEXCLUSIVE flag.

Hmmm - I misread the code, itr seems :-/. Could you please carefully
check the man page text I sent earlier in this thread. Maybe I
injected some errors into the text.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
