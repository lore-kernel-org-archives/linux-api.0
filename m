From: Tejun Heo <tj@kernel.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 14 Sep 2016 16:00:41 -0400
Message-ID: <20160914200041.GB6832@htj.duckdns.org>
References: <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org>
 <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Paul Turner <pjt@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-api@vger.kernel.org

Hello,

On Mon, Sep 12, 2016 at 10:39:04AM -0700, Andy Lutomirski wrote:
> > > Your idea of "trivially" doesn't match mine.  You gave a use case in
> >
> > I suppose I wasn't clear enough.  It is trivial in the sense that if
> > the userland implements something which works for namespace-root, it
> > would work the same in system-root without further modifications.
> 
> So I guess userspace can trivially get it right and can just as trivially
> get it wrong.

I wasn't trying to play a word game.  What I was trying to say is that
a configuration which works for namespace-roots works for the
system-root too, in terms of cgroup hierarchy, without any
modifications.

> > Great, now we agree that what's currently implemented is valid.  I
> > think you're still failing to recognize the inherent specialness of
> > the system-root and how much unnecessary pain the removal of the
> > exemption would cause at virtually no practical gain.  I won't repeat
> > the same backing points here.
> 
> I'm starting to think that you could extend the exemption with considerably
> less difficulty.

Can you please elaborate?  It feels like you're repeating the same
opinions without really describing them in detail or backing them up
in the last couple replies.  Having differing opinions is fine but to
actually hash them out, the opinions and their rationles need to be
laid out in detail.

> > There isn't much which is getting in the way of doing that.  Again,
> > something which follows no-internal-task rule would behave the same no
> > matter where it is.  The system-root is different in that it is exempt
> > from the rule and thus is more flexible but that difference is serving
> > the purpose of handling the inherent specialness of the system-root.
> 
> From *userspace's* POV, I still don't think there's any specialness except
> from an accounting POV.  After all, userspace has no control over the
> special stuff anyway.  And accounting doesn't matter: a namespace could
> just see zeros in any special root accounting slots.

The disagreement here isn't really consequential.  The only reason
this part became imporant is because you felt that something must be
broken, which you now don't think is the case.

I agree that there can be other ways to handle this but what's your
proposal here?  And how would that be practically and substantically
better than what is implemented now?

> > You've been pushing for enforcing the restriction on the system-root
> > too and now are jumping to the opposite end.  It's really frustrating
> > that this is such a whack-a-mole game where you throw ideas without
> > really thinking through them and only concede the bare minimum when
> > all other logical avenues are closed off.  Here, again, you seem to be
> > stating a strong opinion when you haven't fully thought about it or
> > tried to understand the reasons behind it.
> 
> I think you should make it work the same way in namespace roots as it does
> in the system root.  I acknowledge that there are pros and cons of each.  I
> think the current middle ground is worse than either of the consistent
> options.

Again, the only thing you're doing is restating the same opinion.  I
understand that you have an impression that this can be done better
but how exactly?

> > But, whatever, let's go there: Given the arguments that I laid out for
> > the no-internal-tasks rule, how does the problem seem fixable through
> > relaxing the constraint?
> 
> By deciding that, despite the arguments you laid out, it's still worth
> relaxing the constraint.  Or by deciding to add the constraint to the root.

You're not really saying anything of substance in the above paragraph.

> > > Isn't this the same thing?  IIUC the constraint in question is that,
> > > if a non-root cgroup has subtree control on, then it can't have
> > > processes in it.  This is the no-internal-tasks constraint, right?
> >
> > Yes, that is what no-internal-tasks rule is but I don't understand how
> > that is the same thing as process granularity.  Am I completely
> > misunderstanding what you are trying to say here?
> 
> Yes.  I'm saying that no-internal-tasks could be relaxed per controller.

I was asking whether you were wondering whether no-internal-tasks rule
and process-granularity are the same thing.  And, if that's not the
case, what the previous sentence meant.  I can't make out what you're
responding to.

> > If you confine it to the cpu controller, ignore anonymous
> > consumptions, the rather ugly mapping between nice and weight values
> > and the fact that nobody could come up with a practical usefulness for
> > such setup, yes.  My point was never that the cpu controller can't do
> > it but that we should find a better way of coordinating it with other
> > controllers and exposing it to individual applications.
> 
> I'm not sure what the nice-vs-weight thing has to do with internal
> processes, but all of this is a question for Peter.

