From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Date: Tue, 22 Jul 2014 10:48:42 +0200
Message-ID: <20140722084842.GZ3935@laptop>
References: <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos>
 <CFF2E3D6.9D525%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407220047490.20847@nanos>
 <20140721213457.46623e2f@gandalf.local.home>
 <20140722074719.GV3935@laptop>
 <alpine.DEB.2.10.1407221034260.20847@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1407221034260.20847@nanos>
Sender: linux-doc-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Darren Hart <dvhart@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>, Robert Haas <robertmhaas@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 22, 2014 at 10:39:17AM +0200, Thomas Gleixner wrote:
> On Tue, 22 Jul 2014, Peter Zijlstra wrote:
> > Anyway, there is one big fail in the entire futex stack that we 'need'
> > to sort some day and that is NUMA. Some people (again database people)
> > explicitly do not use futexes and instead use sysvsem because of this.
> > 
> > The problem with numa futexes is that because they're vaddr based there
> > is no (persistent) node information. You always end up having to fall
> > back to looking in all nodes before you can guarantee there is no
> > matching futex.
> > 
> > One way to achieve it is by extending the futex value to include a node
> > number, but that's obviously a complete ABI break. Then again, it should
> > be pretty straight fwd, since the node number doesn't need to be part of
> > the actual atomic update part, just part of the userspace storage.
> 
> So you want per node hash buckets, right? Fair enough, but how do you
> make sure, that no thread/process on a different node is fiddling with
> that "node bound" futex as well?

You don't and that should work just as well, just slower. But since the
node id is in the futex 'value' we'll always end up in the right
node-hash, even if its a remote one.

So yes, per node hashes, and a persistent futex->node map.

And before people start talking about mempol and using that to bind
memory to nodes and such, remember that private futexes do not have a
vma lookup and therefore mempols are impossible to use.
