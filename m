Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795381569;
	b=YVLfIRy77qoWph9GMsYiimEgeuqfo9/0EREheV9DyNY8MA2mNOmdCt449h+LkszOgUkJ
	 Sj+zSk2vE1Xa22Pr6tKL32GUcScfChQaAfu1rNirlXR06RbPFQ/U4eURWUTRP/TPkOcpb
	 cshUqvwq1exBxkFOjIGpKJV3FoQoo13J5ZB7rUsqgCm2EDUhXPDDLCwuqCRCdWsLkBQba
	 3S3xSIFGKn9B7Iphp7BMyW+qBDPSdYtLxgEEXxpojaHNDQEi7fU8ZpSwJfI/zztWXwH4S
	 FZRZc0AYJCmnOvdLLZHi90LXkgfyHStQLDxGVz+Eo66QkO0z7S60y+ap1XCoFvPS40A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795381569;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YwlY5+8HMIfOP8gjeCqlZaPCdsmRsLFY3NloYb5Xk4I=;
	b=vcOItC64b9t/TVEdDC4dxvYO3e9cV9X0kfRADs56O9WrxHmAAVSW4VJzkeY764jnaVsx
	 DGxmxuXFetMOackM8WcNEIfOq7Q/ebfCsqtuPMU+W7n5G8GSz0X9a5dUIwsbIzIM5/cgL
	 YiErj1PRpgCX1ZaZ4rnmUal5T4al1RXybR/gQaN0Hor91yYIvrGx16KqMjhXulkk2Krq+
	 fM0Z3ci9jGXiv1mY925QbwdWBMg0BoHUoC3oIi7HuWma3bKEejjVtqVFuvBqn3anELyub
	 DanmXb0Wtq+/dSW3+xqAL37j/Gs0J8WpbCo8PwOKbmcX4wtFV+niu5p3w1yS46QWj3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aT9e0vZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E99606A31A;
	Sun, 22 Nov 2026 21:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aT9e0vZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC971F000C0;
	Sun, 22 Nov 2026 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795381568;
	bh=YwlY5+8HMIfOP8gjeCqlZaPCdsmRsLFY3NloYb5Xk4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aT9e0vZ2pqv52Qiex10tpuz1zIAEEspXo2mek0V8O7o6ySvVMgWs7yrhTsMGMfV2P
	 eIB0L/qXawckjHrNi/esY9WB8cUEBkGgycLSyTmZLIK4wM8JGOlLLiDgRfdg92Vfu+
	 9XLCh/7DIGGSLKRav+uoCa+xCmmNhn7PhxV+VdyhA2x8AeeTjhqa8BO+nsj3DgCwqD
	 pobNJUKYeU3ICt+SSdQOc19IZ2bHM3J9OYak6gKUp+JHT8TySD5nYy5FBrapUpDuVP
	 GHOQYkCen/FynmaLT87JD5rUYQXe4OeNjpHH02PrvKgQOjFIkbDVqYn+6GzJazJLQ3
	 gqJhHBfKWLPPw==
Date: Sun, 22 Nov 2026 21:06:04 +0000
From: Sudeep Holla <sudeep.holla@kernel.org>
To: Ahmed Azeem <ahmed.azeem@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Divin Raj <divin.raj@arm.com>,
	Bertrand Marquis <Bertrand.Marquis@arm.com>
Subject: Re: [PATCH RFC 3/4] firmware: arm: Add PFDI run, result, and error
 injection support
Message-ID: <20261122-cute-wildebeest-of-downpour-b21fdb@sudeepholla>
References: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-0-4772d18b9115@arm.com>
 <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-3-4772d18b9115@arm.com>
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
In-Reply-To: <20261119-topics-ahmaze01-upstream-pfdi-rfc-v1-3-4772d18b9115@arm.com>

On Thu, Nov 19, 2026 at 03:36:05PM +0000, Ahmed Azeem wrote:
> From: Divin Raj <divin.raj@arm.com>
> 
> Extend the PFDI driver with ioctls to execute tests and manage results.
> 
> Add support for PFDI_IOCTL_PE_TEST_RUN, PFDI_IOCTL_PE_TEST_RESULT, and
> PFDI_IOCTL_FORCE_ERROR, along with per-CPU state to serialize test
> execution. When firmware reports PFDI_RET_FAULT_FOUND, return the
> failing test identifier to userspace.
> 
> Signed-off-by: Divin Raj <divin.raj@arm.com>
> Signed-off-by: Ahmed Azeem <ahmed.azeem@arm.com>
> ---
>  drivers/firmware/arm_pfdi.c | 225 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 225 insertions(+)
> 
> diff --git a/drivers/firmware/arm_pfdi.c b/drivers/firmware/arm_pfdi.c
> index 8c6d315b0572..22a69b12dbc8 100644
> --- a/drivers/firmware/arm_pfdi.c
> +++ b/drivers/firmware/arm_pfdi.c
> @@ -350,9 +543,35 @@ static long arm_pfdi_ioctl(struct file *file, unsigned int cmd,
>  					 sizeof(count)))
>  			err = -EFAULT;
>  		break;
> +	case PFDI_IOCTL_PE_TEST_RUN:
> +		if (copy_from_user(&test_run, (void __user *)arg,
> +				   sizeof(test_run)))
> +			return -EFAULT;
> +
> +		err = pfdi_pe_run_tests(cpu, &test_run);
> +		if (err == -EFAULT &&
> +		    copy_to_user((void __user *)arg, &test_run,
> +				 sizeof(test_run)))
> +			err = -EFAULT;
> +		break;
> +	case PFDI_IOCTL_PE_TEST_RESULT:
> +		err = pfdi_pe_get_result(cpu, &ft_id);
> +		if (err == -EFAULT && copy_to_user((void __user *)arg, &ft_id,
> +						   sizeof(ft_id)))
> +			err = -EFAULT;
> +		break;
>  	case PFDI_IOCTL_FW_CHECK:
>  		err = pfdi_pe_fw_check(cpu);
>  		break;
> +	case PFDI_IOCTL_FORCE_ERROR:
> +		if (copy_from_user(&error_info, (void __user *)arg,
> +				   sizeof(error_info)))
> +			return -EFAULT;
> +		if (error_info.reserved)
> +			return -EINVAL;

Do we really need a strict 1:1 mapping between the userspace IOCTLs and the
underlying firmware interface? Looking at the proposed commands, we might be
able to simplify things significantly:

1. RUN and TEST_RESULT could likely be combined into a single interface from a
   userspace perspective.
2. I'm still unclear on the intended use case for FORCE_ERROR (echoing the
   earlier question on the cover letter).
3 FW_CHECK feels like it belongs in driver initialization to catch boot-time
  errors. Since it's hard to see how firmware could safely execute runtime tests
  without OSPM awareness - despite what the spec suggests - exposing FW_CHECK to
  userspace doesn't seem necessary.

Given that RUN appears to be the primary userspace entry point, would a simple
sysfs attribute be a better fit here than adding a new set of IOCTLs?

-- 
Regards,
Sudeep
