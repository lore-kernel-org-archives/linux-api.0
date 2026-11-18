Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997327;
	b=v+29KtQlzNHRczSotZV4gYMFzkqzd9x5no8upeqo4ripaWP5JyprGi2PqWBUoiwfHUFu
	 89nRtwKz9vGHgwrncdKkyFL8LeRorrOai6gW9vliwGe4XDA4ztuWIy8yQt62nS/b7mlL+
	 g0jduY5TsWmaosJomi5rOH51hNAuAWNqUKXQgmfgVe8HjQ0DT1ZfBdkebvYl4qNa7Z6x9
	 YiMcMb9MtrqAZvw2TzTe4DbJeEOSn/ZchPvCjXhcPAc/KLUD8Hf2djRwWTRldxdRxtxB2
	 qzspC2Riv6H62ygvYAs/0qDSy2k9i7EnTrmkM08FPLVp0hAp4aOcYd+2iDJsSkOsGwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997327;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=VyI0JOmPAdt2iJBvWvYtuzWRsKEvaX39Ad8ehcsibZM=;
	b=g47+mTQWA8Eo9Gcv5ITfOqz6bN4XPVjrZIJy6DGqVPi4QrkHD4QyJQe0IJvZoagk0zKA
	 PuuPIEPXFQjuNPccaRADDFOt4HuP+gol7rTxvW+eDRNXbWaTVhzR33gv1oEKzQrpMZi46
	 EZsds7WDhA179vyIZi8//oq/qSRJxIJH1KcNjc9eKAjswZpHZynVtk36r9LmB4UpnHv7M
	 shLbX0rwdborJTNjCNyHJ0dGeNR5V1iVQ0OA9LMJPSUyYZdWkzd7sMSi18aAHUPiYGWoH
	 X1dW7fHqEGGPU6DtlNGIGVghcNqU2O7g0RsFoMRUPisNaMfGdC8XaAUTraScJ+84XtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXjwcxoa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A87606A31C;
	Wed, 18 Nov 2026 10:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HXjwcxoa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1211F000C4;
	Wed, 18 Nov 2026 10:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997326;
	bh=VyI0JOmPAdt2iJBvWvYtuzWRsKEvaX39Ad8ehcsibZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HXjwcxoaSOqZABRPB3fK3y+dBLkJc2kHYfI8Rg/t9SmJ48QgGuPd+Yqk42/FM6LJ+
	 csz56INbPTFK9D2mECMKVo2BHstGNMdWQfQ6/PMZbtAeGo65QNM5zggzAFU5obGwIy
	 2MgM/c69qnedcr5vKGGaeumvvOrHQ6W6NI2sFiHXKaCNxkvH8nAtjxrHn3P56Jcycg
	 Y+4dT78FzjgUrtAGGmV3ZFNz1WiqBqPYJXSp3qJSdPEPVlAoDlE0zK11ZMJHrvOPyM
	 fPOgQT0/HuzxnFRaKdfqhPEmLd5mId6joM3PBtgr4pY3GS39ZDFFDpelDANMqBs8PD
	 Az7JoNEqqNw9A==
Date: Wed, 18 Nov 2026 11:21:57 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
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
Message-ID: <20261118-stapeln-eckpunkte-lesbar-ee73537f474d@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com>
 <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>
 <20261117-rational-ohnehin-unbeugsam-e5c04759a156@brauner>
 <CALCETrWhuOnBy0N0KznmczD4S2XEK0fbr0C=1KFQqTnoTJbQbg@mail.gmail.com>
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
In-Reply-To: <CALCETrWhuOnBy0N0KznmczD4S2XEK0fbr0C=1KFQqTnoTJbQbg@mail.gmail.com>

On Tue, Nov 17, 2026 at 09:37:19AM -0800, Andy Lutomirski wrote:
> On Tue, Nov 17, 2026 at 9:10 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Mon, Nov 16, 2026 at 09:15:18AM -0800, Andy Lutomirski wrote:
> > > On Wed, Nov 11, 2026 at 7:20 AM Christian Brauner <brauner@kernel.org> wrote:
> > > > * a task that setns()es in later gets
> > > >   ns->cap_bset & (cred->cap_userns | cred->cap_permitted)
> > >
> > > I'm not sure this is ideal.  If a task has cap_userns & CAP_NET_ADMIN,
> > > then there is no attack surface issue with allowing it to enter a
> > > namespace and be NET_ADMIN there even if the namespace itself has
> > > CAP_NET_ADMIN cleared from cap_bset.  But any exemption here would
> > > need to be a new API so that it isn't used by accident.
> > >
> > > I'm mostly saying this because container managers might want to
> > > restrict cap_userns within their containers but still have it
> > > themselves for management.  But maybe there isn't any need to enter
> > > the userns for this purpose.
> >
> > I don't think there is. A manager that holds the capabilities itself can
> > just do most things from the outside. I think it's nice that once you're
> > inside a namespace you're bound by its capabiltiy set. Otherwise the set
> > isn't a property of the namespace anymore. If someone comes up with a
> > real need to enter we can add an explicit opt-in later?
> 
> Fair enough.  Also you've written infinitely more nontrivial container
> managers than I have (I've written container managers, too, but
> they're all special-purpose things that don't do much in the way of
> actual managing).

So I think this is another instance where we're bitten by the complexity
of the whole namespace api. In a perfect world our answer would be "Yes,
the owner of the userns is definitely capable of performing all relevant
actions from outside the userns.". But we're actually not able to say
that because there's so many different ways how some <object> is set up
or configured for a container and nobody ever sat down and defined the
model how a container and it's various resoures are set up.

So once again, here we are guessing our way to a decent decision...
Thanks for helping with thinking this through.

