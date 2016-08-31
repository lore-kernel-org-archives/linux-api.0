From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Wed, 31 Aug 2016 12:11:58 -0700
Message-ID: <CALCETrUKOJZS+=QDPyQD+vxXpwyjoj4+Crg6wU7Xk8rP4prYkA@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org> <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org> <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
 <20160831173251.GY12660@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160831173251.GY12660-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 31, 2016 at 10:32 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Andy.
>

>
>> >> I really, really think that cgroup v2 should supply the same
>> >> *interface* inside and outside of a non-root namespace.  If this is
>> >
>> > It *does*.  That's what I tried to explain, that it's exactly
>> > isomorhpic once you discount the system-wide consumptions.
>>
>> I don't think I agree.
>>
>> Suppose I wrote an init program or a cgroup manager.  I can expect
>> that init program to be started in the root cgroup.  The program can
>> be lazy and write +io to /cgroup/cgroup.subtree_control and then
>> create some new cgroup /cgroup/a and it will work (I just tried it).
>>
>> Now I run that program in a namespace.  It will not work because it'll
>> get -EBUSY when it tries to write to cgroup.subtree_control.  (I just
>> tried this, too, only using cd instead of a namespace.)  So it's *not*
>> isomorphic.
>
> Yeah, it is possible to shoot yourself in the foot but both
> system-scope and namespace-scope can implement the exactly same
> behavior - move yourself out of root before enabling resource controls
> and get the same expected outcome, which BTW is how systemd behaves
> already.
>
> You can say that allowing the possibility of deviation isn't a good
> design choice but it is a design choice with other implications - on
> how we deal with configurations without cgroup at all, transitioning
> from v1, bootstrapping a system and avoiding surprising
> userland-visible behaviors (e.g. like creating magic preset cgroups
> and silently migrating process there on certain events).

Are there existing userspace programs that use cgroup2 and enable
subtree control on / when there are processes in /?  If the answer is
no, then I think you should change cgroup2 to just disallow it.  If
the answer is yes, then I think there's a problem and maybe you should
consider a breaking change.  Given that cgroup2 hasn't really launched
on a large scale, it seems worthwhile to get it right.

I don't understand what you're talking about wrt silently migrating
processes.  Are you thinking about usermodehelper?  If so, maybe it
really does make sense to allow (or require?) the cgroup manager to
specify which cgroup these processes end up in.

But, given that all the controllers need to support the current magic
root exception (for genuinely unaccountable things if nothing else),
can you explain what would actually go wrong if you just removed the
restriction entirely?

Also, here's an idea to maybe make PeterZ happier: relax the
restriction a bit per-controller.  Currently (except for /), if you
have subtree control enabled you can't have any processes in the
cgroup.  Could you change this so it only applies to certain
controllers?  If the cpu controller is entirely happy to have
processes and cgroups as siblings, then maybe a cgroup with only cpu
subtree control enabled could allow processes to exist.

>
>> It *also* won't work (I think) if subtree control is enabled on the
>> root, but I don't think this is a problem in practice because subtree
>> control won't be enabled on the namespace root by a sensible cgroup
>> manager.
>
> Exactly the same thing.  You can shoot yourself in the foot but it's
> easy not to.
>

Somewhat off-topic: this appears to be either a bug or a misfeature:

bash-4.3# mkdir foo
bash-4.3# ls foo
cgroup.controllers  cgroup.events  cgroup.procs  cgroup.subtree_control
bash-4.3# mkdir foo/io.max  <-- IMO this shouldn't have worked
bash-4.3# echo +io >cgroup.subtree_control
[   40.470712] cgroup: cgroup_addrm_files: failed to add max, err=-17

Shouldn't cgroups with names that potentially conflict with
kernel-provided dentries be disallowed?

--Andy
