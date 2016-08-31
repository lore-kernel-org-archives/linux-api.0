From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 31 Aug 2016 17:07:54 -0400
Message-ID: <20160831210754.GZ12660@htj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Wed, Aug 31, 2016 at 12:11:58PM -0700, Andy Lutomirski wrote:
> > You can say that allowing the possibility of deviation isn't a good
> > design choice but it is a design choice with other implications - on
> > how we deal with configurations without cgroup at all, transitioning
> > from v1, bootstrapping a system and avoiding surprising
> > userland-visible behaviors (e.g. like creating magic preset cgroups
> > and silently migrating process there on certain events).
> 
> Are there existing userspace programs that use cgroup2 and enable
> subtree control on / when there are processes in /?  If the answer is
> no, then I think you should change cgroup2 to just disallow it.  If
> the answer is yes, then I think there's a problem and maybe you should
> consider a breaking change.  Given that cgroup2 hasn't really launched
> on a large scale, it seems worthwhile to get it right.

Adding the restriction isn't difficult from implementation point of
view and for a system agent which control the boot process
implementing that wouldn't be difficult either but I can't see what
the actual benefits of the extra restriction would be and there are
tangible downsides to doing so.

Consider a use case where the user isn't interested in fully
accounting and dividing up system resources but wants to just cap
resource usage from a subset of workloads.  There is no reason to
require such usages to fully contain all processes in non-root
cgroups.  Furthermore, it's not trivial to migrate all processes out
of root to a sub-cgroup unless the agent is in full control of boot
process.

At least up until this point in discussion, I can't see actual
benefits of adding this restriction and the only reason for pushing it
seems the initial misunderstanding and purism.

> I don't understand what you're talking about wrt silently migrating
> processes.  Are you thinking about usermodehelper?  If so, maybe it
> really does make sense to allow (or require?) the cgroup manager to
> specify which cgroup these processes end up in.

That was from one of the ideas that I was considering way back where
enabling resource control in an intermediate node automatically moves
internal processes to a preset cgroup whether visible or hidden, which
would be another way of addressing the problem.

None of these affects what cgroup v2 can do at all and the only thing
the userland is asked to do under the current scheme is "if you wanna
keep the whole system divided up and use the same mode of operations
across system-scope and namespace-scope move out of root while setting
yourself up, which also happens to be what you have to do inside
namespaces anyway."

> But, given that all the controllers need to support the current magic
> root exception (for genuinely unaccountable things if nothing else),
> can you explain what would actually go wrong if you just removed the
> restriction entirely?

I have, multiple times.  Can you please read 2-1-2 of the document in
the original post and take the discussion from there?

> Also, here's an idea to maybe make PeterZ happier: relax the
> restriction a bit per-controller.  Currently (except for /), if you
> have subtree control enabled you can't have any processes in the
> cgroup.  Could you change this so it only applies to certain
> controllers?  If the cpu controller is entirely happy to have
> processes and cgroups as siblings, then maybe a cgroup with only cpu
> subtree control enabled could allow processes to exist.

The document lists several reasons for not doing this and also that
there is no known real world use case for such configuration.

Please also note that the behavior that you're describing is actually
what rgroup implements.  It makes a lot more sense there because
threads and groups share the same configuration mechanism and it only
has to worry about competition among threads (anonymous consumption is
out of scope for rgroup).

> >> It *also* won't work (I think) if subtree control is enabled on the
> >> root, but I don't think this is a problem in practice because subtree
> >> control won't be enabled on the namespace root by a sensible cgroup
> >> manager.
> >
> > Exactly the same thing.  You can shoot yourself in the foot but it's
> > easy not to.
> 
> Somewhat off-topic: this appears to be either a bug or a misfeature:
> 
> bash-4.3# mkdir foo
> bash-4.3# ls foo
> cgroup.controllers  cgroup.events  cgroup.procs  cgroup.subtree_control
> bash-4.3# mkdir foo/io.max  <-- IMO this shouldn't have worked
> bash-4.3# echo +io >cgroup.subtree_control
> [   40.470712] cgroup: cgroup_addrm_files: failed to add max, err=-17
> 
> Shouldn't cgroups with names that potentially conflict with
> kernel-provided dentries be disallowed?

Yeap, the name collisions suck.  I thought about disallowing all
sub-cgroups which starts with "KNOWN_SUBSYS." but that has a
non-trivial chance of breaking users which were happy before when a
new controller gets added.  But, yeah, we at least should disallow the
known filenames.  Will think more about it.

Thanks.

-- 
tejun
