Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792626094;
	b=W1MzQ8aOkn6mlV1vO2jXniRPRjB6ugxUl+i7GGES5n90/yGTTncRNfq42pHbUL5A2pC4
	 2zgqLbTud2YB62IqnpYidRl//0Xxwi6RO5xDG6aVvnCB/0u96GAoD3phfn54Huaz47QSg
	 1ZEAebaUF1Q1Tz1YkUMZSUE/aZWYE6p+en4QjaSLI+XjChrYdKzLEqib6EI1ex6zz6/Hi
	 Qj2DK0kQh0iwX6wDdLqnu9kdVCFcNTvAFn9vMgnNXEikhfzqKleLYlJNRO3SlDe+ikkMi
	 bxQQdj1lfJo15bEgE91GSbf22VYr03CVCbTT1T4SYl1Z3YqpMEYkF4U+DSsB/K3DpPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792626094;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=9JQopFvN4rZM9m2R9xwMR2uSxRVpYkQzXBI5laTN/EA=;
	b=hb49ymRIyOxtEEPUFVY53mjReiEy9s1vsx1KDnM+stZA993VcQT72hg5zRfEitMCqPG3
	 GEKeS/5KrwOeFdBdTkJRBZ2+R5haIpy9jwSyJZQsJkkM8HuTO0DCzcO8n4OoXcM7cZ3Xg
	 jFvPycGb0KYVzk0FywIECcSnke33BHZdkV4Nqa4SOvnUDFfrSlSGvVTvEMp5ZqL6HfDLQ
	 iQcJtlEWJwuRKXQzmhcTOaQ8bvTPWzTIBW0zOeSyhSo7BJx7BhOQVPJKrmRAzerk/5r/B
	 rUYLjd8UBTr4tNBpOaUxN/M5iXsLWImBzlIDnH8yAFwaexHpqWqonm/5ZCJFxiAETRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZO1541My;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7046606A319;
	Wed, 21 Oct 2026 23:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7046606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=ZO1541My
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=9JQopFvN4rZM9m2R9xwMR2uSxRVpYkQzXBI5laTN/EA=; b=ZO1541MyYrXR3d0HCh70sL9Ag7
	j/PhX+nX6HnRL8ZvYOEGqdz6bPBm/o5ZsGQu5zHF+xJzERtSqE2HCBWlA5v5Qq0fpWXRUpvWGy8+w
	lXGsMQQt7FRfle6OR30DQWCKLJqrC7nAtaNC402UoGK92qFxfI06uiWF46za9XIVo5tZBfZnzNDBW
	AtGXnDs/55I/lHDPgGJT/qICvJlWbIEcC/BNxJHTJ2bAhC4Wgq9iycKfud/IKuljYM6U3WMiC62Pu
	NlYyClYihgUmWe2il+mRcEp7dSzIRsFsI46PbumUAQuMyYM2jpgEbZZZu6rtoE9yLNYiW30/ugday
	0EddCK0A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xJfw1-0000000D3IN-0kSw;
	Wed, 21 Oct 2026 23:41:29 +0000
Message-ID: <db4e46a6-1788-44a3-a3ab-4fded03591d7@infradead.org>
Date: Wed, 21 Oct 2026 16:41:27 -0700
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] docs: security: Describe the Kernel Assurance Plane
 design
To: Ketan Bhardwaj <ketan@armoriq.io>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org,
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
 "HARIHARA SUDHAN . R" <harisudhan@armoriq.io>
References: <20261021165748.19304-1-ketan@armoriq.io>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20261021165748.19304-1-ketan@armoriq.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,
[just a small documentation warning:]

On 10/21/26 9:57 AM, Ketan Bhardwaj wrote:
> diff --git a/Documentation/admin-guide/LSM/index.rst b/Documentation/admin-guide/LSM/index.rst
> index b44ef68f..4a299993 100644
> --- a/Documentation/admin-guide/LSM/index.rst
> +++ b/Documentation/admin-guide/LSM/index.rst
> @@ -48,4 +48,5 @@ subdirectories.
>     Yama
>     SafeSetID
>     ipe
> +   kap
>     landlock

I wondered what this index entry was for and then running
'make htmldocs' complained:

Documentation/admin-guide/LSM/index.rst:48: WARNING: toctree contains reference to nonexisting document 'admin-guide/LSM/kap' [toc.not_readable]


-- 
~Randy

