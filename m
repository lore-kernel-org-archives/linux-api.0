From: Joseph Myers <joseph@codesourcery.com>
Subject: Re: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init
 and thread creation
Date: Wed, 19 Sep 2018 19:49:06 +0000
Message-ID: <alpine.DEB.2.21.1809191944470.4536@digraph.polyomino.org.uk>
References: <20180919144438.1066-1-mathieu.desnoyers@efficios.com> <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c58d4d6e-f22a-f5d9-e23a-5bd72cec1a86@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, nd@arm.com, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, 19 Sep 2018, Szabolcs Nagy wrote:

> i don't think there is precedent for exposing tls symbol in glibc
> (e.g. errno is exposed via __errno_location function) so there
> might be issues with this (but i don't have immediate concerns).

There have been suggestions to expose TLS errno - but also suggestions 
that use of __errno_location is more efficient, at least in terms of code 
size everywhere errno is accessed (for some ABIs, anyway).

The ABI tests have code that would list .tbss symbols as "T" in ABI test 
baselines, but no existing ABI baselines use that.

-- 
Joseph S. Myers
joseph@codesourcery.com
