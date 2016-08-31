From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [Documentation] State of CPU controller in cgroup v2
Date: Tue, 30 Aug 2016 20:42:20 -0700
Message-ID: <CALCETrUEygWrJbG25wSfG3zMG_+TNeP8+gAkcbh4_=ZNWHQCkw@mail.gmail.com>
References: <20160805170752.GK2542@mtj.duckdns.org> <CALCETrXvLNeds+ugZ8j3eD1Zg1RZYJSAET3Kguz5G2vqSLFCwQ@mail.gmail.com>
 <20160820155659.GA16906@mtj.duckdns.org> <CALCETrUWn1ux-ZRJoMjFCuP1aQrPOo3oTPD7k-ojsaov29NsRw@mail.gmail.com>
 <20160829222048.GH28713@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160829222048.GH28713-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Aug 29, 2016 at 3:20 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > These base-system operations are special regardless of cgroup and we
>> > already have sometimes crude ways to affect their behaviors where
>> > necessary through sysctl knobs, priorities on specific kernel threads
>> > and so on.  cgroup doesn't change the situation all that much.  What
>> > gets left in the root cgroup usually are the base-system operations
>> > which are outside the scope of cgroup resource control in the first
>> > place and cgroup resource graph can treat the root as an opaque anchor
>> > point.
>>
>> This seems to explain why the controllers need to be able to handle
>> things being charged to the root cgroup (or to an unidentifiable
>> cgroup, anyway).  That isn't quite the same thing as allowing, from an
>> ABI point of view, the root cgroup to contain processes and cgroups
>> but not allowing other cgroups to do the same thing.  Consider:
>
> The points are 1. we need the root to be a special container anyway

But you don't need to let userspace see that.

> 2. allowing it to be special and contain system-wide consumptions
> doesn't make the resource graph inconsistent once all non-system-wide
> consumptions are put in non-root cgroups, and 3. this is the most
> natural way to handle the situation both from implementation and
> interface standpoints as it makes non-cgroup configuration a natural
> degenerate case of cgroup configuration.
>
>> suppose that systemd (or some competing cgroup manager) is designed to
>> run in the root cgroup namespace.  It presumably expects *itself* to
>> be in the root cgroup.  Now try to run it using cgroups v2 in a
>> non-root namespace.  I don't see how it can possibly work if it the
>> hierarchy constraints don't permit it to create sub-cgroups while it's
>> still in the root.  In fact, this seems impossible to fix even with
>> user code changes.  The manager would need to simultaneously create a
>> new child cgroup to contain itself and assign itself to that child
>> cgroup, because the intermediate state is illegal.
>
> Please re-read the constraint.  It doesn't prevent any organizational
> operations before resource control is enabled.
>
>> I really, really think that cgroup v2 should supply the same
>> *interface* inside and outside of a non-root namespace.  If this is
>
> It *does*.  That's what I tried to explain, that it's exactly
> isomorhpic once you discount the system-wide consumptions.
>

I don't think I agree.

Suppose I wrote an init program or a cgroup manager.  I can expect
that init program to be started in the root cgroup.  The program can
be lazy and write +io to /cgroup/cgroup.subtree_control and then
create some new cgroup /cgroup/a and it will work (I just tried it).

Now I run that program in a namespace.  It will not work because it'll
get -EBUSY when it tries to write to cgroup.subtree_control.  (I just
tried this, too, only using cd instead of a namespace.)  So it's *not*
isomorphic.

It *also* won't work (I think) if subtree control is enabled on the
root, but I don't think this is a problem in practice because subtree
control won't be enabled on the namespace root by a sensible cgroup
manager.

--Andy
