From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Sat, 18 Jul 2015 02:43:25 +0000 (UTC)
Message-ID: <261875635.51.1437187405954.JavaMail.zimbra@efficios.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com> <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <20150717105859.GB21915@domone> <626545401.1010.1437149010438.JavaMail.zimbra@efficios.com> <20150717224353.GA7150@domone>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717224353.GA7150@domone>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?Ond=C5=99ej_B=C3=ADlka?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Cc: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Jul 17, 2015, at 6:43 PM, Ond=C5=99ej B=C3=ADlka neleai@seznam=
=2Ecz wrote:

> On Fri, Jul 17, 2015 at 04:03:30PM +0000, Mathieu Desnoyers wrote:
>> ----- On Jul 17, 2015, at 6:58 AM, Ond=C5=99ej B=C3=ADlka neleai@sez=
nam.cz wrote:
>> [...]
>> >> If we invoke this per-thread registration directly in the glibc N=
PTL
>> >> implementation,
>> >> in start_thread, do you think it would fit your requirements ?
>> >>
>
[...]
>> > Second would be write patch to libc adding function
>> > pthread_create_add_hook_np to register function that would be ran =
after
>> > each thread creation.
>>=20
>> Do you suggest that this callback should be registered once per thre=
ad,
>> or somehow attached to pthread_attr_t ? As maintainer of lttng-ust,
>> where we need some control over our own threads, but where we want m=
inimal
>> impact on the overall application, I would really prefer if we can a=
ttach
>> the callback to pthread_attr_t.
>>=20
> Could you elaborate. I was suggesting per-thread callback, what do yo=
u
> want to do with pthread_attr_t?

Hrm, nevermind, even in the context of lttng-ust, I'd want the callback=
 to
be called for every thread in the application. Therefore, registering t=
his
callback once per process seems to make sense.

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
