From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Sun, 7 Aug 2016 15:36:24 +0000 (UTC)
Message-ID: <468742193.3955.1470584184630.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <20160803154522.GA19969@insomnia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160803154522.GA19969@insomnia>
Sender: linux-kernel-owner@vger.kernel.org
To: Boqun Feng <boqun.feng@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

----- On Aug 3, 2016, at 11:45 AM, Boqun Feng boqun.feng@gmail.com wrote:

> On Wed, Aug 03, 2016 at 03:19:40PM +0200, Peter Zijlstra wrote:
>> On Thu, Jul 21, 2016 at 05:14:16PM -0400, Mathieu Desnoyers wrote:
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 1209323..daef027 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -5085,6 +5085,13 @@ M:	Joe Perches <joe@perches.com>
>> >  S:	Maintained
>> >  F:	scripts/get_maintainer.pl
>> >  
>> > +RESTARTABLE SEQUENCES SUPPORT
>> > +M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> 
>> It would be good to have multiple people here, if we lack volunteers I'd
>> be willing. Paul, Andrew any of you guys willing?
>> 
> 
> I volunteer to review related patches, do tests/benchmarks(esp. on PPC)
> and try to fix/improve any issue as I can.
> 
> Mathieu, may I join the party? ;-)

Hi!

I'm glad to see so much interest in helping me maintain rseq :)
I'll therefore tentatively add the following lines to the maintainers
list in my next round:

RESTARTABLE SEQUENCES SUPPORT
M:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
M:	Peter Zijlstra <peterz@infradead.org>
M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
M:	Boqun Feng <boqun.feng@gmail.com>
L:	linux-kernel@vger.kernel.org
S:	Supported
F:	kernel/rseq.c
F:	include/uapi/linux/rseq.h

Thanks!

Mathieu

> 
> Regards,
> Boqun
> 
>> > +L:	linux-kernel@vger.kernel.org
>> > +S:	Supported
>> > +F:	kernel/rseq.c
>> > +F:	include/uapi/linux/rseq.h
>> > +
>> >  GFS2 FILE SYSTEM
>> >  M:	Steven Whitehouse <swhiteho@redhat.com>
>> >  M:	Bob Peterson <rpeterso@redhat.com>
>> 
> [...]

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
