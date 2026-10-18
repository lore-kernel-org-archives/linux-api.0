Received: from scc-mailout-kit-02.scc.kit.edu (scc-mailout-kit-02.scc.kit.edu [129.13.231.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB331E1A3D;
	Sun, 18 Oct 2026 14:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.13.231.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792333173; cv=none; b=m8O/e6l5b9ZzSncVp4GOdYK5FlTSfwbLA0qUGvn3Wa25BS4t5s9OyWJQEXES40jEw1H9YGAIdPPQ/P2e8hnHgnK4KXH4ZQ0M9t755wz1kmNCwFX6tsIxEs4v4Dc41MAQRAxbsSE8jHJLfqnf2VLY4W1X1vy62P9lGAJhJW+uQzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792333173; c=relaxed/simple;
	bh=XS+7Ohg/JZrIPFioI9xORmtb/pxRJL0TyhsUKFvVfmc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ytchu5NXqFX/m92A3IdRwKrf3Xv0w9wB6OtJZ+mSaGAAN/tqylW2axtjLVe4GBBkGBI302tRK1N0QUk2PRxOjDcCvV93KCf15Qr6yKlJo9yxHRbSS+x5+W2NfmFuXOiNPXtDyq2t3JWzA0iln2DGeEVpnzR8gMpq9f9/l8CktCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usta.de; spf=pass smtp.mailfrom=usta.de; dkim=pass (2048-bit key) header.d=usta.de header.i=@usta.de header.b=gn+0oWKX; dkim=permerror (0-bit key) header.d=usta.de header.i=@usta.de header.b=jBxkvpUE; arc=none smtp.client-ip=129.13.231.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usta.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usta.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=usta.de header.i=@usta.de header.b="gn+0oWKX";
	dkim=permerror (0-bit key) header.d=usta.de header.i=@usta.de header.b="jBxkvpUE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=usta.de;
	s=kit2; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
	:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OV6UBuBD4T165hyrcQCpKCqje1pxW6lCCaRZ+/xF7ws=; b=gn+0oWKX777r191Pm6bwj9kRbP
	PAbZvly5WoMy+qCuRlV2P3lz/qakK/gJBXamLTgvRc4nXnHRWJ5rBUk74mclx6JfAJ2oo+0/nLSI6
	4VjkpVUBBSUzDNx8cXAlB4UnKAxJqoCoo0CJ5G5EWkuzv59uyAGyAdlBogic3686K7Pchcwb/wCqw
	+P4QtE11SEPu6YjFj/69YTcXf1uSXPTCsxALTzwO35VZyBrutU0KNtsTxqMTWHBY3C57KwWsDxkgD
	wTfN1kEbzeatfLIvt/BVQo4ahncKHOpi2gqYvijvUzkeJeUOggGczvvSb3h9ZM1SiMb0N9TfryIBN
	C2zB6UxA==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed; d=usta.de
	; s=kit2ed25519; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=OV6UBuBD4T165hyrcQCpKCqje1pxW6lCCaRZ+/xF7ws=; b=jBxkvpUE0v8N4eRv2odv5eZ5QV
	ieylrr18tGFuVGKNwrj+a359TX3FuIJOtsGMJopzwObbzDjTTvbc1CM78SDQ==;
Received: from hekate.asta.kit.edu ([2a00:1398:5:f401::77])
	by scc-mailout-kit-02.scc.kit.edu with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(envelope-from <schwarze@usta.de>)
	id 1xIRZX-00000003UG4-326X;
	Sun, 18 Oct 2026 16:09:13 +0200
Received: from imap-2.asta.kit.edu ([2a00:1398:5:f400::36])
	by hekate.asta.kit.edu with esmtp (Exim 4.98.2)
	(envelope-from <schwarze@usta.de>)
	id 1xIRZX-0000000GdCt-0pOA;
	Sun, 18 Oct 2026 16:09:11 +0200
Received: from isnote.usta.de ([84.177.232.110])
	by imap-2.asta.kit.edu with ESMTPSA
	id 6iTZOAbT1GoNpxMA4A1LTA
	(envelope-from <schwarze@usta.de>); Sun, 18 Oct 2026 16:09:10 +0200
Date: Sun, 18 Oct 2026 16:09:09 +0200
From: Ingo Schwarze <schwarze@usta.de>
To: Alejandro Colomar <alx@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	=?iso-8859-1?Q?Dani=EBl_H=F6rchner?= <dbjh@gmx.net>,
	linux-man@vger.kernel.org, victorm007@yahoo.com,
	t.piekarski@deloquencia.de, linux-api@vger.kernel.org,
	x86@kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <atTTBYFr1OvYNSjH@isnote.usta.de>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
 <87ecdqewg2.ffs@fw13>
 <atSsS8Pw9Pzixb7g@debian>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atSsS8Pw9Pzixb7g@debian>

Hello,

Alejandro Colomar wrote on Sun, Oct 18, 2026 at 01:25:17PM +0200:
> From: Thomas Gleixner <tglx@kernel.org>

>> So in pratice these syscalls and IOCTLs are ancient ballast and any
>> modern distro should not need them anymore.

Same in OpenBSD; by default, securelevel(7) and sysctl(2) block
access to them.  The most important place where they are still
occasionally used are some very old X11 video drivers that that do
not use kernel mode setting but instead use libpciaccess to access
PCI devices directly.  It appears they are also used by some
coreboot-utils programs, but we did not investigate what exactly
the purpose is there.  No other use case came up when i asked around
among developers.

> Thanks!  I'll keep the manual pages unchanged.

An improvement resulted in OpenBSD manual pages though:

  https://man.openbsd.org/?query=iopl&apropos=1        # two related pages
  https://marc.info/?l=openbsd-cvs&m=179214240879202   # commit message

In general, i believe it is valuable when people adhere to standards
and take care to write portable code.  However, this does not apply to
the present case of low-level hardware control where operations are
unavoidably highly system- and hardware-dependent.

Getting rid of these functions may or may not ultimately become a
goal in OpenBSD, but it appears developers working in the area
currently see no urgency.  There is very little risk because these
finctions have been disabled by default for quite some time now.

Yours,
  Ingo
