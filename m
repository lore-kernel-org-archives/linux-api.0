From: Tejun Heo <tj@kernel.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Fri, 9 Sep 2016 18:57:47 -0400
Message-ID: <20160909225747.GA30105@mtj.duckdns.org>
References: <20160820155659.GA16906@mtj.duckdns.org>
 <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
 <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
 <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
 <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
 <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Hello, again.

On Mon, Sep 05, 2016 at 10:37:55AM -0700, Andy Lutomirski wrote:
> > * It doesn't bring any practical benefits in terms of capability.
> >   Userland can trivially handle the system-root and namespace-roots in
> >   a symmetrical manner.
> 
> Your idea of "trivially" doesn't match mine.  You gave a use case in

I suppose I wasn't clear enough.  It is trivial in the sense that if
the userland implements something which works for namespace-root, it
would work the same in system-root without further modifications.

> which userspace might take advantage of root being special.  If

I was emphasizing the cases where userspace would have to deal with
the inherent differences, and, when they don't, they can behave
exactly the same way.

> userspace does that, then that userspace cannot be run in a container.
> This could be a problem for real users.  Sure, "don't do that" is a
> *valid* answer, but it's not a very helpful answer.

Great, now we agree that what's currently implemented is valid.  I
think you're still failing to recognize the inherent specialness of
the system-root and how much unnecessary pain the removal of the
exemption would cause at virtually no practical gain.  I won't repeat
the same backing points here.

> > * It's an unncessary inconvenience, especially for cases where the
> >   cgroup agent isn't in control of boot, for partial usage cases, or
> >   just for playing with it.
> >
> > You say that I'm ignoring the same use case for namespace-scope but
> > namespace-roots don't have the same hybrid function for partial and
> > uncontrolled systems, so it's not clear why there even NEEDS to be
> > strict symmetry.
> 
> I think their functions are much closer than you think they are.  I
> want a whole Linux distro to be able to run in a container.  This
> means that useful things people do in a distro or initramfs or
> whatever should just work if containerized.

There isn't much which is getting in the way of doing that.  Again,
something which follows no-internal-task rule would behave the same no
matter where it is.  The system-root is different in that it is exempt
from the rule and thus is more flexible but that difference is serving
the purpose of handling the inherent specialness of the system-root.
AFAICS, it is the solution which causes the least amount of contortion
and unnecessary inconvenience to userland.

> > It's easy and understandable to get hangups on asymmetries or
> > exemptions like this, but they also often are acceptable trade-offs.
> > It's really frustrating to see you first getting hung up on "this must
> > be wrong" and even after explanations repeating the same thing just in
> > different ways.
> >
> > If there is something fundamentally wrong with it, sure, let's fix it,
> > but what's actually broken?
> 
> I'm not saying it's fundamentally wrong.  I'm saying it's a design

You were.

> that has a big wart, and that wart is unfortunate, and after thinking
> a bit, I'm starting to agree with PeterZ that this is problematic.  It
> also seems fixable: the constraint could be relaxed.

You've been pushing for enforcing the restriction on the system-root
too and now are jumping to the opposite end.  It's really frustrating
that this is such a whack-a-mole game where you throw ideas without
really thinking through them and only concede the bare minimum when
all other logical avenues are closed off.  Here, again, you seem to be
stating a strong opinion when you haven't fully thought about it or
tried to understand the reasons behind it.

But, whatever, let's go there: Given the arguments that I laid out for
the no-internal-tasks rule, how does the problem seem fixable through
relaxing the constraint?

> >> >> Also, here's an idea to maybe make PeterZ happier: relax the
> >> >> restriction a bit per-controller.  Currently (except for /), if you
> >> >> have subtree control enabled you can't have any processes in the
> >> >> cgroup.  Could you change this so it only applies to certain
> >> >> controllers?  If the cpu controller is entirely happy to have
> >> >> processes and cgroups as siblings, then maybe a cgroup with only cpu
> >> >> subtree control enabled could allow processes to exist.
> >> >
> >> > The document lists several reasons for not doing this and also that
> >> > there is no known real world use case for such configuration.
> >
> > So, up until this point, we were talking about no-internal-tasks
> > constraint.
> 
> Isn't this the same thing?  IIUC the constraint in question is that,
> if a non-root cgroup has subtree control on, then it can't have
> processes in it.  This is the no-internal-tasks constraint, right?

Yes, that is what no-internal-tasks rule is but I don't understand how
that is the same thing as process granularity.  Am I completely
misunderstanding what you are trying to say here?

> And I still think that, at least for cpu, nothing at all goes wrong if
> you allow processes to exist in cgroups that have cpu set in
> subtree-control.

If you confine it to the cpu controller, ignore anonymous
consumptions, the rather ugly mapping between nice and weight values
and the fact that nobody could come up with a practical usefulness for
such setup, yes.  My point was never that the cpu controller can't do
it but that we should find a better way of coordinating it with other
controllers and exposing it to individual applications.

> ----- begin talking about process granularity -----
...
> > I do.  It's a horrible userland API to expose to individual
> > applications if the organization that a given application expects can
> > be disturbed by system operations.  Imagine how this would be
> > documented - "if this operation races with system operation, it may
> > return -ENOENT.  Repeating the path lookup might make the operation
> > succeed again."
> 
> It could be made to work without races, though, with minimal (or even
> no) ABI change.  The managed program could grab an fd pointing to its
> cgroup.  Then it would use openat, etc for all operations.  As long as
> 'mv /cgroup/a/b /cgroup/c/" didn't cause that fd to stop working,
> we're fine.

