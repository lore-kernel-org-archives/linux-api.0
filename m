Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.107.17.57
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794741978;
	b=JiEGOin39Dq9KrWJVOIZgtYyPJP/R4jBVFuAE7uqVocmmDzJH0lb9dn+8JDJb/JYzYAu
	 lt4YLshqPWreqf/clvo63LgoFi/HN4l1AVe/vsHISuNo62x5nRHmBbUcYXbXyet9kX21P
	 p16mkS0Q3/6WZ0NidK3UIlClL7LtPkwHIpDMz6PLsgrDrPuUj+rFUEpYRx0dXdWmHem4R
	 B4KIyTDb22dg9cvMg9gystw5ep+j7zNcPIL9hdjq5fCahZnkCdeUUr5yOm0C5vWgBWAP0
	 7WIlGuMGssE7Q4xph78MOnqRaQVomQOoLT4zZgQOXb/JzD+gBES9SESdFHNRMbARtJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794741978;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xkLE/w3z97ylZ8Sor9sRwmSzH6qQ25Puxw0Ewfd79p4=;
	b=xQjGV7cuy2N/ifwu8CSeLKfqyYEnpp5/MsSUF8l+kG6IBPuVV2909hO5k8Bp4Y9zcPV4
	 lxqxTI2eDP/dveFs10TYn3rusi4ow/rKVuVWZwH/xFdG746P2EYekxPQKtu9JL+MSn5HJ
	 VEYx68Ce0Y2ODbdT1oeUGzp6ljNBKhV9QnnDt8LIhbmmQIcfEc+50+N5xwkt8vNu8JhLk
	 kP2C+tyodixAfRTx3NhK7YuxeLp7NTwo5cnlkF172yQd/1Ql6r9eLaMmf4AuK4Otsl726
	 EKYUYIa1X7NqZZppPzzGPtTvPkpSPycYMpRc+Rez7vXy2B2Uz7a5oZ31EUlI2OFOWrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strace.io;
	spf=pass smtp.mailfrom=altlinux.org;
	arc=none smtp.remote-ip=194.107.17.57
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577C8606A31A;
	Sun, 15 Nov 2026 11:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 577C8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strace.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 4F7F372C8CC;
	Sun, 15 Nov 2026 14:26:10 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
	id 39C5F7CCB3A; Sun, 15 Nov 2026 13:26:10 +0200 (IST)
Date: Sun, 15 Nov 2026 13:26:10 +0200
From: "Dmitry V. Levin" <ldv@strace.io>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Gladkov <legion@kernel.org>,
	Eugene Syromyatnikov <evgsyr@gmail.com>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	strace-devel@lists.strace.io, linux-api@vger.kernel.org,
	Bradley Morgan <bradley.morgan@linux.dev>
Subject: Re: [PATCH v2] ptrace: reject out of range error values in
 PTRACE_SET_SYSCALL_INFO
Message-ID: <20261115112609.GA31399@strace.io>
References: <2D2A202C-35F8-4200-9110-B0E636216FCF@linux.dev>
 <20261115082540.385386-1-renzo@cs.unibo.it>
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
In-Reply-To: <20261115082540.385386-1-renzo@cs.unibo.it>

On Sun, Nov 15, 2026 at 09:25:39AM +0100, Renzo Davoli wrote:
> With is_error set, PTRACE_SET_SYSCALL_INFO passes info.exit.rval to
> syscall_set_return_value() as an "int" error without checking it: a
> positive value, or on 64-bit one outside the "int" range, turns the
> error into a success or is truncated.
> 
> Reject with -ERANGE any error value outside [-MAX_ERRNO, -1].
> 
> Fixes: 26bb32768fe6 ("ptrace: introduce PTRACE_SET_SYSCALL_INFO request")
> Signed-off-by: Renzo Davoli <renzo@cs.unibo.it>
> ---
> v2: shorter commit message and comment, dropped Assisted-by (Bradley Morgan)
> v1: https://lore.kernel.org/lkml/20261114184842.373304-1-renzo@cs.unibo.it/
> 
> Tested on x86_64: rval 0, 1, 3, -4096, INT_MIN and 0x100000000 with
> is_error set are now rejected with -ERANGE; -ESRCH and -4095 still work.
> 
>  kernel/ptrace.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/ptrace.c b/kernel/ptrace.c
> index 3f2fe68ccb14..1ffacfcef8d4 100644
> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -1111,6 +1111,10 @@ ptrace_set_syscall_info_exit(struct task_struct *child, struct pt_regs *regs,
>  	if (rval != info->exit.rval)
>  		return -ERANGE;
>  
> +	/* An error must be a negative errno value. */
> +	if (info->exit.is_error && (rval < -MAX_ERRNO || rval >= 0))
> +		return -ERANGE;
> +
>  	if (info->exit.is_error)
>  		syscall_set_return_value(child, regs, rval, 0);
>  	else

Reviewed-by: Dmitry V. Levin <ldv@strace.io>

Also worth adding a test case for this issue to
tools/testing/selftests/ptrace/set_syscall_info.c


-- 
ldv
