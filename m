From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Tue, 22 Sep 2015 16:00:23 -0500
Message-ID: <87eghqcgpk.fsf@x220.int.ebiederm.org>
References: <20150915120924.14818.49490.stgit@buzz>
	<87h9mvg3kw.fsf@x220.int.ebiederm.org>
	<55F832D2.1070605@yandex-team.ru> <20150915151729.GA144242@dakara>
	<20150915174143.GE4699@ubuntumail> <55F91C3D.1040209@yandex-team.ru>
	<20150916143939.GA32226@mail.hallyn.com>
	<87twquzag1.fsf@x220.int.ebiederm.org>
	<20150916163123.GA1039@mail.hallyn.com>
	<55FF7043.5020701@cn.fujitsu.com>
	<20150921142222.GA24005@mail.hallyn.com>
	<56010680.7000301@yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56010680.7000301-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> (Konstantin Khlebnikov's
	message of "Tue, 22 Sep 2015 10:42:56 +0300")
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> writes:

> On 21.09.2015 17:22, Serge E. Hallyn wrote:
>>
>> So please implement it, as Eric suggested, using the ns inode fds
>> instead of racy pid_t hints for namespaces.
>>
>
> I don't want to loose simple way to use it.
> Sometimes caller cannot prevent races (task its child or
> locked with with ptrace) or it don't care about them.
>
> What about this design:
>
> pid_t getvpid(pid_t pid, pid_t source, pid_t target)
>
> pid > 0 - get vpid of task
> pid = 0 - current pid (= just for symmetry =)
> pid < 0 - get vpid of parent task (ppid of -pid)
>           [ that's really useful for poking isolated pidns ]
> source/target > 0 - pid of source/target task
> source/target = 0 - use current as source/target
> source/target < 0 - use pidns fd (1-arg) as source/target
>
> or the same but without =0 sugar:
>
> pid > 0 - get vpid of task
> pid < 0 - get vpid of parent task (ppid of -arg)
> source/target > 0  - pid of source/target task
> source/target <= 0 - use pidns fd (-arg) as source/target
>
> libc caches current pid, extra getpid shouldn't be a problem.

Yuck.  An invalid fd like for saying use the current pid namespace is
fine.

Using pids to identify namespaces yuck just yuck.  That just seems to
add complexity for no gain except to make programs buggier.

We have a couple of old interfaces that use pids because pids were the
the best we had, but at this point I don't see anything at all that
even suggests that pids are a good choice for identifying namespaces.

If performance is important than caching file descriptors should be
trivial.  If performance is not important it should not be hard to
open "/proc/<pid>/ns/pid".

I do not see the gain of using pids in this interface except to confuse
people, and make the interface brittle.


Eric
