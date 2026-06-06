Received: from mail-108-mta46.mxroute.com (mail-108-mta46.mxroute.com [136.175.108.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80522B672
	for <linux-api@vger.kernel.org>; Sat,  6 Jun 2026 23:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780787471; cv=none; b=GmXyfQnKCtGSVX3EWPT01Th8FdKjcSI0ixe7XjGYlIhINs+xULJOtedFp+Nc4vKKQ78/EeKO8xaaQ2Y4Nbkz4AApnrAMzQuQHmmYBXkPCMR6X1nUdoIQrg2ukV3MdOXAlDQZ865OqBUQR8B/PSpn78Dr9BCCo/0hwDLAjkme6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780787471; c=relaxed/simple;
	bh=yscTuAObCOLGPGBB55PqSrbwiKc6A1IG+AjWeGZYPCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrzL9zC4Tt86ABtsGANeKRNPlnMy09xrYEhst6+Y9czWoEvLXVtFen4x1rmVE/hSy7u0cMwCpPoZ23ahB1tYV0LngTr2mDAY+JlZONZt1+UIe5mdlPX089CVOgHVzW8Ptos8Z6kf0rIZN+4runIonVKdTawdwITlEcYRLb9T87o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wii.dev; spf=pass smtp.mailfrom=wii.dev; dkim=pass (2048-bit key) header.d=wii.dev header.i=@wii.dev header.b=vCzpAelQ; arc=none smtp.client-ip=136.175.108.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wii.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wii.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wii.dev header.i=@wii.dev header.b="vCzpAelQ"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta46.mxroute.com (ZoneMTA) with ESMTPSA id 19e9f2f916c00067f7.010
 for <linux-api@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 06 Jun 2026 23:05:55 +0000
X-Zone-Loop: 19e43d5351a4b774c9b8fee2ec04699f83f1b995269b
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wii.dev;
	s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc
	:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WP2oqipYqAvkBLHuDMzlMOTobd58G4OxvG0iaDmYqXw=; b=vCzpAelQPpt6RsNUq3+d4k9h8J
	JhtfzIqiEKKXVENId/9BsL7cqgB3Viav+h/Eb+VQIYlUCttRzo7zWdghCFKR249l8eMHaP1ZOh8kv
	qMsTpd6Fc+Qy7rsY4rORMXAmcKSq0WKSKsaUZnSdGO01Sj3ZvxRuS+3+mKrU9NDmoJeCelS+7ZRzl
	OcTdXFnniUTD9S2L+2b05iPd9y83rIwyV2kHm45QYubrA5tLh4l2I07BWc9yagHl4gjdG/0Z34+tf
	QPM4E/cH+n/1vfmLc1FbnbFBKSyMcMVCp5tmD6aQKyKYtY+ZwDaAj/fPx83bPpMOXCD9ecCdWoOpb
	rSrH5iGA==;
Date: Sat, 6 Jun 2026 23:05:30 +0000
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
Message-ID: <aiSnujU6u1PAq1l/@wii.dev>
References: <20260605184715.3383415-2-ripatel@wii.dev>
 <lhu1pek4w89.fsf@oldenburg.str.redhat.com>
 <aiMyaJ8zDl76YOVN@wii.dev>
 <lhua4t73hz9.fsf@oldenburg.str.redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lhua4t73hz9.fsf@oldenburg.str.redhat.com>
X-Authenticated-Id: ripatel@wii.dev

On Sat, Jun 06, 2026 at 03:40:10PM +0200, Florian Weimer wrote:
> * Richard Patel:
> 
> > On Fri, Jun 05, 2026 at 09:34:46PM +0200, Florian Weimer wrote:
> >
> >> How do you detect that handling a signal is complete and IBT can be
> >> re-enabled?  Or is it re-enabled before entering the userspace signal
> >> handler?
> >
> > Hi Florian,
> >
> > In v1, we backed up the IBT CPU state into the (user-accessible) signal
> > frame from FRED/XSAVE, then restored it:
> > https://lore.kernel.org/lkml/20260517183024.16292-4-ripatel@wii.dev/
> >
> > In v2, when entering the signal handler, the kernel just context switches
> > to the new user rip, bypassing IBT checks (continues executing if the
> > signal handler does not begin with endbr).
> 
> What's the reason for this?

Hi Florian,

We just don't have a nice way to include IBT state in the signal frame
right now.  v1 had an uabi change (adding a new bit in ucontext_t uc_flags),
which was originally proposed by Intel years ago.  My preferred way to add
IBT state is to carve out an XSAVE area in fpstate, which works well with all
the existing signal frame code.

But I figured it's better to just keep the first pass at user IBT super
simple, in the hopes upstream is more inclined to accept that.

BTW, OpenBSD uses the v2 approach (don't preserve IBT state across signal
handlers), presumably because it's also hard for them to restore IBT state
on sigreturn.

> >> That's not necessarily a problem because its address cannot be directly
> >> overwritten in userspace.  Not all indirect branches need to be checked,
> >> only those that have tweakable targets.  In fact, fewer ENDBR64 markers
> >> are better (although we wouldn't drop the marker from a signal handler
> >> specifically, of course).
> >
> > Just one concern I have is that people start relying on signal handlers
> > not requiring endbr64, and then a future kernel version breaking them once
> > we enforce it.
> 
> Would software enforcement be a possibility?  The kernel could check if
> the landing pad is there.

Enforcement is the easy part.  I can trivially add back 'check if signal
handler starts with endbr64'.  Just the backup/restore of the pre-signal
handler state ('do I expect an endbr64 after returning') is the tricky part.

Thank you,
-Richard
