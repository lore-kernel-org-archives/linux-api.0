From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Fri, 17 Jul 2015 08:53:06 -0700
Message-ID: <CALCETrWSg+gxxwxu8wG8uY8NVqKz6H3yT6YxQZWTm8mYakspgQ@mail.gmail.com>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com> <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com> <20150717102105.GA21915@domone>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150717102105.GA21915@domone>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai-9Vj9tDbzfuSlVyrhU4qvOw@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, libc-alpha <libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 3:21 AM, Ond=C5=99ej B=C3=ADlka <neleai@seznam.=
cz> wrote:
> On Thu, Jul 16, 2015 at 12:27:10PM -0700, Andy Lutomirski wrote:
>> On Thu, Jul 16, 2015 at 11:08 AM, Mathieu Desnoyers
>> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> > ----- On Jul 14, 2015, at 5:34 AM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote=
:
>> >>
>> >> That said, having the ability for the kernel to understand that T=
LS
>> >> implementation are laid out using the same offset on each thread =
seems like
>> >> something that could be valuable long term. Doing so makes it pos=
sible to build
>> >> other TLS-based features without forcing each thread to be regist=
ered.
>> >
>> > AFAIU, using a fixed hardcoded ABI between kernel and user-space m=
ight make
>> > transition from the pre-existing ABI (where this memory area is no=
t
>> > reserved) a bit tricky without registering the area, or getting a =
"feature"
>> > flag, through a system call.
>> >
>> > The related question then becomes: should we issue this system cal=
l once
>> > per process, or once per thread at thread creation ? Issuing it on=
ce per
>> > thread is marginally more costly for thread creation, but seems to=
 be
>> > easier to deal with internally within the kernel.
>> >
>> > We could however ensure that only a single system call is needed p=
er new-coming
>> > thread, rather than one system call per feature. One way to do thi=
s would be
>> > to register an area that may contain more than just the CPU id. It=
 could
>> > consist of an expandable structure with fixed offsets. When regist=
ered, we
>> > could pass the size of that structure as an argument to the system=
 call, so
>> > the kernel knows which features are expected by user-space.
>>
>> If we actually bit the bullet and implemented per-cpu mappings, we
>> could have this be completely flexible because there would be no
>> format at all.  Similarly, if we implemented per-cpu segments,
>> userspace would need to agree with *itself* how to arbitrate it, but
>> the kernel wouldn't need to be involved.
>>
>> With this kind of memory poking, it's definitely messier, which is u=
nfortunate.
>>
> Could you recapitulate thread? On libc side we didn't read most of it=
 so
> it would be appreciated.
>
> If per-cpu mappings mean that there is a single virtual page that is
> mapped to different virtual pages?

Single virtual page that's mapped to different physical pages on
different cpus.  I believe that ARM has some hardware support for
this, but I'm not that familiar with ARM.  x86 can fake it (at the
cost of some context switch overhead).

>
> I had in my todo list improving tls access. This would help tls
> implementations for older arms and in general architectures that dont
> store tcb in register.
>
> My proposal is modulo small constant equivalent of userspace accessin=
g tid
> without syscall overhead, just use array of tcb's for first 32768 tid=
s
> and do syscall only when tid exceeds that.
>
> On userspace my proposal would be use map that to fixed virtual addre=
ss and store tcb in first eigth bytes. Kernel would on context switch a=
long registers also
> save and restore these. That would make tls access cheap as it would
> need only extra load instruction versus static variable.
>

The problem is that having the kernel access userspace memory on
context switch, while doable, is a little bit unpleasant.  We also
really need to get the ABI right the first time, because we don't
really get a second chance.

--Andy
