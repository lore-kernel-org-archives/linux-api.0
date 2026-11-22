Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795312726;
	b=HGXGp2OxJx3oILS2vmO8vkm6eLnCwT1RBoelpTyUSMuqmbmikGbctvEu/jcQSJ++ph9J
	 3IdY2McUMspp4gtAcH55E/tk8ienkVHb0Qz/lPdfOuaTNOOw4I3Vk0R1YKVDjQJOeW1e3
	 iyL8HKFkKEMt/U0VYFy8gyLKAECwyzPnYD5mxLaetvTGg06RUPyvgl8Xfyj7svNVwVsjk
	 eOTtP/2VGtc7CocN0VQgFDhSXq8BRZM66HVAZUjSr5Uxhzr+XtNT7b3VPqxsnhfQ6PScw
	 tiU/OXcsUyGkYMoU0NIw+5UJ/kjPjGX2EdTpUunkdPXCVxypI/rMOV/equx5qsckjmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795312726;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=my1JKAIGP65RNH2BdYIO2cHSch4Ja97YSaehc+euNFY=;
	b=O6RaI2YhBmR9yPZUvaqBLpu1FMDVClMIy89jmXiDRLjIOfFQL+MI5k+Rk4faNPqwDsNe
	 WxLgJb0Ii8tdi9/FQ7e2QlAG+aDI5iWdjAab8/MNpv08ysCJnfvqi1WDZAPWvZl1ugfUr
	 14qJ0f3Bye6vlkgXR3bdxa+eCrwmPufsant/DPzc7QSwJN2ycF0QFM4XyHs0sDmUbVpbq
	 uqJve+yjkjKe22UwfT9jWfFeVZRmiFh4WHn2P7Y9cguijpCs9E5UbTwfHlBSz6mIjUkbG
	 b9fqlgRGiT17pJOGF/h3KK7RpgSLmS19C802u57iDubIkH65w8zjupRmMXWmX0aBo0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFaCXoo1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3FD8B606A320;
	Sun, 22 Nov 2026 01:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFaCXoo1
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4C08B1F000C0;
	Sun, 22 Nov 2026 01:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795312725;
	bh=my1JKAIGP65RNH2BdYIO2cHSch4Ja97YSaehc+euNFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QFaCXoo1RFl2e3MqcAATZcvWUBppaOK/u4W9/JRBcAkZTZdBf5NNHKDAP0XVFq2UB
	 18NyeT4o7uDpW+GnmmzI+4F6b4waTXBsZLCb5Oc5D078Fi5KZpOmNE5DRLdoF99CyC
	 fwmNjLEdakpaJ0FjhWNtTGhuldX628gpogHz2YrFO3V/F2JTjJYRYykIAz6ZKvEbdf
	 Eq4Aa9/TFt/ibItvOY1ZqmLL6sInT0GslX+yZWal1rDzhJqeSDUudf9mp7kJ/4VXuy
	 Yy1eAUnby1UT8qqZtlLSU/6Nmx51AhaQmuwK2mxrpWKp33SvdrM2vbo+hOz7jV/vBA
	 SCSWiC32vxOXg==
Date: Sun, 22 Nov 2026 03:58:41 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v6 00/26] userland: Userland containers
Message-ID: <awJMUf_Upp_ilYPe@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
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
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>

On Sun, Nov 22, 2026 at 03:17:43AM +0200, Jarkko Sakkinen wrote:
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.

This text is out-of-date and need to be updated.

To put short, this is a continuation of "Failed" and "Repeatedly" :-)
[1]

When I looked David's patches in 2025, I thought that while the
packaging might be a bit unfinished the mechanics made sense to me, so
since then I've occasionally worked on this problem (with long pauses
in-between).

The lack of embryonic state, a compact and policy-agnostic
implementation,, the lack of weird parallel syscall API, clean
allow-list security model (with LSM hooks) and the enablers for hotplug
are I guess the main differentiators to the pre-existing science.

I used a lot of same thinking in the life-cycle model as in SGX driver,
which can be seen e.g., as in the staircase initialization i.e.,
how ioctl's work and some other things. It was a reference of
an isolated container I guess that pre-exist in mainline.

[1] https://lwn.net/Articles/1102593/

Br, Jarkko
