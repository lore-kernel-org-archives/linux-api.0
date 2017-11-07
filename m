From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Mon, 6 Nov 2017 21:23:10 -0600
Message-ID: <20171107032310.GA6429@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
 <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com>
 <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com>
 <1510020963.736.42.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510020963.736.42.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 06, 2017 at 09:16:03PM -0500, Daniel Micay wrote:
> On Mon, 2017-11-06 at 16:14 -0600, Serge E. Hallyn wrote:
> > Quoting Daniel Micay (danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> > > Substantial added attack surface will never go away as a problem.
> > > There
> > > aren't a finite number of vulnerabilities to be found.
> > 
> > There's varying levels of usefulness and quality.  There is code which
> > I
> > want to be able to use in a container, and code which I can't ever see
> > a
> > reason for using there.  The latter, especially if it's also in a
> > staging driver, would be nice to have a toggle to disable.
> > 
> > You're not advocating dropping the added attack surface, only adding a
> > way of dealing with an 0day after the fact.  Privilege raising 0days
> > can
> > exist anywhere, not just in code which only root in a user namespace
> > can
> > exercise.  So from that point of view, ksplice seems a more complete
> > solution.  Why not just actually fix the bad code block when we know
> > about it?
> 
> That's not what I'm advocating. I only care about it for proactive
> attack surface reduction downstream. I have no interest in using it to
> block access to known vulnerabilities.
> 
> > Finally, it has been well argued that you can gain many new caps from
> > having only a few others.  Given that, how could you ever be sure
> > that,
> > if an 0day is found which allows root in a user ns to abuse
> > CAP_NET_ADMIN against the host, just keeping CAP_NET_ADMIN from them
> > would suffice?
> 
> I didn't suggest using it that way...
> 
> >  It seems to me that the existing control in
> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct
> > tape
> > in that case.
> 
> There's no such thing as unprivileged_userns_clone in mainline.

Hm.  I was sure Kees had gotten that in...  I guess I was wrong.

> The advantage of this over unprivileged_userns_clone in Debian and maybe
> some other distributions is not giving up unprivileged app containers /
> sandboxes implemented via user namespaces.  For example, Chromium's user
> namespace sandbox likely only needs to have CAP_SYS_CHROOT. Chromium
> will be dropping their setuid sandbox, forcing usage of user namespaces
> to avoid losing the sandbox which will greatly increase local kernel
> attack surface on the host by exposing netfilter management, etc. to
> unprivileged users.
> 
> The proposed approach isn't necessarily the best way to implement this
> kind of mitigation but I think it's filling a real need.

I think I definately prefer what I mentioned in the email to Boris.
Basically a "permanent capability bounding set".  The normal bounding
set gets reset to a full set on every new user_ns creation.  In this
proposal, it would instead be set to the calling task's permanent
capability set, which starts (at boot) full, and which privileged
tasks can pull capabilities out of.

-serge
