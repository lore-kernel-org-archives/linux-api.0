From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
Date: Mon, 15 Jul 2019 17:04:29 -0400
Message-ID: <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Tycho Andersen <tycho@tycho.ws>, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, Linux-Audit Mailing List <linux-audit@redhat.com>, linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com, Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com, nhorman@tuxdriver.com
List-Id: linux-api@vger.kernel.org

On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-05-30 15:29, Paul Moore wrote:

...

> > [REMINDER: It is an "*audit* container ID" and not a general
> > "container ID" ;)  Smiley aside, I'm not kidding about that part.]
> >
> > I'm not interested in supporting/merging something that isn't useful;
> > if this doesn't work for your use case then we need to figure out what
> > would work.  It sounds like nested containers are much more common in
> > the lxc world, can you elaborate a bit more on this?
> >
> > As far as the possible solutions you mention above, I'm not sure I
> > like the per-userns audit container IDs, I'd much rather just emit the
> > necessary tracking information via the audit record stream and let the
> > log analysis tools figure it out.  However, the bigger question is how
> > to limit (re)setting the audit container ID when you are in a non-init
> > userns.  For reasons already mentioned, using capable() is a non
> > starter for everything but the initial userns, and using ns_capable()
> > is equally poor as it essentially allows any userns the ability to
> > munge it's audit container ID (obviously not good).  It appears we
> > need a different method for controlling access to the audit container
> > ID.
>
> We're not quite ready yet for multiple audit daemons and possibly not
> yet for audit namespaces, but this is starting to look a lot like the
> latter.

A few quick comments on audit namespaces: the audit container ID is
not envisioned as a new namespace (even in nested form) and neither do
I consider running multiple audit daemons to be a new namespace.

>From my perspective we create namespaces to allow us to redefine a
global resource for some subset of the system, e.g. providing a unique
/tmp for some number of processes on the system.  While it may be
tempting to think of the audit container ID as something we could
"namespace", especially when multiple audit daemons are concerned, in
some ways this would be counter productive; the audit container ID is
intended to be a global ID that can be used to associate audit event
records with a "container" where the "container" is defined by an
orchestrator outside the audit subsystem.  The global nature of the
audit container ID allows us to maintain a sane(ish) view of the
system in the audit log, if we were to "namespace" the audit container
ID such that the value was no longer guaranteed to be unique
throughout the system, we would need to additionally track the audit
namespace along with the audit container ID which starts to border on
insanity IMHO.

> If we can't trust ns_capable() then why are we passing on
> CAP_AUDIT_CONTROL?  It is being passed down and not stripped purposely
> by the orchestrator/engine.  If ns_capable() isn't inherited how is it
> gained otherwise?  Can it be inserted by cotainer image?  I think the
> answer is "no".  Either we trust ns_capable() or we have audit
> namespaces (recommend based on user namespace) (or both).

My thinking is that since ns_capable() checks the credentials with
respect to the current user namespace we can't rely on it to control
access since it would be possible for a privileged process running
inside an unprivileged container to manipulate the audit container ID
(containerized process has CAP_AUDIT_CONTROL, e.g. running as root in
the container, while the container itself does not).

> At this point I would say we are at an impasse unless we trust
> ns_capable() or we implement audit namespaces.

I'm not sure how we can trust ns_capable(), but if you can think of a
way I would love to hear it.  I'm also not sure how namespacing audit
is helpful (see my above comments), but if you think it is please
explain.

> I don't think another mechanism to trust nested orchestrators/engines
> will buy us anything.
>
> Am I missing something?

Based on your questions/comments above it looks like your
understanding of ns_capable() does not match mine; if I'm thinking
about ns_capable() incorrectly, please educate me.

-- 
paul moore
www.paul-moore.com
