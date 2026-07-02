Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AE43191CE;
	Thu,  2 Jul 2026 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007035; cv=none; b=CRGb6pxdMxWgHssbNGleRWfIw/5+ZbDA3yl1M1cgZO6QPx41ISQVOkt/EOBgZ39ewVBb3OIY2RPIxulEHD/USk01sjkfGkKjde37s1oGZwxELMIGm8K+LC2ZzDia7WXs+NUQXoPb4WT5TsusPS6CRdS9dBpNja5BdOX9u39dkQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007035; c=relaxed/simple;
	bh=vf9XSdkCvFVNbsoR1vcY9ePWywXI5GETA9KGjDxzwiY=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=J0ummyyfWWoxKLID4SGs07oHdUQLtRaAl5oq2WhJwN47FG2otdugmHPWbaUZUG3ijEPKmxDCLBazgffQV77AOqYPuIr7pQ2fTE6PohG/79WAPWjpSN9a6SZe/0tZd1fKoeGx8ONTzy5uSQTwqvybHEXH9hRI71G2McrQliFEB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me; spf=pass smtp.mailfrom=johnericson.me; dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b=wPiWIf7i; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PK70Z+VM; arc=none smtp.client-ip=202.12.124.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnericson.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b="wPiWIf7i";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PK70Z+VM"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.stl.internal (Postfix) with ESMTP id 222731300436;
	Thu,  2 Jul 2026 11:43:53 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Thu, 02 Jul 2026 11:43:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1783007032; x=1783014232; bh=vf9XSdkCvFVNbsoR1vcY9ePWywXI5GET
	A9KGjDxzwiY=; b=wPiWIf7iWy32YLJJ0SMGd1NcHSYqScVIM3M7FpHP8AXgk4g7
	Y7i3X/KOZkuNAUqQ+y3cdD+UjdGk2QXfFwWaLUZmgmw8LEii8rDeuYKdDBHXz2LA
	3KsnRLL4yDkarzv5R87JCrikNYvgeMrOwAcxYEiGGihPIoZrIewMC89TruqSbNZR
	O48Cm0gC7ZEuKEgBi0XIjbc4mZmEGaYft6zUHn4PtlkbSghDjcw6gdcjDdLVeK0T
	Fu2thCuuX7tid1qgyLz2LNbNM3eCHR3ycyCBGK7XwjipzJBYH+1UKeOZy3a0cT3l
	VOC+PGhPVBiLY+mkhuLVfAKgozera91Ua6z4GA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783007032; x=
	1783014232; bh=vf9XSdkCvFVNbsoR1vcY9ePWywXI5GETA9KGjDxzwiY=; b=P
	K70Z+VMbMfq+5ZKQNqUpYAOuUQfjP68coj6vUY9T6sckYR/HCRZhcEEqVNjBpDnr
	A1PNn5KW8Sd44fxzC1E2EoUXgZ8hEduXecCuqoCFn9ADyjEU9heuclcZ1/0l5Fx6
	4U7FWpitVNBg8XD1YkSA7/bE8pVSUR+eHlQ1guvRFysOTh7M0piqZiAPg9SGzos2
	Z+u2VDsihTHs965Jl9oLVAL4u5bh+q1p/2hVUSMwVIS92/e2YEOwjvFTDV/PCCbM
	NSeuxsP/6QzjJo3uK+IEDCrnoopkXuQ/VEWV94lxtqE+mUZsuUfLp5qCTq/BrARg
	xFLhph53xQ5zPK5B/JJTg==
X-ME-Sender: <xms:OIdGasFIfFAiBrIhi8ce5Kwx18rxTFFEvEo3pPv8ajOwE1Y220Bxmg>
    <xme:OIdGagI0wzl2dkZWudPjNS6w2ARQiDJNdsoSaWK1KyL6DG-LvPc0aXIftuEjxhW3R
    tIIBjJvpTZTR9ixMD-BT1iDAAyL9L6MQfgJ4qM-QjQ5LX8tJ6ixWsVl>
