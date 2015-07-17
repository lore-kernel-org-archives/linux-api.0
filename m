From: =?utf-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
Subject: Re: [RFC PATCH] getcpu_cache system call: caching current CPU
 number (x86)
Date: Fri, 17 Jul 2015 12:21:05 +0200
Message-ID: <20150717102105.GA21915@domone>
References: <1436724386-30909-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F39C6@PRN-MBX02-1.TheFacebook.com>
 <587954201.31.1436808992876.JavaMail.zimbra@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D5F5DA0@PRN-MBX02-1.TheFacebook.com>
 <549319255.383.1437070088597.JavaMail.zimbra@efficios.com>
 <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-61063-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <CALCETrWEKE=mow3vVh7C4r8CuGy_d5VOEz7KkpijuR5cpBfFtg@mail.gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ben Maurer <bmaurer@fb.com>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Lai Jiangshan <laijs@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-api <linux-api@vger.kernel.org>, libc-alpha <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 16, 2015 at 12:27:10PM -0700, Andy Lutomirski wrote:
> On Thu, Jul 16, 2015 at 11:08 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > ----- On Jul 14, 2015, at 5:34 AM, Ben Maurer bmaurer@fb.com wrote:
> >>
> >> That said, having the ability for the kernel to understand that TLS
> >> implementation are laid out using the same offset on each thread seems like
> >> something that could be valuable long term. Doing so makes it possible to build
> >> other TLS-based features without forcing each thread to be registered.
> >
> > AFAIU, using a fixed hardcoded ABI between kernel and user-space might make
> > transition from the pre-existing ABI (where this memory area is not
> > reserved) a bit tricky without registering the area, or getting a "feature"
> > flag, through a system call.
> >
> > The related question then becomes: should we issue this system call once
> > per process, or once per thread at thread creation ? Issuing it once per
> > thread is marginally more costly for thread creation, but seems to be
> > easier to deal with internally within the kernel.
> >
> > We could however ensure that only a single system call is needed per new-coming
> > thread, rather than one system call per feature. One way to do this would be
> > to register an area that may contain more than just the CPU id. It could
> > consist of an expandable structure with fixed offsets. When registered, we
> > could pass the size of that structure as an argument to the system call, so
> > the kernel knows which features are expected by user-space.
> 
> If we actually bit the bullet and implemented per-cpu mappings, we
> could have this be completely flexible because there would be no
> format at all.  Similarly, if we implemented per-cpu segments,
> userspace would need to agree with *itself* how to arbitrate it, but
> the kernel wouldn't need to be involved.
> 
> With this kind of memory poking, it's definitely messier, which is unfortunate.
> 
Could you recapitulate thread? On libc side we didn't read most of it so
it would be appreciated.

If per-cpu mappings mean that there is a single virtual page that is
mapped to different virtual pages?

I had in my todo list improving tls access. This would help tls
implementations for older arms and in general architectures that dont
store tcb in register.

My proposal is modulo small constant equivalent of userspace accessing tid 
without syscall overhead, just use array of tcb's for first 32768 tids
and do syscall only when tid exceeds that.

On userspace my proposal would be use map that to fixed virtual address and store tcb in first eigth bytes. Kernel would on context switch along registers also
save and restore these. That would make tls access cheap as it would
need only extra load instruction versus static variable.
