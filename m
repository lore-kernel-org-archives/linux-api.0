From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Thu, 22 Nov 2018 10:14:44 -0500
Message-ID: <20181122151444.GE23599@brightrain.aerifal.cx>
References: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
 <20181122143603.GD23599@brightrain.aerifal.cx>
 <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97463-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <782067422.9852.1542899056778.JavaMail.zimbra@efficios.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 22, 2018 at 10:04:16AM -0500, Mathieu Desnoyers wrote:
> ----- On Nov 22, 2018, at 9:36 AM, Rich Felker dalias@libc.org wrote:
> 
> > On Wed, Nov 21, 2018 at 01:39:32PM -0500, Mathieu Desnoyers wrote:
> >> Register rseq(2) TLS for each thread (including main), and unregister
> >> for each thread (excluding main). "rseq" stands for Restartable
> >> Sequences.
> > 
> > Maybe I'm missing something obvious, but "unregister" does not seem to
> > be a meaningful operation. Can you clarify what it's for?
> 
> There are really two ways rseq TLS can end up being unregistered: either
> through an explicit call to the rseq "unregister", or when the OS frees the
> thread's task struct.
> 
> You bring an interesting point here: do we need to explicitly unregister
> rseq at thread exit, or can we leave that to the OS ?
> 
> The key thing to look for here is whether it's valid to access the
> TLS area of the thread from preemption or signal delivery happening
> at the very end of START_THREAD_DEFN. If it's OK to access it until
> the very end of the thread lifetime, then we could do without an
> explicit unregistration. However, if at any given point of the late
> thread lifetime we end up in a situation where reading or writing to
> that TLS area can cause corruption, then we need to carefully
> unregister it before that memory is reclaimed/reused.

The thread memory cannot be reused until after kernel task exit,
reported via the set_tid_address futex. Also, assuming signals are
blocked (which is absolutely necessary for other reasons) nothing in
userspace can touch the rseq state after this point anyway.

I was more confused about the need for reference counting, though.
Where would anything be able to observe a state other than "refcnt>0"?
-- in which case tracking it makes no sense. If the goal is to make an
ABI thatsupports environments where libc doesn't have rseq support,
and a third-party library is providing a compatible ABI, it seems all
that would be needed it a boolean thread-local "is_initialized" flag.
There does not seem to be any safe way such a library could be
dynamically unloaded (which would require unregistration in all
threads) and thus no need for a count.

Rich
