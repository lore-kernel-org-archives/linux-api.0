From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Tue, 17 Oct 2017 16:19:41 +0000
Message-ID: <CY4PR15MB168879D6220D976B04FE482CCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <DM5PR15MB1690DA99E4AA74FBE54CF7F9CF480@DM5PR15MB1690.namprd15.prod.outlook.com>
 <CA+55aFzPBES0JOYuZhuNM7NKN+G9ytZQT2daueFPw0j9HGpdGQ@mail.gmail.com>
 <20171013205418.GM3521@linux.vnet.ibm.com>
 <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com>
 <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com>
 <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com>
 <20171016164600.GO2482@two.firstfloor.org>,<21865534.42661.1508192263844.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <21865534.42661.1508192263844.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: carlos <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7PKcE1GVeWGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hey,

> So far the restrictions I see for libraries using this symbol are:
> - They should never be unloaded,
> - They should never be loaded with dlopen RTLD_LOCAL flag.

We talked a bit about this off-list but I wanted to state publicly that I t=
hink this model works well for our use case. Specifically,

(1) It reduces complexity by focusing on the common case -- long term we ex=
pect glibc to manage the process of using this feature and registering/dere=
gistering threads for rseq. Unloading isn't a challenge in these situations=
, so why add the complexity for it?

(2) This still allows for early adopters to use rseq before there is glibc =
support. I believe the vast majority of real world applications meet these =
two criteria you've listed. If not, they can create a thin shared library t=
hat has the sole purpose of providing the weak symbol and that never gets u=
nloaded

(3) This allows for applications to provide the __rseq_abi so that they can=
 ensure it uses the initial_exec tls model and optimize in-application asse=
mbly code for it. This is a good optimization for server applications that =
tend to statically link.

If others agree with this, would it make sense to remove the concept of ref=
erence counting in the system call that defines and redefines the per-threa=
d area? Seems like it would remove complexity.

-b=
