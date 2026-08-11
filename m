Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF9F412BFB;
	Tue, 11 Aug 2026 08:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437371; cv=none; b=P2dg7sQXz3VQON89YNKAwzCgahNW1jLdseBFfe//vEDZUsKgTEiAfLVjJ+HH6SPdNu8chjKdTfQ95ubMQujw6fthsS75T5jzMyq2u4+N76bScINIKcf2beoUT3tCzjTnpfdJ1b8HrqS7YWZWHOyMwZkELKwD8UCpX1vQAFDaqi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437371; c=relaxed/simple;
	bh=SrLPzKUK/MCFO0kUJIRIMsWupWP+YYYfBnIMkgi1Few=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eaWvIgWKbH8JGa09zB+XYvhO7w0SqzziVakpZn8GW51LKuzJRe5AcmxsB0GzfILL2PwSxmTMSebrQuYXLggMu1f6O/AaYVXcM68C543PtWkXN1vlBzr4Flw2bFRQbKCP9EbhbWss1n3HypeI3h1nu05YC89pL4vDqJk6Jl7QB3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SZ4QaSPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SZ4QaSPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC05F1F000E9;
	Tue, 11 Aug 2026 08:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437370;
	bh=dYjArlVEBDJPkhUvOeEdMdDh+UIps4e0rRoiI59xdRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SZ4QaSPp7e+Uz8lEZSw4orSlh79ceSljDTSwMoehCbbcLqbIKT0Z0DhDq9qJ1Xb91
	 w4bGl8ep9/8x9Z0AnQUOIL2pZ7sGg7sPKgzcRqgEygfLugkBdD6EWMPa7g1qqMuHyE
	 GM81HkC8hGMKxCBQfpCWv8cupHtUkU/3fYQ9rqZ4ZMaGidmIDwgdIQ6eHrjY+ihqwL
	 npXaJtf8UzBUi4I1EPc5Nfg1Db0uLaCjXgaxJsXsqCu8ng5Lxv30R729tmNd5taUpo
	 7IwcTaXwRZ0zT66ifXL9d+krNdhvoIBLx5w0lSXWOjW5Vq6zE0hU/n5Sw8d/3j2iLb
	 NH/VU27KESRfQ==
Date: Tue, 11 Aug 2026 10:36:06 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
	Alex Ousherovitch <aousherovitch@rambus.com>, Conor Dooley <conor+dt@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jonathan Corbet <corbet@lwn.net>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Rob Herring <robh@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org, 
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>, linux-api@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-riscv@lists.infradead.org, Shuah Khan <skhan@linuxfoundation.org>, 
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH v3 02/19] crypto: cmh - add core platform driver
Message-ID: <20260811-notorious-humorous-frigatebird-ed4637@quoll>
References: <20260806195519.2703224-1-skrishnamoorthy@rambus.com>
 <20260806195519.2703224-3-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260806195519.2703224-3-skrishnamoorthy@rambus.com>

On Thu, Aug 06, 2026 at 12:55:01PM -0700, Saravanakrishnan Krishnamoorthy wrote:
> From: Alex Ousherovitch <aousherovitch@rambus.com>
> 
> Add the Rambus CryptoManager Hub (CMH) hardware crypto accelerator
> core platform driver.  This patch provides:
> 
> - Platform driver registration and probe/remove lifecycle
> - Hardware configuration and core discovery
> - Mailbox Queue Interface (MQI) for VCQ command submission
> - Transaction manager with async completion and backlog support
> - Result handler with threaded-IRQ completion
> - DMA buffer management
> - Debugfs instrumentation (when CONFIG_CRYPTO_DEV_CMH_DEBUG=y)
> - Sysfs attributes (fw_version, hw_version, boot_status,
>   mbx_available, mbx_count)
> - Kconfig and Makefile integration
>

Entire posting has multiple high and critical reports from Sashiko.

Best regards,
Krzysztof

