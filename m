From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 12:34:41 +0000 (UTC)
Message-ID: <1708236568.48529.1460032481233.JavaMail.zimbra@efficios.com>
References: <1459789313-4917-1-git-send-email-mathieu.desnoyers@efficios.com> <5703E191.2040707@redhat.com> <20160405164722.GB3430@twins.programming.kicks-ass.net> <570621E5.7060306@redhat.com> <20160407103158.GP3430@twins.programming.kicks-ass.net> <570638D9.7010108@redhat.com> <20160407111938.GR3430@twins.programming.kicks-ass.net> <57064CA9.101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57064CA9.101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 7, 2016, at 8:03 AM, Florian Weimer fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wro=
te:

> On 04/07/2016 01:19 PM, Peter Zijlstra wrote:
>> On Thu, Apr 07, 2016 at 12:39:21PM +0200, Florian Weimer wrote:
>>> On 04/07/2016 12:31 PM, Peter Zijlstra wrote:
>>>> On Thu, Apr 07, 2016 at 11:01:25AM +0200, Florian Weimer wrote:
>>>>>> Because ideally this structure would be part of the initial (gli=
bc) TCB
>>>>>> with fixed offset etc.
>>>>>
>>>>> This is not possible because we have layering violations and code
>>>>> assumes it knows the precise of the glibc TCB.  I think Address
>>>>> Sanitizer is in this category.  This means we cannot adjust the T=
CB size
>>>>> based on the kernel headers used to compile glibc, and there will=
 have
>>>>> to be some indirection.
>>>>
>>>> So with the proposed fixed sized object it would work, right?
>>>
>>> I didn't see a proposal for a fixed size buffer, in the sense that =
the
>>> size of struct sockaddr_in is fixed.
>>=20
>> This thing proposed a single 64byte structure (with the possibility =
of
>> eventually adding more 64byte structures). Basically:
>>=20
>> struct tlabi {
>> 	union {
>> 		__u8[64] __foo;
>> 		struct {
>> 			/* fields go here */
>> 		};
>> 	};
>> } __aligned__(64);
>=20
> That's not really =E2=80=9Cfixed size=E2=80=9D as far as an ABI is co=
ncerned, due to the
> possibility of future extensions.

Hi Florian,

Let me try to spell out how I'm proposing to combine
fixed-size structure as well as future extensions.
I understand that this trick might be a bit counter-
intuitive.

Initially, we define a fixed size struct tlabi, which
length is 64 bytes. It is zero-padded, and will never be
extended beyond 64 bytes. When we register it to the
system call, we pass value 0 to the tlabi_nr parameter.
So far, the kernel only has to track a single pointer
and a 32-bit features mask per thread.

If we even fill up those 64 bytes, then we need to assign
a new struct tlabi_1. Its length may also be fixed at 64 bytes,
or another size that we can decide at that time. When userspace
will register this new structure, it will pass value 1 as
tlabi_nr parameter. At that point, the kernel will need to
track two pointers per thread, one for tlabi_nr=3D0 and one for
tlabi_nr=3D1. However, the kernel can combine the features_mask
of the two tlabi structures internally into a single uint64_t
bitmask per thread, and then we can extend this to a larger
bitmask if we ever have more than 64 features.

Now the question is: Peter Anvin claims that this scheme is
too complex, and we should just have a dynamically-sized
area, which size is the max between the size known by the
kernel and the size known by glibc. I'm trying to figure out
whether we can do that without adding NULL pointer checks, size
checks, and all sorts of extra code to the user-space fast-path,
or else that would mean going down the fixed-size structure route
would be justified.

Hopefully my summary here helps clarifying a few points.

Thanks!

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
