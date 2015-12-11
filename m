From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] restartable sequences v2: fast user-space
 percpu critical sections
Date: Fri, 11 Dec 2015 13:39:45 +0000 (UTC)
Message-ID: <729444271.232573.1449841185204.JavaMail.zimbra@efficios.com>
References: <20151027235635.16059.11630.stgit@pjt-glaptop.roam.corp.google.com> <1070636085.232143.1449835536723.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1070636085.232143.1449835536723.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Turner <commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Dec 11, 2015, at 7:05 AM, Mathieu Desnoyers mathieu.desnoyers@=
efficios.com wrote:

> ----- On Oct 27, 2015, at 7:56 PM, Paul Turner commonly-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wro=
te:
>=20
>> This is an update to the previously posted series at:
>>  https://lkml.org/lkml/2015/6/24/665
>>=20
>> Dave Watson has posted a similar follow-up which allows additional c=
ritical
>> regions to be registered as well as single-step support at:
>>  https://lkml.org/lkml/2015/10/22/588
>>=20
>> This series is a new approach which introduces an alternate ABI that=
 does not
>> depend on open-coded assembly nor a central 'repository' of rseq seq=
uences.
>> Sequences may now be inlined and the preparatory[*] work for the seq=
uence can
>> be written in a higher level language.
>=20
> Hi Paul,
>=20
> Thanks for sending this updated series! A few questions:
>=20
> When you say that the preparatory work can be written in a higher
> level language, does it mean it still has to be inlined, or function
> calls are explicitly supported ? It would be good to clarify this in
> the changelog/documentation.
>=20
> Another point: in this changelog, it's unclear to me what the [*] ref=
ers
> to (after "preparatory"). Below there is a [*] before "A sequence ess=
entially
> has 3 steps", and and plain '*' before "0. Userspace stores current e=
vent+cpu
> counter values".
>=20
>>=20
>> This new ABI has also been written to support debugger interaction i=
n a way
>> that the previous ABI could not.
>>=20
>> [*] A sequence essentially has 3 steps:
>>  1) Determine which cpu the sequence is being run on
>>  2) Preparatory work specific to the state read in 1)
>>  3) A single commit instruction which finalizes any state updates.
>=20
> The link between those 3 steps and the following "progress" items
> below seems a bit confusing, because those are two numbered lists.
> Perhaps using the numbers above for the overall steps, and sub-number=
s
> after a dot could help exposing the relation, e.g.:
>=20
> 1.1 Userspace stores current event+cpu counter values
> 2.1 Userspace loads the rip to move to at failure into cx
> 2.2 Userspace loads the rip of the instruction following
>    the critical section into a registered TLS address.
> ....
>=20
>=20
>>=20
>> We require a single instruction for (3) so that if it is interrupted=
 in any
