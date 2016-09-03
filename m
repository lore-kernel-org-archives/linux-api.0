From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Sat, 3 Sep 2016 18:05:26 -0400
Message-ID: <20160903220526.GA20784@mtj.duckdns.org>
References: <20160805170752.GK2542@mtj.duckdns.org>
 <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello, Andy.

On Wed, Aug 31, 2016 at 02:46:20PM -0700, Andy Lutomirski wrote:
> > Consider a use case where the user isn't interested in fully
> > accounting and dividing up system resources but wants to just cap
> > resource usage from a subset of workloads.  There is no reason to
> > require such usages to fully contain all processes in non-root
> > cgroups.  Furthermore, it's not trivial to migrate all processes out
> > of root to a sub-cgroup unless the agent is in full control of boot
> > process.
> 
> Then please also consider exactly the same use case while running in a
> container.
> 
> I'm a bit frustrated that you're saying that my example failure modes
> consist of shooting oneself in the foot and then you go on to come up
> with your own examples that have precisely the same problem.

You have a point, which is

  The system-root and namespace-roots are not symmetric.

and that's a valid concern.  Here's why the system-root is special.

* A system has entities and resource consumptions which can only be
  attributed to the "system".  The system-root is the natural place to
  put them.  The system-root has stuff no other cgroups, not even
  namespace-roots, have.  It's a unique situation.

* The need to bypass most cgroup related overhead when not in use.
  The system-root is there whether cgroup is actally in use or not and
  thus can not impose noticeable overhead.  It has to make sense for
  both resource-controlled systems as well as ones that aren't.
  Again, no other group has these requirements.

  Note that this means that all controllers should be able to and
  already allow uncontained consumptions in the system-root.  I'll
  come back to this later.

Now, due to the various issues with direct competition between
processes and cgroups, cgroup v2 disallows resource control across
them (the no-internal-tasks restriction); however, cgroup v2 currently
doesn't apply the restriction to the system-root.  Here are the
reasons.

* It doesn't bring any practical benefits in terms of implementation.
  As noted above, all controllers already have to allow uncontained
  consumptions in the system-root and that's the only attribute
  required for the exemption.

* It doesn't bring any practical benefits in terms of capability.
  Userland can trivially handle the system-root and namespace-roots in
  a symmetrical manner.

* It's an unncessary inconvenience, especially for cases where the
  cgroup agent isn't in control of boot, for partial usage cases, or
  just for playing with it.

You say that I'm ignoring the same use case for namespace-scope but
namespace-roots don't have the same hybrid function for partial and
uncontrolled systems, so it's not clear why there even NEEDS to be
strict symmetry.

On this subject, your only actual point is that there is an asymmetry
and that's bothersome.  I've been trying to explain why the special
case doesn't actually get in the way in terms of implementation or
capability and is actually beneficial.  Instead of engaging in the
actual discussion, you're constantly coming up with different ways of
saying "it's not symmetric".

The system-root and namespace-roots aren't equivalent.  There are a
lot of parallels between system-root and namescope-root but they
aren't the same thing (e.g. bootstrapping a namespace is a less
complicated and more malleable process).  The system-root is not even
a fully qualified node of the resource graph.

It's easy and understandable to get hangups on asymmetries or
exemptions like this, but they also often are acceptable trade-offs.
It's really frustrating to see you first getting hung up on "this must
be wrong" and even after explanations repeating the same thing just in
different ways.

If there is something fundamentally wrong with it, sure, let's fix it,
but what's actually broken?

> > I have, multiple times.  Can you please read 2-1-2 of the document in
> > the original post and take the discussion from there?
> 
> I've read it multiple times, and I don't see any explanation that's
> consistent with the fact that you are exempting the root cgroup from
> this constraint.  If the constraint were really critical to everything
> working, then I would expect the root cgroup to have exactly the same
> problem.  This makes me think that either something nasty is being
> fudged for the root cgroup or that the constraint isn't actually so
> important after all.  The only thing on point I can find is:
> 
> > Root cgroup is exempt from this constraint, which is in line with
> > how root cgroup is handled in general - it's excluded from cgroup
> > resource accounting and control.
> 
> and that's not very helpful.

