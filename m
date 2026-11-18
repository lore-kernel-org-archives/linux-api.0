Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037878;
	b=KSCZmru9Br4SUmn/zMeczmZqQxZL8c7nlNVXxdTmXK6iI4g3Nb5+EV857KS3qPV9wuVg
	 KTjYJn/YQdXE1I5LDded71P2j7ov0xMDSEAlDUArEP6nct3W8KQWQW69Yj0arrofaCb59
	 hR0cMCssNHpIqvqCaGHarj8AOmvSm8Ahh6J6SSwCR8WAjgjXTIOn3h4G3sf55PgQ0I39m
	 RhHn766xnbO2eDWoxrpFtBoA/FB2gY6V7q/R7zj2kfLb7vvblQ7GPToMpD0bDKmgN5ujs
	 KaxNukCHWXxqitLmNLCBQUOEja20Eq1q3oemiTcLt8ZQ04XQL+hdr5g1JpjGVrFA+8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037878;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=eda4ISHn5njc0IevbUeQv7QSiOeoFwowNLfqeedWwx0=;
	b=1djInVBB8GMxDbFzpAAcKXmmArFf9C7RHCtx1BZSDEvv36kdX1uqU4wMliFQ4vMFdcQe
	 nZYzAs6/X4AKyYveJwOOpTz06P6fuRTjj6WwRKEt+t9Z0Cm8dAwAsTttAyw7CUiDTG6yn
	 IEp2GOIzHLHpOJ+6a/xnQY0gFNnhXXcWlN+jSeZb24LRAcSazxAZU03J15StPwXNx2H+2
	 5HZww26zE70Kt06bAT7oT73BeaJIBvJ19XL39UrzyS3qw6OPZd9jKa7MdDhNyXdRkwZbU
	 0gWGmPi5X5H6G8nfA96akhwhVoe1eQCL9Bq/3Ass+rq9NWQ7SLEBHcTRncutXJVw+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QP74cqrM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6A8606A31C;
	Wed, 18 Nov 2026 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QP74cqrM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC47C1F000C6;
	Wed, 18 Nov 2026 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795037878;
	bh=eda4ISHn5njc0IevbUeQv7QSiOeoFwowNLfqeedWwx0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QP74cqrMg0ssgYPhlNLoVnUlyqLBPz6kMLxr/sw5q2NaYR+sCsU54vyW7wHThRcVS
	 raNEPpiCIuSXRAiQbacG1+liaCR23nyvaHGk9TFbWQkARNw66swW9gHtQcmFqfD0Ii
	 7FZ5pImPnVTEtKn3zhcb3jbYp/YJnoZtfg1MAq+zWXGrEA0+HOdW89pWMbgL3NLRKL
	 NIAtzZ1UWNbb40X6PFi1xfR3mibxsMx695uW0E0hxpekgNiu+Jn9qifkC7KkrZqgai
	 DY//3k4nI7FN0LjTaNX/HOq+alHp5ja8vWBWe4lMDQ2uvF7NA+Q8/NIv6yoaFdS5c7
	 nkj3DuVlfw9Yw==
Date: Wed, 18 Nov 2026 22:37:49 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>, lennart@poettering.net, 
	Jann Horn <jannh@google.com>
Cc: "Hallgrimur H. Gunnarsson" <halg@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Jan Kara <jack@suse.cz>, 
	James Morris <jmorris@namei.org>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, KP Singh <kpsingh@kernel.org>, 
	Jonathan Calmels <jcalmels@3xx0.net>, Casey Schaufler <casey@schaufler-ca.com>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, 
	containers@lists.linux.dev, netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] userns: per-namespace capability bounding set and
 opt-in netns loopback
