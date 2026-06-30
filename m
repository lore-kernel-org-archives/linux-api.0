Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC4940F8CF;
	Tue, 30 Jun 2026 13:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782825449; cv=none; b=ebXg2r1YAtzqbKSOMjv8nJ8mnBLYrSIhCCUXgg1xEz7R4s21IG5STLQfnTXyXo+XTCmAgTi+bQ2Cy7BYOb9KN/luA6l7F2BqafIdJiXLY8uuPnsulddY1mgw5iUU+jZ5t2n7r1S22Jhi55kxlFWyh0v8RLUYspk/D55Ix1PSbSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782825449; c=relaxed/simple;
	bh=iI76W3PIrDhqbWGp0y3KQ51pCAUrRp75kAhzuGY/tEU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OmSMfM2OvCZfr+qzfRZwTlqoCQoAGpCLuZtpWJ0INfYP3bq4U7y4G2jmmS860f/LfH9Yudb6f5rC1svxaAZ17MfIDiSBKkOwEMlHoftFSWOibuU7nmrZy5hYTvJMehLwxaiJ84EyM17HAnHM9pO6188gjdY18bs69GA3Fh9vxnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=WISo7c+k; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RzmWZ+Zs; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="WISo7c+k";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RzmWZ+Zs"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id B019FEC00B6;
	Tue, 30 Jun 2026 09:17:27 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Tue, 30 Jun 2026 09:17:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1782825447;
	 x=1782911847; bh=4LdR2VibH2njnBU1uMocI4RPYCENH1tmdqLS48/1hGo=; b=
	WISo7c+kpKV/nDh5yqQVPHu+c6g1rKFZM6Dae3bT2ElcSB32bHiHAi3sDJyNG2j5
	77ogskDL11g6tnQKg2CksDeaNZt0Bc9iRHF9JKbsM/Bra65ApmNTmgSWPNCgMkYI
	yMvyRQfOPT/8pUEcScN/jF1vH70x5ntGIeifFsoU0QdsLGHQFP7dfq0s/e8jXIAK
	Ty5HAF7AGOusNNLI2h89cTnfQsI3VBQEhLYV0zujPtxQ7nyoJXhl/LCIWdxsbmiP
	2chi6r8nAEc7eU7v487lw992yjmjfOmo8gTeArcMZQXj+x4PVPbpvmpaoc0Clyre
	OzRIaSeSqhRGdO7MEImG0w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782825447; x=
	1782911847; bh=4LdR2VibH2njnBU1uMocI4RPYCENH1tmdqLS48/1hGo=; b=R
	zmWZ+ZshVCb8nMtSffsknxV+SylqMf3qhC3YgzZF6QD9djKhoDQQesAdbdgENJ12
	doHte+3Of3YE2nwuDq/rz93rYg8KuDttuWi1NkGq4wYCagNjiQOg37GCmy861Swq
	cXQFNZMwzAhRjRe5jECnjqD07xFI2pNgIsfhMhBevux3kxi/nF9kM70RLyCZAwty
	T+cWzfNkkFYdVGifENXXTZ1PHKIivwIjjMmrQmAuTXWVOY3iNOEezwEmgXELFBaK
	sxkCmkgKULqYSedZ7/CzCkKmcnXUpDZLWXZbv/klqIhy60CnfhnMBl8M7/pHcAbR
	rTq2MqfnJJ5JFfZI67HIg==
X-ME-Sender: <xms:5sFDavS71utmq9yzuWzZsNDxBe71ZnZrxkkGEyBmFxbsxJ4cn7I10g>
    <xme:5sFDarkSyg9Li02US6EG-qUs51lbo0df0ElbnJafdL9a196f9RbDmnybEF_ebM5QI
    wBVdljj0l5T2xs6B8oG_lSX8Q1MgBudnD73Ad0IuUVxyya0uDrXIw>
