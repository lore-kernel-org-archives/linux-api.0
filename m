From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RESEND PATCH 2/3] epoll: Add implementation for epoll_pwait1
Date: Thu, 8 Jan 2015 12:48:27 +0100
Message-ID: <CAKgNAkiKz1pdt_uYpFDsCNLPr6UBJHZs72o3iAh57+7uG1uksQ@mail.gmail.com>
References: <1420708563-21743-1-git-send-email-famz@redhat.com>
 <1420708563-21743-3-git-send-email-famz@redhat.com> <54AE65BB.1020707@redhat.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54AE65BB.1020707-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Juri Lelli <juri.lelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Zach Brown <zab-ugsP4Wv/S6ZeoWH0uzbU5w@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dario Faggioli <raistlin-k2GhghHVRtY@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers>
List-Id: linux-api@vger.kernel.org

On 8 January 2015 at 12:10, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>
> On 08/01/2015 10:16, Fam Zheng wrote:
>> Unlike ppoll(2), which accepts a timespec argument "timeout_ts" to
>> specify the timeout, epoll_wait(2) and epoll_pwait(2) expect a
>> microsecond timeout in int type.
>>
>> This is an obstacle for applications in switching from ppoll to epoll,
>> if they want nanosecond resolution in their event loops.
>>
>> Therefore, adding this variation of epoll wait interface, giving user an
>> option with *both* advantages, is a reasonable move: there could be
>> constantly scalable performance polling many fds, while having a
>> nanosecond timeout precision (assuming it has properly set up timer
>> slack with prctl(2)).
>>
>> Signed-off-by: Fam Zheng <famz-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/eventpoll.c           | 24 ++++++++++++++++++++++++
>>  include/linux/syscalls.h |  4 ++++
>>  kernel/sys_ni.c          |  3 +++
>>  3 files changed, 31 insertions(+)
>
> As mentioned by Miklos in the non-resent version, please add a flags
> argument.  Invalid flags should return -EINVAL.
>
> In fact, we could already use the flags argument to specify an absolute
> timeout, which is a nice thing to have for QEMU too.

Nice! It looks like we found this iteration of "failure to include a
flags argument is a mistake" already!

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
