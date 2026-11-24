Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527591;
	b=XCPi63v6Hkn0Um023rVTTiKtAcD/K+Loj7LEBcQhNm37AUzkgWHjy9inxr49iDYKoR8R
	 +MAdWpVmQVrlKVofpz6/6jVQtQoDR8LsYpZQMkvzVjuVnieHE/ehIjegSMQPKTp6Tzjbn
	 schOj82GZkIIya/oq1LXaqniFK6aMuVzisRcj7ClA6bW/bwoSMxDs1a7NAJc8bcXaahdd
	 jeizfgARtbOzP156gSZbawwgagMNDGES6oJy4XwoMLbvKStZoD6u9t9MhJEBHuiSecUme
	 MZiXGJ5M9E81+MT3mu0PNODjdAq+y5U0a2IJflRBgeMfYPOrHA+xqHWJ39EwIUd09hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527591;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=FFPocmiYjY4uBN7YtxnCPmj3gxT6Y3NraGib0JuLZOA=;
	b=C0U+o8S2IPDov1peDSFoLeUAHCsbUdiTkIR6VxI229qxxcgbtIpQEH0j7p6nTwtKQpXm
	 6AVJzhlHstuK8eQBSGKj4eAp3CDHrTJrWYaOaJ9VedNCaoC3leJwCBnzolObbxmdWBYI/
	 DesZCwcQgnKOSLaYhXlXFT66hD9L/CI8Ec5tal/57bYj35/7ClpIEd1mDy36uU9Bkvggo
	 TNMP3DDQduHSTT1A8TLJVESo++Fo9dyhjtAIw7v7yTk+jalNZQ7pSiBqECKf21G0Ab/SK
	 lN7i7VCRaDK4gkzqvua7YVXPi2/g/0iAH0FjNuTiy3V89TrAAmSIsvLZSblyAwY+i3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=jannau.net;
	spf=pass smtp.mailfrom=jannau.net;
	dkim=pass header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm2 header.b="3u8FKVI/";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="by/oM2OY";
	arc=none smtp.remote-ip=202.12.124.146
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4292A606A31E
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 13:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4292A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jannau.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jannau.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=jannau.net header.i=@jannau.net header.a=rsa-sha256 header.s=fm2 header.b=3u8FKVI/;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=by/oM2OY
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id A345D1D00596
	for <linux-api@vger.kernel.org>; Tue, 24 Nov 2026 08:39:49 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 24 Nov 2026 08:39:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jannau.net; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1795527586; x=1795613986; bh=FFPocmiYjY
	4uBN7YtxnCPmj3gxT6Y3NraGib0JuLZOA=; b=3u8FKVI/enGiX4SpeOpEBmpEvX
	aBv8TvMxxzF4btN9FAYKThFHiu7X7N0FZR+cqUl8jyMkts9nZbxT+1e2+oKcJASc
	C8Zwd8cganVwj2OSt7VKiqWX5gKKUfKk87Hd9Lcwe2yqlyAsFKcCgqAqI98UIqL2
	2Spk3c0nkJhVTCcOkact54bH/2t16sdZCE/+P1BxhiIbxI+LmX4XVLl2AkJbvtBJ
	14cN0o8Idi8wgkCDgMD7o1na/dnGVZpXvUad7F4Itow13I0vmPjomIrE9clQIHMl
	dmIOXDWcIbfrhRGEyj3+K3ffDpS5K63GwT+E5dJx6Pect6KfjMf7qNXq42/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1795527586; x=1795613986; bh=FFPocmiYjY4uBN7YtxnCPmj3gxT6Y3NraGi
	b0JuLZOA=; b=by/oM2OYQLK45eJq48XUNA1hX//hn3i5lbtoZY8KzPP9lcQxzgA
	e8W6F0880h/IxZNfg5BPLXhps1JS/5Ik8+GbsLQJMA8JFqU2fPTLuUzUfpMZEBy4
	1dlpnBLyTjK9g0AkM0WguaQiy9GGL8CMwVcT07NW0fc/Sqbme4Mh2ZO3f9Yt8Hd4
	MF+YmSZ9Jy67iJGfcuq/Dcs3Thv+vSnR8EjCnNbLsMIjkHd8je344Acu5IowkKxu
	Qgu7Qo63a5tnRjGS2VLfR+3nf7LlBL1+bmlJIsSt4Tqrf7VBiJr6xZ1ohCbjo1n0
	tHpQsVOQfjvjllYu5MQdVRmSL8169nN5fzQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=jannau.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795527586; d=jannau.net;
	mf=PGpAamFubmF1Lm5ldD4=;
	rt=PGxpbnV4LWFwaUB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:nxy08G6hV2hiNeiOAvV0xllY44WO3VIR/0VpZo5Dab/qe6m
	IEwIV8vkpAmf26CoVs+y5ehlwdEne7fVlpvKOgIueVYI1hUPh3paH1Q7PdldLL+D
	eTPaPrzrGJvcHOWFHlhDUkJi1CKiC42fJYu4jEoolMtPCwLLkNcR4982aKO+/lDI
	XW5/lRUMGoUHz34iZ4dEk/zgMQtameYs/uTqrgfblv/pjRqZif9UUmF/rkOF0ryN
	k72fYZxw8OFyENlFG3Gjy7QVwbaYmIBhJLZjNm50eAnFiUamFGrVbYtda5b81NMw
	BpuYLlpHtsVe0tYYWdicwRtvLsc3Ur8X4oETDNg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:+4ev4b6mxHnY25pdL20Nn41AxB3DfsjG2hFal/APdjM=:tuy7Q02L8EFGyAlb/RTajzDppwDejqGxKUsvjdBdGZs=;
