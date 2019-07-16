From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Tue, 16 Jul 2019 19:30:15 -0400
Message-ID: <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
References: <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca> <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
 <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tycho Andersen <tycho@tycho.ws>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Tue, Jul 16, 2019 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-07-15 17:04, Paul Moore wrote:
> > On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:

...

> > > If we can't trust ns_capable() then why are we passing on
> > > CAP_AUDIT_CONTROL?  It is being passed down and not stripped purposely
> > > by the orchestrator/engine.  If ns_capable() isn't inherited how is it
> > > gained otherwise?  Can it be inserted by cotainer image?  I think the
> > > answer is "no".  Either we trust ns_capable() or we have audit
> > > namespaces (recommend based on user namespace) (or both).
> >
> > My thinking is that since ns_capable() checks the credentials with
> > respect to the current user namespace we can't rely on it to control
> > access since it would be possible for a privileged process running
> > inside an unprivileged container to manipulate the audit container ID
> > (containerized process has CAP_AUDIT_CONTROL, e.g. running as root in
> > the container, while the container itself does not).
>
> What makes an unprivileged container unprivileged?  "root", or "CAP_*"?

My understanding is that when most people refer to an unprivileged
container they are referring to a container run without capabilities
or a container run by a user other than root.  I'm sure there are
better definitions out there, by folks much smarter than me on these
things, but that's my working definition.

> If CAP_AUDIT_CONTROL is granted, does "root" matter?

Our discussions here have been about capabilities, not UIDs.  The only
reason root might matter is that it generally has the full capability
set.

> Does it matter what user namespace it is in?

What likely matters is what check is called: capable() or
ns_capable().  Those can yield very different results.

> I understand that root is *gained* in an
> unprivileged user namespace, but capabilities are inherited or permitted
> and that process either has it or it doesn't and an unprivileged user
> namespace can't gain a capability that has been rescinded.  Different
> subsystems use the userid or capabilities or both to determine
> privileges.

Once again, I believe the important thing to focus on here is
capable() vs ns_capable().  We can't safely rely on ns_capable() for
the audit container ID policy since that is easily met inside the
container regardless of the process' creds which started the
container.

> In this case, is the userid relevant?

We don't do UID checks, we do capability checks, so yes, the UID is irrelevant.

> > > At this point I would say we are at an impasse unless we trust
> > > ns_capable() or we implement audit namespaces.
> >
> > I'm not sure how we can trust ns_capable(), but if you can think of a
> > way I would love to hear it.  I'm also not sure how namespacing audit
> > is helpful (see my above comments), but if you think it is please
> > explain.
>
> So if we are not namespacing, why do we not trust capabilities?

We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).

-- 
paul moore
www.paul-moore.com
