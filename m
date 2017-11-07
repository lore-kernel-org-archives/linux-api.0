From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
Date: Mon, 6 Nov 2017 21:28:02 -0600
Message-ID: <20171107032802.GA6669@mail.hallyn.com>
References: <20171103004436.40026-1-mahesh@bandewar.net>
 <20171104235346.GA17170@mail.hallyn.com>
 <CAF2d9jg1tZz-hnVBeXm3geq7jSBt5v5w6+p5B1V-7huS4qbMBA@mail.gmail.com>
 <20171106150302.GA26634@mail.hallyn.com>
 <1510003994.736.0.camel@gmail.com>
 <20171106221418.GA32543@mail.hallyn.com>
 <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com>
 <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Lukashev <blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mahesh Bandewar <mahesh-bmGAjcP2qsnk1uMJSBkQmQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel-hardening <kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 06, 2017 at 07:01:58PM -0500, Boris Lukashev wrote:
> On Mon, Nov 6, 2017 at 6:39 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Quoting Boris Lukashev (blukashev-JNja4Z15B3SvB/ACxS1yDA@public.gmane.org):
> >> On Mon, Nov 6, 2017 at 5:14 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> >> > Quoting Daniel Micay (danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org):
> >> >> Substantial added attack surface will never go away as a problem. There
> >> >> aren't a finite number of vulnerabilities to be found.
> >> >
> >> > There's varying levels of usefulness and quality.  There is code which I
> >> > want to be able to use in a container, and code which I can't ever see a
> >> > reason for using there.  The latter, especially if it's also in a
> >> > staging driver, would be nice to have a toggle to disable.
> >> >
> >> > You're not advocating dropping the added attack surface, only adding a
> >> > way of dealing with an 0day after the fact.  Privilege raising 0days can
> >> > exist anywhere, not just in code which only root in a user namespace can
> >> > exercise.  So from that point of view, ksplice seems a more complete
> >> > solution.  Why not just actually fix the bad code block when we know
> >> > about it?
> >> >
> >> > Finally, it has been well argued that you can gain many new caps from
> >> > having only a few others.  Given that, how could you ever be sure that,
> >> > if an 0day is found which allows root in a user ns to abuse
> >> > CAP_NET_ADMIN against the host, just keeping CAP_NET_ADMIN from them
> >> > would suffice?  It seems to me that the existing control in
> >> > /proc/sys/kernel/unprivileged_userns_clone might be the better duct tape
> >> > in that case.
> >> >
> >> > -serge
> >>
> >> This seems to be heading toward "we need full zones in Linux" with
> >> their own procfs and sysfs namespace and a stricter isolation model
> >> for resources and capabilities. So long as things can happen in a
> >> namespace which have a privileged relationship with host resources,
> >> this is going to be cat-and-mouse to one degree or another.
> >>
> >> Containers and namespaces dont have a one-to-one relationship, so i'm
> >> not sure that's the best term to use in the kernel security context
> >
> > Sorry - what's not the best term to use?
> 
> Pardon, "containers," since they're namespaces+system construct.
> 
> >
> >> since there's a bunch of userspace and implementation delta across the
> >> different systems (with their own security models and so forth).
> >> Without accounting for what a specific implementation may or may not
> >> do, and only looking at "how do we reduce privileged impact on parent
> >> context from unprivileged namespaces," this patch does seem to provide
> >> a logical way of reducing the privileges available in such a namespace
> >> and often needed to mount escapes/impact parent context.
> >
> > What different implementations do is irrelevant - as an unprivileged user
> > I can always, with no help, create a new user namespace mapping my current
> > uid to root, and exercise this code.  So the security model implemented
> > by a particular userspace namespace-using driver doesn't matter, as it
> > only restricts me if I choose to use it.
> >
> > But, I guess you're actually saying that some program might know that it
> > should never use network code so want to drop CAP_NET_*?  And you're
> > saying that a "global capability bounding set" might be useful?
> >
> 
> The "global capability bounding set" with forced inheritance can be
> used to prevent the vector you describe wherein the capability of UID
> 0 in the child NS is restricted from the parent implicitly, so yes,
> that nomenclature seems appropriate.
> 
> > Would it be better to actually implement it as a new bounding set that
> > is maintained across user namespace creations, but is per-task (inherted
> > by children of course)?  Instead of a sysctl?
> >
> > -serge
> 
> In line with the previous comment, the inheritance across subsequent
> invocations should be forced to prevent the context you described.
> Please pardon my ignorance, not sure what you mean in terms of
> "per-task" across namespace creation.

I meant each task has a perm_cap_bset next to the cap_bset.  So task
p1 (if it has privilege) can drop CAP_SYS_ADMIN from perm_cap_bset,
p2 (if it has privilege) can drop CAP_NET_ADMIN.  When p1 creates a
new user_ns, that init task has its cap_bset set to all caps but
CAP_SYS_ADMIN.

I think for simplicity perm_cap_bset would *only* affect the filling
of cap_bset at user namespace creation.  So if you wanted to drop a
capability from your own cap_bset as well, you'd have to do that
separately.
