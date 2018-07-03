From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Mon, 2 Jul 2018 22:01:31 -0400 (EDT)
Message-ID: <858886246.10882.1530583291379.JavaMail.zimbra@efficios.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com> <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com> <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com> <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com> <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com> <1959930320.10843.1530573742647.JavaMail.zimbra@efficios.com> <8B2E4CEB-3080-4602-8B62-774E400892EB@amacapital.net> <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <459661281.10865.1530580742205.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 9:19 PM, Mathieu Desnoyers mathieu.desnoyers@effic=
ios.com wrote:

> ----- On Jul 2, 2018, at 7:37 PM, Andy Lutomirski luto@amacapital.net wro=
te:
>=20
>>> On Jul 2, 2018, at 4:22 PM, Mathieu Desnoyers <mathieu.desnoyers@effici=
os.com>
>>> wrote:
>>>=20
>>> ----- On Jul 2, 2018, at 7:16 PM, Mathieu Desnoyers
>>> mathieu.desnoyers@efficios.com wrote:
>>>=20
>>>> ----- On Jul 2, 2018, at 7:06 PM, Linus Torvalds torvalds@linux-founda=
tion.org
>>>> wrote:
>>>>=20
>>>>> On Mon, Jul 2, 2018 at 4:00 PM Mathieu Desnoyers
>>>>> <mathieu.desnoyers@efficios.com> wrote:
>>>>>>=20
>>>>>> Unfortunately, that rseq->rseq_cs field needs to be updated by user-=
space
>>>>>> with single-copy atomicity. Therefore, we want 32-bit user-space to =
initialize
>>>>>> the padding with 0, and only update the low bits with single-copy at=
omicity.
>>>>>=20
>>>>> Well... It's actually still single-copy atomicity as a 64-bit value.
>>>>>=20
>>>>> Why? Because it doesn't matter how you write the upper bits. You'll b=
e
>>>>> writing the same value to them (zero) anyway.
>>>>>=20
>>>>> So who cares if the write ends up being two instructions, because the
>>>>> write to the upper bits doesn't actually *do* anything.
>>>>>=20
>>>>> Hmm?
>>>>=20
>>>> Are there any kind of guarantees that a __u64 update on a 32-bit archi=
tecture
>>>> won't be torn into something daft like byte-per-byte stores when perfo=
rmed
>>>> from C code ?
>>>>=20
>>>> I don't worry whether the upper bits get updated or how, but I really =
care
>>>> about not having store tearing of the low bits update.
>>>=20
>>> For the records, most updates of those low bits are done in assembly
>>> from critical sections, for which we control exactly how the update is
>>> performed.
>>>=20
>>> However, there is one helper function in user-space that updates that v=
alue
>>> from C through a volatile store, e.g.:
>>>=20
>>> static inline void rseq_prepare_unload(void)
>>> {
>>>        __rseq_abi.rseq_cs =3D 0;
>>> }
>>=20
>> How about making the field be:
>>=20
>> union {
>> __u64 rseq_cs;
>> struct {
>>   __u32 rseq_cs_low;
>>   __u32 rseq_cs_high;
>> };
>> };
>>=20
>> 32-bit user code that cares about performance can just write to rseq_cs_=
low
>> because it already knows that rseq_cs_high =3D=3D 0.
>>=20
>> The header could even supply a static inline helper write_rseq_cs() that
>> atomically writes a pointer and just does the right thing for 64-bit, fo=
r
>> 32-bit BE, and for 32-bit LE.
>>=20
>> I think the union really is needed because we can=E2=80=99t rely on user=
 code being
>> built with -fno-strict-aliasing.  Or the helper could use inline asm.
>>=20
>> Anyway, the point is that we get optimal code generation (a single instr=
uction
>> write of the correct number of bits) without any compat magic in the ker=
nel.
>=20
> That works for me! Any objection from anyone else for this approach ?

One thing to consider is how we will implement the load of that pointer
on the kernel side. Strictly-speaking, the rseq uapi talks about single-cop=
y
atomicity, and does not specify _which_ thread is expected to update that
pointer. So arguably, the common case is that the current thread is updatin=
g
it, which would allow the kernel to read it piece-wise. However, nothing
prevents user-space from updating it from another thread with single-copy
atomicity.

So in order to be on the safe side, I prefer to guarantee single-copy
atomicity of the get_user() load from the kernel that reads this pointer.
This means a 32-bit kernel would have to perform two independent loads:
one for low bits, one for high bits.

So it does look like we need some __LP64__ ifdefery even with the union
trick. Therefore, I'm not convinced the union is useful at all.

Thoughts ?

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
