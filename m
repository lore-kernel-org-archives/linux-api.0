From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Mon, 19 Sep 2016 17:53:40 -0400
Message-ID: <20160919215340.GB4023@htj.duckdns.org>
References: <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org>
 <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org>
 <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Thu, Sep 15, 2016 at 01:08:07PM -0700, Andy Lutomirski wrote:
> With regard to no-internal-tasks, I see (at least) three options:
> 
> 1. Keep the cgroup2 status quo.  Lots of distros and such are likely
> to have their cgroup management fail if run in a container.  I really,

I don't know where you're getting this.  No-internal-tasks rule has
*NOTHING* to do with how or how not cgroup v1 hierarchies can be used
inside a namespace.  I suppose this is coming from the same
misunderstanding that Austin has.  Please see my reply there for more
details.

> really dislike this option.

Up until this point, you haven't supplied any valid technical reasons
for your objection.  Repeating "really" doesn't add to the discussion
at all.  If you're indicating that you don't like it on an aeshtetic
ground, please just say so.

> 2. Enforce no-internal-tasks for the root cgroup.  Un-cgroupable
> thinks will still get accounted to the root cgroup even if subtree
> control is on, but no tasks can be in the root cgroup if the root
> cgroup has subtree control on.  (If some controllers removed the
> no-internal-tasks restriction, this would apply to the root as well.)
> I think this may annoy certain users.  If so, and if those users are
> doing something valid, then I think that either those users should be
> strongly encouraged or even forced to changed so namespacing works for
> them or that we should do (3) instead.

Theoretically, we can do that but what are the upsides and are they
enough to justify the added inconveniences?  Up until now, the only
argument you provided is that people may do certain things in
system-root which might not work in namespace-root but that isn't a
critical problem.  No real functionalities are lost by implementing
the same behaviors both inside and outside namespaces.

> 3. Remove the no-internal-tasks restriction entirely.  I can see this
> resulting in a lot of configuration awkwardness, but I think it will
> *work*, especially since all of the controllers already need to do
> something vaguely intelligent when subtree control is on in the root
> and there are tasks in the root.

The reasons for no-internal-tasks restriction have been explained
multiple times in the documentations and throughout this thread, and
we also discussed how and why system-root is special and allowing
system-root's special treatment doesn't break things.

> What I'm trying to say is that I think that option (1) is sufficiently
> bad that cgroup2 should do (2) or (3) instead.  If option (2) is
> preferred and if it would break userspace, then I think we can work
> around it by entirely deprecating cgroup2, renaming it to cgroup3, and
> doing option (2) there.  You've given reasons you don't like options
> (2) and (3).  I mostly agree with those reasons, but I don't think
> they're strong enough to overcome the problems with (1).

And you keep suggesting very drastic measures for an issue which isn't
critical without providing any substantial technical reasons why such
drastic measures would be necessary.  This part of discussion started
with your misunderstanding of the implications of the system-root
being special, and the only reason you presented in the previous
message is still a, different, misunderstanding.

The only thing which isn't changing here is your opinions on how it
should be.  It is a baffling situation because your opinions don't
seem to be affected at all by the validity of reasons for thinking so.

> BTW, Mike keeps mentioning exclusive cgroups as problematic with the
> no-internal-tasks constraints.  Do exclusive cgroups still exist in
> cgroup2?  Could we perhaps just remove that capability entirely?  I've
> never understood what problem exlusive cpusets and such solve that
> can't be more comprehensibly solved by just assigning the cpusets the
> normal inclusive way.

This was explained before during the discussion.  Maybe it wasn't
clear enough.  The knob is a config protector which protects oneself
from changing its configs.  It doesn't really belong in the kernel.
My guess is that it was added because delegation model wasn't properly
established and people tried to delegate resource control knobs along
with the cgroups and then wanted to prevent those knobs from changed
in certain ways.

> >> What kind of migration do you mean?  Having fds follow rename(2) around is
> >> the normal vfs behavior, so I don't really know what you mean.
> >
> > Process or task migration by writing pid to cgroup.procs or tasks
> > file.  cgroup never supported directory / cgroup level migrations.
> 
> Ugh.  Perhaps cgroup2 should start supporting this.  I think that
> making rename(2) work is simpler than adding a whole new API for
> rgroups, and I think it could solve a lot of the same problems that
> rgroups are trying to solve.

We haven't needed that yet and supporting rename(2) doesn't
necessarily make the API safe in terms of migration atomicity.  Also,
as pointed out in my previous reply (and rgroup documentation),
atomicity is only one part of rationales for rgroup.

Thanks.

-- 
tejun
