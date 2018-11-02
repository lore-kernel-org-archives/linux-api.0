From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 1/2] glibc: Perform rseq(2) registration at nptl init
 and thread creation (v3)
Date: Fri, 2 Nov 2018 08:20:18 -0700
Message-ID: <CALCETrWG4j7R7jzuoPW6ifYVzwuQGMEHBp7Pb_k66_2hn1wUHg@mail.gmail.com>
References: <20181102115259.11383-1-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181102115259.11383-1-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: libc-alpha <libc-alpha@sourceware.org>, Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, "Joseph S. Myers" <joseph@codesourcery.com>, szabolcs.nagy@arm.com, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 2, 2018 at 4:53 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Here is a third round of prototype registering rseq(2) TLS for each
> thread (including main), and unregistering for each thread (excluding
> main). "rseq" stands for Restartable Sequences.
>
> Remaining open questions:
>
> - How early do we want to register rseq and how late do we want to
>   unregister it ? It's important to consider if we expect rseq to
>   be used by the memory allocator and within destructor callbacks.
>   However, we want to be sure the TLS (__thread) area is properly
>   allocated across its entire use by rseq.
>
> - We do not need an atomic increment/decrement for the refcount per
>   se. Just being atomic with respect to the current thread (and nested
>   signals) would be enough. What is the proper API to use there ?
>
> See the rseq(2) man page proposed here:
>   https://lkml.org/lkml/2018/9/19/647
>

Merely having rseq registered carries some small but nonzero overhead,
right?  Should this perhaps live in a librseq.so or similar (possibly
built as part of libc) to avoid the overhead for programs that don't
use it?