Message-ID: <20261118-professionell-kondition-kerzen-5dd23c1ee490@brauner>
References: <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com>
 <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>
 <20261117-rational-ohnehin-unbeugsam-e5c04759a156@brauner>
 <CALCETrWhuOnBy0N0KznmczD4S2XEK0fbr0C=1KFQqTnoTJbQbg@mail.gmail.com>
 <20261118-stapeln-eckpunkte-lesbar-ee73537f474d@brauner>
 <20261118-zufahrt-baubeginn-gutsbetrieb-c09004227e8f@brauner>
 <CALCETrUMNr=32ENT6VBKPzoyJDfaX6nzZsjMVxuz9O3z+6LRhw@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrUMNr=32ENT6VBKPzoyJDfaX6nzZsjMVxuz9O3z+6LRhw@mail.gmail.com>

On Wed, Nov 18, 2026 at 01:12:45PM -0800, Andy Lutomirski wrote:
> On Wed, Nov 18, 2026 at 1:06 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Wed, Nov 18, 2026 at 11:21:57AM +0100, Christian Brauner wrote:
> > > On Tue, Nov 17, 2026 at 09:37:19AM -0800, Andy Lutomirski wrote:
> > > > On Tue, Nov 17, 2026 at 9:10 AM Christian Brauner <brauner@kernel.org> wrote:
> > > > >
> > > > > On Mon, Nov 16, 2026 at 09:15:18AM -0800, Andy Lutomirski wrote:
> > > > > > On Wed, Nov 11, 2026 at 7:20 AM Christian Brauner <brauner@kernel.org> wrote:
> > > > > > > * a task that setns()es in later gets
> > > > > > >   ns->cap_bset & (cred->cap_userns | cred->cap_permitted)
> > > > > >
> > > > > > I'm not sure this is ideal.  If a task has cap_userns & CAP_NET_ADMIN,
> > > > > > then there is no attack surface issue with allowing it to enter a
> > > > > > namespace and be NET_ADMIN there even if the namespace itself has
> > > > > > CAP_NET_ADMIN cleared from cap_bset.  But any exemption here would
> > > > > > need to be a new API so that it isn't used by accident.
> > > > > >
> > > > > > I'm mostly saying this because container managers might want to
> > > > > > restrict cap_userns within their containers but still have it
> > > > > > themselves for management.  But maybe there isn't any need to enter
> > > > > > the userns for this purpose.
> > > > >
> > > > > I don't think there is. A manager that holds the capabilities itself can
> > > > > just do most things from the outside. I think it's nice that once you're
> > > > > inside a namespace you're bound by its capabiltiy set. Otherwise the set
> > > > > isn't a property of the namespace anymore. If someone comes up with a
> > > > > real need to enter we can add an explicit opt-in later?
> > > >
> > > > Fair enough.  Also you've written infinitely more nontrivial container
> > > > managers than I have (I've written container managers, too, but
> > > > they're all special-purpose things that don't do much in the way of
> > > > actual managing).
> > >
> > > So I think this is another instance where we're bitten by the complexity
> > > of the whole namespace api. In a perfect world our answer would be "Yes,
> > > the owner of the userns is definitely capable of performing all relevant
> > > actions from outside the userns.". But we're actually not able to say
> > > that because there's so many different ways how some <object> is set up
> > > or configured for a container and nobody ever sat down and defined the
> > > model how a container and it's various resoures are set up.
> > >
> > > So once again, here we are guessing our way to a decent decision...
> > > Thanks for helping with thinking this through.
> > >
> > > > > > > * Root in a container has caps as well so for containers the exemption
> > > > > > >   would be wrong.
> > > > > > >
> > > > > > >   So here we need a a lockable SECURE_NO_USERNS_CAP_RAISE bit thingy.
> > > > > > >   This turns off the exemption and prevents raising the mask.
> > > > > > >
> > > > > > >   Docker lowers the mask, sets and locks the bit, and
> > > > > > >   unshare(CLONE_NEWUSER) in the container doesn't hand out CAP_NET_ADMIN
> > > > > > >   anymore.
> > > > > >
> > > > > > Can you clarify this part a bit?  I'm not seeing why Docker should be
> > > > > > special.  Shouldn't the inside of a Docker container work as much like
> > > > > > a normal non-container system as possible?  What's the use case?
> > > > >
> > > > > I picked Docker because you brought it up, and your goal of allowing
> > > > > user namespaces even in Docker is kinda the use case. Docker can only
> > > > > drop the CLONE_NEWUSER block from its seccomp profile if nested user
> > > > > namespaces can't get more caps than root/Docker wants to give them.
> > > > >
> > > > > But the bit isn't at all Docker specific. Any privileged task that wants the
> > > > > mask to apply to itself would benefit. With just the exemption this wouldn't be
> > > > > possible:
> > > > >
> > > > > (1) A runtime that holds full capabilities gives a
> > > > >     user namespace it creates all bits.
> > > > >     It can just set the bit before creating it.
> > > > >
> > > > > (2) In a container without a user namespace container root has host-level
> > > > >     capabilities. Any user namespace it creates gets them through this
> > > > >     exemption thing. So it can also add them back to its mask. And the mask is
> > > > >     inherited. So every process it starts can then create user namespaces with
> > > > >     them.
> > > > >
> > > > >     by raising the bit we stop both. The locked bit keeps container root which
> > > > >     also has CAP_SETPCAP from clearing it.
> > > > >
> > > >
> > > > I'm still not 100% sure I'm following this.  By "exemption" are you
> > > > talking about the cred->cap_premitted term here?
> > >
> > > Yes.
> > >
> > > > ns->cap_bset = parent->cap_bset &
> > > >                        (cred->cap_userns | cred->cap_permitted);
> > > >
> > > > (As as aside, as formulated, the parent->cap_bset term should be
> > > > irrelevant, no?  cred always refers to a task in parent, and this
> > >
> > > (
> > > I don't think it i.s
> > > cap_userns is full by default. Entering a namespace doesn't change it.
> > > A task inside a namespace with a reduced cap_bset still has the full
> > > mask. Without the term a child namespace gets more caps than its parent
> > > had.
> > >
> > > cap_permitted can grow through a setuid-root exec in the parent
> > > namespace. And that exec is bounded by the tasks bounding set and not
> > > by the namespace bounding set.
> > >
> > > So that term ensures that the namespace bounding set shrinks
> > > monotonically by construction.
> > >
> > > I think it would only be redundant if exec would be clamped by cap_bset.
> > > I'm not sure if the patchset does this.
> > >
> > > /me looks...
> > >
> > > Ah, ok... this patch series already clamps exec to the namespace
> > > bounding set. So yes, you're right.
> > > )
> > >
> > > > whole thing is defined so that cap_userns and cap_permitted are always
> > > > subsets of parent's cap_bset, right?)
> > > >
> > > > I think I agree that there needs to be a way to turn the cap_permitted
> > > > thing on and off (and I'm also not sure whether cap_permitted is
> > > > better than cap_effective), but I'm not convinced that an inheritable
> > >
> > > The effective set can be raised from the permitted set at will. So I
> > > think permitted is just more correct.
> > >
> > > > and lockable bit is necessary or wise.
> > > >
> > > > How about changing the rule to:
> > > >
> > > > child->cap_bset = parent->cap_bset & soft_cap_userns &
> > > > (cred->cap_userns | cred->cap_permitted)
> > > >
> > > > a) (ugly but easier) A non-inheritable prctl-controlled mask
> > > > soft_cap_userns, changing the rule to parent->cap_bset &
> > > > soft_cap_userns & (cred->cap_userns | cred->cap_permitted).
> > > > soft_cap_userns would be reset to all ones on on fork and exec to
> > > > avoid creating new inheritable security-relevant state.
> > >
> > > So both let the creator pick. But the bit is for the creator when it
> > > wants to self-restrict: container-root without a user namespace.
> > >
> > > It's the same reason that securebits and no_new_privs are inheritable
> > > and lockable. Afaict, a) is reset on exec so it doesn't control the next
> > > exec. b) covers namespace creation but not unsharing a user namespace.
> > >
> > > > b) A whole new create-a-namespace API where the caller chooses
> > > > soft_cap_userns at the time they create the namespace.
> > > >
> > > > > On the host none of that matters as the mask is root's own policy there.
> > > >
> > > > I'm still not seeing how there's a difference between host vs
> > > > init-userns-container vs separate-userns-container.  After all, in
> > >
> > > I think the difference is simply whether the restricting task holds the
> > > capabilities itself. Unprivileged users on the host don't and so they're
> > > not subject to the exemption. The bit is for that case where the task
> > > holds the caps.
> > >
> > > But ok, if we really don't want to bother with container without user
> > > namespaces the bit vs a) thing can also go into a follow-up series.
> > >
> > > > Unfortunately we don't live in this world, and I'm not convinced that
> > > > can credibly even approximate it, because people really like their
> > > > setuid programs working inside a userns.  It still bugs me that we're
> > > > designing permission systems designed to work in the POSIX model that
> > > > I think we all kind of agree is fundamentally rather messed up.
> > >
> > > I don't think all hope is lost. We have slowly been pushing in this
> > > direction. systemd allows to set NoNewPrivileges= in it's global config
> > > so it's possible to enable it for the whole system easily.
> > >
> > > There's been a ton of work to get rid of classic setuid-exec stuff:
> > >
> > > * run0 instead of sudo (with sudo compat), and systemd-ptybrokerd for
> > >   interactive shells
> > > * nsresourced for user namespaces with delegated ranges, mountfsd for
> > >   unprivileged image mounts
> > > * outside of systemd: pwaccessd/pwupdd/newidmapd replacing unix_chkpwd,
> > >   passwd and newuidmap/newgidmap, polkit without a setuid helper, and
> > >   su/sudo/pkexec wrappers on top of ptybrokerd
> > >
> > > But yes, containers are the sore spot. no_new_privs inherited from PID
> > > 1 breaks setuid inside of containers.
> > >
> > > My idea has been to make this dynamic:
> > >
> > > * deny privilege gain on exec in the initial user namespace and allow it
> > >   in nested ones. I mused about this in
> > >   https://github.com/uapi-group/kernel-features/pull/38
> > >
> > > Also, since v7.1 there's CLONE_NNP to spawn a child without no_new_privs
> > > set.
> >
> > Forgot:
> >
> > https://www.thkukuk.de/blog/no_new_privs/
> >
> > has an overview of where we're currently at.
> 
> Nice!
> 
> I commented in the uapi-group issue:
> 
> I think there may be a rather more direct solution to this problem. I
> seem to recall advocating for clearing no_new_privs when entering a
> userns way back when, and IIRC I dropped this as part of the extensive
> negotiation to get NNP into the kernel in the first place. (I think
> dropping it was probably the right decision to keep the final patch
> simple.)
> 
> But I think I would still advocate for an option to let clone, unshare
> and setns callers turn no_new_privs off. The logic is that, if you own
> a userns, you already have all capabilities in it. If you enter it,
> you get to keep those by having them raised in cap_permitted. Being
> able to clear NNP and thus drop and subsequently regain them does not
> let you do anything you couldn’t already do.
> 
> An LSM hook for this would be needed because this argument does not
> apply to non-namespace-scoped LSM-based privileges. But the LSM hook
> would just be a "may this caller enter this userns and clear
> no_new_privs while doing so" query. In the absence of LSMs, the
> operation would be allowed.
> 
> This would allow a fully no_new_privs host to run an ordinary
> container that runs, in the ordinary way, without no_new_privs, and
> without hitting any new LSM calls after it's started.
> 
> The API could be as simple as a CLONE_CLEAR_NNP bit.

I think that sounds ok. I worry a little it since it would somewhat
alter the promise that NNP gives. What model do you envision?
It seems that CLONE_CLEAR_NNP would only be allowed with CLONE_NEWUSER.
I _think_ this safe even for privileged users that create a user
namespace and map uid 0 to uid 0. So I think this could work.
