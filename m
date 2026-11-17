Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794909109;
	b=fua7ZVEFXwI15zwRdcZoqng3OapoN0SA0VzIhsYyNdIACUFTBDYaDiKXBYeNwHNzEnWh
	 QbUiFZnCG8HmV3voXuJGyUpzOPuMhzC9pH8sL0A6DXo5CKyWElT4VNchKnO7GSr/xYvZa
	 VHw+TjcdOesfyH4Td+essT7ECREGhASQNAek3wU5kxutMLnZD3j4B9L3Zzrs8TMw0kS/w
	 k/ioSy1gTnkuVdR5Nt2XlSzqmcwU5ibXJJfFQOwTSGjgW/z3bPENXxBGbY/vDlA4YoYT2
	 ofB68EEjMxCNad5WV9SfrkmOIy6o+G5nX0P/ryWTco9maf3TlbWQymBlnlqWUESab1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794909109;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=cKRq7f5sfRlpjrqiJnBl46k8dvzPN6Cm5PEhEPkW5k8=;
	b=nqZsdhKa3dCIZ+nNBxXlU4guD4AZjXuw5Xd3jB40wpQRUhyJRcXe+CCQMkUgEqneeYY4
	 JgEWi94tsfsch0AH4TJkQ925e4gvcZgpgXh4dAtnB3zpvEBobDjHG5ix46+3O0aZZPVH+
	 ATfe/SzzdxYajorofnyJdOashJmE+sjiSncRsJPyCghXltOj9i8AgNocbT2p+lk0f6KeB
	 L4prcQp6BfUcKLUeCe9XCu4NMwl7Xp8+5jGePfJaGY0/NjDWIDCXNLDLth0O4kQcORRhl
	 D0fAu1u+BER6spfqpHicUNUFCAwu2ALQSgkW671fHL5moV/shX1GzcEX5RExrtv2gIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=Gx9Xu9iP;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FED0606A323;
	Tue, 17 Nov 2026 09:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FED0606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=Gx9Xu9iP
Received: from cs.unibo.it (renzopb-wl.cs.unibo.it [130.136.2.252])
	by mail.virtlab.unibo.it (Postfix) with ESMTPSA id D3C6C1C024A;
	Tue, 17 Nov 2026 10:51:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794909105;
	bh=cKRq7f5sfRlpjrqiJnBl46k8dvzPN6Cm5PEhEPkW5k8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gx9Xu9iPedqdjGY9OlCzB4M4OllwpC+LUcPKuPjRaC406iguJqjPJlei/m35BR0Zi
	 kI4hahO0nhl4v+Y36ymGFZ0d85NGjmGt8zHBYUZChHs6VLZSbRvmd3CQqe3rHYe51a
	 bpaFBHPHohObg24dEROUiMEG16WJ+QBj34x8HXcM=
Date: Tue, 17 Nov 2026 10:51:44 +0100
From: Renzo Davoli <renzo@cs.unibo.it>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	"Dmitry V . Levin" <ldv@strace.io>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Bradley Morgan <bradley.morgan@linux.dev>,
	Shuah Khan <shuah@kernel.org>, strace-devel@lists.strace.io,
	linux-api@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 2/2] selftests/ptrace: check that
 PTRACE_SET_SYSCALL_INFO rejects invalid error values
Message-ID: <avwjsMQay_N_pfvt@cs.unibo.it>
References: <20261116134050.505355-1-renzo@cs.unibo.it>
 <20261116134050.505355-3-renzo@cs.unibo.it>
 <20261116153642.a8dddc43f53fed0402283dfa@linux-foundation.org>
 <avwY4RW14jtVfgZO@cs.unibo.it>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avwY4RW14jtVfgZO@cs.unibo.it>

On Tue, Nov 17, 2026 at 10:05:37AM +0100, Renzo Davoli wrote:
> Thanks Andrew, the fixup is correct and a good addition: the test now
> covers both sides of the -MAX_ERRNO boundary.

A follow-up for when the other two PTRACE_SET_SYSCALL_INFO series come
up:

[PATCH v11 0/3] PTRACE_SET_SYSCALL_INFO: add support for seccomp syscall skipping
https://lore.kernel.org/lkml/20261114181923.370930-1-renzo@cs.unibo.it/
[PATCH v4 0/3] ptrace_set_syscall_info: add support for instruction pointer modification
https://lore.kernel.org/lkml/20261114184720.373178-1-renzo@cs.unibo.it/

I tested the full stack on x86_64 (QEMU): this series with your fixup,
then the syscall-skipping v11, then SET_IP v4 (which depends on
syscall-skipping). set_syscall_info passes.

There is one trivial textual conflict: your "#define MAX_ERRNO" lands
right where syscall-skipping v11 patch 3/3 adds new #includes, so it
does not apply with plain "git am"; "git am -3" resolves it, and the
result differs from the stack without your fixup only by the fixup
itself. If you prefer, I can send syscall-skipping v12 rebased on top
of mm-nonmm-unstable.

renzo
