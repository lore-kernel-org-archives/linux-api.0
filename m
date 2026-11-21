Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795276704;
	b=frhmcBqQhzf9tTfl159M2JmUkFOnJ+qs8w0PBKKkYORMEMfOPOAw3Mi5D4v/ap7veD1a
	 tRKaz7tNkErnIS/hn1I9UqBHdYjxszss1Xnhi7Ie3ZPwUjviz7qGqHKT9QTX2y+07KHa5
	 N7YSz2h8Il3Beu6j8mfln+N3rpjJFmDcnURn5f3Z/Ac53Sb4190OUrDOhVUSVr8nUC1Ot
	 YoTCKIpBs7BTlByYDXr2dpqcLJflj3GWINqUWyuwOFOyyb5AMVZE4e6RpdW209l6IBaoz
	 onpWOJbD6hAlRTjs+DvwrYNicYC/nRWow9MuPjwxP2xG8+0DU4ghHLVSgd5hKWb3OSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795276704;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=v59nU/2/9ru5K4MWt6NBStp2evSJmM0oxZDWWYQAtDI=;
	b=0JL6xAV00bIeAmdy65OkntNQ6/gOve1YRLAsgo1ifLPBGfQPLTSnuz5mMRUFf2cLgM9J
	 843QfDOMijL3/d9UWWPwjz4am5I0p1fPBhLb0NKqEVxvrJOd5JfmFDoMhJ2gsbUNOSe/B
	 AIGxBhTkRsR4Xwav0rvvwb7rCI9t78aJFiMY77FlgLMkb1H+6EDETWzHi+BZfuDy++Nhm
	 uKca+VTEjwluL8NnNjutu7RvpQyb0QvTiZ2A4NMjSRHHObHVPq/z3VW76lblva3b8615h
	 J4sz7mMfnQisiF/hsE5YTlJTHMTngN8x5gDzQ7zBPcynP8boBjpaV7brbJVR3pUmn3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U08EaliS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 97BD2606A320;
	Sat, 21 Nov 2026 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U08EaliS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CCAC31F000CA;
	Sat, 21 Nov 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795276704;
	bh=v59nU/2/9ru5K4MWt6NBStp2evSJmM0oxZDWWYQAtDI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U08EaliSbWubcMuaRUSpPl/xtocKTKRG5+LWCQtIwOvf1KyYvw7cQGTtMNjwQj+jx
	 Ng4QuX/N5lAp9jx7j2hYITxmWQlgrLoVVYa7nA2uyLxoanOfvKHnmbqHjP3p/WCFrD
	 wR2GLYIVuzGz9NvoACIKUCu691qClsGC87Em4zfKUaOoSmXlVErC63uKS9A8IKcQXV
	 JshEx6xACR1YzyWXaG3Je89a0VlL+//Y5PN4Fs+llD0UvUh/DHsT+RER+LdFLuuIYI
	 qeEI4tunehkM1Hw5Lm2kKHa7grtpMKogAQdxNcFXoeymOIsJD6zKuEuZzxuJLG15Uh
	 +W0MW70agCpIw==
Date: Sat, 21 Nov 2026 17:58:20 +0200
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
Message-ID: <awG_nK9E-UjkVgK6@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-4-jarkko@kernel.org>
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
In-Reply-To: <20261121000844.1863324-4-jarkko@kernel.org>

On Sat, Nov 21, 2026 at 02:08:22AM +0200, Jarkko Sakkinen wrote:
> Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
> system call tables and asm-generic unistd.h.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
>  arch/arm/tools/syscall.tbl                  | 1 +
>  arch/arm64/tools/syscall_32.tbl             | 1 +
>  arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
>  arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
>  arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
>  arch/s390/kernel/syscalls/syscall.tbl       | 1 +
>  arch/sh/kernel/syscalls/syscall.tbl         | 1 +
>  arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
>  arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
>  arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
>  include/uapi/asm-generic/unistd.h           | 6 +++++-
>  scripts/syscall.tbl                         | 1 +
>  18 files changed, 22 insertions(+), 1 deletion(-)

I'll populate remaining arch's at the time when I split this. It has
enough coverage for the time being.

Br, Jarkko
