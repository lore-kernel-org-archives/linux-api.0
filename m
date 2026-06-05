Received: from mail-108-mta4.mxroute.com (mail-108-mta4.mxroute.com [136.175.108.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A820393DE9
	for <linux-api@vger.kernel.org>; Fri,  5 Jun 2026 20:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780691890; cv=none; b=O30MrYHixSG90poEx1TEMtmav97e5wXfo0CZse27SClPkZtyVrr0NnGrjkg2Kr8pbyakqWLtvLMgbnYpVCNDwDaUhOnDO+vhkLUV+hKbiFTk7lFGahlO9cDTsGu7eo8oT/2cj7sxVPvr/XPto8+ZJ7IZo5MLejfxfhUn4bptbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780691890; c=relaxed/simple;
	bh=mtRFSkWblm61wGrh/wpoZ7P+qtpA7tqnNoCqk9zA3O8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwPxDnIRMXxLVHTJC2W/QAGfwHX6BJadvwSOlWYK9/usaWAZxOo6n0hSJWraJ39tysRv90FfHrjd6MTZ17pVBdgnk2uHpfiIRgDVwbtrjqJmkG2jNdkJG517pn46u90VP0YxMqsusMsbOhvWgKzIOExWonE51x6vswyXo6zpSGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wii.dev; spf=pass smtp.mailfrom=wii.dev; dkim=pass (2048-bit key) header.d=wii.dev header.i=@wii.dev header.b=cnA+rOMB; arc=none smtp.client-ip=136.175.108.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wii.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wii.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wii.dev header.i=@wii.dev header.b="cnA+rOMB"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta4.mxroute.com (ZoneMTA) with ESMTPSA id 19e997d22bd00067f7.010
 for <linux-api@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 05 Jun 2026 20:32:55 +0000
X-Zone-Loop: 1b92b155840ba66de76f21a0b81b6bc7650139ecf08a
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wii.dev;
	s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc
	:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WcZzNqmpt6jHPh6vf5iW0qnbE08NIl2+GlfUTtZVfjI=; b=cnA+rOMBGmo8XuDqWhFFinwish
	9fTECOf7ox3lVvB/P8JYFx3kfBDQGOn7SGnwMm0pBKWkn3Q2KKp/6f5yWB/ehThI5dh7ZVExpbAqm
	agmru/doC17m8GUP6NJtGQM5b5jqr+lJQoc1vpWEXJkdINvQrjT6SvG4GGmGZYR4DcVEn3MQoGdl8
	7S13simPnPtCwkXOOLe4+1Tzo6c8MYGLgceeEB5NWezUXpnmo8XEvVe0f7Yxb8GspZ2ewGQy70s9T
	KH6vIgODllVhzkRHTPfZU4yaL7sbiTYMXTqmBCHXFhirB6w+xne7k9+q+kxkcPvJ/PupyLivmur1V
	dMiFzx3A==;
Date: Fri, 5 Jun 2026 20:32:40 +0000
From: Richard Patel <ripatel@wii.dev>
To: Florian Weimer <fweimer@redhat.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	David Laight <david.laight.linux@gmail.com>,
	Andy Lutomirski <luto@kernel.org>, Kees Cook <kees@kernel.org>,
	Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
	linux-api@vger.kernel.org, Arjun Shankar <ashankar@redhat.com>
Subject: Re: [PATCH v2 0/5] Usermode Indirect Branch Tracking
Message-ID: <aiMyaJ8zDl76YOVN@wii.dev>
References: <20260605184715.3383415-2-ripatel@wii.dev>
 <lhu1pek4w89.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lhu1pek4w89.fsf@oldenburg.str.redhat.com>
X-Authenticated-Id: ripatel@wii.dev

On Fri, Jun 05, 2026 at 09:34:46PM +0200, Florian Weimer wrote:

> How do you detect that handling a signal is complete and IBT can be
> re-enabled?  Or is it re-enabled before entering the userspace signal
> handler?

Hi Florian,

In v1, we backed up the IBT CPU state into the (user-accessible) signal
frame from FRED/XSAVE, then restored it:
https://lore.kernel.org/lkml/20260517183024.16292-4-ripatel@wii.dev/

In v2, when entering the signal handler, the kernel just context switches
to the new user rip, bypassing IBT checks (continues executing if the
signal handler does not begin with endbr).

IBT stays enabled in both designs, just the IBT state is preserved in v1,
and lost in v2.

The same thing happens when doing a sigreturn in v2 (e.g. via trampoline),
again IBT is not enforced.  IBT stays enabled when doing a siglongjmp,
though.

Some time in the future, ideally:
- signal handler is *required* to start with endbr (this is easy)
- sigreturn as in my asm example enforces endbr after returning from a
  signal handler to a in-progres indirect branc
- libc (sig)longjmp is made IBT-compatible

Btw, I had self-tests for the v1 design, and {signal handle,rt_sigreturn,
siglongjmp} with {success case,violation} works flawlessly with Fedora 44
glibc amd64. With glibc i686 I ran into PLT issues, probably my fault.

It is quite surprised that siglongjmp was working, btw, since the glibc
longjmp code uses 'jmp *reg' (without notrack prefix). I guess you do an
endbr64 at the setjmp side?

> > The main question is whether glibc is happy with this prctl syscall API.
> 
> As far as I can tell, the prctl works for glibc.  Re-use of an
> arch_prctl constant might have been problematic, but the series is not
> doing that.

Nice :-)
The alternative would have been to bolt on stuff to ARCH_SHSTK, or create
an entirely new arch_prctl. Open to any API.

> Adding the ELF GNU note parsing can be added later, but perhaps not
> cleanly.  I'm still a bit worried we might have to rev the markup
> because too many binaries are in circulation that claim compatibility,
> have never been tested, and are actually broken.  If the kernel does not
> look at the ELF bits, things a slightly simpler.

Phew, I was hoping you'd say that.

If you want, I can sketch out glibc IBT enabling and test it on Debian
and Fedora, which IIRC already emit compile with -fcf-protection=branch
for all OS packages.

> > There is one notable gap in this patch series, to do with signals:
> >
> >   000a: mov rax, 0x100a
> >   000f: jmp rax
> >   *** signal occurs ***
> >   *** signal handler runs, does sigreturn ***
> >   100a: nop
> >
> > The above sequence does not crash.
> >
> > With IBT, it should crash at the nop (because an endr64 is expected there).
> > The IBT state (WAIT_FOR_ENDBR in IA32_U_CET MSR) is not backed up to the
> > signal frame though.  So, when userland does a sigreturn, the CPU has
> > forgotten that it was doing an indirect branch before the signal.
> > (This specifically only occurs with signal handlers that sigreturn.)
> >
> > This is because IA32_U_CET is part of XSAVE 'supervisor' state, so
> > regular XSAVE/XRSTOR can't access it.  Doing a manual backup is tricky.
> 
> That's a bit annoying.  Is this restricted to signal handlers, or does
> it apply to page faults, too?

Only signal handlers, page faults don't reset IBT.

> > A related problem is that the signal handler routine is not checked for
> > endbr preamble.
> 
> That's not necessarily a problem because its address cannot be directly
> overwritten in userspace.  Not all indirect branches need to be checked,
> only those that have tweakable targets.  In fact, fewer ENDBR64 markers
> are better (although we wouldn't drop the marker from a signal handler
> specifically, of course).

Just one concern I have is that people start relying on signal handlers
not requiring endbr64, and then a future kernel version breaking them once
we enforce it.

Really appreciate your review,

-Richard