X-ME-Sender: <xms:oZMFa67Ho0y6HXBSX3CJ2MosLcdKnQNDtwBPM34ltRrNfKhN7U5ToQ>
    <xme:oZMFa0Ug99pQyk5vvOOlsG6_V6eA4JzUhQirf0oGqfG0DfKnz9a34KSQdOkyh2A04
    3NXgCkjakrjmFwKBjYjdS-9PaPX6dxzIM9Bb-dXpS0k81ApSqU9Sog>
X-ME-Received: <xmr:oZMFa-7-kKzbsnjcJzV12ts_etvG3AxNbq7EAl-5vHGUs9sEsQf6RYrUjjz0xtfL1NbXtQlJvBMokCmJWRQIwrUqQHwkdpANxww>
X-ME-Proxy-Cause: dmFkZTESlBZ1BuWOe+JmUTVOFojllnFIlNcYBew5u3AEO/m5xTCbKEeFkRQF7OGVf/tX8T
    h/i9V7vfl+JMtQsvzqaD6jIwjRZ10u9k+PQYJC6AFKCtkCtwZuvqe5uDKGokPJylK4JKE7
    5nr4nOwn2m+UvTgT3l/15tMjM9IY8d4FwGd8NCK3NTpUv4186uhiAY3yrCk4autrjnKz9a
    qvREk+HSNuOK+UuyioWs8kYmt0XK8u5JbsuhHng1mHLFw78Nh6lrSdYQdign+ZCgIl+E+Q
    Ix3UENuWSWr9uY5l0yTToy1m0Gt30AKG9WklczbCNa59q6Tq6x8agtI+ZUvictJGlQYirB
    YLtmw3d2wtCb8oRlublfJ7zK/GEHEdwqHPSaOfeA0neCJaSquWzKyeTFIb6r7FcAU6etuh
    hNv1qIakJip8Xje33U6cLveSeSTufTRPV7cLpWSMKpB1apaUuxHFVFIRQs6ge0YKAXjHo/
    xxYbhJOBhYORFfvX8d6IX2cYHbb2ziSRg8dl2f5955xyUUPgH8jQnLfk3lzz9PutsvXC9v
    FGTFKYurFsyi7tEySux1IQpsn6xypNA4ZXS0JozfRqenLXQsUqcpxdAVQOoHJ7u6asIlqV
    xbVFz9L1Q2613VDJgHo5+dN9WbOD6oWExzCW2dCM218Ra0EHhTOrRyyILhYA
X-ME-Proxy: <xmx:oZMFa1G2ZjzOevGieoPIWUTRsyuZloqzmaMkNKT1EVyiymEZ1gt8eg>
    <xmx:oZMFax_f60edb8Y9k9tqrQdbmhOWIDFcbtRAdsTgiuVpHoxmO4sYew>
    <xmx:oZMFa3XhQDLyVB9KS1UzXyhgsNEcnVJa5rg0vg6OZtJBLmYEaf3Itg>
    <xmx:oZMFazECzWRr2ZG51ct7gAEukGErUWyrRpkr0Iwpzn8SIbbiYoZOMg>
    <xmx:opMFayrjv0nTLBIJkDe51obopTxGaE3jeJFYxqhPnmyhlZfod7IFXooO>
Feedback-ID: i47b949f6:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Nov 2026 08:39:45 -0500 (EST)
Date: Tue, 24 Nov 2026 14:39:43 +0100
From: Janne Grunau <j@jannau.net>
To: peder.bergan@gmail.com
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>,
	Asahi Lina <lina+kernel@asahilina.net>,
	Lyude Paul <lyude@redhat.com>, dri-devel@lists.freedesktop.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH] rust: drm: enable standard fdinfo for Rust drivers
Message-ID: <20261124133943.GA372978@robin.jannau.net>
References: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>
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
In-Reply-To: <20261119-fix-drm-rust-fdinfo-v1-1-c10f4134488d@gmail.com>

On Thu, Nov 19, 2026 at 10:48:47AM +0100, Peder Bergan via B4 Relay wrote:
> From: Peder Bergan <peder.bergan@gmail.com>
> 
> DRM monitoring tools use drm-driver and drm-client-id in procfs fdinfo
> to identify DRM clients. The common Rust DRM file operations leave
> show_fdinfo unset, so these entries are missing for those clients.
> 
> Set show_fdinfo to drm_show_fdinfo. The DRM core helper emits the
> standard client information and calls the separate driver statistics
> hook if the driver provides one.

None of the drivers (upstream and out of tree) set
drm_driver.show_fdinfo though as they can't yet so only drm-driver and
drm-client-id will be printed.

I guess this is ok and if a driver wants or needs opt-out of
`show_fdinfo` it can be made optional then. Note that most C drivers
don't set this either only the main GPU drivers and a few npu drivers.

Tested on Apple silicon system with the Asahi downstream driver.

Tested-by: Janne Grunau <j@jannau.net>
Reviewed-by: Janne Grunau <j@jannau.net>

> Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")

I don't think the Fixes: tag is justified. This is an optional callback
and the majority of C drivers (in numbers) don't set it. Even if it sets
it won't provide much useful information for any existing Rust driver.

thanks,
Janne
