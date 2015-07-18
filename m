From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU number
 (x86)
Date: Sat, 18 Jul 2015 03:34:33 -0400
Message-ID: <20150718073433.GH1173@brightrain.aerifal.cx>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
 <20150717232836.GA13604@domone>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-61107-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <20150717232836.GA13604@domone>
To: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ben Maurer <bmaurer@fb.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Sat, Jul 18, 2015 at 01:28:36AM +0200, Ondřej Bílka wrote:
> On Fri, Jul 17, 2015 at 11:48:14AM -0700, Linus Torvalds wrote:
> > On Thu, Jul 16, 2015 at 12:27 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > >
> > > If we actually bit the bullet and implemented per-cpu mappings
> > 
> > That's not ever going to happen.
> > 
> > The Linux VM model of "one page table per VM" is the right one.
> > Anything else sucks, and makes threading a disaster.
> > 
> > So you can try to prove me wrong, but seriously, I doubt you'll succeed.
> > 
> > On x86, if you want per-cpu memory areas, you should basically plan on
> > using segment registers instead (although other odd state has been
> > used - there's been the people who use segment limits etc rather than
> > the *pointer* itself, preferring to use "lsl" to get percpu data. You
> > could also imaging hiding things in the vector state somewhere if you
> > control your environment well enough).
> >
> Thats correct, problem is that you need some sort of hack like this on
> archs that otherwise would need syscall to get tid/access tls variable.
> 
> On x64 and archs that have register for tls this could be implemented
> relatively easily.
> 
> Kernel needs to allocate 
> 
> int running_cpu_for_tid[32768];

This does not scale. You're assuming the default task ("pid") number
limit, but this can be raised up to 512k (beyond that is impossible
because of PI/robust futex ABI).

> On context switch it atomically writes to this table 
> 
> running_cpu_for_tid[tid] = cpu;
> 
> This table is read-only accessible from userspace as mmaped file.

There is a much simpler solution: use a per-cpu (rather than per-task)
page that contains the right value for the cpu. I believe vdso already
does something like this, no?

Rich
