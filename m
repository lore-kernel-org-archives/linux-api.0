From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Thu, 15 Sep 2016 13:08:07 -0700
Message-ID: <CALCETrUA6_noue4kq9JLqr-V_yo7hB+v1Arhg6i6fFn0tyTrpw@mail.gmail.com>
References: <20160829222048.GH28713@mtj.duckdns.org> <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org> <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
 <20160831210754.GZ12660@htj.duckdns.org> <CALCETrXj2Z=-GMaWV_EpCvw_8C3t1vc=D53Ff2wdvo=At8ZF1Q@mail.gmail.com>
 <20160903220526.GA20784@mtj.duckdns.org> <CALCETrVcAjFWLQ1arjSP-g=4jRY_J7G-j9JJHrvTDgOnxApYPw@mail.gmail.com>
 <20160909225747.GA30105@mtj.duckdns.org> <CALCETrUhpPQdyZ-6WRjdB+iLbpGBduRZMWXQtCuS+R7Cq7rygg@mail.gmail.com>
 <20160914200041.GB6832@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914200041.GB6832-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Sep 14, 2016 at 1:00 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>

With regard to no-internal-tasks, I see (at least) three options:

1. Keep the cgroup2 status quo.  Lots of distros and such are likely
to have their cgroup management fail if run in a container.  I really,
really dislike this option.

2. Enforce no-internal-tasks for the root cgroup.  Un-cgroupable
thinks will still get accounted to the root cgroup even if subtree
control is on, but no tasks can be in the root cgroup if the root
cgroup has subtree control on.  (If some controllers removed the
no-internal-tasks restriction, this would apply to the root as well.)
I think this may annoy certain users.  If so, and if those users are
doing something valid, then I think that either those users should be
strongly encouraged or even forced to changed so namespacing works for
them or that we should do (3) instead.

3. Remove the no-internal-tasks restriction entirely.  I can see this
resulting in a lot of configuration awkwardness, but I think it will
*work*, especially since all of the controllers already need to do
something vaguely intelligent when subtree control is on in the root
and there are tasks in the root.

What I'm trying to say is that I think that option (1) is sufficiently
bad that cgroup2 should do (2) or (3) instead.  If option (2) is
preferred and if it would break userspace, then I think we can work
around it by entirely deprecating cgroup2, renaming it to cgroup3, and
doing option (2) there.  You've given reasons you don't like options
(2) and (3).  I mostly agree with those reasons, but I don't think
they're strong enough to overcome the problems with (1).

BTW, Mike keeps mentioning exclusive cgroups as problematic with the
no-internal-tasks constraints.  Do exclusive cgroups still exist in
cgroup2?  Could we perhaps just remove that capability entirely?  I've
never understood what problem exlusive cpusets and such solve that
can't be more comprehensibly solved by just assigning the cpusets the
normal inclusive way.

>> > After a migration, the cgroup and its interface knobs are a different
>> > directory and files.  Semantically, during migration, we aren't moving
>> > the directory or files and it'd be bizarre to overlay the semantics
>> > you're describing on top of the existing cgroupfs.  We will have to
>> > break away from the very basic vfs rules such as a fd, once opened,
>> > always corresponding to the same file.
>>
>> What kind of migration do you mean?  Having fds follow rename(2) around is
>> the normal vfs behavior, so I don't really know what you mean.
>
> Process or task migration by writing pid to cgroup.procs or tasks
> file.  cgroup never supported directory / cgroup level migrations.
>

Ugh.  Perhaps cgroup2 should start supporting this.  I think that
making rename(2) work is simpler than adding a whole new API for
rgroups, and I think it could solve a lot of the same problems that
rgroups are trying to solve.

--Andy
