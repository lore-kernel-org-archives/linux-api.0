From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Fri, 17 Jul 2015 16:33:42 -0700
Message-ID: <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com> <20150717232836.GA13604@domone>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717232836.GA13604@domone>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 4:28 PM, Ond=C5=99ej B=C3=ADlka <neleai@seznam.=
cz> wrote:
> On Fri, Jul 17, 2015 at 11:48:14AM -0700, Linus Torvalds wrote:
>>
>> On x86, if you want per-cpu memory areas, you should basically plan =
on
>> using segment registers instead (although other odd state has been
>> used - there's been the people who use segment limits etc rather tha=
n
>> the *pointer* itself, preferring to use "lsl" to get percpu data. Yo=
u
>> could also imaging hiding things in the vector state somewhere if yo=
u
>> control your environment well enough).
>>
> Thats correct, problem is that you need some sort of hack like this o=
n
> archs that otherwise would need syscall to get tid/access tls variabl=
e.
>
> On x64 and archs that have register for tls this could be implemented
> relatively easily.
>
> Kernel needs to allocate
>
> int running_cpu_for_tid[32768];
>
> On context switch it atomically writes to this table
>
> running_cpu_for_tid[tid] =3D cpu;
>
> This table is read-only accessible from userspace as mmaped file.
>
> Then userspace just needs to access it with three indirections like:
>
> __thread tid;
>
> char caches[CPU_MAX];
> #define getcpu_cache caches[tid > 32768 ? get_cpu() : running_cpu_for=
_tid[tid]]
>
> With more complicated kernel interface you could eliminate one
> indirection as we would use void * array instead and thread could do
> syscall to register what values it should use for each thread.

Or we implement per-cpu segment registers so you can point gs directly
at percpu data.  This is conceptually easy and has no weird ABI
issues.  All it needs is an implementation and some good tests.

I think the API should be "set gsbase to x + y*(cpu number)".  On
x86_64, userspace just allocates a big swath of virtual space and
populates it as needed.

--Andy
