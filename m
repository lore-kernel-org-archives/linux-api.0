From: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Tue, 17 Oct 2017 16:41:03 +0000
Message-ID: <CY4PR15MB16886FD43FB48592F3F5892FCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171013205418.GM3521@linux.vnet.ibm.com>
 <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com>
 <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com>
 <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com>
 <20171016164600.GO2482@two.firstfloor.org>
 <21865534.42661.1508192263844.JavaMail.zimbra@efficios.com>
 <CY4PR15MB168879D6220D976B04FE482CCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com>,<1292309161.43101.1508258000235.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292309161.43101.1508258000235.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, carlos <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

>=A0I have a use-case for keeping the reference counting in place though. I=
t's
>=A0use of rseq in signal handlers.

Would this be solved by saying that the rseq api will return an error if yo=
u register and there's already a block registered. In this case the signal =
handler would register the rseq abi area just as the non-signal code is try=
ing to do the same. The non-signal code would see this error code and reali=
ze that its job had been done for it and then go on it's way.

It would be unsafe for signal handler code to *unregister* the area, but I =
don't think that's necessary.

Basically we'd support a refcount of either 0 or 1, but nothing else.

If a signal handler registers the ABI area, how will it ensure the ABI is c=
leaned up at thread exit? I can't imagine pthread_key is signal safe.=
