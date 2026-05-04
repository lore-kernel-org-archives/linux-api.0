Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148EF3E5EDB;
	Mon,  4 May 2026 18:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919121; cv=none; b=gWInGo2xEwHYXJ1f4JzYAKz5xpxgDZBCsw7715VgcYXXrnEBu458aWdTLYuRz9dKWi6eFE0y1BvIhgbnNcLial3XwwrfJ+O1SLmYxNNWp/VfdZj1sgrsrd28MXTRb+4AZlMsQHe5uO5M4hJMXpuPVnpsNQ/neDLWdg1U9SJXTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919121; c=relaxed/simple;
	bh=Kb/NMNloL+Clwsy6e6Q4rr0m/L9z3Rfv+12Y23nYhOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLof7MWh+Fcif/m5YODkRJGwDdYTW7RhhYB2dlb7MUfbCqVKzJDiNElCHWVZtsmKWnFTlSkShclP90JNEx+5k8NYCYDTC0fVWby4dtIt0L1h373qmH4KVy5akxI76LVK12I8OcPKj76rvHTutpVtrT6qjuA06k/bd8RQPvqclzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/d6pBSY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/d6pBSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F6CC2BCFC;
	Mon,  4 May 2026 18:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777919120;
	bh=Kb/NMNloL+Clwsy6e6Q4rr0m/L9z3Rfv+12Y23nYhOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/d6pBSYEiFV0cwdmW5pkBnpqQSGJB/91CKxGokMkb2GKeGLkQXHCqxs7vpFifTFr
	 HHlRD3nm6tvXuh50cs29J9RmyJid5wqo7DCPUz0IlR7ZadcRTM7m5mqqIY40oa4ZL6
	 Vugkk/Ug/teUvByZSvLQ0dkOgkae8rr8OMjVIQys9bZyytHu4BsI7CNYIDs1MI3G4P
	 eL7JYtqgf/lCi8pnROuFbBb3gM3llKipRIeF4Ng+vrysXp4XujFmb9i5gRThcgqH8c
	 SBIrogtM80QueicHWhKCFmO6vXvgxUHYUXHdYysC0lt+2IedW5BZGpZpi7LDQORyxP
	 suK9JObx4OuAw==
Date: Mon, 4 May 2026 11:24:00 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Jeff Barnes <jeffbarnes@linux.microsoft.com>
Cc: Jon Kohler <jon@nutanix.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
Message-ID: <20260504182400.GA5315@sol>
References: <20260504173952.GA2291@sol>
 <F100C726-F841-461B-BE2F-C2018C122426@getmailspring.com>
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F100C726-F841-461B-BE2F-C2018C122426@getmailspring.com>

On Mon, May 04, 2026 at 02:12:11PM -0400, Jeff Barnes wrote:
> A plain hash provides no protection against an attacker who can modify
> both the object and its reference hash.

Same with the HMAC, because in the FIPS integrity check the key isn't
secret.  You can find the key used by the sha512hmac binary here:
https://github.com/smuellerDD/libkcapi/blob/master/apps/kcapi-hasher.c#L125

- Eric
