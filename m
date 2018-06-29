From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are < TASK_SIZE
Date: Fri, 29 Jun 2018 07:02:04 -0700
Message-ID: <CA+55aFzpD5xF80iiFNd+EMkJnRQdKPumM5p24Sr+LeBt8Gg=wg@mail.gmail.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com>
 <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com>
 <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
 <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
 <CA+55aFzxCjkSbfRUeX3W_oXSJ6LMUdRVYB=DR2b3rUNkiixM1A@mail.gmail.com> <9200ED2A-AE4B-4094-81C9-E92240B4840F@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9200ED2A-AE4B-4094-81C9-E92240B4840F@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Lutomirski <luto@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, Peter Anvin <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Christoph Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 28, 2018 at 6:08 PM Andy Lutomirski <luto@amacapital.net> wrote:
> > On Jun 28, 2018, at 5:18 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> >
> > Make it do
> >
> >        if (rseq_cs->abort_ip != (unsigned long)rseq_cs->abort_ip)
> >                return -EINVAL;
> >
> > at abort time.
>
> You sure?  Because, unless I remember wrong, a 32-bit user program on a 64-bit kernel will actually work at least most of the time even if high bits are set.

Sure.

If you run a 32-bit binary on a 64-bit kernel,. you will have access
to the 0xc0000000 - 0xffffffff area that you wouldn't have had access
to if it ran on a 32-bit kernel.

But exactly *because* you have access to that area, those addresses
are actually valid addresses for the 32-bit case, so they shouldn't be
considered bad. They can't happen on a native 32-bit kerne, but a
32-bit program doesn't even care. If it has user memory mapped in that
area, it should work.

And if it *doesn't* have user memory mapped in that area, then it will
fail when the trying to execute the (non-existent) abort sequence.

After all, depending on configuration, a native 32-bit kernel might
limit user space even more (ie some vendors had a 2G:2G split instead
of the traditional 3G:1G split.

Was that the case you were thinking of, or was it something else?

              Linus
