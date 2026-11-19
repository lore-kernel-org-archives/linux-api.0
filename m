Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795110191;
	b=EClClKyb7yKspNyQ/fZaLiz+sP3wb11GOg4RP1+C6fvDXj3cNe4d+sYL4uqcx59Puc3X
	 EgiC4w25Nz8mWjOsc/C707AexEwVnioeKkBaogsZtHxaAM06VvHM7CJxR/Zbo6at+r1hm
	 t0g+3K/+0IiAqSwu3xVTJ8fYYv1880U2X6ex5zC4VCJ/txjmFCdREuH2elovQDCWWE+Ex
	 Nqq24/Md7IfA1EFbcafGDFAvJmHt+8BNVZ1VYz2hWnlwfojDAIv9nu2tcogdvqGJdO3x+
	 vp8MRCZvnWzBtUKxJuxwu0hEw09U0+jmXIyG4eR8yNzFGDLDBeVViy2FKMAO3QTxfOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795110191;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=rKTl60KWr0mLCOQNUgZPIfoXZLaIl31V2GUy6m5DwRU=;
	b=odrc+f6HWhL0zjGKBRES837A5RtnueUyhgmWMe1MGS69HNSNE2wxx4mdXSM1RbGHYzKa
	 lfp6DBF6J2DjyCBdZo9QMNU/KBm9pdl+yAv6ws6eyZ3/+5sI8dX4kxK0RwmivuHgCAagW
	 IdY0OlakKMt8IdJw2X0LVElP0ZapqMZXI9GOD6cR+hvupzn3toXHUtZsBLZ0oFslsdXr/
	 tfrakUVWd216ksEh1qIKbHDCWLDGNAWFICc3UMP//HSRsTWvth4kGhJvAcONELjx81eFU
	 W7EGzPq5kHA0rpU2bKygjWfTRxHXHohlCFsXZWDF7IQ7Wf/JlSJP5lcDoaHWwtbBS7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mfCBeh22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D580F606A325;
	Thu, 19 Nov 2026 17:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mfCBeh22
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EB54C1F000C5;
	Thu, 19 Nov 2026 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795110191;
	bh=rKTl60KWr0mLCOQNUgZPIfoXZLaIl31V2GUy6m5DwRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mfCBeh22AyZN2cDQZ0Z3bJFKmJBo+enYokZCrjW0LvIdaiFzf5Bi3bgp0L0pLjFWF
	 KWOEF+P2hF61/peFpR73vG8J+9uVqnaeOC2VVpvhjr0eAKH/uWuel7whOJ5owj8sU2
	 glpuvnfjRorUr2e2vDGVnSh9dXG+PdrIyBOOy6SKqZ2WHBOdCOz/GGQbHDMRH6sWbG
	 oswAu3w/7e/zP2JPnJ7b8OVVV4E8dzRljglTvQj3hIKUP3MfzhRaDJSaCVZEBklcD+
	 RAPIN/Xj87FF4H2rjUER26wi7sgLK+edQ71PUfcQ63F0iIdJ6eg9f0wtVKbk8BaM+R
	 GVSZhVPnmJLKg==
Date: Thu, 19 Nov 2026 19:43:07 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Serge Hallyn <sergeh@kernel.org>, Kees Cook <kees@kernel.org>,
	Paul Moore <paul@paul-moore.com>, linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
Message-ID: <av81Kz8I5mq3TaY4@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>

On Thu, Nov 19, 2026 at 05:30:55PM +0000, Josef Bacik wrote:
> On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski <luto@amacapital.net> wrote:
> > cells: The dance where I create an anonymous mountns, mount stuff into
> > it, and then attach it to the cell is cute.  But I think the userns
> > interaction is wrong: you are making me assemble all the mounts in
> > *my* userns and then clone the entire tree into a fresh, non-anonymous
> > mountns bound to the current userns.  And that clone operation is not
> > free and serves no actual practical purpose.
> 
> The copy buys us nothing, agreed.  That's just what the mount API gives
> me to work with today, it's not something cells wants.  If I could make
> an empty mount namespace and fill it by fd I'd use that, the "root" slot
> takes a mount namespace fd already.  Extending the API for that makes
> sense to me on its own.
> 
> The mount namespace staying with the builder's userns is on purpose
> though, that's what keeps the cell from mounting anything no matter what
> capabilities it was given.  The builder sets the tree up and hands it
> over, so the cell only ever has what it was given, and the mount code
> isn't something it can attack from the inside.
> 
> > cells: I find it *incredibly annoying* that one generally cannot put
> > new mounts into an existing container using most existing container
> > managers.  I hit this on a surprisingly regular basis.  You seem to be
> > baking this into the whole cells design.  Why?
> 
> By design.  Allowing changes to a running container is what causes the
> problems.  If you need another mount, tear it down and build it again.
> 
> > both of you: Can we please make it possible to do the parts of this
> > that oughtn't require privilege without privilege?
> 
> Agreed, we need to come up with a design for this.

To clear things up I'm not pushing "my stuff" over "your stuff", and
I get if that is the impression I might have given :-) Apologies for
that.

I think it is better to look where things balance. It can even lead
to something else than anyone considered (something better). I'm
all for right solution :-) Distruption is painful but useful

E.g., MOVE_MOUNT_T_MNTS is completely independent patch regardless
of patch set for what it is worth [1].

> 
> Thanks,
> 
> Josef


[1] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/commit/?h=rootns&id=cb058646b3dd76b13f5044846c119fe1d28db4bf

Br, Jarkko

