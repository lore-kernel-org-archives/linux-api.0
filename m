From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH] thread_local_abi system call: caching current CPU
 number (x86)
Date: Fri, 17 Jul 2015 10:03:00 -0700
Message-ID: <20150717170300.GB1424@x>
References: <1437076851-14848-1-git-send-email-mathieu.desnoyers@efficios.com>
 <5CDDBDF2D36D9F43B9F5E99003F6A0D48D616ED9@PRN-MBX02-1.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5CDDBDF2D36D9F43B9F5E99003F6A0D48D616ED9@PRN-MBX02-1.TheFacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ben Maurer <bmaurer@fb.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul Turner <pjt@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 10:49:19AM +0000, Ben Maurer wrote:
> Mathieu Desnoyers wrote:
> > Expose a new system call allowing threads to register a userspace memory
> > area where to store the current CPU number. Scheduler migration sets the
> 
> I really like that this approach makes it easier to add a per-thread interaction between userspace and the kernel in the future.
> 
> >+       if (!tlap || t->thread_local_abi_len <
> >+                       offsetof(struct thread_local_abi, cpu)
> >+                       + sizeof(tlap->cpu))
> 
> Could you save a branch here by enforcing that thread_local_abi_len = 0 if thread_local_abi = null?

"saving a branch" doesn't seem like a good reason to do that; however,
it *is* the convention across other calls: if you pass 0, the pointer
is ignored, but if you pass non-zero, the pointer must be valid or you
get -EFAULT (or an actual segfault).

- Josh Triplett
