From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC PATCH v6 1/5] Thread-local ABI system call: cache CPU
 number of running thread
Date: Thu, 7 Apr 2016 14:25:28 +0200
Message-ID: <20160407122528.GS3430@twins.programming.kicks-ass.net>
References: <5702A037.60200@zytor.com>
 <492303698.44994.1459799188052.JavaMail.zimbra@efficios.com>
 <856357054.45028.1459802903401.JavaMail.zimbra@efficios.com>
 <5703E191.2040707@redhat.com>
 <20160405164722.GB3430@twins.programming.kicks-ass.net>
 <570621E5.7060306@redhat.com>
 <20160407103158.GP3430@twins.programming.kicks-ass.net>
 <570638D9.7010108@redhat.com>
 <20160407111938.GR3430@twins.programming.kicks-ass.net>
 <57064CA9.101@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57064CA9.101-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 07, 2016 at 02:03:53PM +0200, Florian Weimer wrote:
> > struct tlabi {
> > 	union {
> > 		__u8[64] __foo;
> > 		struct {
> > 			/* fields go here */
> > 		};
> > 	};
> > } __aligned__(64);
>=20
> That's not really =E2=80=9Cfixed size=E2=80=9D as far as an ABI is co=
ncerned, due to the
> possibility of future extensions.

sizeof(struct tlabi) is always the same, right? How is that not fixed?

> > People objected against the fixed size scheme, but it being possibl=
e to
> > get a fixed TCB offset and reduce indirections is a big win IMO.
>=20
> It's a difficult trade-off.  It's not an indirection as such, it's av=
oid
> loading the dynamic TLS offset.

What we _want_ is being able to use %[gf]s:offset and have it work (I
forever forget which segment register userspace TLS uses).

> Let me repeat that the ELF TLS GNU ABI has very limited support for
> static offsets at present, and it is difficult to make them available
> more widely without code generation at run time (in the form of text
> relocations, but still).

Do you have a pointer to something I can read? Because I'm clearly not
understanding the full issue here.
