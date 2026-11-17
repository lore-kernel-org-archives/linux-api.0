Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.136.161.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794906343;
	b=JR7R9DFkPbfuN/u8DRxQdMCFRwHK4ywjRGSAEIwMKA52Mb2XkLR/GW9pqf0NA+x3eSCT
	 aHjaQkJrNV0QO9FqZ2Cevff7sw4cF3sc4zdbEDunEHPGj+V4SWD62AhvjAEydoYxeMcVh
	 g/HD4O6cw2gkxTfaVF6iSrg8TMGs68rLjA/exqoZiasoWwbRW7AaTRCZKbEAUe/Unerq0
	 l7Snhanx8I56lx3zHksAfmcY/9C2HjbcZKL/VdlmOyBA17O+Q61vnPkznylsOqUagG6Ag
	 PACIfFcmSgho63tik+HW4LQCnKFD+AL5embJe4xKS9IR5cfX7Va2zAvgUnc11yNL6dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794906343;
	h=DMARC-Filter:Received:DKIM-Signature:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=q9unebL19dWYI7xi7vjuz1ClkA+F8EiJo9H2IlkNq/g=;
	b=zjgBdQRgkQOP9DrKF69UV3DooWlyvENKhvMoIWLBkpITWsgMW66bXDLTeUMvccgiYayb
	 x98NM/y878OR6Qni+c6COHBvOyh4T4eXHTwEA1YC28butqgjKV37ANq6cIkIktw+dlSU2
	 ofepPHVUibbkRXhtdkQW1arzuLRtAndV0Xq9KKDPV4qDqCeUmsfspQGR/k6/qrsWzmFRk
	 FQ/f5rV3vGXxuUl0qWs6rxRw+tEOO3vUOYo9oPZ+30ToYscNZgONTT9D5dAgb3JmZIqLd
	 U2ZzCLsEyNizLKx8D4KzM9UhQ+XOBztJYm7IHjg3QuNKrJ7jb/NH99mZDZAXTdc3+7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.unibo.it;
	spf=pass smtp.mailfrom=cs.unibo.it;
	dkim=pass header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=jQPvnuKs;
	arc=none smtp.remote-ip=130.136.161.50
Received: from mail.virtlab.unibo.it (mail.virtlab.unibo.it [130.136.161.50])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A4F606A31C;
	Tue, 17 Nov 2026 09:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96A4F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.unibo.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cs.unibo.it header.i=@cs.unibo.it header.a=rsa-sha256 header.s=virtlab header.b=jQPvnuKs
Received: from cs.unibo.it (renzopb-wl.cs.unibo.it [130.136.2.252])
	by mail.virtlab.unibo.it (Postfix) with ESMTPSA id 46AF71C024A;
	Tue, 17 Nov 2026 10:05:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=cs.unibo.it;
	s=virtlab; t=1794906338;
	bh=q9unebL19dWYI7xi7vjuz1ClkA+F8EiJo9H2IlkNq/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jQPvnuKs6sB3GBlqerzW884eyCwWr6CzTNc7zR1uJCkehdi3BzPegRG4dH1jXQ7Nm
	 p6yKWzMRnewkDVCXF6m17FFOfqtI1qEUGsC6y50I2yVNlzMNueXHBahEw6PLWU3cQW
	 NfcbSKbbqoWTZrNyu8qkVzZM8CIdL8NLr8OzSGwM=
Date: Tue, 17 Nov 2026 10:05:37 +0100
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
Message-ID: <avwY4RW14jtVfgZO@cs.unibo.it>
References: <20261116134050.505355-1-renzo@cs.unibo.it>
 <20261116134050.505355-3-renzo@cs.unibo.it>
 <20261116153642.a8dddc43f53fed0402283dfa@linux-foundation.org>
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
In-Reply-To: <20261116153642.a8dddc43f53fed0402283dfa@linux-foundation.org>

On Mon, 16 Nov 2026 15:36:42 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> LLM suggested a little fixup here, please check.
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: selftests/ptrace: test the lowest valid syscall error

Thanks Andrew, the fixup is correct and a good addition: the test now
covers both sides of the -MAX_ERRNO boundary.

I tested it on top of v4 (x86_64, QEMU): set_syscall_info passes.

Reviewed-by: Renzo Davoli <renzo@cs.unibo.it>
Tested-by: Renzo Davoli <renzo@cs.unibo.it>

renzo
