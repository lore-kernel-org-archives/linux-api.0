Received: from scc-mailout-kit-01.scc.kit.edu (scc-mailout-kit-01.scc.kit.edu [141.52.71.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5191A38F9;
	Sun, 11 Oct 2026 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.52.71.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791746118; cv=none; b=EWCpZam87rVS8SfweuTMD1lFyRoDks9jwHvgoMM+qCajuzdR/UhQ814fZnvDoRE5K80wqktj8lp0mjAwVp99VxuSHbPRgIY10f+B+/ozEkIQCtJ3/YgIc00ChRRHAIu5qWJFvDgcpR+mFDx/iE/aOVei0loyvW2PR2ug6M662Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791746118; c=relaxed/simple;
	bh=8/dpvRPdKSDsBuzKo1atBVfHni/uYjKdFHodvdCrrDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KPAabADwYax/6iDmR7ssRL7TDkqud6duNDypB3hTjX8n8tVg1G7N+d3gRIn5EoTqxalKXMO7vgy0I4/XzBhjW7XTVMWRa87CgA0nBqmQtU9fEEuxTaxuCmmaH+ciPxEkbe4jeQc896or5J3iOk+EjKAqd0i2bFyy5TX7Uu3gbNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usta.de; spf=pass smtp.mailfrom=usta.de; dkim=pass (2048-bit key) header.d=usta.de header.i=@usta.de header.b=P+ZU0Ajv; dkim=permerror (0-bit key) header.d=usta.de header.i=@usta.de header.b=YzKUpmiK; arc=none smtp.client-ip=141.52.71.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=usta.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=usta.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=usta.de header.i=@usta.de header.b="P+ZU0Ajv";
	dkim=permerror (0-bit key) header.d=usta.de header.i=@usta.de header.b="YzKUpmiK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=usta.de;
	s=kit2; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
	:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4ccvYMCpuFpem6f6MMae2JJGUzS5UYlpQ+Yuv9RWAlo=; b=P+ZU0Ajv/jX6p+n9DuKnQ0w96i
	Upn+DUcK1VaOhG4iRG2ra0Ipub/JRkPA6rzJHKvrwnbhgzyLGwoYc4PJ5QyUha+T9TUGIshLflWmS
	T758sYKDL8qBvAMN2oqUh0/7YxXV0wiDPy7Yr0sZpx02+CtgbG/ZqlcYnGkFUcSlMMiqIcG7ptgw0
	kG8lqOqyi67WX6C66PENiQcgcX/m3Ei+cP/VifApEZXv0aNIwbf8ma2nSLFhV7SyFR0dJd6TS7tWl
	EeFinC4PNuZ25D4uq5tc7oG0ukxaxRjfe9m4tiZRRKIfZ26wT8CdQIrJbznGFZXRJecS+iiwn7xj+
	thgMZkvw==;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed; d=usta.de
	; s=kit2ed25519; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4ccvYMCpuFpem6f6MMae2JJGUzS5UYlpQ+Yuv9RWAlo=; b=YzKUpmiK6yo3+J9T6tLVZ0m5F+
	WRiPoiqmXz37diQ0VfGqZREBalcTmbda0gM5B2i7Oqafr2yGb1+zAG2vl9Bg==;
Received: from hekate.asta.kit.edu ([2a00:1398:5:f401::77])
	by scc-mailout-kit-01.scc.kit.edu with esmtps (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(envelope-from <schwarze@usta.de>)
	id 1xFyjG-00000006gG6-12JE;
	Sun, 11 Oct 2026 20:57:03 +0200
Received: from imap-2.asta.kit.edu ([2a00:1398:5:f400::36])
	by hekate.asta.kit.edu with esmtp (Exim 4.98.2)
	(envelope-from <schwarze@usta.de>)
	id 1xFyjF-0000000GAH8-3leY;
	Sun, 11 Oct 2026 20:57:01 +0200
Received: from isnote.usta.de ([84.177.232.110])
	by imap-2.asta.kit.edu with ESMTPSA
	id yrm2J/3by2rg3w4A4A1LTA
	(envelope-from <schwarze@usta.de>); Sun, 11 Oct 2026 20:57:01 +0200
Date: Sun, 11 Oct 2026 20:57:00 +0200
From: Ingo Schwarze <schwarze@usta.de>
To: Alejandro Colomar <alx@kernel.org>
Cc: =?iso-8859-1?Q?Dani=EBl_H=F6rchner?= <dbjh@gmx.net>,
	linux-man@vger.kernel.org, Thomas Gleixner <tglx@kernel.org>,
	victorm007@yahoo.com, t.piekarski@deloquencia.de,
	linux-api@vger.kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
Message-ID: <asvb_O-dY5z9xzJZ@isnote.usta.de>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian>
 <asvFcQvNlx6Oq9Gc@debian>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asvFcQvNlx6Oq9Gc@debian>

Hello,

i'm answering here because Alejandro is asking me directly.
However, please take my comments with a grain of salt because
this whole topic is far out of my comfort zone, and i have
never worked on low-level hardware support.

My naive impression is that all the mentioned functions are entirely
anachronistic.  If Daniel is correct that these functions are
intended to provide mechanisms "to allow user programs to directly
communicate with hardware through I/O ports" then i suspect that
goal as a whole is completely misguided and opposed to what the
point of having any operating system at all is in the first place:
controlling hardware access and making sure that userland *cannot*
directly manipulate hardware.

I searched the entire source code of the OpenBSD operating system,
both kernel and userland, and failed to find anything that uses
these functions.  In the Xenocara tree, which contains the X11
implementation used by OpenBSD, there is one reference in a highly
obscure driver, vmmouse(4) = VMware Mouse input driver, but
looking at /usr/X11R6/lib/modules/input/vmmouse_drv.so, i do not
see it actually used, so i suspect it is disabled by the configure
script.  There is another reference in xfree86/os-support/bsd/i386_video.c,
but it's only conditionally compiled, so it seems likely that is also
disabled.  Admittedly, searching very large codebases like this
is not trivial, so i might have overlooked something.

To summarize, i cannot say why OpenBSD retained i386_iopl(2)
and amd64_iopl(2).  It seems possible to me it was an accident,
and deleting it was merely forgotten.  Looking through the
entire commit history of these functions, my impression is
that since these functions were first provided in OpenBSD
almost exactly 31 years ago, exactly one persion ever changed
anything substantial with respect to them, and that single
change happened in 1998.  Such a low level of activity often
occurs when the functionality in question is obsolete and unused.

If you think that would be helpful, i could ask around inside the
OpenBSD developer community whether i386_iopl(2) and amd64_iopl(2)
should be deleted, or whether they still serve any purpose, and if
so, which purpose, and report back to you.

One thing is abundantly clear: in normal multi-user operation,
amd64_iopl(2) cannot be used on OpenBSD because OpenBSD runs
with securelevel(7) = 1 by default and because OpenBSD runs
with sysctl(8) machdep.allowaperture=0 by default, and i don't
recall ever needing allowaperture for anything for more than
a decade now.

Yours,
  Ingo

-- 
Ingo Schwarze             <schwarze@usta.de>
http://www.openbsd.org/   <schwarze@openbsd.org>
http://mandoc.bsd.lv/     <schwarze@mandoc.bsd.lv>
