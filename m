From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?=
        <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend 2/2] userns: control capabilities of some user namespaces
Date: Sun, 5 Nov 2017 23:23:33 -0800
Message-ID: <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
References: <20171103004436.40026-1-mahesh@bandewar.net> <20171104235346.GA17170@mail.hallyn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171104235346.GA17170-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Nov 4, 2017 at 4:53 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
>
> Quoting Mahesh Bandewar (mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org):
> > Init-user-ns is always uncontrolled and a process that has SYS_ADMIN
> > that belongs to uncontrolled user-ns can create another (child) user-
> > namespace that is uncontrolled. Any other process (that either does
> > not have SYS_ADMIN or belongs to a controlled user-ns) can only
> > create a user-ns that is controlled.
>
> That's a huge change though.  It means that any system that previously
> used unprivileged containers will need new privileged code (which always
> risks more privilege leaks through the new code) to re-enable what was
> possible without privilege before.  That's a regression.
>
I wouldn't call it a regression since the existing behavior is
preserved as it is if the default-mask is not altered. i.e.
uncontrolled process can create user-ns and have full control inside
that user-ns. The only difference is - as an example if 'something'
comes up which makes a specific capability expose ring-0, so admin can
quickly remove the capability in question from the mask, so that no
untrusted code can exploit that capability until either the kernel is
patched or workloads are sanitized keeping in mind what was
discovered. (I have given some real life example vulnerabilities
published recently about CAP_NET_RAW in the cover letter)

> I'm very much interested in what you want to do,  But it seems like
> it would be worth starting with some automated code analysis that shows
> exactly what code becomes accessible to unprivileged users with user
> namespaces which was accessible to unprivileged users before.  Then we
> can reason about classifying that code and perhaps limiting access to
> some of it.
I would like to look at this as 'a tool' that is available to admins
who can quickly take possible-compromise-situation under-control
probably at the cost of some functionality-loss until kernel is
patched and the mask is restored to default value.

I'm not sure if automated tools could discover anything since these
changes should not alter behavior in any way.