My apologies.  I somehow thought that was part of the documentation.
Will update it later, but here's an excerpt from my earlier response.

  Having a special case doesn't necessarily get in the way of
  benefiting from a set of general rules.  The root cgroup is
  inherently special as it has to be the catch-all scope for entities
  and resource consumptions which can't be tied to any specific
  consumer - irq handling, packet rx, journal writes, memory reclaim
  from global memory pressure and so on.  None of sub-cgroups have to
  worry about them.

  These base-system operations are special regardless of cgroup and we
  already have sometimes crude ways to affect their behaviors where
  necessary through sysctl knobs, priorities on specific kernel
  threads and so on.  cgroup doesn't change the situation all that
  much.  What gets left in the root cgroup usually are the base-system
  operations which are outside the scope of cgroup resource control in
  the first place and cgroup resource graph can treat the root as an
  opaque anchor point.

  There can be other ways to deal with the issue; however, treating
  root cgroup this way has the big advantage of minimizing the gap
  between configurations without and with cgroups both in terms of
  mental model and implementation.

  Hopefully, the case of a namespace root is clear now.  If it's gonna
  have a sub-hierarchy, it itself can't contain processes but the
  system root just contains base-system entities and resources which a
  namespace root doesn't have to worry about.  Ignoring base-system
  stuff, a namespace root is topologically in the same position as the
  system root in the cgroup resource graph.

Maybe this wasn't as clear as I thought it was.  I hope the earlier
part of this message is enough of a clarification.

> >> Also, here's an idea to maybe make PeterZ happier: relax the
> >> restriction a bit per-controller.  Currently (except for /), if you
> >> have subtree control enabled you can't have any processes in the
> >> cgroup.  Could you change this so it only applies to certain
> >> controllers?  If the cpu controller is entirely happy to have
> >> processes and cgroups as siblings, then maybe a cgroup with only cpu
> >> subtree control enabled could allow processes to exist.
> >
> > The document lists several reasons for not doing this and also that
> > there is no known real world use case for such configuration.

So, up until this point, we were talking about no-internal-tasks
constraint.

> My company's production workload would map quite nicely to this
> relaxed model.  I have quite a few processes each with several
> threads.  Some of those threads get some CPUs, some get other CPUs,
> and they vary in what shares of what CPUs they get.  To be clear,
> there is not a hierarchy of resource usage that's compatible with the
> process hierarchy.  Multiple processes have threads that should be
> grouped in a different place in the hierarchy than other threads.
> Concretely, I have processes A and B with threads A1, A2, B1, and B2.
> (And many more, but this is enough to get the point across.)  The
> natural grouping is:
> 
> Group 1: A1 and B1
> Group 2: A2
> Group 3: B2

And now you're talking about process granularity.

> This cannot be expressed with rgroup or with cgroup2.  cgroup1 has no
> problem with it.  If I were using memcg, I would want to have a memcg
> hierarchy that was incompatible with the hierarchy above, so I
> actually find the cgroup2 insistence on a unified hierarchy to be a
> bit annoying, but I at least understand the motivation behind the
> unified hierarchy.
> 
> And I don't care that the system controller can't atomically move this
> whole mess around.  I'm currently running without systemd, so I don't

I do.  It's a horrible userland API to expose to individual
applications if the organization that a given application expects can
be disturbed by system operations.  Imagine how this would be
documented - "if this operation races with system operation, it may
return -ENOENT.  Repeating the path lookup might make the operation
succeed again."

> *have* a system controller.  If I end up migrating to systemd, I'll
> probably put this whole pile into its own slice and manage it
> manually.

Yeah, systemd has delegation feature for cases like that which we
depend on too.

As for your example, who performs the cgroup setup and configuration,
the application itself or an external entity?  If an external entity,
how does it know which thread is what?

And, as for rgroup not covering it, would extending rgroup to cover
multi-process cases be enough or are there more fundamental issues?

> > Yeap, the name collisions suck.  I thought about disallowing all
> > sub-cgroups which starts with "KNOWN_SUBSYS." but that has a
> > non-trivial chance of breaking users which were happy before when a
> > new controller gets added.  But, yeah, we at least should disallow the
> > known filenames.  Will think more about it.
> 
> How about disallowing names that contain a '.'?

That's guaranteed to break things left and right, and, given how
departed it is from what has been all along including v1, it'd be an
actually gratuitous painful change.  While name collisions is a nasty
possibility, it seldom is a practical problem as most use naming
schemes which are unlikely to actually collide.  Even "$SUBSYS." is
likely too broad.  Most cures seem worse than the disease here.

Thanks.

-- 
tejun
