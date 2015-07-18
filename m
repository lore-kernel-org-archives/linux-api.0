From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Sat, 18 Jul 2015 12:35:03 +0200
Message-ID: <20150718103503.GA30356@domone>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
 <CA+55aFz-VBnEKh0SPKgu8xV5=Zb+=6odybVUDoOYOknshbcFJA@mail.gmail.com>
 <20150717232836.GA13604@domone>
 <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-61110-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CALCETrVY=kjeA_4pazy3BL+ekfcV6WHKw8e3z-LBxx_uP1bw2Q@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ben Maurer <bmaurer@fb.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 04:33:42PM -0700, Andy Lutomirski wrote:
> On Fri, Jul 17, 2015 at 4:28 PM, Ondřej Bílka <neleai@seznam.cz> wrote:
> > On Fri, Jul 17, 2015 at 11:48:14AM -0700, Linus Torvalds wrote:
> >>
> >> On x86, if you want per-cpu memory areas, you should basically plan on
> >> using segment registers instead (although other odd state has been
> >> used - there's been the people who use segment limits etc rather than
> >> the *pointer* itself, preferring to use "lsl" to get percpu data. You
> >> could also imaging hiding things in the vector state somewhere if you
> >> control your environment well enough).
> >>
> > Thats correct, problem is that you need some sort of hack like this on
> > archs that otherwise would need syscall to get tid/access tls variable.
> >
> > On x64 and archs that have register for tls this could be implemented
> > relatively easily.
> >
> > Kernel needs to allocate
> >
> > int running_cpu_for_tid[32768];
> >
> > On context switch it atomically writes to this table
> >
> > running_cpu_for_tid[tid] = cpu;
> >
> > This table is read-only accessible from userspace as mmaped file.
> >
> > Then userspace just needs to access it with three indirections like:
> >
> > __thread tid;
> >
> > char caches[CPU_MAX];
> > #define getcpu_cache caches[tid > 32768 ? get_cpu() : running_cpu_for_tid[tid]]
> >
> > With more complicated kernel interface you could eliminate one
> > indirection as we would use void * array instead and thread could do
> > syscall to register what values it should use for each thread.
> 
> Or we implement per-cpu segment registers so you can point gs directly
> at percpu data.  This is conceptually easy and has no weird ABI
> issues.  All it needs is an implementation and some good tests.
>
That only works if you have free register on your arch. As gs there was
rfc to teach gcc use it which could give bigger speedup. I didn't see
how much this could help yet so I am bit skeptical.

 
> I think the API should be "set gsbase to x + y*(cpu number)".  On
> x86_64, userspace just allocates a big swath of virtual space and
> populates it as needed.
> 
That wouldn't work well if two shared libraries want to use that. You
would need to use something like se it to 4096*cpu_number or so.

Also we didn't considered yet overhead, as this slows down everything a
bit due slower context switches. So will this needs to have widespread
performance improvement to be worthwhile. What are use cases to make
that pay itself?
