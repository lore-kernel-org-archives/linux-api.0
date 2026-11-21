Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795284759;
	b=Y5fnf9Hw4gF0KHFNg3vBFtpt414VbhOBI3RRgKIMa04hF1dOUUsPs/WhH+8dM/AQtGOh
	 LahomGVo/9Hm4mORzfawlQFn1XOhiQdA6qO6kqwmIla/djuCOJrN2U4rRX12uEnpide+e
	 +AnFvhtiYK3k3J+uxpW8YPXyk3cbaFwL2Uq6GXJeo1c7hZxtHPfAjNgLj+67i4yusfR+G
	 CLIBxwHlSoPZADG7Q+LNSg5Eb2RZ9eaNivZUjyfHZcVsNx2oskVO/Idvqk+whqRF5lJsZ
	 yps56OzzhGJbCZaTLbAK+D+n6GDJshWrW/v7lsBSABA4iOaoUvPqBv8JYUcYIbZr4kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795284759;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ykgUhZMzGN/x6qhqJXjutPzw/2bCyhgJYf32RJRH3+8=;
	b=XDU3JOIArsnq05JusHgUDLrYo9vnIO+w0idyPp8CMGBEyisPN3Z2HQacLFqVNk5+jupm
	 qXYjLTKQuOjaz2DgD+Jushvse6uJhLZpzh+JVZ7pxg1U+wMI8owXhg6mQWSeAUr3RWTfd
	 Dy9ao+9iJOZxnRi4zxz4dA9b3loPQtK4NVLIx7gagxIeNx9+QBariss6qSZfwSP+eiZaZ
	 y0hQo1+sZwojRmRv1SRmX9fdCkkKSJmKrVJLMPg5v2fsdH11uRn6VREjY15645DNFI+bM
	 H7IgAyIHl3u4hmCmHuCmwlSrc4cEB6JJaqdGnSvzsnVHTgHP51eOP7BEVxL6tL5WRiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gizXyHcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 357DF606A320;
	Sat, 21 Nov 2026 18:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gizXyHcG
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC9AB1F000C0;
	Sat, 21 Nov 2026 18:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795284758;
	bh=ykgUhZMzGN/x6qhqJXjutPzw/2bCyhgJYf32RJRH3+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gizXyHcGyrGFgvHEvIb9lBxy4s1YyUMohTsz1YR1Kjs4SBFw7IQhXrX2OT1wM3S5u
	 UzRI3Gypn4jjecAF62TMtKRjzuWDeJKF3tHlEkR8dHOQO71qen2XaMaRXuZ2JwxGe3
	 SUFeClDq3oJQk0WXNB5Ijq4r/aiPanGP+qW2kCO69BVJyeM8uDii2aPFbmtzCctv5M
	 edz8R1joRKw3mfPuioJyw3oDqceUDETJpPLdiPZL9XazsMe4uyyTuoYRGE3drNdEvu
	 3xDY8vdIAOR/GMOSD8oHVS7BRyXA2i/6lRMXxIclEY+fZP9bJot+0RauhBALLOEWHD
	 xxyHgZ7Fzhbrw==
Date: Sat, 21 Nov 2026 20:12:34 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
Message-ID: <awHfEvlmG8XEGaam@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-4-jarkko@kernel.org>
 <awG_nK9E-UjkVgK6@kernel.org>
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
In-Reply-To: <awG_nK9E-UjkVgK6@kernel.org>

On Sat, Nov 21, 2026 at 05:58:24PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:22AM +0200, Jarkko Sakkinen wrote:
> > Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
> > system call tables and asm-generic unistd.h.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > ---
> >  arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
> >  arch/arm/tools/syscall.tbl                  | 1 +
> >  arch/arm64/tools/syscall_32.tbl             | 1 +
> >  arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
> >  arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
> >  arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
> >  arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
> >  arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
> >  arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
> >  arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
> >  arch/s390/kernel/syscalls/syscall.tbl       | 1 +
> >  arch/sh/kernel/syscalls/syscall.tbl         | 1 +
> >  arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
> >  arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
> >  arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
> >  arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
> >  include/uapi/asm-generic/unistd.h           | 6 +++++-
> >  scripts/syscall.tbl                         | 1 +
> >  18 files changed, 22 insertions(+), 1 deletion(-)
> 
> I'll populate remaining arch's at the time when I split this. It has
> enough coverage for the time being.

Ugh, I have all populated but I found some other issues to fixup while
checking this.

Br, Jarkko