> > > > * Root in a container has caps as well so for containers the exemption
> > > >   would be wrong.
> > > >
> > > >   So here we need a a lockable SECURE_NO_USERNS_CAP_RAISE bit thingy.
> > > >   This turns off the exemption and prevents raising the mask.
> > > >
> > > >   Docker lowers the mask, sets and locks the bit, and
> > > >   unshare(CLONE_NEWUSER) in the container doesn't hand out CAP_NET_ADMIN
> > > >   anymore.
> > >
> > > Can you clarify this part a bit?  I'm not seeing why Docker should be
> > > special.  Shouldn't the inside of a Docker container work as much like
> > > a normal non-container system as possible?  What's the use case?
> >
> > I picked Docker because you brought it up, and your goal of allowing
> > user namespaces even in Docker is kinda the use case. Docker can only
> > drop the CLONE_NEWUSER block from its seccomp profile if nested user
> > namespaces can't get more caps than root/Docker wants to give them.
> >
> > But the bit isn't at all Docker specific. Any privileged task that wants the
> > mask to apply to itself would benefit. With just the exemption this wouldn't be
> > possible:
> >
> > (1) A runtime that holds full capabilities gives a
> >     user namespace it creates all bits.
> >     It can just set the bit before creating it.
> >
> > (2) In a container without a user namespace container root has host-level
> >     capabilities. Any user namespace it creates gets them through this
> >     exemption thing. So it can also add them back to its mask. And the mask is
> >     inherited. So every process it starts can then create user namespaces with
> >     them.
> >
> >     by raising the bit we stop both. The locked bit keeps container root which
> >     also has CAP_SETPCAP from clearing it.
> >
> 
> I'm still not 100% sure I'm following this.  By "exemption" are you
> talking about the cred->cap_premitted term here?

Yes.

> ns->cap_bset = parent->cap_bset &
>                        (cred->cap_userns | cred->cap_permitted);
> 
> (As as aside, as formulated, the parent->cap_bset term should be
> irrelevant, no?  cred always refers to a task in parent, and this

(
I don't think it i.s
cap_userns is full by default. Entering a namespace doesn't change it.
A task inside a namespace with a reduced cap_bset still has the full
mask. Without the term a child namespace gets more caps than its parent
had.

cap_permitted can grow through a setuid-root exec in the parent
namespace. And that exec is bounded by the tasks bounding set and not
by the namespace bounding set.

So that term ensures that the namespace bounding set shrinks
monotonically by construction.

I think it would only be redundant if exec would be clamped by cap_bset.
I'm not sure if the patchset does this.

/me looks...

Ah, ok... this patch series already clamps exec to the namespace
bounding set. So yes, you're right.
)

> whole thing is defined so that cap_userns and cap_permitted are always
> subsets of parent's cap_bset, right?)
> 
> I think I agree that there needs to be a way to turn the cap_permitted
> thing on and off (and I'm also not sure whether cap_permitted is
> better than cap_effective), but I'm not convinced that an inheritable

The effective set can be raised from the permitted set at will. So I
think permitted is just more correct.

> and lockable bit is necessary or wise.
> 
> How about changing the rule to:
> 
> child->cap_bset = parent->cap_bset & soft_cap_userns &
> (cred->cap_userns | cred->cap_permitted)
> 
> a) (ugly but easier) A non-inheritable prctl-controlled mask
> soft_cap_userns, changing the rule to parent->cap_bset &
> soft_cap_userns & (cred->cap_userns | cred->cap_permitted).
> soft_cap_userns would be reset to all ones on on fork and exec to
> avoid creating new inheritable security-relevant state.

So both let the creator pick. But the bit is for the creator when it
wants to self-restrict: container-root without a user namespace.

It's the same reason that securebits and no_new_privs are inheritable
and lockable. Afaict, a) is reset on exec so it doesn't control the next
exec. b) covers namespace creation but not unsharing a user namespace.

> b) A whole new create-a-namespace API where the caller chooses
> soft_cap_userns at the time they create the namespace.
> 
> > On the host none of that matters as the mask is root's own policy there.
> 
> I'm still not seeing how there's a difference between host vs
> init-userns-container vs separate-userns-container.  After all, in

I think the difference is simply whether the restricting task holds the
capabilities itself. Unprivileged users on the host don't and so they're
not subject to the exemption. The bit is for that case where the task
holds the caps.

But ok, if we really don't want to bother with container without user
namespaces the bit vs a) thing can also go into a follow-up series.

> Unfortunately we don't live in this world, and I'm not convinced that
> can credibly even approximate it, because people really like their
> setuid programs working inside a userns.  It still bugs me that we're
> designing permission systems designed to work in the POSIX model that
> I think we all kind of agree is fundamentally rather messed up.

I don't think all hope is lost. We have slowly been pushing in this
direction. systemd allows to set NoNewPrivileges= in it's global config
so it's possible to enable it for the whole system easily.

There's been a ton of work to get rid of classic setuid-exec stuff:

* run0 instead of sudo (with sudo compat), and systemd-ptybrokerd for
  interactive shells
* nsresourced for user namespaces with delegated ranges, mountfsd for
  unprivileged image mounts
* outside of systemd: pwaccessd/pwupdd/newidmapd replacing unix_chkpwd,
  passwd and newuidmap/newgidmap, polkit without a setuid helper, and
  su/sudo/pkexec wrappers on top of ptybrokerd

But yes, containers are the sore spot. no_new_privs inherited from PID
1 breaks setuid inside of containers.

My idea has been to make this dynamic:

* deny privilege gain on exec in the initial user namespace and allow it
  in nested ones. I mused about this in
  https://github.com/uapi-group/kernel-features/pull/38

Also, since v7.1 there's CLONE_NNP to spawn a child without no_new_privs
set.
