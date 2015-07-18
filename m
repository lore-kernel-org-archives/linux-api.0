From: Florian Weimer <fw@deneb.enyo.de>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number (x86)
Date: Sat, 18 Jul 2015 11:47:53 +0200
Message-ID: <877fpxre46.fsf@mid.deneb.enyo.de>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
	<587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
	<5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
	<549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-61108-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
	(Mathieu Desnoyers's message of "Thu, 16 Jul 2015 18:08:08 +0000
	(UTC)")
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ben Maurer <bmaurer@fb.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

* Mathieu Desnoyers:

> The related question then becomes: should we issue this system call once
> per process, or once per thread at thread creation ? Issuing it once per
> thread is marginally more costly for thread creation, but seems to be
> easier to deal with internally within the kernel.

I might be missing something, but here is my take:

It has to be a per-thread attribute because glibc uses clone
internally and wants to set the flag, but the same process may have
application or library code which uses clone to create threads, too,
but does not know about this new feature.  If it's per-process, the
existing code would fail.

(We may argue indefinitely if this is a supported use case from the
glibc point of view, but I'm pretty sure there is code out there which
does exactly this, even though it's fairly complicated to get right.)
