From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 15:59:10 +0000 (UTC)
Message-ID: <966747921.48958.1460044750563.JavaMail.zimbra@efficios.com>
References: <5702A037.60200@zytor.com> <20160405164722.GB3430@twins.programming.kicks-ass.net> <570621E5.7060306@redhat.com> <20160407103158.GP3430@twins.programming.kicks-ass.net> <570638D9.7010108@redhat.com> <20160407111938.GR3430@twins.programming.kicks-ass.net> <57064CA9.101@redhat.com> <20160407122528.GS3430@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160407122528.GS3430-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 7, 2016, at 8:25 AM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org w=
rote:

> On Thu, Apr 07, 2016 at 02:03:53PM +0200, Florian Weimer wrote:
>> > struct tlabi {
>> > 	union {
>> > 		__u8[64] __foo;
>> > 		struct {
>> > 			/* fields go here */
>> > 		};
>> > 	};
>> > } __aligned__(64);
>>=20
>> That's not really =E2=80=9Cfixed size=E2=80=9D as far as an ABI is c=
oncerned, due to the
>> possibility of future extensions.
>=20
> sizeof(struct tlabi) is always the same, right? How is that not fixed=
?
>=20
>> > People objected against the fixed size scheme, but it being possib=
le to
>> > get a fixed TCB offset and reduce indirections is a big win IMO.
>>=20
>> It's a difficult trade-off.  It's not an indirection as such, it's a=
void
>> loading the dynamic TLS offset.
>=20
> What we _want_ is being able to use %[gf]s:offset and have it work (I
> forever forget which segment register userspace TLS uses).
>=20
>> Let me repeat that the ELF TLS GNU ABI has very limited support for
>> static offsets at present, and it is difficult to make them availabl=
e
>> more widely without code generation at run time (in the form of text
>> relocations, but still).
>=20
> Do you have a pointer to something I can read? Because I'm clearly no=
t
> understanding the full issue here.

=46or what is is worth, here are a couple of objdump snippet of my
test program without and with -fPIC:

* Compiled with -O2, *without* -fPIC, x86-64:

__thread __attribute__((weak)) volatile struct thread_local_abi __threa=
d_local_abi;

static
int32_t read_cpu_id(void)
{
        if (unlikely(!(__thread_local_abi.features & TLABI_FEATURE_CPU_=
ID)))
  40064e:       64 8b 04 25 c0 ff ff    mov    %fs:0xffffffffffffffc0,%=
eax
  400655:       ff=20
  400656:       a8 01                   test   $0x1,%al
  400658:       74 71                   je     4006cb <main+0xab>
                return sched_getcpu();
        return __thread_local_abi.cpu_id;
  40065a:       64 8b 14 25 c4 ff ff    mov    %fs:0xffffffffffffffc4,%=
edx
  400661:       ff=20
}


* Compiled with -O2, with -fPIC, x86_64:

__thread __attribute__((weak)) volatile struct thread_local_abi __threa=
d_local_abi;


  4006de:       64 48 8b 04 25 00 00    mov    %fs:0x0,%rax
  4006e5:       00 00=20

static
int32_t read_cpu_id(void)
{
        if (unlikely(!(__thread_local_abi.features & TLABI_FEATURE_CPU_=
ID)))
  4006e7:       48 8d 80 c0 ff ff ff    lea    -0x40(%rax),%rax
  4006ee:       8b 10                   mov    (%rax),%edx
  4006f0:       83 e2 01                and    $0x1,%edx
  4006f3:       0f 84 80 00 00 00       je     400779 <main+0xc9>
                return sched_getcpu();
        return __thread_local_abi.cpu_id;
  4006f9:       8b 50 04                mov    0x4(%rax),%edx
}

So with -fPIC (libraries), TLS adds an extra indirection. However,
it just needs to load the base address once, and can then access
both "features" and "cpu_id" fields as offsets from that base.

=46or executables compiled without -fPIC, there is no indirection.
This justifies the following paragraph in the proposed man page:

           The symbol __thread_local_abi is recommended  to  be  used  =
across
           libraries  and applications wishing to register a the thread=
-local
           ABI structure for tlabi_nr 0. The attribute "weak" is  recom=
mended
           when  declaring  this  variable  in  libraries.   Applicatio=
ns can
           choose to define their own version of this symbol without th=
e weak
           attribute as a performance improvement.

Thoughts ?

Thanks,

Mathieu

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