X-ME-Proxy-Cause: dmFkZTF+NSnu+XaOspE2EihAi3NXS0A1r/m8N6lhdEMhD0xW2+drSOkZ9tBmgDcRwUzvdo
    fbt9CkRI6f0YJAVEYT0rbp/vQpJri2O9Sm8bYbXkc6i7B6SllqtSf5YBNdpvpzOMVdXPHo
    o7N5gCjwFrRUJXZ3ks3+akis0HfacElviYZrR1oqy5QCkPBJ4J1s44pu8+qfLZ1vz4dWkp
    zrp7A/wycXK65nL/2bNbmldrKAgL0uveO8Bj2e3Fjbc5bgFxzQ29X3dG6Ye/+jqlnpzPqc
    +SiDsZb9ec8Jq4g7MzCHMaoVbk3jxvjn3s80dBpd0ge/BOmK5cKZZ2RVuxIN2QABFXBfmG
    5kGcc8bX8B8F3Ckx66skCWUtb5d3A4quZ/B7La/HXlANAvu1G+JPQ1QN11mKKTOC1oR29z
    iJKln3+yTtbSsT/GJJ44BaLKFukCfdNW9YjOxuD4jMEIjG4VdKtC6lLKbOCw3M6hnEpVjM
    V+eQwt8ala5H2xQv9bfHqm1JOCdBsUcMto9OhOW9mrsZtjTpqDoF/1Ni+XcK4wdThLNSi4
    3Gk8MDuK3sI7umIyHFlZP1Yki2GFoSx5jnurMr/h4Hp7OLKjlS4EeMqREWoc3jSpXPWJJZ
    JXlWfmDjBH66SygB3F3PK3FtPAnhI4f56UvXC0MtkBTIUNbT2qQTSX+1Nf8g
X-ME-Proxy: <xmx:5sFDaqQcINTUh7B0nwmgxo9m0oJWuch2SY5GtFFIpxf_TLExRFAFNg>
    <xmx:5sFDaibJjF4RD04j7mFk3FUHKtqvddnNvah6NSdg8Jmb-DlaE5N_Og>
    <xmx:5sFDanV3y3vIyOk_QBnSyKd1xsVYg7wYLjV7lXf_iqMYiEuB1I9Eiw>
    <xmx:5sFDanXuVsgENA-PnojmDfkGI3iOqFr6uC5y4PlJV88_NqV8t1-LRQ>
    <xmx:58FDaoyuiRZyNi3pfjiAdFEgVVf5SFfYa7o-Jjr-fZmj6n6f8IqCoDxN>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id CD88C182007E; Tue, 30 Jun 2026 09:17:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: ALm-NtMBapr3
Date: Tue, 30 Jun 2026 15:16:45 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 "Andy Lutomirski" <luto@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Russell King" <linux@armlinux.org.uk>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Vincenzo Frascino" <vincenzo.frascino@arm.com>,
 "John Stultz" <jstultz@google.com>, "Stephen Boyd" <sboyd@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Andreas Larsson" <andreas@gaisler.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-api@vger.kernel.org, sparclinux@vger.kernel.org
Message-Id: <965a922e-e7f2-4399-8c63-a5f4bbd6b338@app.fastmail.com>
In-Reply-To: 
 <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
References: <20260630-vdso-compat_32bit_time-v2-0-520d194640dd@linutronix.de>
Subject: Re: [PATCH v2 0/9] vDSO: Respect COMPAT_32BIT_TIME
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026, at 09:38, Thomas Wei=C3=9Fschuh wrote:
> If CONFIG_COMPAT_32BIT_TIME is disabled then the vDSO should not
> provide any 32-bit time related functionality. This is the intended
> effect of the kconfig option and also the fallback system calls would
> also not be implemented.
>
> Currently the kconfig option does not affect the gettimeofday() syscal=
l,
> so also keep that in the vDSO.
>
> I also tried to introduce some helpers to avoid much of the ifdeffery,
> but due to the high variance in the architecture-specific glue code
> these would need to handle they ended up being worse than the current
> proposal.
>
> As a side-effect this will make the self-tests more reliable,
> as there is now always a matching syscall available for each vDSO func=
tion.
>
> clock_gettime_time64() was only introduced in v6.19, so libc implement=
ations

   ^ clock_getres_time64()

> Signed-off-by: Thomas Wei=C3=9Fschuh <thomas.weissschuh@linutronix.de>
> ---

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

once we have consensus on my patch 1/9 comment. Thanks for
continuing this work!

      Arnd
