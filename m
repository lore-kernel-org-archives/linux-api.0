From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Wed, 8 Nov 2017 03:09:59 -0800
Message-ID: <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
References: <20171103004436.40026-1-mahesh@bandewar.net> <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com> <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com> <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com> <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171107032802.GA6669-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Sorry folks I was traveling and seems like lot happened on this thread. :p

I will try to response few of these comments selectively -

> The thing that makes me hesitate with this set is that it is a
> permanent new feature to address what (I hope) is a temporary
> problem.
I agree this is permanent new feature but it's not solving a temporary
problem. It's impossible to assess what and when new vulnerability
that could show up. I think Daniel summed it up appropriately in his
response

> Seems like there are two naive ways to do it, the first being to just
> look at all code under ns_capable() plus code called from there.  It
> seems like looking at the result of that could be fruitful.
This is really hard. The main issue that there were features designed
and developed before user-ns days with an assumption that unprivileged
users will never get certain capabilities which only root user gets.
Now that is not true anymore with user-ns creation with mapping root
for any process. Also at the same time blocking user-ns creation for
eveyone is a big-hammer which is not needed too. So it's not that easy
to just perform a code-walk-though and correct those decisions now.

> It seems to me that the existing control in
> /proc/sys/kernel/unprivileged_userns_clone might be the better duct tape
> in that case.
This solution is essentially blocking unprivileged users from using
the user-namespaces entirely. This is not really a solution that can
work. The solution that this patch-set adds allows unprivileged users
to create user-namespaces. Actually the proposed solution is more
fine-grained approach than the unprivileged_userns_clone solution
since you can selectively block capabilities rather than completely
blocking the functionality.

> I meant each task has a perm_cap_bset next to the cap_bset.  So task
> p1 (if it has privilege) can drop CAP_SYS_ADMIN from perm_cap_bset,
> p2 (if it has privilege) can drop CAP_NET_ADMIN.  When p1 creates a
> new user_ns, that init task has its cap_bset set to all caps but
> CAP_SYS_ADMIN.
>
> I think for simplicity perm_cap_bset would *only* affect the filling
> of cap_bset at user namespace creation.  So if you wanted to drop a
> capability from your own cap_bset as well, you'd have to do that
> separately.
My original intention is to reduce the attack surface when
vulnerabilities are discovered / published, but I don't see how this
is solving that issue. Also the reason to have sysctl is to have
simplistic control across the board to contain the situation. If that
is not addressed then we might need some other solution on top of
this.
