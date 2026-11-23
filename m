Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795396648;
	b=lwMFAWY4Sth6+Te52M7XEozZaLO60hAPaExl/Zuin7YOQ3M9/NQde7U3ZnEZ/Ko1gzUH
	 i3Vgj124yCUIO41BecVB3AAt7OGsAmZUyboFQah/4Eew50qsGBiN2LFM2XZRfWR7oR8Se
	 KWrHhtST46TBY99c51r5zIKIP7ll0XsFKs/jiJGyFOl7Kclf3EzyYs9MYvPJd3dmV7kAt
	 4uTVjHINqZsoZn+IdSR1FWAwKCkTQSYC4SIdDEi6LUAbs8smL8IvN7Tifs7HAngzadRCP
	 rqsO+amKYFuvemVKyD/xKNIMGBDjJ4Zsyi6SdysUt/YzxlQwuCfdBOaOvdC0oeOz/9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795396648;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0aOCQuegkDUwskKeZ1j/NRStwGaSRAPMc97ZLi2jvTo=;
	b=t1PlF5JNadRi3FQbyKzCijaUJIj6Um/BPLdNRNl1OCmVoB1hS87Ie8hMgTyQSWUjctJx
	 uHS3YfMVkM4YUDuT6xcIhPmuKQtIzGL9qM/bHaoZUxGcQQhTnOFUI3XqwyUtyOTixYzO4
	 6lRMkswUdISJBSE2nowPZXp4+L1CqjUOPofCU5bTSBTf+8ic7fascEJm3T37TYS9Tooqz
	 x+B/EDLxOjcQbwsry4h4sA6n4eftKBUsXlJSXXgnmvyx6RBh89EZn63VO5L2IbB93n/ay
	 9GaRimYkJ5hvHGfwD+ewjw5jSioHXwjV7yhIr0XL+TPdTySp2zFx6gw9q8A4FZgPvMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oU88Ot+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7C5BF606A31A;
	Mon, 23 Nov 2026 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oU88Ot+D
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 51A941F000C0;
	Mon, 23 Nov 2026 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396648;
	bh=0aOCQuegkDUwskKeZ1j/NRStwGaSRAPMc97ZLi2jvTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oU88Ot+DNQP+6mgTLa+2Y0T8my6gPsAHGZ88SJHShFaf8cOQRDR/RsBGJuK8xoFLK
	 ie9hfueXtMCampSV8SKLb3OF0QNXZC677qfYNG23pJ5iHahuOwYmCYQaDeoNgy4F/v
	 WrSodOYpWarCv74fRWHad1uMwFGvOjPMCZF6v7Wi0+rA5eMcDfTGMme0DFDaIYr4Bj
	 BV8BCmSY+LkBq+1fjI9o6dPp9AmTJdXStFcDzKkDk5gAEWZ2CVD8G/BBRGYx8zrMSG
	 V37z3MaBHsr34qCd4KVhM7YMEkrvDZO2nf/YcaxeI9eniMitk/+WJmG2GXL3uA5PBi
	 C9nhE3GDUd0ug==
Date: Mon, 23 Nov 2026 03:17:24 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOUJCbB_j0BuHvo@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
 <awOQDOel_72Xwjm7@kernel.org>
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
In-Reply-To: <awOQDOel_72Xwjm7@kernel.org>

On Mon, Nov 23, 2026 at 03:00:00AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 12:21:16AM +0000, Alexei Starovoitov wrote:
> > On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/
> > 
> > v7 was sent 18 hours after v6. v6 got replies from the bots only.
> > v1 was +2559 lines. v7 is +5782.
> > All six findings of sashiko on v6 are still in v7.
> > None of the seven versions got a reply from the vfs or LSM maintainers.
> 
> Apologies, I started testing this with bare metal as a result of
> hotplug, and things just started to roll out as I got a better touch on
> its use as a result.  The growth is by majority in kselftest. The
> feature has not really grown but API has shrunk along the way. Still,
> demonstrating that full detachment from syscall API is important,
> because it sets a bar for any approach trying to do this.
> 
> I had no idea that e.g., that  quality would be even possible but
> one thing led to another this went a bit out of hands.
> 
> I also wanted this to as good form as possible before going on
> holiday, which I'll be starting tomorrow but this was not a
> motivative reason.
> 
> So yeah, again, apologies.
> 
> > 
> > The way you're spamming people you're only reducing chances of anything going in.
> 
> I personally think that "getting in" should not be a goal in the first
> place. I care more about that whaever gets in has a high bar of
> quality enough. It can be something different than this but
> when I read the LWN article about Cells I was alarmed enough
> so that I had to do this and prove my point.

For completeness: I'll consider this final RFC.

Br, Jarkko
