Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786A93BF67A;
	Mon, 27 Jul 2026 03:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785123053; cv=none; b=J8J16IwDjDtq5xof35Fw9UQ8YUedlXfcXJdhPb+IjnWPc+gtiYvHAQm5gUtAkjoRwtfpOebtkEnaEjQuPpbTPGmGFd1TyqgkRbT+4vSWrbCYL19sC/jrG4faT05M617eFDG2/ouM0F2ryMDO+HmLdTo2exN0voXAPm7Uf4bnmvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785123053; c=relaxed/simple;
	bh=DnX/0KnqSGuL5j3Q3YSeF948GyXioPXyVgkxshJkInA=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=X/T3EcoebIZnH7xTQHqHd+WIa6U1Y2IaJzodSB8RBphZTgAdgwcdkUuWggCpdzJdp/Ip0kbMvicJcyf0ADz4Ye5workXq38xHAiURvF6gfULJjf8CBpIzcWSTqppoc4Poub13imBKIWWf5nZNknurw3KXIBvV3evYxaQReb3XTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me; spf=pass smtp.mailfrom=johnericson.me; dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b=P3iU7cxR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hvgN4sM1; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnericson.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b="P3iU7cxR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hvgN4sM1"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 865F01400262;
	Sun, 26 Jul 2026 23:30:50 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Sun, 26 Jul 2026 23:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785123050; x=1785209450; bh=DnX/0KnqSGuL5j3Q3YSeF948GyXioPXy
	VgkxshJkInA=; b=P3iU7cxRpnqV9+d9ZlT7g3AVcwlddrXc6HhT80YaadCZ43nj
	pADbapboRMpgTnzwuW/TMgPayfSzzqgUVcMNg27c124bYz42DdOLER7c3b+mV0OL
	zln64lUhIOxCw7CE7Kaubj1DhP2J3tUKP1E+U6kHQ9WXPIF5UmkujMy4U3WybAlq
	rCOBlMdy6YPaTruQ+ZnjhifM6B6LYfr/0jbgLSD8IHXvZtBmvT4hRGcYIsT+pusM
	tECco+rt+ouAIkZtEAy4B77nbphNHQcwFs5zYuudMPdRt8mq9v159zab5iZgwcTY
	dfCzP89T0casZ90XYWWSIpCetiH66LFWZGMDHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785123050; x=
	1785209450; bh=DnX/0KnqSGuL5j3Q3YSeF948GyXioPXyVgkxshJkInA=; b=h
	vgN4sM1sb7xCqReCEwSjF9ZnE1vD6gBc4LUYhs0D0AacETAwisUSUd3tjNL0kHwP
	m0Up7AulQrBIvavn38bAhTD+l571p2i5n3QR2+r3Varu5phzCNTRAsbh2puRkU4H
	oGkV8F1X51hN7vWqSUCn3GhIrAPKZZz037I+OxsXxp8VtJGiRYBQdNj/d7nunci1
	YPi+hM4y83RssNhdKiL2AJ+3inBs2dy2pB1jQ/QP9uIzvow9LcwEUv3a9KLYKnGf
	liwwBv02n4ErtmabDoybtxha4OKFjUf9Tryz7dNKCZDpEOKxO4zf6h5ZMlob1Qc+
	Giawan8x6GZgdZKjFCSag==
X-ME-Sender: <xms:6dBmamL5CrhvbuEfkW54NlpWcvYbSGjfwOkZyvBBm9NVScjVKQZAkg>
    <xme:6dBmao8OofbDRvXzm1aleA17sU_FlUDWW-tFxockD4oNqwTmfOt0zLuw-ZDf__FLI
    cduxXGwCTCdGzEI5NmALDpWanoo6i20fwlWjx3pU-4G6AXNOm_mIPg>
