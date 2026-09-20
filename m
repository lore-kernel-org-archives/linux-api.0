Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A0A3ED5BB;
	Sun, 20 Sep 2026 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789899670; cv=none; b=Jne/5LmD+qnPQ++v+6POGLNjpS1a6Z5Xn4flqBVfs+s4VdGV/p2SJluJzLawapj4yfhRgbaf3eCu5449zPqr4a8w0slKbvVKkbOAFHa3wE4MeqMQfVRoJfkVmZ/Z+uKXsRWPL0fTuNRs/LX3Oe0o9YCDcUOkRXG8XM+DWjbBmPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789899670; c=relaxed/simple;
	bh=Voce/lFCdTRcJBOz+PzC499UMedgZyBd36VrILiD3yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cpB31UJ0jkgBvjvkN9nVtQLRuuOMvjGJAs9WOypuXPZeFB8S1d4syaFZH8qEA/0EgDiytNStx/edD+iwiSRnLK/3W4Q0/xCQjOUl0nrkkVpoPmgnDcU9SpSN3I6pJzlO+3nYImn5M0y3b2hfXa5A3QRexT4NS67zEZWUdo2UkQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrJ85rcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrJ85rcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A361F000FF;
	Sun, 20 Sep 2026 10:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789899668;
	bh=jMzLV3kGdoPOUL/f0tlElCHPgt1qK0SveX9Obruno+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DrJ85rcjB5RUFNWfz0e6CklakGVbPwmO/ru+6tBsrA+gS1eEM+JstE5j4MP3kMEau
	 VNNFYUwSg8Zc9ge8JuRnWvyA9mRa8zRceqtFHjeasm4nWumyjV7L/z8xlFqp2XLbb5
	 tkfSiwIssRK9BWWpyD4pUHPu8hSMGjkzE74rLQJ4=
Date: Sun, 20 Sep 2026 12:20:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: =?utf-8?B?5p6X5r+s5ZOy?= <m18667909625@163.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-api@vger.kernel.org,
	luto@kernel.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com
Subject: Re: [PATCH] kernel: add system_energy_efficiency syscall (nr 337)
Message-ID: <2026092041-foster-eradicate-822b@gregkh>
References: <20260920100714.46206-1-m18667909625@163.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260920100714.46206-1-m18667909625@163.com>

On Sun, Sep 20, 2026 at 06:07:13PM +0800, 林濬哲 wrote:
> Add a new syscall that reports GPU presence and system-wide
> energy information:
> 
> - mode 0: returns the number of display devices found on the PCI bus
> - mode 1: returns an energy efficiency metric; prefers the real GPU
>   power reported through hwmon, falls back to runtime PM status
>   weights, plus the online CPU count
> - mode 2: returns the real-time GPU power in milliwatts read from
>   the hwmon power1_input channel exposed by GPU drivers
>   (amdgpu/nouveau/radeon/nvidia); returns 0 if not reported

Cute, but you missed a bunch of other gpu drivers, AND all of this can
be done today from userspace, no syscall is needed, right?

thanks,

greg k-h
