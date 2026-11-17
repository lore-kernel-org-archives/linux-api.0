Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794935415;
	b=vgYjJpFrpq20Hq16mLRb8t8yF/38vasZb0UrasPyp9Ap5q5ukfK5jcEb6IRvsV8ojWv3
	 w2/hkGhIy3xPfJkCSZiOSu8pUi/s97jZgTpt0cmipwBx+mbTQdbssz82+4OzDqWeYrXC6
	 FswwW01dxOERyYV4VdJYHfLxwf93VrTAK7b95Lu4rR6JoLvhaiZNHvsyl+ARV101ERUov
	 b6ydZraE0Id91ErIttged1vVlcd0d2dKkyNuVto+BwsLuBmpIs66n80B8E8hiiMMz1C2j
	 54jmgd/JxdyfV6AjIAMfZbjL1zjidSvK5+YLF4MfT+oYpna2PZx88sUpkJ6e/mlIEYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794935415;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=UNMoeiPf59zYewdyjbUj2KK7jui/9PboPaDgtiTNze4=;
	b=2Dgbyha1rDpF/cFLJBhsvR0yQLVd2jQQStgQkSbPoaDQCU3uOg3mrHvrGhmqas//v9Lt
	 L4lm2Yk/zzUDwBYqsCiOZaa/cbZ/lMircZKXFOQ2uLB4iNLmNxqMHknob6nHH+hd6PIZU
	 +T/M/kqAL8tMrmqx/M8zP2WjQdpHNx/3Ago6hupHmY5gIWkzETi31VXUegcVpfDAsTYaN
	 anpg0uyrJH0+WzjADHLxgdqlIghYxczx68fB5LHgIzB6nHY07f3WiZ7UQPOT1z0mBCfjY
	 RG5dOqn71Hd9i4cpEfWEkYPK4xpPRwYaEoEFJ7y1+Nj9AgeC0VWMQ7j+FPB++yTE5kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8VNHL7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3ED606A332;
	Tue, 17 Nov 2026 17:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J8VNHL7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A691F000D0;
	Tue, 17 Nov 2026 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794935415;
	bh=UNMoeiPf59zYewdyjbUj2KK7jui/9PboPaDgtiTNze4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J8VNHL7O5Di6/5Eh1Hsa+2mJVMo1E4BgTzxJeLjEeRaGuZEk9jNTJE4r92Gt/IR4C
	 jUVSpDoz1E9Ldg18one5LIpmAS/ZAxLV76EiCm7MDKwEkez+ViOzmRM5aq3mYEdpJH
	 W0ECfaxzMRCXp9yeztZUsAVgb+IjecnR1Foy2EEuS78w3iVfK5Sr6UBlExFQhYtpI8
	 O3D0PHyNhZpFsj+TDn9Ea6mKRR/NTIV7KspXMRPadByng4fsko6iUVU8+K8LLYIByg
	 7UIYHxKTDgTdIZC4nFwDTgAnX/SQrTQQEDztyvpn/GTLqGWLakEX0FoxwttTA/pIov
	 +6HPHfzqw2Frw==
Date: Tue, 17 Nov 2026 18:10:07 +0100
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
Message-ID: <20261117-rational-ohnehin-unbeugsam-e5c04759a156@brauner>
References: <20261028221705.3915340-1-halg@google.com>
 <CALCETrW9ygriu54gxiHFLEd5+hJminQo0r8Jwd63wR69Dj4W7w@mail.gmail.com>
 <20261106-befreien-addieren-eislauf-e09212803534@brauner>
 <CALCETrWa1SBLcb5oWjqjgzZvKvCoHjmYFk=Lf5ytEM9uqm5jYA@mail.gmail.com>
 <avM41a80aig2de-R@google.com>
 <20261111-behagen-faktisch-entgegen-e2e714373895@brauner>
 <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>
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
In-Reply-To: <CALCETrUjW=kXxyggDUvEN+Pxc-pE98eVbdW8XBU8JzfqXj_voA@mail.gmail.com>

On Mon, Nov 16, 2026 at 09:15:18AM -0800, Andy Lutomirski wrote:
> On Wed, Nov 11, 2026 at 7:20 AM Christian Brauner <brauner@kernel.org> wrote:
> > * a task that setns()es in later gets
> >   ns->cap_bset & (cred->cap_userns | cred->cap_permitted)
> 
> I'm not sure this is ideal.  If a task has cap_userns & CAP_NET_ADMIN,
> then there is no attack surface issue with allowing it to enter a
> namespace and be NET_ADMIN there even if the namespace itself has
> CAP_NET_ADMIN cleared from cap_bset.  But any exemption here would
> need to be a new API so that it isn't used by accident.
> 
> I'm mostly saying this because container managers might want to
> restrict cap_userns within their containers but still have it
> themselves for management.  But maybe there isn't any need to enter
> the userns for this purpose.

I don't think there is. A manager that holds the capabilities itself can
just do most things from the outside. I think it's nice that once you're
inside a namespace you're bound by its capabiltiy set. Otherwise the set
isn't a property of the namespace anymore. If someone comes up with a
real need to enter we can add an explicit opt-in later?

> > * Root in a container has caps as well so for containers the exemption
> >   would be wrong.
> >
> >   So here we need a a lockable SECURE_NO_USERNS_CAP_RAISE bit thingy.
> >   This turns off the exemption and prevents raising the mask.
> >
> >   Docker lowers the mask, sets and locks the bit, and
> >   unshare(CLONE_NEWUSER) in the container doesn't hand out CAP_NET_ADMIN
> >   anymore.
> 
> Can you clarify this part a bit?  I'm not seeing why Docker should be
> special.  Shouldn't the inside of a Docker container work as much like
> a normal non-container system as possible?  What's the use case?

I picked Docker because you brought it up, and your goal of allowing
user namespaces even in Docker is kinda the use case. Docker can only
drop the CLONE_NEWUSER block from its seccomp profile if nested user
namespaces can't get more caps than root/Docker wants to give them.

But the bit isn't at all Docker specific. Any privileged task that wants the
mask to apply to itself would benefit. With just the exemption this wouldn't be
possible:

(1) A runtime that holds full capabilities gives a 
    user namespace it creates all bits.
    It can just set the bit before creating it.

(2) In a container without a user namespace container root has host-level
    capabilities. Any user namespace it creates gets them through this
    exemption thing. So it can also add them back to its mask. And the mask is
    inherited. So every process it starts can then create user namespaces with
    them.

    by raising the bit we stop both. The locked bit keeps container root which
    also has CAP_SETPCAP from clearing it.

On the host none of that matters as the mask is root's own policy there.

> In any event, the ptrace access checks also need to be updated.  If
> we're adding cap_userns, then one should not be able to
> PTRACE_MODE_ATTACH a task with higher cap_userns.

Yeah, I mentioned that in my reply earlier.
