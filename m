From: Denys Vlasenko <vda.linux-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [CRIU] [PATCH 3/3] signalfd: add ability to read siginfo-s
 without dequeuing signals (v2)
Date: Mon, 11 Feb 2013 15:46:52 +0100
Message-ID: <CAK1hOcMepaOD80GOvUv1xz3xibTG_iKMK-w7698K6KfRmcKGeA@mail.gmail.com>
References: <1358849741-9611-4-git-send-email-avagin@openvz.org>
 <20130208191056.GA13674@redhat.com> <CAKgNAki0xt_wwixp7kdv04fKOCtCh-ObQjkFE9PiX6FapkO34A@mail.gmail.com>
 <201302111029.50998.vda.linux@googlemail.com> <20130211105941.GA26717@paralelels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130211105941.GA26717-yYYamFZzV1regbzhZkK2zA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 11, 2013 at 11:59 AM, Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
>> > I suppose I had wondered along similar lines, but in a slightly
>> > different direction: would the use of a /proc interface to get the
>> > queued signals make some sense?
>>
>> I think that /proc interface beats adding magic flags and magic semantic
>> to [p]read.
>>
>> It also has the benefit of being human-readable. You don't need
>> to write a special C program to "cat /proc/$$/foo".
>>
>> Andrey, I know that it is hard to let go of the code you invested time
>> and efforts in creating. But this isn't the last patch, is it?
>> You will need to retrieve yet more data for process checkpointing.
>> When you start working on the next patch for it, consider trying
>> /proc approach.
>
> I don't think that we need to convert siginfo into a human readable format
> in kernel.

My point is that bolting hacks onto various bits of kernel API
in order to support process checkpointing makes those APIs
(their in-kernel implementation) ridden with special cases
and harder to support in the future.

Process checkpointing needs to bite the bullet and
create its own API instead.

Whether it would be a /proc/PID/checkpoint or a
ptrace(PTRACE_GET_CHKPOINT_DATA) is another question.

-- 
vda
