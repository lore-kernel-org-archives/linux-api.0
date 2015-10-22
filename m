From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [PATCH] userns/capability: Add user namespace capability
Date: Thu, 22 Oct 2015 15:45:09 -0500
Message-ID: <87twpi63ai.fsf@x220.int.ebiederm.org>
References: <5622700C.9090107@miglix.eu>
	<20151017215501.GA22900@mail.hallyn.com> <5623FD82.4030902@miglix.eu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5623FD82.4030902-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org> (Tobias Markus's message of "Sun, 18
	Oct 2015 22:13:54 +0200")
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


Thank you for a creative solution to a problem that you perceive.  I
appreciate it when people aim to solve problems they see.

Tobias Markus <tobias-gyUQdkDHmHmHXe+LvDLADg@public.gmane.org> writes:

> On 17.10.2015 23:55, Serge E. Hallyn wrote:
>> On Sat, Oct 17, 2015 at 05:58:04PM +0200, Tobias Markus wrote:
>>> Add capability CAP_SYS_USER_NS.
>>> Tasks having CAP_SYS_USER_NS are allowed to create a new user namespace
>>> when calling clone or unshare with CLONE_NEWUSER.
>>>
>>> Rationale:
>>>
>>> Linux 3.8 saw the introduction of unpriviledged user namespaces,
>>> allowing unpriviledged users (without CAP_SYS_ADMIN) to be a "fake" root
>>> inside a separate user namespace. Before that, any namespace creation
>>> required CAP_SYS_ADMIN (or, in practice, the user had to be root).
>>> Unfortunately, there have been some security-relevant bugs in the
>>> meantime. Because of the fairly complex nature of user namespaces, it is
>>> reasonable to say that future vulnerabilties can not be excluded. Some
>>> distributions even wholly disable user namespaces because of this.
>> 
>> Fwiw I'm not in favor of this.  Debian has a patch (I believe the one
>> I originally wrote for Ubuntu but which Ubuntu dropped long ago) adding a
>> sysctl, off by default, for enabling user namespaces.
>
> While it certainly works, enabling a feature like this at runtime
> doesn't seem like a long term solution.
>
> The fact that Debian added this patch in the first place already
> demonstrates that there is demand for a way to limit unpriviledged user
> namespace creation. Please, don't get me wrong: I would *really like* to
> see widespread adoption and continued development of user namespaces!
> But the status quo remains: Distributions outright disabling user
> namespaces (e.g. Arch Linux) won't make it easier.

Let me say I applaud Arch Linux for not doing what so many distributions
do and enable every feature in the kernel.  I appreciate a distribution
that does not enable interesting kernel features while they are still
having their bugs shaken out of them.

I also think Debians approach to limit things while they mature is also
wisdom.

>> Posix capabilities are intended for privileged actions, not for
>> actions which explicitly should not require privilege, but which
>> we feel are in development.
>> 
>
> Certainly, in an ideal world, user namespaces will never lead to any
> kernel-level exploits. But reality is different: There *have been*
> serious kernel vulnerabilities due to user namespaces, and there *will
> be* serious kernel vulnerabilities due to user namespaces.

When you start talk about the future that is not yet real you have
stopped talking about reality.  That sounds like a pessimists world view
rather than reality.

The reality is new features are buggy and take time to mature.  It takes
time for understanding to percolate through peoples heads.

> Now, those are the alternatives imho:
>
> * Status quo: Some distributions will disable user namespaces by default
> in some way or another. User wishing to use user namespaces will have to
> use a custom kernel or enable a sysctl flag that was patched in by the
> downstream developers. On distributions that enable user namespaces by
> default, even users that don't wish to use them in the first places will
> be affected by vulnerabilities.

Again I disagree.  I see distributions waiting to enable user namespaces
until they mature and until they are interesting enough.  I do not see
rushing to enable the newest features as wisdom, unless that the point
of your distribution is to enable people to play with the latest
features.

I suspect we are quickly coming to a point where user namespaces will be
sufficiently compelling that they will be enabled more widely.  


At this point the most helpful things I can see to be done are.
- Verify all userns related fixes have made it back into 4.1.x
- Play with and/or audit the userns code to see if more bugs can be
  found.
- Analyze user namespaces and see if they are uniquely worse than
  anything else.

I agree that if user namespaces pose a unique security challenge to
the kernel we should do something about them.  I think it is a healthy
question to ask.  For the conversation to be productive I think we need
numbers and analsysis, not just worst case analsysis based on fear.  To
date all I see are teething pains.

My back of the napkin analysis is that there are maybe 3,000 lines of
code executed in user namespaces (mostly from fs/namespace.c) that
are not otherwise reachable from unprivileged users, while there are
perhaps 100,000 - 250,000 lines of code reachable by unprivileged users
(not counting drivers).

At this point I do not expect that removing access to 3 lines out of 100
will significanlty reduce the probability that someone will find
exploitable code in the kernel.

I do think I goofed and enabled the code in fs/namespace.c before it was
ready to be accessed by unprivileged users.  My apologies to everyone
inconvinenced by that.


Tobias I do think you have fallen into a fault in your analysis of the
situtation that many other people have.  The assumption that by limiting
access to who can create user namespaces that we limit badness by people
who are root in a user namespace.   Very few of the problems I have seen
go away if a user is not able to create a user namespace.  Most problems
exist in some when an application is root inside a user namespace.

Tobias your proposal to me reads as enabling a feature only for those
users most likely to exploit it, which honestly seems backwards.

Eric
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