X-ME-Proxy-Cause: dmFkZTGlxY9+gBpG9X1uB+DzXycKtMx3zVwJLLJwrP34Cktasl8RMjl3xmDcMcQ2V8U+6e
    ygbsLcWiNriFGMOpKvMuTCxD0JL1FioMNpFWOarfZC+sp3wJqOL4vFqhymBzXK6MKO9/1J
    QZZhFwaGrAW/fEn4THhs/cHBFRjDJSFhlCPcPfQkaoIJSiuHzi9P68qI/JZXdasegXCILH
    otHgSYEIIR3SMDozBP5fA2ugzPwxPCYCPF6KvwYD7inYlXDSuCPV12GVuP6340XFvFOzwL
    ETlUqoIkgJtvpzYWnmLSfHIOC6wCN8OCG0I5q4nLkONoLzCCF3hFUW4g2TE43a6gFd4InU
    4LVAZYOSSKGUjD9H4OD+ynva7HAeZuaZL6ZVP6qsH2WlI4Dau4Nwiw+l6Y7pkp7V5Fs6uJ
    S/+jknIw075+Ql26MpV8dRXiWVWHTeH1fBUnB1DgGpcv9IxDbRFgbK/N4nkXMRH7UKAK8i
    8PUXnzYX3iJwjWx24E5MyttqyIW8PkVPSP5vj9SjCgCqLn2NL6VIoGZeq83lqsWkf42owz
    jxbUvTs6LGBRIf/21MxMFKeqiCDc4JB17Y2OjCrx6dR3oZCkHi696i10tHtASkmr3OXq86
    94JHZBEO5yyD5W3eqk9X3I+OzsUTfcGaDisDA1H8QbcXmOUdNZm5yCmIumXw
X-ME-Proxy: <xmx:6dBmaqYBajzRc-837XD4GpzoS2q_Cs3ucth9iRmOYXDSFedgE1H1lw>
    <xmx:6dBmapxXhrDjvzZnoAwEGE6gjHRhPrZfcX3LEpyekvcJ8Jhna-YYWg>
    <xmx:6dBmapYGdSooVy8-fxisx2B9DniMHoepgED8O3WLcgSJZPEQDsNMfg>
    <xmx:6dBmaqymO-XMsWlj9e-YuRU_XKRt51pbNBG45mtWHJoHPxio6-jFbw>
    <xmx:6tBmaoWaE-bDDNklke_NYy_4OXvTVJfKLhj5AOVgjzJv5UESSnxSP6LJ>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C76942CC0083; Sun, 26 Jul 2026 23:30:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 26 Jul 2026 23:30:29 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Andy Lutomirski" <luto@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 "Jann Horn" <jannh@google.com>, linux-api <linux-api@vger.kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Kees Cook" <kees@kernel.org>,
 "Farid Zakaria" <farid.m.zakaria@gmail.com>,
 "Al Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 LKML <linux-kernel@vger.kernel.org>, "Jonathan Corbet" <corbet@lwn.net>,
 linux-doc <linux-doc@vger.kernel.org>
Message-Id: <09b4735f-c04e-40f3-a7f5-254b7918fbfd@app.fastmail.com>
In-Reply-To: 
 <CALCETrW-ObgCm=Vhm6AiyyS25q+SyXkCvVWB7JEaawmOMCrrpA@mail.gmail.com>
References: <20260723-work-failfs-v1-0-3f69b9a9e958@kernel.org>
 <20260723-work-failfs-v1-4-3f69b9a9e958@kernel.org>
 <CALCETrVDX-PcSJoHFwymh7d=oUKotJQQuh+AzmsA7YQySBzD3w@mail.gmail.com>
 <20260723-mahlt-abhob-semantik-21254c8d36cb@brauner>
 <CALCETrVezim-eYOFWon1w7FngTgWb2nkuZb_duf9q=TrNqiqkQ@mail.gmail.com>
 <20260723-wutausbruch-aufraffen-gipfel-73767d4aa71f@brauner>
 <CALCETrW-ObgCm=Vhm6AiyyS25q+SyXkCvVWB7JEaawmOMCrrpA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/7] fs: support FD_FAILFS_ROOT in fchroot()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Very happy to see this patch series appear; thanks Christian!

Also happy with where this specific thread is going. I will just add
that an additional flag in fs_struct to force RESOLVE_BENEATH in *all* path
lookup would also be nice. The combination of:

root = pwd = failfs;
chroot_locked = false;
always_resolve_beneath = true;

goes along way to getting Capsicum's "capability mode". Then we just
need to figure out things like more capabilities for directory file
descriptors per Andy's brainstorming thread thread (which I ought to get
to replying to).

John
