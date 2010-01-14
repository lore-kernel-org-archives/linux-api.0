From: "Andrew C. Morrow" <andrew.c.morrow-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5] add MAP_UNLOCKED mmap flag
Date: Thu, 14 Jan 2010 14:30:17 -0500
Message-ID: <6feea4871001141130j4184a24di363b7e6553d506e8@mail.gmail.com>
References: <20100114162327.673E.A69D9226@jp.fujitsu.com>
	 <20100114080117.GL18808@redhat.com>
	 <20100114170247.6747.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100114170247.6747.A69D9226-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jan 14, 2010 at 3:17 AM, KOSAKI Motohiro
<kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
>> > Hmm..
>> > Your answer didn't match I wanted.
>> Then I don't get what you want.
>
> I want to know the benefit of the patch for patch reviewing.
>

The benefit of the patch is that it makes it possible for an
application which has previously called mlockall(MCL_FUTURE) to
selectively exempt new memory mappings from memory locking, on a
per-mmap-call basis. As was pointed out earlier, there is currently no
thread-safe way for an application to do this. The earlier proposed
workaround of toggling MCL_FUTURE around calls to mmap is racy in a
multi-threaded context. Other threads may manipulate the address space
during the window where MCL_FUTURE is off, subverting the programmers
intended memory locking semantics.

The ability to exempt specific memory mappings from memory locking is
necessary when the region to be mapped is larger than physical memory.
In such cases a call to mmap the region cannot succeed, unless
MAP_UNLOCKED is available.


>
>> > few additional questions.
>> >
>> > - Why don't you change your application? It seems natural way than=
 kernel change.
>> There is no way to change my application and achieve what I've descr=
ibed
>> in a multithreaded app.
>
> Then, we don't recommend to use mlockall(). I don't hope to hear your=
 conclusion,
> it is not objectivization. I hope to hear why you reached such conclu=
sion.
>

I agree that mlockall is a big hammer and should be avoided in most
cases, but there are situations where it is exactly what is needed. In
Gleb's instance, it sounds like he is doing some finicky performance
measurement and major page faults skew his results. In my case, I have
a realtime process where the measured latency impact of major page
faults is unacceptable. In both of these cases, mlockall is a
reasonable approach to eliminating major faults.

However, Gleb and I have independently found ourselves unable to use
mlockall because we also need to create a very large memory mapping
(for which we don't care about major faults). The proposed
MAP_UNLOCKED flag would allow us to override MCL_FUTURE for that one
mapping.

>
>> > - Why do you want your virtual machine have mlockall? AFAIK, curre=
nt majority
>> > =A0 virtual machine doesn't.
>> It is absolutely irrelevant for that patch, but just because you ask=
 I
>> want to measure the cost of swapping out of a guest memory.
>
> No. if you stop to use mlockall, the issue is vanished.
>

And other issues arise. Gleb described a situation where the use of
mlockall is justified, identified an issue which prevents its use, and
provided a patch which resolves that issue. Why are you focusing on
the validity of using mlockall?

>
>> > - If this feature added, average distro user can get any benefit?
>> >
>> ?! Is this some kind of new measure? There are plenty of much more
>> invasive features that don't bring benefits to an average distro use=
r.
>> This feature can bring benefit to embedded/RT developers.
>
> I mean who get benifit?
>
>
>> > I mean, many application developrs want to add their specific feat=
ure
>> > into kernel. but if we allow it unlimitedly, major syscall become
>> > the trushbox of pretty toy feature soon.
>> >
>> And if application developer wants to extend kernel in a way that it
>> will be possible to do something that was not possible before why is
>> this a bad thing? I would agree with you if for my problem was users=
pace
>> solution, but there is none. The mmap interface is asymmetric in reg=
ards
>> to mlock currently. There is MAP_LOCKED, but no MAP_UNLOCKED. Why
>> MAP_LOCKED is useful then?
>
> Why? Because this is formal LKML reviewing process. I'm reviewing you=
r
> patch for YOU.
>
> If there is no objective reason, I don't want to continue reviewing.
>

There is an objective reason: the current interaction between
mlockall(MCL_FUTURE) and mmap has a deficiency. In 'normal' mode,
without MCL_FUTURE in force, the default is that new memory mappings
are not locked, but mmap provides MAP_LOCKED specifically to override
that default. However, with MCL_FUTURE toggled to on, there is no
analogous way to tell mmap to override the default. The proposed
MAP_UNLOCKED flag would resolve this deficiency.

Andrew