After a migration, the cgroup and its interface knobs are a different
directory and files.  Semantically, during migration, we aren't moving
the directory or files and it'd be bizarre to overlay the semantics
you're describing on top of the existing cgroupfs.  We will have to
break away from the very basic vfs rules such as a fd, once opened,
always corresponding to the same file.  The only thing openat(2) does
is abstracting away prefix handling and that is only a small part of
the problem.

A more acceptable way could be implementing, say, per-task filesystem
which always appears at the fixed location and proxies the operations;
however, even this wouldn't be able to handle issues stemming from
lack of actual atomicity.  Think about two tasks accessing the same
interface file.  If they race against outside agent migrating them
one-by-one, they may or may not be accessing the same file.  If they
perform operations with side effects such as config changes, creation
of sub-cgroups and migrations, what would be the end result?

In addition, a per-task filesystem is an a lot worse interface to
program against than a system-call based API, especially when the same
API which is used to do the exact same operations on threads can be
reused for resource groups.

> Note that this pretty much has to work if cgroup namespaces are to
> allow rearrangement of the hierarchy -- '/cgroup/' from inside the
> namespace has to remain valid at all times

If I'm not mistaken, namespaces don't allow this type of dynamic
migrations.

> Obviously this only works if the cgroup in question doesn't itself get
> destroyed, but having an internal hierarchy is a bit nonsensical if
> the application shares a cgroup with another application, so that
> shouldn't be a problem in practice.
>
> In fact, ISTM that allowing applications to manage cgroup
> sub-hierarchies has almost exactly the same set of constraints as
> allowing namespaced cgroup managers to work.  In a container, the
> outer manager manages where the container lives and the container
> manages its own hierarchy.  Why can't fancy cgroup-aware applications
> work exactly the same way?

System agents and individual applications are different.  This is the
same argument that you brought up earlier in this thread where you
said that userland can just set up namespaces for individual
applications.  In purely mathematical terms, they can be mapped to
each other but that grossly ignores practical differences between
them.

Most applications should and want to keep their assumptions
conservative, robust and portable, and not dependent on some crazy
fragile and custom-built namespace setup that nobody in the stack is
really responsible for.  How many would ever program against something
like that?

A system agent has a large part of the system configuration under its
control (it's the system agent after all) and thus is way more
flexible in what assumptions it can dictate and depend on.

> > Yeah, systemd has delegation feature for cases like that which we
> > depend on too.
> >
> > As for your example, who performs the cgroup setup and configuration,
> > the application itself or an external entity?  If an external entity,
> > how does it know which thread is what?
> 
> In my case, it would be a little script that reads a config file that
> knows all kinds of internal information about the application and its
> threads.

I see.  One-of-a-kind custom setup.  This is a completely valid usage;
however, please also recognize that it's an extremely specific one
which is niche by definition.  If we're going to support
in-application hierarchical resource control, I think it's very
important to make sure that it's something which is easy to use and
widely accessible so that any lay application can make use of it.
I'll come back to this point later.

> > And, as for rgroup not covering it, would extending rgroup to cover
> > multi-process cases be enough or are there more fundamental issues?
> 
> Maybe, as long as the configuration could actually be created -- IIUC
> the current rgroup proposal requires that the hierarchy of groups
> matches the hierarchy implied by clone(), which isn't going to happen
> in my case.

We can make that dynamic as long as the subtree is properly scoped;
however, there is an important design decision to make here.  If we
open up full-on dynamic migrations to individual applications, we
commit ourselves to supporting arbitrarily high frequency migration
operations, which we've never supported before and will restrict what
we can do in terms of optimizing hot paths over migration.

We haven't had to face this decision because cgroup has never properly
supported delegating to applications and the in-use setups where this
happens are custom configurations where there is no boundary between
system and applications and adhoc trial-and-error is good enough a way
to find a working solution.  That wiggle room goes away once we
officially open this up to individual applications.

So, if we decide to open up dynamic assignment, we need to weigh what
we gain in terms of capabilities against reduction of implementation
maneuvering room.  I guess there can be a middleground where, for
example, only initial asssignment is allowed.

It is really difficult to understand your position without
understanding where the requirements are coming from.  Can you please
elaborate more on the workload?  Why is the specific configuration
useful?  What is it trying to achieve?

> But, given that this fancy-cgroup-aware-multiprocess-application case
> looks so much like cgroup-using container, ISTM you could solve the
> problem completely by just allowing tasks to be split out by users who
> want to do it.  (Obviously those users will get funny results if they
> try to do this to memcg.  "Don't do that" seems fine here.)  I don't
> expect the race condition issues you're worried about to happen in
> practice.  Certainly not in my case, since I control the entire
> system.

What people do now with cgroup inside an application is extremely
limited.  Because there is no proper support for it, each use case has
to craft up a dedicated custom setup which is all but guaranteed to be
incompatible with what someone else would come up for another
application.  Everybody is in "this is mine, I control the entire
system" mindset, which is fine for those specific setups but
deterimental to making it widely available and useful.

Accepting some measured restrictions and building a common ground for
everyone can make in-application cgroup usages vastly more accessible
and useful than now.  Certain things would need to be done differently
and maybe some scenarios won't be supported as well but those are
trade-offs that we'd need to weigh against what we gain.  Another
point is that, for very specific use cases where none of these generic
concerns matter, keeping using cgroup v1 is fine.  The lack of common
resource domains has never been an issue for those use cases anyway.

Thanks.

-- 
tejun
