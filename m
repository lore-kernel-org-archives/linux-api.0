From: Ben Maurer <bmaurer@fb.com>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Fri, 13 Oct 2017 09:35:32 +0000
Message-ID: <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>,<CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy54Sk63VkS3HFnd4MPiSbgV6==NaYwr+D9sjG6KZGmHQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, David Goldblatt <davidgoldblatt@fb.com>, Qi Wang <qiwang@fb.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Michael Kerrisk <mtk.manpages@gmail>
List-Id: linux-api@vger.kernel.org

Hey,

I'm really excited to hear that you're open to this patch set and totally u=
nderstand the desire for some more numbers. I have a few thoughts and quest=
ions -- hopefully ones that could help better understand where you'd like t=
o see more data (potentially from myself and other Facebook folks)

> A "increment percpu value" simply isn't relevant.

While I understand it seems trivial, my experience has been that this type =
of operation can actually be important in many server workloads. In applica=
tions with 1000s of threads, keeping a counter like this can pose a challen=
ge. One can use a per-thread variable, but the size overhead here can be ve=
ry large (8 bytes per counter per thread adds up very quickly). And atomic =
instructions can cause contention quickly. Server programs tend to have man=
y statistical counters, being able to implement them efficiently without si=
ze bloat is a real world win.

This type of per-cpu counter can also very quickly be used to implement oth=
er abstractions in common use -- eg an asymmetric reader-writer lock or a r=
eference counted object that is changed infrequently. While thread local st=
orage can also be used in these cases this can be a substantial size overhe=
ad and can also require cooperation between the application and the library=
 to manage thread lifecycle.

At least from what I've seen of our usage of these types of abstractions wi=
thin Facebook, if rseq met these use cases and did absolutely nothing else =
it would still be a feature that our applications would benefit from. Hopef=
ully we can find evidence that it can do even more than this, but I think t=
hat this "trivial" use case is actually addressing a real world problem.

> When I asked last time, people pointed me to potential uses, including
> malloc libraries that could get per-thread performance with just
> per-cpu (not per thread) data structure overhead. I see that you once
> more point to the slides from 2013 that again talks about it.
>
> But people didn't post code, people didn't post numbers, and people
> didn't point to actual real uses, just "this could happen".

At Facebook we did some work to experiment with rseq and jemalloc Qi and Da=
vid (cc'd) may be able to provide more context on the current state.

> Because without real-world uses, it's not obvious that there won't be
> somebody who goes "oh, this isn't quite enough for us, the semantics
> are subtly incompatible with our real-world use case".

Is your concern mainly this question (is this patchset a good way to bring =
per-cpu algorithms to userspace)? I'm hoping that given the variety of ways=
 that per-cpu data structures are used in the kernel the concerns around th=
is patch set are mainly around what approach we should take rather than if =
per-cpu algorithms are a good idea at all. If this is your main concern per=
haps our focus should be around demonstrating that a number of useful per-c=
pu algorithms can be implemented using restartable sequences.

Ultimately I'm worried there's a chicken and egg problem here. It's hard to=
 get people to commit to investing in rseq without a clear path to the patc=
hset seeing the light of day. It's also easy to understand why you'd be rel=
uctant to merge such a substantial and unfamiliar API without extensive dat=
a. If we're still not able to get compelling data, I'm wondering if there a=
re other approaches that could get us unstuck, eg

(1) Could we merge enough of this patchset (eg things like the faster getcp=
u() operation, which seems like a good improvement over the current approac=
h). If we make the remaining patches small enough it may be easier for soph=
isticated users to apply the remaining patches, maintain them, and provide =
real-world operational experience with this abstraction.

(2) Could we implement restartable sequences in the kernel but only allow t=
he vdso to make use of them? We could have the vdso export a number of high=
-level operations (like the ones suggested in Paul Turner's original presen=
tation -- per-cpu spin lock, per-cpu atomic increment/decrement, per-cpu li=
st push/pop). This would allow us to get real-world data about how these pr=
imitives are used without committing to a complex ABI -- only committing to=
 support the specific operations. If the whole idea flops we could eventual=
ly create a slow/naive implementation of the vdso functions and kill restar=
table sequences entirely.

-b=
