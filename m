From: Denys Vlasenko <vda.linux-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
 without dequeuing signals (v2)
Date: Mon, 11 Feb 2013 18:25:54 +0100
Message-ID: <CAK1hOcNOYRWwrwZEpVza1CTSL_mHEj-Ur577QRnBNkOmdb=Bdw@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com>
 <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com> <511905D7.3040209@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511905D7.3040209-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2013 at 3:53 PM, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On 02/11/2013 06:46 PM, Denys Vlasenko wrote:
>> On Mon, Feb 11, 2013 at 11:59 AM, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>>>>> I suppose I had wondered along similar lines, but in a slightly
>>>>> different direction: would the use of a /proc interface to get the
>>>>> queued signals make some sense?
>>>>
>>>> I think that /proc interface beats adding magic flags and magic semantic
>>>> to [p]read.
>>>>
>>>> It also has the benefit of being human-readable. You don't need
>>>> to write a special C program to "cat /proc/$$/foo".
>>>>
>>>> Andrey, I know that it is hard to let go of the code you invested time
>>>> and efforts in creating. But this isn't the last patch, is it?
>>>> You will need to retrieve yet more data for process checkpointing.
>>>> When you start working on the next patch for it, consider trying
>>>> /proc approach.
>>>
>>> I don't think that we need to convert siginfo into a human readable format
>>> in kernel.
>>
>> My point is that bolting hacks onto various bits of kernel API
>> in order to support process checkpointing makes those APIs
>> (their in-kernel implementation) ridden with special cases
>> and harder to support in the future.
>>
>> Process checkpointing needs to bite the bullet and
>> create its own API instead.
>
> This is bad approach as well. What we should do is come up with a sane
> API that makes sense without the checkpoint-restore project _when_ _possible_.

Coming up with a sane API in general isn't easy.

Consider numerous blunders enshrined in the Unix API,
such as O_NONBLOCK being a file's flag instead of being
a flag of read(), or waitpid, or sigwait,
(had to be fds which one can feed to select/poll)...

If you have your own playground in /proc/PID/foo,
you can mature your API without touching many other areas
of kernel, and without making mistakes permanent.
Later, when other people are interested, they can factor out
your code.


You are planning to use signalfd to extract pending signals
from the process being checkpointed.

This must be a quite convoluted method already, since you
need to create a signalfd and then read from it *in the context
of the process you are checkpointing*.

I presume you are ptrace-attaching to the process and then
play games with setting registers and injecting syscalls.
This does not look particularly sane to me, I'm afraid.

Compared to this, ptrace-attaching to the process
and then reading from /proc or issuing a new ptrace request
looks much cleaner. My opinion, of course.

-- 
vda
