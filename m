Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795817103;
	b=xzBjIVGACUQoW/ZwABfdjUfaAQcd0C5GV4Mow4zaWQbmleIkrVOpn7ouVWq4D8Jc61zl
	 wxN5EjSLpU+7/1NDgKfahUMN6BElTVRLgD+wLL4Ic+jaYubQrCA7TeR5coJuTG1ER67Vj
	 1JxrQZxCMKj5sDpCif9INaf0DE/T0FAmi98LQtMiOZczoJINWay9NqIB47sUKsAVXHSJ2
	 s7HwBq0apP5JnJIWK/WnJUwCU8BEjZJSqcA3/Kaq8VbN/NS9n+/hjLgwOpmncNhYyGA5P
	 MjYa8JKKZzUnQEXk4jQQk6cdk/cO/hSMz1e6ceEpJStmGrWozXi/AqOgIlthwcU1dwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795817103;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VClEl58XM+4yXwL7AVYGyfY+c6D9g2rn19iL32LNkI8=;
	b=iURggHt5GL4a4kzkzgLCcjCap45l/N0alCAUwcadyfIIZJj4erMbHoOwN0YJ42fEpSE7
	 BLZIQh9Xy09s08Ttdsw3NWxPZDib+3BGSGJsDW77oPieM0b75pu9yyNV7USwlbFyfJYiN
	 mFMLt16TYIMemoIDSodRLnd+OJ+mwUoMEvyiX3/DyKs3CXW8nhb5/jUteNIwOfa0q3EqC
	 lcpFMzgxMJ2azccsuO9Iwi5XEcP8vutGbt/w6ohy4wmUIVqtFJZAFbjSzS8cmtgJqyUb3
	 7BBMNPIVUP+K+9F8/6iJDnrTUsCf7NAUajcB4pz26EypcyyYYbDTYauCpL833OSyK+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QS7KGb4n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 97A0A606A32E;
	Fri, 27 Nov 2026 22:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QS7KGb4n
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2BE351F0089A;
	Fri, 27 Nov 2026 22:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795817102;
	bh=VClEl58XM+4yXwL7AVYGyfY+c6D9g2rn19iL32LNkI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QS7KGb4n0K48enlxjXtEoZXYMfLNEzUZc0nrvMlq+RBQfB7wWnMWYI991nx2Zj9WT
	 yltCzx0jUvSe4dkir4KNtrEflQ4W4WHHqhxrPiYkrf7CxTZRt4r/Ouhb9dL6JqcVf4
	 giCouAfNICB2sxJaEcy39Msuzd4reWO9vF4IXzx0c2fbXapZaiNTS8yakNKj7qPUfX
	 HVbiAkMsSLoKilTFCAyBPeTxgs6uA1eeawTTfk4MObjkKz5sSt4Oze4QCvSWJIatzu
	 Z5QoZv3pUaa4PPiiiZr91ZSBRKkmKw0OTVw+hXdJVmzDNMUuR2WvCEG4eRjkvRwjYp
	 JKdgsN8Wm9ftg==
Date: Sat, 28 Nov 2026 00:04:58 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awn-ioAuksHNV-Rc@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
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
In-Reply-To: <20261127214103.542291-1-safinaskar@gmail.com>

On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> Jarkko Sakkinen <jarkko@kernel.org>:
> > I personally think that "getting in" should not be a goal in the first
> > place. I care more about that whaever gets in has a high bar of
> > quality enough. It can be something different than this but
> > when I read the LWN article about Cells I was alarmed enough
> > so that I had to do this and prove my point.
> 
> I think that Bacik's patchset has better chances than yours.
> I think so, because (as Bacik said) it was tested in Anthropic, and also
> because Brauner reacted positively:
> https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> 
> So I suggest reading Bacik's patchset and say what you don't like about it.
> You will have chance to influence Bacik's proposal before it will be merged.

I've read it through and the way I'm seeing it is that it is overdoing,
and has somewhat complicated life-cycle model tbh. I don't like it.

This could be of course wrong way to see things and I did this just
to demonstrate that similar goals can be achieved with a relatively
lightweight core. And this is also demonstrated with a Python daemon
emulating Cells style containers (and alos relatively trivial SystemD
wiring).

There's no reason to continue this for the time being as it
demonstrates already how I see the world i.e., "I showed the
code". It's up to whoever decides these what they do.

> 
> (Note: I am not kernel developer.)
> 
> -- 
> Askar Safin

Br, Jarkko
