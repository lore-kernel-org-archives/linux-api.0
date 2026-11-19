Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795110716;
	b=hbf+HfHvm5q7yFBw+/hn16PovdsQ3Q4Slm/CSZsZXCoO4I5HGrFj5NHc1KJOaFe3M5KI
	 WO/hI1YDQlLE1e7zwQfzYSz0kRWIWm97pr4ezr9VROLSnk/2xfcMHs7kaYHH1qx8drmzS
	 xlSihMpu86ol9e9p23RX8VV/0Fl1aTPZGG/yZV8oGpj+VFnxcro/Dve+TNUz+sSJue252
	 VGB8BQtE7P9UUVCcjWLVX67y5PWj4nxn7BxdqbOql2Ubp6r7Idhn8JDTSDiYtH2z4ZDEI
	 fPhPe/WDPjro4aZKr4Ww/5jWiIBKUlSRqrg5lJj6FzhRJIEdAJkRF3LqnRK37A9+Krg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795110716;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+gNl9zSZClKVdpkaHWachxujrl0GYW/4jdpRJHBtw2I=;
	b=rUUv3XTeJrVuTAjgFitoHTtRqaJ3F6+BuVbyoUUoynxX2glJ39eHfmSULDr74ldo0Syo
	 yd0kIY4Td7yBPrI68JJg5bnE+TyAifgdu8L9dj0XrW6Ri3udgBBZq8fsD+v4FAIsdHV3H
	 X89GTdguxO1g/xHzdF7aVeuVfbK0eA0EKtkni2O3r2Oj7SzXar4H/RvbjEDZuQzYCAHP+
	 6x/dkP7eo0VWm7oIL+MvglRy6Pv+wiEm1fP7mHnRuteSPw5c0ysbxsLpY5FP8cztfD3s8
	 Ew5FfGR1t7ndCejp0iWwlsjQjfcdlwrIdb5CqzLDb3oguzfmC1qGVF5GpFo4CbqLeUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aiqyiiz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C32AE606A335;
	Thu, 19 Nov 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aiqyiiz6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9C0D1F0282A;
	Thu, 19 Nov 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795110716;
	bh=+gNl9zSZClKVdpkaHWachxujrl0GYW/4jdpRJHBtw2I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aiqyiiz6bl8XYtDgoUqfWd2e3ncbmubamZrPonR3TanM5FN8nXs1TLGUZGhlkVuuT
	 Z/Ue4EeQ3x4yQzeJeyfG85WqvRWtqsNH4lYEdpAu3A+C2bZk9YHB5QkrPGQWkvmgjv
	 hCfvjDcsGNDPETyHcrbPP8OG7SumINSK57wvUw5uBMfxWJRn4VYu9c1RffQdGSwWDa
	 oshe3N4O6E/JQBgtV4ap/wmiPbF73n6b2qownpkX1nZJB0UFgpRI2XfhtWXgvJfVWY
	 K2mhqgFnAygHmzLqyWV0tcVwpTtlWVMqT0DEOC9YY7Ho5PlUDa9yJqXTsF7LsR34UI
	 UZLMuf9e92xQg==
Date: Thu, 19 Nov 2026 19:51:52 +0200
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
Message-ID: <av83OLX1_mhgh-Dc@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
 <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
 <av3akYFOYaeQZauZ@kernel.org>
 <av3bkDnwmjunTleX@kernel.org>
 <CALCETrXPLeUgxyhjP4XuWS46FKB0TUHF5PcMkdMf+qeEXbyXRA@mail.gmail.com>
 <9463a969d35a7d5ec5a56aeb67644b94.josef@toxicpanda.com>
 <av81Kz8I5mq3TaY4@kernel.org>
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
In-Reply-To: <av81Kz8I5mq3TaY4@kernel.org>

On Thu, Nov 19, 2026 at 07:43:11PM +0200, Jarkko Sakkinen wrote:
> On Thu, Nov 19, 2026 at 05:30:55PM +0000, Josef Bacik wrote:
> > On Wed, Nov 18, 2026 at 9:46 AM Andy Lutomirski <luto@amacapital.net> wrote:
> > > cells: The dance where I create an anonymous mountns, mount stuff into
> > > it, and then attach it to the cell is cute.  But I think the userns
> > > interaction is wrong: you are making me assemble all the mounts in
> > > *my* userns and then clone the entire tree into a fresh, non-anonymous
> > > mountns bound to the current userns.  And that clone operation is not
> > > free and serves no actual practical purpose.
> > 
> > The copy buys us nothing, agreed.  That's just what the mount API gives
> > me to work with today, it's not something cells wants.  If I could make
> > an empty mount namespace and fill it by fd I'd use that, the "root" slot
> > takes a mount namespace fd already.  Extending the API for that makes
> > sense to me on its own.
> > 
> > The mount namespace staying with the builder's userns is on purpose
> > though, that's what keeps the cell from mounting anything no matter what
> > capabilities it was given.  The builder sets the tree up and hands it
> > over, so the cell only ever has what it was given, and the mount code
> > isn't something it can attack from the inside.
> > 
> > > cells: I find it *incredibly annoying* that one generally cannot put
> > > new mounts into an existing container using most existing container
> > > managers.  I hit this on a surprisingly regular basis.  You seem to be
> > > baking this into the whole cells design.  Why?
> > 
> > By design.  Allowing changes to a running container is what causes the
> > problems.  If you need another mount, tear it down and build it again.
> > 
> > > both of you: Can we please make it possible to do the parts of this
> > > that oughtn't require privilege without privilege?
> > 
> > Agreed, we need to come up with a design for this.
> 
> To clear things up I'm not pushing "my stuff" over "your stuff", and
> I get if that is the impression I might have given :-) Apologies for
> that.
> 
> I think it is better to look where things balance. It can even lead
> to something else than anyone considered (something better). I'm
> all for right solution :-) Distruption is painful but useful
> 
> E.g., MOVE_MOUNT_T_MNTS is completely independent patch regardless
> of patch set for what it is worth [1].

E.g., if it'd turned out that some parts of this work is useful and
derivable to Cells, I'm good.

Just want to make clear where I stand on this topic. I know how
opionated area of kernel namespaces are, so it was not exactly an
eager action from my side.

Br, Jarkko

Br, Jarkko
