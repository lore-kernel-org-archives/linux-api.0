From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Date: Wed, 21 Oct 2009 11:33:38 +0200
Message-ID: <20091021093338.GA11670@elf.ucw.cz>
References: <20091013044925.GA28181@us.ibm.com>
 <20091013045556.GJ28435@us.ibm.com>
 <20091019213636.GB1482@ucw.cz>
 <200910211037.38413.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753275AbZJUJdm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200910211037.38413.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>, torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu, hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com, kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com, linux-api@vger.kernel.org, Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
List-Id: linux-api@vger.kernel.org

On Wed 2009-10-21 10:37:38, Arnd Bergmann wrote:
> > 
> > > +struct clone_struct {
> > > +	u64 flags;
> > > +	u64 child_stack;
> > 
> > u64 seems wrong  on 32 bit platforms. ulong?
> 
> That would make it incompatible between 64 bit kernels and
> 32 bit user space, requiring a wrapper. Better leave it at u64.

Ok.

> > > +	If a pid in the @pids list is 0, the kernel will assign the next
> > > +	available pid in the pid namespace, for the process.
> > > +
> > > +	If a pid in the @pids list is non-zero, the kernel tries to assign
> > > +	the specified pid in that namespace.  If that pid is already in use
> > > +	by another process, the system call fails with -EBUSY.
> > ...
> > > +	On failure, clone3() returns -1 and sets 'errno' to one of following
> > > +	values (the child process is not created).
> > 
> > Inconsistent with above. Syscalls really return -ERRCODE, errno is
> > glibc magic.
> 
> Quite the opposite is true.

Well, it is still inconsistent. Half the docs talks -ERRCODE, half
talks -1/errno=ERRCODE.

> > > +	pid_t pids[] = { 77, 99 };
> > > +	struct clone_struct cs;
> > > +
> > > +	cs.flags = (u64) SIGCHLD;
> > > +	cs.child_stack = (u64) setup_child_stack();
> > > +	cs.nr_pids = 2;
> > > +	cs.parent_tid = 0LL;
> > > +	cs.child_tid = 0LL;
> > > +
> > > +	rc = syscall(__NR_clone3, &cs, pids);
> > 
> > Hmm, is there reason why pids are not at the end of struct
> > clone_struct? Passing most parameters in special structure, then pids
> > separately is strange...
> 
> I suggested doing that, it's a lot easier to handle fixed length data
> structures than an array at the end.

You could still put the something * pids at the end of (fixed length)
structure.

(Not that I agree with the argument, pid array is variable-length,
anyway, and inlining it at the end of structure should not make code
more complex).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
