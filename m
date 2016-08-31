From: Tejun Heo <tj@kernel.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 31 Aug 2016 13:32:51 -0400
Message-ID: <20160831173251.GY12660@htj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hello, Andy.

On Tue, Aug 30, 2016 at 08:42:20PM -0700, Andy Lutomirski wrote:
> On Mon, Aug 29, 2016 at 3:20 PM, Tejun Heo <tj@kernel.org> wrote:
> >> This seems to explain why the controllers need to be able to handle
> >> things being charged to the root cgroup (or to an unidentifiable
> >> cgroup, anyway).  That isn't quite the same thing as allowing, from an
> >> ABI point of view, the root cgroup to contain processes and cgroups
> >> but not allowing other cgroups to do the same thing.  Consider:
> >
> > The points are 1. we need the root to be a special container anyway
> 
> But you don't need to let userspace see that.

I'm not saying that what cgroup v2 implements is the only solution.
There of course can be other approaches which don't expose this
particular detail to userland.  I was highlighting that there is an
underlying condition to be dealt with and that what cgroup v2
implements is one working solution for it.

It's fine to have, say, aesthetical disgreements on the specifics of
the chosen approach, and, while a bit late, we can still talk about
pros and cons of different possible approaches and make improvements
where it makes sense.  However, this isn't in any way a
make-it-or-break-it issue as you implied before.

> >> I really, really think that cgroup v2 should supply the same
> >> *interface* inside and outside of a non-root namespace.  If this is
> >
> > It *does*.  That's what I tried to explain, that it's exactly
> > isomorhpic once you discount the system-wide consumptions.
> 
> I don't think I agree.
> 
> Suppose I wrote an init program or a cgroup manager.  I can expect
> that init program to be started in the root cgroup.  The program can
> be lazy and write +io to /cgroup/cgroup.subtree_control and then
> create some new cgroup /cgroup/a and it will work (I just tried it).
> 
> Now I run that program in a namespace.  It will not work because it'll
> get -EBUSY when it tries to write to cgroup.subtree_control.  (I just
> tried this, too, only using cd instead of a namespace.)  So it's *not*
> isomorphic.

Yeah, it is possible to shoot yourself in the foot but both
system-scope and namespace-scope can implement the exactly same
behavior - move yourself out of root before enabling resource controls
and get the same expected outcome, which BTW is how systemd behaves
already.

You can say that allowing the possibility of deviation isn't a good
design choice but it is a design choice with other implications - on
how we deal with configurations without cgroup at all, transitioning
from v1, bootstrapping a system and avoiding surprising
userland-visible behaviors (e.g. like creating magic preset cgroups
and silently migrating process there on certain events).

> It *also* won't work (I think) if subtree control is enabled on the
> root, but I don't think this is a problem in practice because subtree
> control won't be enabled on the namespace root by a sensible cgroup
> manager.

Exactly the same thing.  You can shoot yourself in the foot but it's
easy not to.

Thanks.

-- 
tejun
