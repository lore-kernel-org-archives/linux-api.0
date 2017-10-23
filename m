From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Mon, 23 Oct 2017 17:30:13 +0000
Message-ID: <CY4PR15MB16888F91F41A4A1D322C102CCF460@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-2-mathieu.desnoyers@efficios.com>
 <CY4PR15MB1688286D6B1283A1C234BAE6CF4E0@CY4PR15MB1688.namprd15.prod.outlook.com>,<515879378.43966.1508350299712.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515879378.43966.1508350299712.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Michael
List-Id: linux-api@vger.kernel.org

> if (!((long)ip - (long)start_ip <=3D (long)post_commit_offset))
>=A0=A0 return 1;

> This introduces an issue here: if "ip" is lower than "start_ip", we
> can incorrectly think we are in a critical section, when we are in
> fact not.

This shouldn't be an issue if we used unsigned numbers. Eg if start_ip is X=
 and post_commit_offset is L, then (ip - X <=3D L) means that if ip is less=
 than X ip - X will be signed, which will become a large unsigned value.=20

> or to the kernel to set it back to NULL if it finds out that it is
> preempting/delivering a signal over an instruction pointer outside
> of the current rseq_cs start_ip/post_commit_ip range (lazy clear).

I see, lazy clear makes sense. Still, if during most execution periods the =
user code enters some rseq section (likely if rseq is used for something li=
ke malloc) on every context switch this code will have to be run.

> Moreover, this modification would add a subtraction on the common case
> (ip - start_ip), and makes the ABI slightly uglier.

We could benchmark it but the subtraction should be similar in cost to the =
extra comparison but reducing the number of branches seems like it will hel=
p as well. FWIW GCC attempts to translate this kind of sequence to a subtra=
ct and compare: https://godbolt.org/g/5DGLvo.

I agree the ABI is uglier, but since we're mucking with every context switc=
h I thought I'd point it out.

> If I understand well, you are proposing to speed up .so load time by
> means of removing relocations of pointers within rseq_cs, done by
> making those relative to the rseq_cs address.

Yeah, I think this may be overkill as optimization.