>> way, we can proceed from (1) once more [or potentially bail].
>>=20
>> This new ABI can be described as:
>> Progress is ordered as follows:
>>  *0. Userspace stores current event+cpu counter values
>=20
> This does not explain where those "current" values are
> read from ? Moreover, step [3] below seems to refer to values
> read at [0], but [0] is about storing values, not reading them.
> There is probably a very simple explanation to this, but in its
> current form, this is puzzling. Moreover, where is it stored ?
>=20
> I would suggest to change event+cpu -> (event, cpu), since they
> are not summed, but rather combined as a tuple.
>=20
>>   1. Userspace loads the rip to move to at failure into cx
>=20
> Is it really cx (16-bit), or ecx/rcx ?
>=20
> "the rip to move to at failure" could be defined as
> "failure address" or "restart address", and then referred
> to afterward. This would clarify point [4] below rather than
> saying "to the address from =C2=AD[1]".
>=20
>>   2. Userspace loads the rip of the instruction following
>>      the critical section into a registered TLS address.
>=20
> The critical section is not clearly defined. What is the
> first instruction included in that c.s., and what is the
> first instruction after the c.s. ?
>=20
>>   3. Userspace loads the values read at [0] into a known
>>      location.
>=20
> How can we "load the value ... into" ? We usually load from,
> and store to a location. What I think you mean here is that
> Userspace loads the values read at [0] into a known register.
> (I would expect location target a memory address).
>=20
>>   4. Userspace tests to see whether the current event and
>>      cpu counter values match those stored at 0.  Manually
>>      jumping to the address from [1] in the case of a
>>      mismatch.
>=20
> address from [1] -> "failure/restart address"
>=20
>>=20
>>      Note that if we are preempted or otherwise interrupted
>>      then the kernel can also now perform this comparison
>>      and conditionally jump us to [1].
>=20
> Does it jump us to [1] or to the failure/restart address ?
>=20
>>   5. Our final instruction before [2] is then our commit.
>>      The critical section is self-terminating.  [2] must
>>      also be cleared at this point.
>=20
> Is it the step [2] or the instruction following the critical
> section to you refer to here ?
>=20
>>=20
>> For x86_64:
>>   [3] uses rdx to represent cpu and event counter as a
>>       single 64-bit value.
>>=20
>> For i386:
>>   [3] uses ax for cpu and dx for the event_counter.
>=20
> Having 16 bit only for CPU id limits us to 65536 CPUs.
> Can this be an issue ?
>=20
> Having 16 bit only for the event counter may start to become
> tricky for counter overflows.
>=20
> Are we strictly required to put both cpu id and seq counter
> into the same register, or those could be put into two regs ?
>=20
>>=20
>>  Both:
>>   Instruction after commit: rseq_state->post_commit_instr
>>   Current event and cpu state: rseq_state->event_and_cpu
>>=20
>> Exactly, for x86_64 this looks like:
>>  movq <failed>, rcx [1]
>>  movq $1f, <commit_instr> [2]
>>  cmpq <start value>, <current value> [3] (start is in rcx)
>=20
> As you stated yourself in a reply, rcx -> rdx.
>=20
>>  jnz <failed> (4)
>>  movq <to_write>, (<target>) (5)
>>  1: movq $0, <commit_instr>
>>=20
>> There has been some related discussion, which I am supportive of, in=
 which
>> we use fs/gs instead of TLS.  This maps naturally to the above and r=
emoves
>> the current requirement for per-thread initialization (this is a goo=
d thing!).
>=20
> It would be important to keep allowing other architectures to use TLS=
-based
> approaches though.
>=20
>>=20
>> On debugger interactions:
>>=20
>> There are some nice properties about this new style of API which all=
ow it to
>> actually support safe interactions with a debugger:
>> a) The event counter is a per-cpu value.  This means that we can not=
 advance
>>    it if no threads from the same process execute on that cpu.  This
>>    naturally allows basic single step support with thread-isolation.
>> b) Single-step can be augmented to evalute the ABI without increment=
ing the
>>    event count.
>> c) A debugger can also be augmented to evaluate this ABI and push re=
starts
>>    on the kernel's behalf.
>>=20
>> This is also compatible with David's approach of not single stepping=
 between
>> 2-4 above.  However, I think these are ultimately a little stronger =
since true
>> single-stepping and breakpoint support would be available.  Which wo=
uld be
>> nice to allow actual debugging of sequences.
>>=20
>> (Note that I haven't bothered implementing these in the current patc=
hset as we
>> are still winnowing down on the ABI and they just add complexity.  I=
t's
>> important to note that they are possible however.)
>=20
> Ensuring these restartable critical sections can be used on shared me=
mory
> across processes seems rather important. I wonder if the debuggabilit=
y of the
> critical section really justifies to introduce a "PRIVATE" and a "SHA=
RED" mode
> for the rseq (similar to sys_futex), or if we could just enforce that=
 no
> breakpoint should be inserted within the critical section (except the=
 very
> first instruction).

One more thought about breakpoints: I now understand that with your new=
 approach,
the critical section ranges are only tracked momentarily during the cri=
tical
section. There is no registry kept of all critical sections, which coul=
d make
ptrace peek tweaks challenging.

An alternative approach might be to allow the debugger to put a breakpo=
int
within the critical section, but override the breakpoint handler in the=
 kernel
so that it just resumes user-space execution, effectively ignoring the
breakpoint.

Thanks,

Mathieu

>=20
> Thoughts ?
>=20
> Thanks,
>=20
> Mathieu
>=20
>=20
>>=20
>> Thanks,
>>=20
>> - Paul
>=20
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
