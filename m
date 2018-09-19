From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Wed, 19 Sep 2018 16:10:54 -0400 (EDT)
Message-ID: <466724077.8623.1537387854947.JavaMail.zimbra@efficios.com>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com> <alpine.DEB.2.21.1809191944470.4536@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809191944470.4536@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, nd <nd@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha <libc-alpha@sourceware.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Sep 19, 2018, at 3:49 PM, Joseph Myers joseph@codesourcery.com wrote:

> On Wed, 19 Sep 2018, Szabolcs Nagy wrote:
> 
>> i don't think there is precedent for exposing tls symbol in glibc
>> (e.g. errno is exposed via __errno_location function) so there
>> might be issues with this (but i don't have immediate concerns).
> 
> There have been suggestions to expose TLS errno - but also suggestions
> that use of __errno_location is more efficient, at least in terms of code
> size everywhere errno is accessed (for some ABIs, anyway).

AFAIU, the trade-off is different between the errno use-case and the
rseq use-case.

If my understanding is correct, errno is not supposed to be used in
fast-paths, only when an error is returned. So size is more important than
speed there.

Comparatively, rseq is _meant_ to speed up fast-paths. A per-cpu statistics
counter can be incremented in 2ns with rseq on a Intel E5-2630, which is faster
than a simple function call.

So for rseq, we should favor speed over space, which means the user applications
and libraries would need access to the TLS symbol without requiring an
accessor function. That's also why I'm using the initial-exec tls model
rather than the global-dynamic: I want to make sure no function call is
generated there.

> The ABI tests have code that would list .tbss symbols as "T" in ABI test
> baselines, but no existing ABI baselines use that.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