That part is from cgroup cpu controller weight being mapped to task
nice numbers because the priorities between the two have to be somehow
comparable.  It's not a critical issue, just awkward.

> > After a migration, the cgroup and its interface knobs are a different
> > directory and files.  Semantically, during migration, we aren't moving
> > the directory or files and it'd be bizarre to overlay the semantics
> > you're describing on top of the existing cgroupfs.  We will have to
> > break away from the very basic vfs rules such as a fd, once opened,
> > always corresponding to the same file.
> 
> What kind of migration do you mean?  Having fds follow rename(2) around is
> the normal vfs behavior, so I don't really know what you mean.

Process or task migration by writing pid to cgroup.procs or tasks
file.  cgroup never supported directory / cgroup level migrations.

> > If I'm not mistaken, namespaces don't allow this type of dynamic
> > migrations.
> 
> I don't see why they couldn't allow exactly this.  If you rename(2) a
> cgroup, any namespace with that cgroup as root should keep it as root,
> completely atomically.  If this doesn't work, I'd argue that it's a bug.

I hope this part is clear now.

> > A system agent has a large part of the system configuration under its
> > control (it's the system agent after all) and thus is way more
> > flexible in what assumptions it can dictate and depend on.
> 
> Can you give an example of any use case for which a system agent would
> fork, exec a daemon that isn't written by the same developers as the system
> agent, and then walk that daemon's process tree and move the processes
> around in the cgroup hierarchy one by one?  I think this is what you're
> describing, and I don't see why doing so is sensible.  Certainly if a
> system agent gives the daemon write access to cgroupfs, it should not start
> moving that daemon's children around individually.

That's the only way anything can be moved across cgroups.  In terms of
resource control, I can't think of scenarios which would *require*
this behavior but it's still a behavior cgroup has to allow as there's
no "spawn this process in that cgroup" call and all migrations are
dynamic.

We can proclaim that once an application is started outer scope
shouldn't meddle with it.  It would be another restriction where
violation would actually break applications tho.  And it doesn't
address other downsides - making in-application controls less
approachable as it requires specific setup and cooperation from the
system agent, and the interface being awkward.

> > We can make that dynamic as long as the subtree is properly scoped;
> > however, there is an important design decision to make here.  If we
> > open up full-on dynamic migrations to individual applications, we
> > commit ourselves to supporting arbitrarily high frequency migration
> > operations, which we've never supported before and will restrict what
> > we can do in terms of optimizing hot paths over migration.
> 
> I haven't (yet?) seen use cases where changing cgroups *quickly* is
> important.

Android does something along this line - creating preset cgroups and
migrating processes according to their current states.  The problem is
that once we generally open up the API to individual applications,
there is no good way of policing the usages and there certainly are
multiple ways to make use of frequent cgroup membership changes
especially for stateless controllers like CPU.

We can easily end up in situations where having several of these
usages on the same machine bogs down the whole system.  One way to
avoid this is building the API so that changing cgroup membership is
naturally unattractive - e.g. membership can only be assigned only on
creation of a new thread or process, or migration can only be towards
deeper level in the tree, so that migrations can be used to organize
the threads and processes as necessary but not used as the primary
method of adjusting configurations dynamically.

> > It is really difficult to understand your position without
> > understanding where the requirements are coming from.  Can you please
> > elaborate more on the workload?  Why is the specific configuration
> > useful?  What is it trying to achieve?
> 
> Multiple cooperating RT processes, most of which have non-RT helper
> threads.  For scheduling purposes, I lump the non-RT threads together.

I see.  Can you please share how the cgroups are actually configured
(ie. how the weights are assigned and so on)?

> Will you (Tejun), PeterZ, and maybe some of the other interested parties be
> at KS?  Maybe this is worth hashing out in person.

Yeap, it'd be nice to talk in person.  However, I'm not sure talking
offline is the best way to hash out technical details.  The discussion
has been painful but we're actually addressing technical
misunderstandings and where the actual disgreements lie.  We really
need to agree on what we disagree on and why first.

Thanks.

-- 
tejun