X-ME-Proxy-Cause: dmFkZTF1QqVkYWXEVVgDZimDsMhAsUZjAfnUjHrZwcnS/C2Z757MjYdRqxqUruGGfXLYdW
    EsoNXCOq8oCONH5vd0WLSrPRGh9XFE8tHmJ1gIKI3LuR0La/9A8vB/90k9UUGtpCROmeqr
    xHmVjgn0C2+RD+VkPMucZPlynxVuKdbUDWjDu4wK0IRjKix6gagkr3wmFWR3LNLEV9Rcrl
    d9NT3Ro+fl2aGLLooU775EXkXRypUrCfdW5tcQQow3+UGwF9AH4FP5pAbsZyHku8tid93+
    X6dlYUPXj0i4Xyp1/NMOVWNiCdOMerJRKfs7lrvxsYCHxoTkteaLKD0Urj1867+0bKMvZz
    S/ii+FXiFN7nD8u4I3FvgYqJiCiA7WCi8pPvn1QXN1rLkkWzeOlBlyVwN16RHwLHkUzFIH
    oMWpl5sMBsJ9nt7ScHh5ydDbtkh6qZO1DbQAX8PysYJVmGU/aIUvIPcfoSTRoo8eptZjQ0
    01x7Ah/VTUS9FmOXJbdiIlK8sdBwon4KSGeXiS8TI3Ta/Q8eAz17Xmkc36EvAtPrwhyuPB
    BUpkC6FPwbNRUovXDE3tGLXxD3giOz/US6YfpnE2jSqlUU22ly0+i6Y/Ymv/cUdQDG2uH3
    kgJsHTxCF0+tOnroapZT+O4AnJsT0KVXmYIY24hYnlnUAADbZK2FXvgaoZ0Q
X-ME-Proxy: <xmx:OIdGakVnKWaSJABfEYQHKXqQa3tynug9Da6dnI3Hv9HGSm99vrbDNg>
    <xmx:OIdGalxNPdKZLG_iXrmDRY-OAgX92Bc5M5ZhW82Xlv83I4MX3bK52w>
    <xmx:OIdGas4QIqiXvdTjtz6tFoS2jpfWXqo5z0CotTmmRIv9YJ_kJVGQXg>
    <xmx:OIdGavhCS2ne6jKctt3pB-EWRMd6JBpw6iwI-8mFVNVl6Bix8WNyXQ>
    <xmx:OIdGao9rnT-IushQv9sjuHB3_QfZcYHKn5pcNMezfWfAZJ1Z06q8Evw2>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 117E12CC0083; Thu,  2 Jul 2026 11:43:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AG8qDlxFSDr7
Date: Thu, 02 Jul 2026 11:43:31 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Christian Brauner" <brauner@kernel.org>,
 "Andy Lutomirski" <luto@kernel.org>
Cc: "Li Chen" <me@linux.beauty>, "Cong Wang" <cwang@multikernel.io>,
 linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Al Viro" <viro@zeniv.linux.org.uk>, "Kees Cook" <kees@kernel.org>,
 "Sergei Zimmerman" <sergei@zimmerman.foo>,
 "Farid Zakaria" <farid.m.zakaria@gmail.com>
Message-Id: <5abd7c81-3c6b-45d1-aaab-195493c1cdc9@app.fastmail.com>
In-Reply-To: 
 <20260702-entladen-farbkombinationen-klarheit-fe24cb608f23@brauner>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260629-hauer-erhitzen-sobald-96d3dff68707@brauner>
 <CALCETrVuh0-biOw=TgYN9ERTFAoiki57XeZ3S2T3dO2+hL54gA@mail.gmail.com>
 <20260702-entladen-farbkombinationen-klarheit-fe24cb608f23@brauner>
Subject: Re: [RFC] Null Namespaces
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, Jul 2, 2026, at 4:34 AM, Christian Brauner wrote:
> I think we could make that work with both FD_NULLFS_ROOT and
> FD_FAILFS_ROOT...

Fantastic!!

What comes next? Do you want to submit the patches for this, Christian,
or do you want one of us to? (Just trying to be helpful.)

John
