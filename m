From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 31 Aug 2016 14:46:20 -0700
Message-ID: <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org> <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org> <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org> <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160831210754.GZ12660@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Paul Turner <pjt@google.com>, Li Zefan <lizefan@huawei.com>, Linux API <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 31, 2016 at 2:07 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Aug 31, 2016 at 12:11:58PM -0700, Andy Lutomirski wrote:
>> > You can say that allowing the possibility of deviation isn't a good
>> > design choice but it is a design choice with other implications - on
>> > how we deal with configurations without cgroup at all, transitioning
>> > from v1, bootstrapping a system and avoiding surprising
>> > userland-visible behaviors (e.g. like creating magic preset cgroups
>> > and silently migrating process there on certain events).
>>
>> Are there existing userspace programs that use cgroup2 and enable
>> subtree control on / when there are processes in /?  If the answer is
>> no, then I think you should change cgroup2 to just disallow it.  If
>> the answer is yes, then I think there's a problem and maybe you should
>> consider a breaking change.  Given that cgroup2 hasn't really launched
>> on a large scale, it seems worthwhile to get it right.
>
> Adding the restriction isn't difficult from implementation point of
> view and for a system agent which control the boot process
> implementing that wouldn't be difficult either but I can't see what
> the actual benefits of the extra restriction would be and there are
> tangible downsides to doing so.
>
> Consider a use case where the user isn't interested in fully
> accounting and dividing up system resources but wants to just cap
> resource usage from a subset of workloads.  There is no reason to
> require such usages to fully contain all processes in non-root
> cgroups.  Furthermore, it's not trivial to migrate all processes out
> of root to a sub-cgroup unless the agent is in full control of boot
> process.

Then please also consider exactly the same use case while running in a
container.

I'm a bit frustrated that you're saying that my example failure modes
consist of shooting oneself in the foot and then you go on to come up
with your own examples that have precisely the same problem.

>
>> I don't understand what you're talking about wrt silently migrating
>> processes.  Are you thinking about usermodehelper?  If so, maybe it
>> really does make sense to allow (or require?) the cgroup manager to
>> specify which cgroup these processes end up in.
>
> That was from one of the ideas that I was considering way back where
> enabling resource control in an intermediate node automatically moves
> internal processes to a preset cgroup whether visible or hidden, which
> would be another way of addressing the problem.
>
> None of these affects what cgroup v2 can do at all and the only thing
> the userland is asked to do under the current scheme is "if you wanna
> keep the whole system divided up and use the same mode of operations
> across system-scope and namespace-scope move out of root while setting
> yourself up, which also happens to be what you have to do inside
> namespaces anyway."
>
>> But, given that all the controllers need to support the current magic
>> root exception (for genuinely unaccountable things if nothing else),
>> can you explain what would actually go wrong if you just removed the
>> restriction entirely?
>
> I have, multiple times.  Can you please read 2-1-2 of the document in
> the original post and take the discussion from there?

I've read it multiple times, and I don't see any explanation that's
consistent with the fact that you are exempting the root cgroup from
this constraint.  If the constraint were really critical to everything
working, then I would expect the root cgroup to have exactly the same
problem.  This makes me think that either something nasty is being
fudged for the root cgroup or that the constraint isn't actually so
important after all.  The only thing on point I can find is:

> Root cgroup is exempt from this constraint, which is in line with
> how root cgroup is handled in general - it's excluded from cgroup
> resource accounting and control.

and that's not very helpful.

>
>> Also, here's an idea to maybe make PeterZ happier: relax the
>> restriction a bit per-controller.  Currently (except for /), if you
>> have subtree control enabled you can't have any processes in the
>> cgroup.  Could you change this so it only applies to certain
>> controllers?  If the cpu controller is entirely happy to have
>> processes and cgroups as siblings, then maybe a cgroup with only cpu
>> subtree control enabled could allow processes to exist.
>
> The document lists several reasons for not doing this and also that
> there is no known real world use case for such configuration.

My company's production workload would map quite nicely to this
relaxed model.  I have quite a few processes each with several
threads.  Some of those threads get some CPUs, some get other CPUs,
and they vary in what shares of what CPUs they get.  To be clear,
there is not a hierarchy of resource usage that's compatible with the
process hierarchy.  Multiple processes have threads that should be
grouped in a different place in the hierarchy than other threads.
Concretely, I have processes A and B with threads A1, A2, B1, and B2.
(And many more, but this is enough to get the point across.)  The
natural grouping is:

Group 1: A1 and B1
Group 2: A2
Group 3: B2

This cannot be expressed with rgroup or with cgroup2.  cgroup1 has no
problem with it.  If I were using memcg, I would want to have a memcg
hierarchy that was incompatible with the hierarchy above, so I
actually find the cgroup2 insistence on a unified hierarchy to be a
bit annoying, but I at least understand the motivation behind the
unified hierarchy.

And I don't care that the system controller can't atomically move this
whole mess around.  I'm currently running without systemd, so I don't
*have* a system controller.  If I end up migrating to systemd, I'll
probably put this whole pile into its own slice and manage it
manually.

>
>> >> It *also* won't work (I think) if subtree control is enabled on the
>> >> root, but I don't think this is a problem in practice because subtree
>> >> control won't be enabled on the namespace root by a sensible cgroup
>> >> manager.
>> >
>> > Exactly the same thing.  You can shoot yourself in the foot but it's
>> > easy not to.
>>
>> Somewhat off-topic: this appears to be either a bug or a misfeature:
>>
>> bash-4.3# mkdir foo
>> bash-4.3# ls foo
>> cgroup.controllers  cgroup.events  cgroup.procs  cgroup.subtree_control
>> bash-4.3# mkdir foo/io.max  <-- IMO this shouldn't have worked
>> bash-4.3# echo +io >cgroup.subtree_control
>> [   40.470712] cgroup: cgroup_addrm_files: failed to add max, err=-17
>>
>> Shouldn't cgroups with names that potentially conflict with
>> kernel-provided dentries be disallowed?
>
> Yeap, the name collisions suck.  I thought about disallowing all
> sub-cgroups which starts with "KNOWN_SUBSYS." but that has a
> non-trivial chance of breaking users which were happy before when a
> new controller gets added.  But, yeah, we at least should disallow the
> known filenames.  Will think more about it.

How about disallowing names that contain a '.'?

--Andy
