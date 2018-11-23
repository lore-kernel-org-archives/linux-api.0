From: Rich Felker <dalias@libc.org>
Subject: Re: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl
 init and thread creation
Date: Fri, 23 Nov 2018 12:44:38 -0500
Message-ID: <20181123174438.GL23599@brightrain.aerifal.cx>
References: <686626451.10113.1542901620250.JavaMail.zimbra@efficios.com>
 <87wop5xeit.fsf@oldenburg.str.redhat.com>
 <1045257294.10291.1542905262086.JavaMail.zimbra@efficios.com>
 <87k1l5xd33.fsf@oldenburg.str.redhat.com>
 <20181122171010.GH23599@brightrain.aerifal.cx>
 <871s7cvt1l.fsf@oldenburg.str.redhat.com>
 <20181123142843.GJ23599@brightrain.aerifal.cx>
 <1150466925.11664.1542992720871.JavaMail.zimbra@efficios.com>
 <20181123173019.GK23599@brightrain.aerifal.cx>
 <87zhtzsngn.fsf@oldenburg.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <libc-alpha-return-97508-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
Content-Disposition: inline
In-Reply-To: <87zhtzsngn.fsf@oldenburg.str.redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
To: Florian Weimer <fweimer@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, carlos <carlos@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 23, 2018 at 06:39:04PM +0100, Florian Weimer wrote:
> * Rich Felker:
> 
> > On Fri, Nov 23, 2018 at 12:05:20PM -0500, Mathieu Desnoyers wrote:
> >> There has been presumptions about signals being blocked when the thread
> >> exits throughout this email thread. Out of curiosity, what code is
> >> responsible for disabling signals in this situation ? Related to this,
> >> is it valid to access a IE model TLS variable from a signal handler at
> >> _any_ point where the signal handler nests over thread's execution ?
> >> This includes early start and just before invoking the exit system call.
> >
> > It should be valid to access *any* TLS object like this, but the
> > standards don't cover it well.
> 
> C++ makes it undefined:
> 
>   <http://eel.is/c++draft/support.signal#def:evaluation,signal-safe>

C also leaves access to pretty much anything from a signal handler
undefined, but that makes signals basically useless. POSIX
inadvertently defines a lot more than it wanted to by ignoring
indirect ways you can access objects using AS-safe functions to pass
around their addresses; there's an open issue for this:

http://austingroupbugs.net/view.php?id=728

I think it's reasonable to say, based on how fond POSIX is of signals
for realtime stuff, that it should allow some reasonable operations,
but just be more careful about what it allows, and disallowing access
to TLS would preclude the only ways to make signals non-awful for
multithreaded processes.

Rich
