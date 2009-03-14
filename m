From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: What can OpenVZ do?
Date: Fri, 13 Mar 2009 19:26:56 -0500
Message-ID: <20090314002656.GA12337@us.ibm.com>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org> <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx> <20090212114207.e1c2de82.akpm@linux-foundation.org> <1234475483.30155.194.camel@nimitz> <20090213102732.GB4608@elte.hu> <20090213113248.GA15275@x200.localdomain> <20090213114503.GG15679@elte.hu> <20090213222818.GA17630@x200.localdomain> <m1wsatrmu0.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <m1wsatrmu0.fsf@fess.ebiederm.org>
Sender: owner-linux-mm@kvack.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org, containers@lists.linux-foundation.org, Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk, hpa@zytor.com, Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>, Pavel Emelyanov <xemul@openvz.org>
List-Id: linux-api@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> 
> > On Fri, Feb 13, 2009 at 12:45:03PM +0100, Ingo Molnar wrote:
> >> 
> >> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >> 
> >> > On Fri, Feb 13, 2009 at 11:27:32AM +0100, Ingo Molnar wrote:
> >> > > Merging checkpoints instead might give them the incentive to get
> >> > > their act together.
> >> > 
> >> > Knowing how much time it takes to beat CPT back into usable shape every time
> >> > big kernel rebase is done, OpenVZ/Virtuozzo have every single damn incentive
> >> > to have CPT mainlined.
> >> 
> >> So where is the bottleneck? I suspect the effort in having forward ported
> >> it across 4 major kernel releases in a single year is already larger than
> >> the technical effort it would  take to upstream it. Any unreasonable upstream 
> >> resistence/passivity you are bumping into?
> >
> > People were busy with netns/containers stuff and OpenVZ/Virtuozzo bugs.
> 
> Yes.  Getting the namespaces particularly the network namespace finished
> has consumed a lot of work.
> 
> Then we have a bunch of people helping with ill conceived patches that seem
> to wear out the patience of people upstream.  Al, Greg kh, Linus.
> 
> The whole recent ressurection of the question of we should have a clone
> with pid syscall.

/me points

Alexey started it :)

But, Linus asks to start with simple checkpoint/restart patches.  Oren's
basic patchset pretty much does that, though, right?  Patches 1-7 just
do a basic single task.  8-10 add simple open files.  11, 13 and 14 do
external checkpoint and multiple tasks.

Are these an ok place to start, or do these need to be simplified even
more?

-serge

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
