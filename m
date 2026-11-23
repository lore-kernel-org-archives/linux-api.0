Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795396140;
	b=B/gRJfw0BvUs5ldw+vfoha68TijSFgCAojvml183k/oLwIPYDLnZCd8bim7RX4GgZl4E
	 8oq7ASm0hb5Ac4GltAvX2ERpfXYgf3FSlbC84FATaOg/5gVxsmzk3uxm646ywVP4l9ohU
	 JC7Cwh1anpldqI3fZ1WH45xXqKGPuTmmndOk2x9nuK+z8Rm/AirWFgZWchAFE7H/xPvYK
	 hNzwx90uUUwQi3A1rdBC9pgvAEDw+LYTwoYRj9OgtVxYj+2Tr2nDMhbbhKhw8gD9JXSBx
	 kyz03nRzoxb4Nm7yw4+DdUEUVzlawcf3gmsZY7mFRnfmW26tpX57BMK21grLSGbeXvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795396140;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=54suIHluMeZO/ufn4/dBIrDiE7/KVFZ3u4m3JUaSiGc=;
	b=mFXOX//Y414qUeWO8kH+SQN8LukPPtTGfQHXhs43Ad+AMjlB/OOyFWdncukuj7eloEzZ
	 vrk4cMEXALE/L0DcSprBieD96lNpqhSNEAWMZo76z094qXBW2UPIwIc6mBtbGIT3znl9y
	 lcql+wp3vV85lt69wge4ax+lG5zl5cJDHZLAolzT8GJGTV+my4LAgTcq0GqfxqE9Wrezj
	 OiHPryxjGXcBlzjm6ncPKK+qPlyXucNSL1o0HQwH/JY+t+CaIpnOqDHe6oC9UjXA4KTkQ
	 Yh2yvGubPAEqwPKrrByIK7V1g00/+C6SxLhrwQoHGiX7SI9mj9QOtjszE/W9btOv3Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HF9uETWv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4B333606A31A;
	Mon, 23 Nov 2026 01:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HF9uETWv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5FAE31F000C0;
	Mon, 23 Nov 2026 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795396140;
	bh=54suIHluMeZO/ufn4/dBIrDiE7/KVFZ3u4m3JUaSiGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HF9uETWvgDgCbmGGppAFO03CUDvTiOIhaCY09lktVw3xBo+nBNXLRW9vgavEdg8Yq
	 w6jb69qUgfdhMLLUmmEukONSxkeSOgm4ac11L4U2+6RHH7AfddReVAfDbiWC20UZJ1
	 ObzV8+KU9EaJEEKwf9vQ0MB3DAwy3F+GuZAUWZiOM7AyEKWqXvrFk7f7TpuEGttoN4
	 Fy8mjA8UXStRyDAuKWmm+xzq5TtrHIVGOHkgItUyaQRjYNC63yXCwvcjmrZVfvnU/t
	 +zElr+nCAMWfHgU4XzXa9pP0+2Ljdb0uQglf4xGcMb1ZolxErN/TPOiWi0uas5nrft
	 DoyDlnL5SNLMA==
Date: Mon, 23 Nov 2026 03:08:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOSKAvA-65pF3kw@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
 <awOHVCpztLQv4Uwv@kernel.org>
 <awOIIuoNvNLZ_scF@kernel.org>
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
In-Reply-To: <awOIIuoNvNLZ_scF@kernel.org>

On Mon, Nov 23, 2026 at 02:26:14AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:22:49AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > > SYSCALLS
> > > > > ========
> > > > > 
> > > > > Two new system calls are proposed:
> > > > > 
> > > > > 1. userland_open(): open an opaque staircase-initialized container
> > > > >    object (modeled on Intel SGX enclave initialization with separate
> > > > >    build and live states) with no embryonic state, opting selected
> > > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > > >    extents for a container user namespace in a single atomic system
> > > > >    call.
> > > > 
> > > > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > > > 
> > > > An alternative to userland_open() would a file e.g., virtual device
> > > > file, and necessary wiring for open().
> > > > 
> > > > Then the added syscall surface would reduce only to userns_set_idmap(),
> > > > and it adds more robustness to access control (e.g. who can create
> > > > containers).
> > > > 
> > > > What do you think of this?
> > > 
> > > Also, easy way to detect the feature. This does make sense to me.
> > 
> > This as a side-effect would enable LKM compilation, and reorganization
> > of the beef of the core feature as a driver. Not sure what would be
> > the best location for the driver tho, perhaps just drivers/userland.
> > 
> > I.e., full decoupling from the syscalls.
> 
> Right, and LKMs are great for live patching. This has enough quantative
> weight.

Not actually sure given clone flags etc. if detachment is doable, or
even if it can be, makes sense. Likely not so great idea after all,
after thinking this for a while  (at least not in this form).

Br, Jarkko
