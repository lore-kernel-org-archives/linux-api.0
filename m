Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8838B189F54;
	Wed, 15 Jan 2025 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736962607; cv=none; b=MgGldpSqk6eAa0ofjTWvKn97nvW+yKfoSZRyZeAE54CJsO7PNhQRoayrm/SxFeVKaG/I9SlXZKaYgY1U6BJwwohbqHeFRv0Uzr8hoHjt6U8RSu7pLUzVlJX2AcVbARbnWBjUAg3nU/nadWPSyvCsPwMMts3xSYq9Ywtj4XfUC6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736962607; c=relaxed/simple;
	bh=jIZmBNFA0klvzSW2k4cGdbc9PTtKLBDtrXHoT56dCfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E69uDOSbrVfI9IEkAz632+b2HiyO1YgweCDM3A60y9EYhpPaxYIRJyrEsS5nt8o3DijHVBSGe66jZdfip9uZnfuceYfgMOZbH8s1A3L6efg4xtOkR6GmndSgNTXKPJ05tecPbRkBFYCVqyOA8I333LtOvK5Yv+4Jn7NXfrvMW8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strace.io; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strace.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
	by vmicros1.altlinux.org (Postfix) with ESMTP id E6CE172C8CC;
	Wed, 15 Jan 2025 20:36:42 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
	id DB29C7CCB3A; Wed, 15 Jan 2025 19:36:42 +0200 (IST)
Date: Wed, 15 Jan 2025 19:36:42 +0200
From: "Dmitry V. Levin" <ldv@strace.io>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Mike Frysinger <vapier@gentoo.org>,
	Renzo Davoli <renzo@cs.unibo.it>,
	Davide Berardi <berardi.dav@gmail.com>,
	strace-devel@lists.strace.io, linux-kernel@vger.kernel.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2 6/7] ptrace: introduce PTRACE_SET_SYSCALL_INFO request
Message-ID: <20250115173642.GA25129@strace.io>
References: <20250113170925.GA392@strace.io>
 <20250113171208.GF589@strace.io>
 <20250115163809.GC11980@redhat.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250115163809.GC11980@redhat.com>

On Wed, Jan 15, 2025 at 05:38:09PM +0100, Oleg Nesterov wrote:
[...]
> > +	syscall_set_nr(child, regs, nr);
> > +	/*
> > +	 * If the syscall number is set to -1, setting syscall arguments is not
> > +	 * just pointless, it would also clobber the syscall return value on
> > +	 * those architectures that share the same register both for the first
> > +	 * argument of syscall and its return value.
> > +	 */
> > +	if (nr != -1)
> > +		syscall_set_arguments(child, regs, args);
> 
> Thanks, much better than I tried to suggest in my reply to V1.
> 
> But may be
> 
> 	if (syscall_get_nr() != -1)
> 		syscall_set_arguments(...);
> 
> will look a bit more consistent?

I'm sorry, but I didn't follow.  As we've just set the syscall number with
syscall_set_nr(), why would we want to call syscall_get_nr() right after
that to obtain the syscall number?


-- 
ldv
