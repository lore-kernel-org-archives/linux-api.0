From: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 15:15:48 +0000
Message-ID: <Pine.LNX.4.64.1405151510430.3155@digraph.polyomino.org.uk>
References: <537346E5.4050407@gmail.com>  <CF98E3EF.90564%dvhart@linux.intel.com>
 <1400101522.6897.1.camel@buesod1.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1400101522.6897.1.camel@buesod1.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Darren Hart <dvhart@linux.intel.com>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>, "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Davidlohr Bueso <davidlohr.bueso@hp.com>, Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Linux API <linux-api@vger.kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-Id: linux-api@vger.kernel.org

On Wed, 14 May 2014, Davidlohr Bueso wrote:

> > If I'm wrong, or we can restore the futex() call, great. If not... Should
> > we keep the man-pages and document it as syscall(SYS_futex, ..., op, ...) ?
> 
> +1, is there anything preventing adding a futex wrapper... glibc folks?

See what I said at 
<https://sourceware.org/bugzilla/show_bug.cgi?id=9712#c4> (with references 
to previous discussions).  Someone needs to take the lead on pushing to 
consensus the question of what syscalls should have wrappers in glibc, and 
then implement the conclusions.

-- 
Joseph S. Myers
joseph@codesourcery.com
