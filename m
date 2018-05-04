From: Ben Maurer <bmaurer@fb.com>
Subject: Re: [RFC PATCH for 4.18 00/14] Restartable Sequences
Date: Fri, 4 May 2018 22:17:38 +0000
Message-ID: <BL0PR1501MB2067A0682D5D74E040ABC9AECF860@BL0PR1501MB2067.namprd15.prod.outlook.com>
References: <20180430224433.17407-1-mathieu.desnoyers@efficios.com>
 <CAKOZuesa338sc_=w6-wvro25idrSN_zx_zrHFyo-bDiORs7FZw@mail.gmail.com>
 <660904075.9201.1525276988842.JavaMail.zimbra@efficios.com>
 <CAKOZueu_7Ha_WXMyxqMEScXo1aHWr9qYRxqyb-Rpd4k1JP3xHA@mail.gmail.com>
 <1718748931.10084.1525363941807.JavaMail.zimbra@efficios.com>
 <CAJWu+opXjYrjrz1=k0TjjCqiYQ0y=6jRMiRWNvb8_dHAtSByug@mail.gmail.com>
 <CAKOZueve1K8bmS0pmeCAAburoJtzRA4DeN=OCyW3kHiNo8WO=A@mail.gmail.com>,<CAJWu+opkzpmwY5jJ0353JKyaOFCqa95AKGhxUdQZ6pZf_omsaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJWu+opkzpmwY5jJ0353JKyaOFCqa95AKGhxUdQZ6pZf_omsaQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joel Fernandes <joelaf@google.com>, Daniel Colascione <dancol@google.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, LKML <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, "andi@firstfloor.org" <andi@firstfloor.org>, "cl@linux.com" <cl@linux.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>
List-Id: linux-api@vger.kernel.org

Hey -

I think the ideas Daniel brings up here are interesting -- specifically the=
 notion that a thread could set a "pre-sleep wish" to signal it's sleeping.=
 As this conversation shows I think there's a fair bit of depth to that. Fo=
r example, the FUTEX_LOCK is an alternative approach. Another idea might be=
 using the "currently running cpu" area of rseq to tell if the process in q=
uestion was sleeping (assuming that the kernel would be modified to set thi=
s to -1 every time a process was unscheduled)

The idea discussed here seems orthogonal to the core thesis of rseq. I'm wo=
ndering if we can focus on getting rseq in, maybe with a eye for making sur=
e this use case could be handled long term. My sense is that this is possib=
le. We could use the flags setting in the per-thread rseq area, or maybe ex=
tend the meaning of the structure rseq_cs points to to signal that there wa=
s information about how to signal the sleeping of the current process. It s=
eems to me this would be a natural way to add the functionality Daniel talk=
s about if desired in the future.

Daniel - do you think there's anything we should do in the patch set today =
that would make it easier to implement your idea in the future without expa=
nding the scope of the patch today. i.e. is there anything else we need to =
do to lay the framework for your idea.

I'd really love to see us get this patch in. There's a whole host of primit=
ives this unlocks (more efficient RCU, better malloc implementations, fast =
reader-writer locks). I'm sure we'll have more ideas about APIs to provide =
once we've explored these use cases, but to me this patch is the MVP we nee=
d to ship to get that feedback. It's a solid framework that we can build up=
on, eg with the "opv" syscall or the idea in this thread if user feedback s=
hows those things are necessary.

-b=
