From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend 2/2] userns: control capabilities of some user
 namespaces
Date: Sat, 4 Nov 2017 18:53:46 -0500
Message-ID: <20171104235346.GA17170@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171103004436.40026-1-mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mahesh Bandewar <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Quoting Mahesh Bandewar (mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org):
> Init-user-ns is always uncontrolled and a process that has SYS_ADMIN
> that belongs to uncontrolled user-ns can create another (child) user-
> namespace that is uncontrolled. Any other process (that either does
> not have SYS_ADMIN or belongs to a controlled user-ns) can only
> create a user-ns that is controlled.

That's a huge change though.  It means that any system that previously
used unprivileged containers will need new privileged code (which always
risks more privilege leaks through the new code) to re-enable what was
possible without privilege before.  That's a regression.

I'm very much interested in what you want to do,  But it seems like
it would be worth starting with some automated code analysis that shows
exactly what code becomes accessible to unprivileged users with user
namespaces which was accessible to unprivileged users before.  Then we
can reason about classifying that code and perhaps limiting access to
some of it.
