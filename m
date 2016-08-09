From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v7 1/7] Restartable sequences system call
Date: Tue, 9 Aug 2016 13:22:25 +0000 (UTC)
Message-ID: <287916633.5354.1470748945398.JavaMail.zimbra@efficios.com>
References: <1469135662-31512-1-git-send-email-mathieu.desnoyers@efficios.com> <1469135662-31512-2-git-send-email-mathieu.desnoyers@efficios.com> <20160803131940.GM6862@twins.programming.kicks-ass.net> <20160803154522.GA19969@insomnia> <468742193.3955.1470584184630.JavaMail.zimbra@efficios.com> <20160807233543.GB13232@tardis.cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160807233543.GB13232-jkllrLZ6VuqyUtPGxGje5AC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

----- On Aug 7, 2016, at 7:35 PM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> On Sun, Aug 07, 2016 at 03:36:24PM +0000, Mathieu Desnoyers wrote:
>> ----- On Aug 3, 2016, at 11:45 AM, Boqun Feng boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> 
>> > On Wed, Aug 03, 2016 at 03:19:40PM +0200, Peter Zijlstra wrote:
>> >> On Thu, Jul 21, 2016 at 05:14:16PM -0400, Mathieu Desnoyers wrote:
>> >> > diff --git a/MAINTAINERS b/MAINTAINERS
>> >> > index 1209323..daef027 100644
>> >> > --- a/MAINTAINERS
>> >> > +++ b/MAINTAINERS
>> >> > @@ -5085,6 +5085,13 @@ M:	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
>> >> >  S:	Maintained
>> >> >  F:	scripts/get_maintainer.pl
>> >> >  
>> >> > +RESTARTABLE SEQUENCES SUPPORT
>> >> > +M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> >> 
>> >> It would be good to have multiple people here, if we lack volunteers I'd
>> >> be willing. Paul, Andrew any of you guys willing?
>> >> 
>> > 
>> > I volunteer to review related patches, do tests/benchmarks(esp. on PPC)
>> > and try to fix/improve any issue as I can.
>> > 
>> > Mathieu, may I join the party? ;-)
>> 
>> Hi!
>> 
>> I'm glad to see so much interest in helping me maintain rseq :)
>> I'll therefore tentatively add the following lines to the maintainers
>> list in my next round:
>> 
>> RESTARTABLE SEQUENCES SUPPORT
>> M:	Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
>> M:	Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> M:	"Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> M:	Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> S:	Supported
>> F:	kernel/rseq.c
>> F:	include/uapi/linux/rseq.h
>> 
> 
> Thank you, Mathieu ;-)
> 
> Maybe we also should put the selftest directory here? Like:
> 
> F:	tools/testing/selftests/rseq
> 
> Of course, this line better be added in patch 7 rather than patch 1.

Adding this to patch 7, with a "/" at the end of the line, since it
targets an entire directory.

Thanks,

Mathieu

> 
> Regards,
> Boqun
> 
>> Thanks!
>> 
>> Mathieu
>> 
>> > 
>> > Regards,
>> > Boqun
>> > 
>> >> > +L:	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> >> > +S:	Supported
>> >> > +F:	kernel/rseq.c
>> >> > +F:	include/uapi/linux/rseq.h
>> >> > +
>> >> >  GFS2 FILE SYSTEM
>> >> >  M:	Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >  M:	Bob Peterson <rpeterso-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> 
>> > [...]
>> 
>> --
>> Mathieu Desnoyers
>> EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
