From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v11 for 4.15 01/24] Restartable sequences system call
Date: Tue, 14 Nov 2017 21:48:16 +0000
Message-ID: <CY4PR15MB1688889C3A48AEBDD7C3AC5ACF280@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-2-mathieu.desnoyers@efficios.com>
 <CY4PR15MB168866BFDCFECF81B7EF4CF1CF280@CY4PR15MB1688.namprd15.prod.outlook.com>,<574606484.15158.1510692743725.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <574606484.15158.1510692743725.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org


>>>=A0=A0=A0=A0=A0=A0 int rseq(struct rseq * rseq, uint32_t rseq_len, int f=
lags, uint32_t sig);
>>=20
>> Really dumb question -- and one I'm sorry to bring up at the last minute=
. Should
>> we consider making the syscall name something more generic "register_tls=
_abi"?
> I proposed that approach back in 2016 ("tls abi" system call), and the fe=
edback
> I received back then is that it was preferred to have a dedicated "rseq" =
system
> call than an "open ended" and generic "tls abi" system call.

Ultimately I'm fine either way. I do think that in the past few months of r=
eview it has become clear that creating this tls abi requires a fair bit of=
 work. It'd be a shame to see a future attempt to use such an ABI made diff=
icult by forcing the author to figure out the registration process yet agai=
n. I assume the maintainers of glibc would also like to avoid the need to r=
egister multiple ABIs.

-b=
