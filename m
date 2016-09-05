From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Mon, 5 Sep 2016 10:37:55 -0700
Message-ID: <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org> <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org> <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org> <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org> <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160903220526.GA20784@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 3, 2016 at 3:05 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Andy.
>
> On Wed, Aug 31, 2016 at 02:46:20PM -0700, Andy Lutomirski wrote:
>> > Consider a use case where the user isn't interested in fully
>> > accounting and dividing up system resources but wants to just cap
>> > resource usage from a subset of workloads.  There is no reason to
>> > require such usages to fully contain all processes in non-root
>> > cgroups.  Furthermore, it's not trivial to migrate all processes out
>> > of root to a sub-cgroup unless the agent is in full control of boot
>> > process.
>>
>> Then please also consider exactly the same use case while running in a
>> container.
>>
>> I'm a bit frustrated that you're saying that my example failure modes
>> consist of shooting oneself in the foot and then you go on to come up
>> with your own examples that have precisely the same problem.
>
> You have a point, which is
>
>   The system-root and namespace-roots are not symmetric.
>
> and that's a valid concern.  Here's why the system-root is special.
>

[...]

>
> Now, due to the various issues with direct competition between
> processes and cgroups, cgroup v2 disallows resource control across
> them (the no-internal-tasks restriction); however, cgroup v2 currently
> doesn't apply the restriction to the system-root.  Here are the
> reasons.
>
> * It doesn't bring any practical benefits in terms of implementation.
>   As noted above, all controllers already have to allow uncontained
>   consumptions in the system-root and that's the only attribute
>   required for the exemption.
>
> * It doesn't bring any practical benefits in terms of capability.
>   Userland can trivially handle the system-root and namespace-roots in
>   a symmetrical manner.

Your idea of "trivially" doesn't match mine.  You gave a use case in
which userspace might take advantage of root being special.  If
userspace does that, then that userspace cannot be run in a container.
This could be a problem for real users.  Sure, "don't do that" is a
*valid* answer, but it's not a very helpful answer.

>
> * It's an unncessary inconvenience, especially for cases where the
>   cgroup agent isn't in control of boot, for partial usage cases, or
>   just for playing with it.
>
> You say that I'm ignoring the same use case for namespace-scope but
> namespace-roots don't have the same hybrid function for partial and
> uncontrolled systems, so it's not clear why there even NEEDS to be
> strict symmetry.

I think their functions are much closer than you think they are.  I
want a whole Linux distro to be able to run in a container.  This
means that useful things people do in a distro or initramfs or
whatever should just work if containerized.

>
> It's easy and understandable to get hangups on asymmetries or
> exemptions like this, but they also often are acceptable trade-offs.
> It's really frustrating to see you first getting hung up on "this must
> be wrong" and even after explanations repeating the same thing just in
> different ways.
>
> If there is something fundamentally wrong with it, sure, let's fix it,
> but what's actually broken?

I'm not saying it's fundamentally wrong.  I'm saying it's a design
that has a big wart, and that wart is unfortunate, and after thinking
a bit, I'm starting to agree with PeterZ that this is problematic.  It
also seems fixable: the constraint could be relaxed.

>> >> Also, here's an idea to maybe make PeterZ happier: relax the
>> >> restriction a bit per-controller.  Currently (except for /), if you
>> >> have subtree control enabled you can't have any processes in the
>> >> cgroup.  Could you change this so it only applies to certain
>> >> controllers?  If the cpu controller is entirely happy to have
>> >> processes and cgroups as siblings, then maybe a cgroup with only cpu
>> >> subtree control enabled could allow processes to exist.
>> >
>> > The document lists several reasons for not doing this and also that
>> > there is no known real world use case for such configuration.
>
> So, up until this point, we were talking about no-internal-tasks
> constraint.

Isn't this the same thing?  IIUC the constraint in question is that,
if a non-root cgroup has subtree control on, then it can't have
processes in it.  This is the no-internal-tasks constraint, right?

And I still think that, at least for cpu, nothing at all goes wrong if
you allow processes to exist in cgroups that have cpu set in
subtree-control.

----- begin talking about process granularity -----

>
>> My company's production workload would map quite nicely to this
>> relaxed model.  I have quite a few processes each with several
>> threads.  Some of those threads get some CPUs, some get other CPUs,
>> and they vary in what shares of what CPUs they get.  To be clear,
>> there is not a hierarchy of resource usage that's compatible with the
>> process hierarchy.  Multiple processes have threads that should be
>> grouped in a different place in the hierarchy than other threads.
>> Concretely, I have processes A and B with threads A1, A2, B1, and B2.
>> (And many more, but this is enough to get the point across.)  The
>> natural grouping is:
>>
>> Group 1: A1 and B1
>> Group 2: A2
>> Group 3: B2
>
> And now you're talking about process granularity.

Yes.

>
>> This cannot be expressed with rgroup or with cgroup2.  cgroup1 has no
>> problem with it.  If I were using memcg, I would want to have a memcg
>> hierarchy that was incompatible with the hierarchy above, so I
>> actually find the cgroup2 insistence on a unified hierarchy to be a
>> bit annoying, but I at least understand the motivation behind the
>> unified hierarchy.
>>
>> And I don't care that the system controller can't atomically move this
>> whole mess around.  I'm currently running without systemd, so I don't
>
> I do.  It's a horrible userland API to expose to individual
> applications if the organization that a given application expects can
> be disturbed by system operations.  Imagine how this would be
> documented - "if this operation races with system operation, it may
> return -ENOENT.  Repeating the path lookup might make the operation
> succeed again."

It could be made to work without races, though, with minimal (or even
no) ABI change.  The managed program could grab an fd pointing to its
cgroup.  Then it would use openat, etc for all operations.  As long as
'mv /cgroup/a/b /cgroup/c/" didn't cause that fd to stop working,
we're fine.

Note that this pretty much has to work if cgroup namespaces are to
allow rearrangement of the hierarchy -- '/cgroup/' from inside the
namespace has to remain valid at all times

Obviously this only works if the cgroup in question doesn't itself get
destroyed, but having an internal hierarchy is a bit nonsensical if
the application shares a cgroup with another application, so that
shouldn't be a problem in practice.

In fact, ISTM that allowing applications to manage cgroup
sub-hierarchies has almost exactly the same set of constraints as
allowing namespaced cgroup managers to work.  In a container, the
outer manager manages where the container lives and the container
manages its own hierarchy.  Why can't fancy cgroup-aware applications
work exactly the same way?

>
>> *have* a system controller.  If I end up migrating to systemd, I'll
>> probably put this whole pile into its own slice and manage it
>> manually.
>
> Yeah, systemd has delegation feature for cases like that which we
> depend on too.
>
> As for your example, who performs the cgroup setup and configuration,
> the application itself or an external entity?  If an external entity,
> how does it know which thread is what?

In my case, it would be a little script that reads a config file that
knows all kinds of internal information about the application and its
threads.

>
> And, as for rgroup not covering it, would extending rgroup to cover
> multi-process cases be enough or are there more fundamental issues?

Maybe, as long as the configuration could actually be created -- IIUC
the current rgroup proposal requires that the hierarchy of groups
matches the hierarchy implied by clone(), which isn't going to happen
in my case.

But, given that this fancy-cgroup-aware-multiprocess-application case
looks so much like cgroup-using container, ISTM you could solve the
problem completely by just allowing tasks to be split out by users who
want to do it.  (Obviously those users will get funny results if they
try to do this to memcg.  "Don't do that" seems fine here.)  I don't
expect the race condition issues you're worried about to happen in
practice.  Certainly not in my case, since I control the entire
system.
