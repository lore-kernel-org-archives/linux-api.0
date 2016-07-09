From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 6/9] x86, pkeys: add pkey set/get syscalls
Date: Sat, 9 Jul 2016 10:37:15 +0200
Message-ID: <20160709083715.GA29939@gmail.com>
References: <20160707124719.3F04C882@viggo.jf.intel.com>
 <20160707124728.C1116BB1@viggo.jf.intel.com>
 <20160707144508.GZ11498@techsingularity.net>
 <577E924C.6010406@sr71.net>
 <20160708071810.GA27457@gmail.com>
 <577FD587.6050101@sr71.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <577FD587.6050101@sr71.net>
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave@sr71.net>
Cc: Mel Gorman <mgorman@techsingularity.net>, linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, dave.hansen@linux.intel.com, arnd@arndb.de, hughd@google.com, viro@zeniv.linux.org.uk, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-Id: linux-api@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On 07/08/2016 12:18 AM, Ingo Molnar wrote:
>
> > So the question is, what is user-space going to do? Do any glibc patc=
hes=20
> > exist? How are the user-space library side APIs going to look like?
>=20
> My goal at the moment is to get folks enabled to the point that they ca=
n start=20
> modifying apps to use pkeys without having to patch their kernels.
>  I don't have confidence that we can design good high-level userspace i=
nterfaces=20
> without seeing some real apps try to use the low-level ones and seeing =
how they=20
> struggle.
>=20
> I had some glibc code to do the pkey alloc/free operations, but those a=
ren't=20
> necessary if we're doing it in the kernel.  Other than getting the sysc=
all=20
> wrappers in place, I don't have any immediate plans to do anything in g=
libc.
>=20
> Was there something you were expecting to see?

Yeah, so (as you probably guessed!) I'm starting to have second thoughts =
about the=20
complexity of the alloc/free/set/get interface I suggested, and Mel's rev=
iew=20
certainly strengthened that feeling.

I have two worries:

1)

A technical worry I have is that the 'pkey allocation interface' does not=
 seem to=20
be taking the per thread property of pkeys into account - while that prop=
erty=20
would be useful for apps. That is a limitation that seems unjustified.

The reason for this is that we are storing the key allocation bitmap in s=
truct_mm,=20
in mm->context.pkey_allocation_map - while we should be storing it in tas=
k_struct=20
or thread_info.

We could solve this by moving the allocation bitmap to the task struct, b=
ut:

2)

My main worry is that it appears at this stage that we are still pretty f=
ar away=20
from completely shadowing the hardware pkey state in the kernel - and wit=
hout that=20
we cannot really force user-space to use the 'proper' APIs. They can just=
 use the=20
raw instructions, condition them on a CPUID and be done with it: everythi=
ng can be=20
organized in user-space.

Furthermore, implementing it in a high performance fashion would be prett=
y complex=20
- at minimum we'd have to register a per thread read-write user-space dat=
a area=20
where the kernel could store pkeys management data so that vsyscalls can =
access it=20
... None of that facility exists today.

And without vsyscall optimizations user-space might legitimately use its =
own=20
implementation for performance reasons and we'd end up with twice the com=
plexity=20
and a largely unused piece of kernel infrastructure ...

So how about the following minimalistic approach instead, to get the ball=
 rolling=20
without making ABI decisions we might regret:

 - There are 16 pkey indices on x86 currently. We already use index 15 fo=
r the=20
   true PROT_EXEC implementation. Let's set aside another pkey index for =
the=20
   kernel's potential future use (index 14), and clear it explicitly in t=
he=20
   FPU context on every context switch if CONFIG_X86_DEBUG_FPU is enabled=
 to make=20
   sure it remains unallocated.

 - Expose just the new mprotect_pkey() system call to install a pkey inde=
x into=20
   the page tables - but we let user-space organize its key allocations.

 - Give user-space an idea about limits:

     "ALL THESE WORLDS ARE YOURS=E2=80=94EXCEPT EUROPA ATTEMPT NO LANDING=
 THERE"

   Ooops, wrong one. Lets try this instead:

     Expose the current maximum user-space usable pkeys index in some
     programmatically accessible fashion. Maybe mprotect_pkey() could rej=
ect a=20
     permanently allocated kernel pkey index via a distinctive error code=
?

   I.e. this pattern:

     ret =3D pkey_mprotect(NULL, PAGE_SIZE, real_prot, pkey);

   ... would validate the pkey and we'd return -EOPNOTSUPP for pkey that =
is not=20
   available? This would allow maximum future flexibility as it would not=
 define=20
   kernel allocated pkeys as a 'range'.

 - ... and otherwise leave the remaining 14 pkey indices for user-space t=
o manage.

If in the future user-space pkeys usage grows to such a level that kernel=
=20
arbitration becomes desirable then we can still implement the get/set/all=
oc/free=20
system calls as well: the first use of those system calls would switch on=
 the=20
kernel's pkey management facilities and from that point on user-space is =
supposed=20
to use the published system calls only. Applications using pkey instructi=
ons=20
directly would still work just fine: they'd never use the new system call=
s.

I.e. we can actually keep a bigger ABI flexibility by introducing the sim=
plest=20
possible ABI at this stage. Maybe user-space usage of this hardware featu=
re will=20
never grow beyond that simple ABI - in which case we've saved quite a bit=
 of=20
ongoing maintenance complexity...

And yes, I realize that we've come a full round since the very first vers=
ion of=20
this patch set, but I think the extra hoops were still worth it, because =
the=20
true-PROT_EXEC feature came out of it which is very useful IMHO. But my m=
ore=20
complex pkey management syscall ideas don't seem to be all that useful an=
ymore.

So what do you think about this direction? This would simplify the patch =
set quite=20
a bit and would touch very little MM code beyond the mprotect_pkey() bits=
.

Thanks,

	Ingo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
