Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07845221C2;
	Thu, 15 Oct 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792083276; cv=none; b=Ua0R7X+Nt8EnzI/VDVc0695MfGWoKWILVvSqI0lJ6xO4tECF0Wr3OJS4A7y1H0n4uZtIXRZWO8Oet+QtcVWFBSgHqjsAfu6xAu98fCzX2p4cfQbBF39aeZK3EPmmbVB5Lp6V0Y0XgCW7VH5aahpBfSivlzCsXPBysbgscb7feRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792083276; c=relaxed/simple;
	bh=ZBzVsGDuL3mQoCfk9ExKSNOkkj0UIJ+NHJSkM6ZMMV8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UXTouclzArcZeG1eCCsvb+lGlEBOwn0rtukCG0oOWGf7OdVsFbRojTnaABcWSn2Oit8q+5ywE739OksVyJdtrF3G2jJ5DXl6FodURkcJw8rJhvRQpfdO4172+FHeE2y6I9mjzZbI3KrxnmhOhzpTZUeW0RhYVJwSDhyscwasrFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5dIKf9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5dIKf9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CD31F000C4;
	Thu, 15 Oct 2026 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792083264;
	bh=mpTV07E8j0GAxgYDxVjNqR5fZDQwtHygSNPwavCMd4o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=U5dIKf9aNOoqY4XMCBbrLJrsWESrplp2HdSaNXG4rLy5tHjoTUZnJaxrS7XMNnWd7
	 oYfGXEe0+EMiKqsi/Prg8pLfxjpq/PlzLIUifoQSGmEt9/lOW7uUT+j8xFuBovEUbd
	 6KNX8N579Xoggeq9du8iFcFVCExWsRwzBsDwNtT+D77NuJeBj1Pfp4wLNoLD9KgE01
	 LOE+Vwq3lnW56jyHUUhilU8BqetvuDemdhP6c2UjhKS/PT2yrMTNdh332yaQyW5xO9
	 U4jPwY/KIESZOI6HOzVEpH4idJPHZquYhO+gDi6l/bg1nsd2OhYy/VDpn5IdvANPUj
	 LKhu99lAM8yew==
From: Thomas Gleixner <tglx@kernel.org>
To: Alejandro Colomar <alx@kernel.org>, =?utf-8?Q?Dani=C3=ABl_H=C3=B6rchne?=
 =?utf-8?Q?r?= <dbjh@gmx.net>,
 linux-man@vger.kernel.org, Ingo Schwarze <schwarze@openbsd.org>
Cc: victorm007@yahoo.com, t.piekarski@deloquencia.de,
 linux-api@vger.kernel.org, x86@kernel.org
Subject: Re: Suggestions for an improvement to the man page "iopl - change
 I/O privilege level".
In-Reply-To: <asvFcQvNlx6Oq9Gc@debian>
References: <trinity-4d271f4c-4816-435f-b8c9-53eef0ff29c7-1786468770978@trinity-msg-rest-gmx-gmx-live-d7f776569-bpnnk>
 <asvEtnxChV2-dELG@debian> <asvFcQvNlx6Oq9Gc@debian>
Date: Thu, 15 Oct 2026 18:54:21 +0200
Message-ID: <87ecdqewg2.ffs@fw13>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Sun, Oct 11 2026 at 19:26, Alejandro Colomar wrote:
>> > However, as far as I can tell, all mentioned BSDs have dropped
>> > that functionality, but NetBSD and OpenBSD retained their version
>> > of iopl(): i386_iopl(), x86_64_iopl() (NetBSD/x86_64) and
>> > amd64_iopl() (OpenBSD/x86_64). FreeBSD and DragonFly BSD set the
>> > IOPL of the relevant process to 3 in the kernel, when the process
>> > successfully opens /dev/io.
>> > In other words, the BSD projects all preferred to drop their
>> > versions of ioperm() in favor of continuing to provide user
>> > programs a way to change the IOPL. It is interesting and perhaps
>> > noteworthy that the Linux project appears to head in the opposite
>> > direction.
>
> Ingo, Thomas, do you have any comments from the OpenBSD and Linux sides?

The 'iopl() is slower' comment is just voodoo as it really does not
matter whether a syscall at setup time takes a bit longer or not. But
30+ years ago syscall performance bragging was part of the game :)

Though the difference between iopl() and ioperm() is not only that
ioperm() provides a more granular control than iopl() over the I/O ports
which can be accessed.

Up to Linux 5.4 iopl() was implemented using the IOPL bits in
EFLAGS. Setting them to '3' allows user space to access not only all I/O
ports via IN/INS/OUT/OUTS, but also allows user space to use CLI/STI.

ioperm() was there first (as of Linux 0.96). It allows not only to have
more granular control over the accessible IO ports but also avoids the
CLI/STI enablement.

iopl() followed in 0.97 and was deprecated after we changed the iopl()
implementation in 5.5 to utilize the IOPERM bitmap, which effectively
prevents the usage of CLI/STI in user space. Ancient X-Servers used to
utilize CLI/STI in user space for serialization, but that code has long
reached the ugly code museum.

Aside of the syscalls the permission bitmap can also be changed via
X86 specific VT IOCTLs.

In all cases the caller must have RAWIO capabilities. The syscalls and
the IOCTLs can be disabled at compile time and the security framework
can lock them down, i.e. disable them.

So in pratice these syscalls and IOCTLs are ancient ballast and any
modern distro should not need them anymore.

Though at least in the enterprise world there have been binary only
vendor "value add" programs which depended on them. At least that was the
case seven years ago.

But as kernels might have the syscalls disabled or security measures
make them unacessible at runtime, these syscalls and IOCTLs might be
indeed just nostalgia.

My personal preference would be to just delete them, but if there is a
legitimate use case then I prefer to have ioperm() as that allows at
least fine granular permission checks via the syscall security controls
instead of having the binary all or nothing iopl() mechanism.

Thanks,

        tglx
