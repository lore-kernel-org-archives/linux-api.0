Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7052F8E99;
	Thu, 25 Jun 2026 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782410752; cv=none; b=XdnBo5gTro3OpIFjYr9FEQ6xhvthNJyV+ukyncnoz9ub2N0hjTu5A1VAHYNuqVcuLs5hL90ccc4SgS3pEi80yLM87aoOzr/6FaX2NrViIlvUZM0tjtpW3bN7nBBmju4KmBr7DnjTpMN7oIPD17wETecTYy67zbJlgormXWnmwZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782410752; c=relaxed/simple;
	bh=GPj509ZMrtTNp459KDd1Tt1hl7NhkDgoFuECeU/F1ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pHK4qXxgub1xh/NIBo7C+/htg8XFGXFQwgTAFWcbI/kmOvTLZ1WkPdL23mMf024Woexx9WkI8XpFmfE6drJKC7Wz93v6GoLOe7fj0X357/9doQDcqspt+GBqmo6+biHi9IdCTpn//9cQ4h/nu1ej0g+DgKL2B/+kbBUbB191hOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0Dulsv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0Dulsv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517B11F000E9;
	Thu, 25 Jun 2026 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782410751;
	bh=GPj509ZMrtTNp459KDd1Tt1hl7NhkDgoFuECeU/F1ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y0Dulsv+tq6dpOQYJPHD9uJzO92mLf7cUS1Y7MmHCGqrbzdASqZgDnkOi574uebM3
	 XRAiX4p8OnoRELCT3ZgT88aEJyHyeNtQ39O+JZJosNmw1YKYYr0coSKuR5qlkFgjjv
	 Nj5xn9GYkKUOTjrqTfgPZoOFhZoqMp2VaG52/9Lj5dMqKy5yTejWIIDHymKkROHO4f
	 mTLjEYe/qJURoam9/rbWSgdhkPIOizYT20Ol0bsuOi7d3mEuvrxzdEpVRZCRFl17zL
	 /7mfG+3C93DaNWt3rt5cwwMXKvSCbLHogRpIqCc+kUpTW8H9uXSV4YAIbFK1hqKxEV
	 en578ajw1UoYw==
Date: Thu, 25 Jun 2026 11:05:44 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Saravanakrishnan Krishnamoorthy <skrishnamoorthy@rambus.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
	Alex Ousherovitch <aousherovitch@rambus.com>,
	Conor Dooley <conor+dt@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Corbet <corbet@lwn.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Rob Herring <robh@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>, devicetree@vger.kernel.org,
	Joel Wittenauer <Joel.Wittenauer@cryptography.com>,
	linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	Shuah Khan <skhan@linuxfoundation.org>, sipsupport@rambus.com,
	Thi Nguyen <thin@rambus.com>
Subject: Re: [PATCH 00/19] crypto: cmh - add CRI CryptoManager Hub driver
Message-ID: <20260625180544.GB2514@quark>
References: <20260625173328.1140487-1-skrishnamoorthy@rambus.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625173328.1140487-1-skrishnamoorthy@rambus.com>

On Thu, Jun 25, 2026 at 10:33:08AM -0700, Saravanakrishnan Krishnamoorthy wrote:
> ** This message and any attachments are for the sole use of the
> intended recipient(s). It may contain information that is confidential
> and privileged. If you are not the intended recipient of this message,
> you are prohibited from printing, copying, forwarding or saving it.
> Please delete the message and attachments and notify the sender
> immediately. **

Okay, I deleted it.

- Eric
