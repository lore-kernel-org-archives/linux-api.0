From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test app.
Date: Thu, 25 Oct 2012 12:23:24 +0200
Message-ID: <CAKgNAkj=52rPitKT2b4_=dwczpfub6RQojjX4rNhFZQZHecSTA@mail.gmail.com>
References: <1345756535-8372-1-git-send-email-palewis@adobe.com>
 <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com>
 <5086D27F.1000007@adobe.com> <50873DFA.5010205@adobe.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50873DFA.5010205-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paton J. Lewis" <palewis-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jason Baron <jbaron-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Holland <pholland-dv/VyGpifdQAvxtiuMwx3w@public.gmane.org>, Davide Libenzi <davidel-AhlLAIvw+VEjIGhXcJzhZg@public.gmane.org>, "libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org" <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Pat,


>> I suppose that I have a concern that goes in the other direction. Is
>> there not some other solution possible that doesn't require the use of
>> EPOLLONESHOT? It seems overly restrictive to require that the caller
>> must employ this flag, and imposes the burden that the caller must
>> re-enable monitoring after each event.
>>
>> Does a solution like the following (with no requirement for EPOLLONESHOT)
>> work?
>>
>> 0. Implement an epoll_ctl() operation EPOLL_CTL_XXX
>>    where the name XXX might be chosen based on the decision
>>    in 4(a).
>> 1. EPOLL_CTL_XXX employs a private flag, EPOLLUSED, in the
>>    per-fd events mask in the ready list. By default,
>>    that flag is off.
>> 2. epoll_wait() always clears the EPOLLUSED flag if a
>>    file descriptor is found to be ready.
>> 3. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>    flag is NOT set, then
>>         a) it sets the EPOLLUSED flag
>>         b) It disables I/O events (as per EPOLL_CTL_DISABLE)
>>            (I'm not 100% sure if this is necesary).
>>         c) it returns EBUSY to the caller
>> 4. If an epoll_ctl(EPOLL_CTL_XXX) discovers that the EPOLLUSED
>>    flag IS set, then it
>>         a) either deletes the fd or disables events for the fd
>>            (the choice here is a matter of design taste, I think;
>>            deletion has the virtue of simplicity; disabling provides
>>            the option to re-enable the fd later, if desired)
>>         b) returns 0 to the caller.
>>
>> All of the above with suitable locking around the user-space cache.
>>
>> Cheers,
>>
>> Michael
>
>
> I don't believe that proposal will solve the problem. Consider the case
> where a worker thread has just executed epoll_wait and is about to execute
> the next line of code (which will access the data associated with the fd
> receiving the event). If the deletion thread manages to call
> epoll_ctl(EPOLL_CTL_XXX) for that fd twice in a row before the worker thread
> is able to execute the next statement, then the deletion thread will
> mistakenly conclude that it is safe to destroy the data that the worker
> thread is about to access.

Okay -- I had the idea there might be a hole in my proposal ;-).

By the way, have you been reading the comments in the two LWN articles
on EPOLL_CTL_DISABLE?
https://lwn.net/Articles/520012/
http://lwn.net/SubscriberLink/520198/fd81ba0ecb1858a2/

There's some interesting proposals there--some suggesting that an
entirely user-space solution might be possible. I haven't looked
deeply into the ideas though.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
