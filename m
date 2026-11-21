Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795292219;
	b=qM93Iqa3qBj3N5mBGj8jgCa0wQFXABFRUYf8qucW5u4oIgDR8U6E8JAORwgD2ny/E+Jy
	 3+5RZ+lImWF1RMM2w+o8DzcPZWe6yjH6pzXjIwuNEVcpUoc6qc6Nm3EtwZOaOsTg1RLHX
	 rByJtFkqRWA8F9SVH9bhTQlH5USPfimxXzXZ0tG+uzscXhcVCCrchEGrIGdaIXfyV7XiH
	 mzfBWeltHr7Fa8sTANkkNUwdHRovRGBbxjxjFCcakiwW7bpGBj56y2TgduPGV5OzlQYZk
	 aufWzr6FBWOMzy4FJUwbla5+nM6MPIdoG8FVMrY/ovok/eIBGBpNG/VWgq/8PstptHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795292219;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WCBP8JNN9LhYmA42mMEQijOkZabItzYoL6U32M5rD5U=;
	b=c4Gdg/hmcgTuAB+fnVOTSmTpVeGvK3YbUhqoc3sUvRE6IsuDAUY8P1Z0CoqRGL2m+2Is
	 KLm6u5t53J7FxtYZWX11N3F4FDiVfcslFoSVENthG6Qb3mZkQAM9xxVog23SIU0VexXaG
	 yGHfnYiz2CY369WhoFUdIVt5RNAJuzRyaHoO4QY2DnFVtB0VJlxjwCDXzlfwoerlxhVr0
	 9MJFqqnJGdbGYwin8sXTv1s8D4NB8i65GBhIAa69k24/zGFuPvBxhEuC692NSBGldWnAk
	 5WVtLyT+2qQFBGJzCUpAS9pZQr8M1DBaCZ7g/uHmfbABzKbB+YpStBQ4NNmicSwZJFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awKUlLbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 12A33606A320;
	Sat, 21 Nov 2026 20:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awKUlLbv
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24FC01F000C0;
	Sat, 21 Nov 2026 20:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795292218;
	bh=WCBP8JNN9LhYmA42mMEQijOkZabItzYoL6U32M5rD5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=awKUlLbvP1S0RSzq6or2hZk+BFppVeROah3E6sRNOD8PhwN/YJIWZpiBtcRyolg/T
	 OAor4bxjQjxffQ2cWBYSzf+63SP3VWuAFwgbj5r1R8nWBvFl0qsUuXzRDQrkVAzDwV
	 4dtkFBBRR2QZ+lmw2F8tH4liqDs/uESzlGjQXBgpRCOVdHoZucHE/KRjglh51qB0Ro
	 /HfEC2+MWTkQpXSu7fSpGg2hbdcqX6hRvudPt9RKoDxJ/ULfNU+vmQPE2IQU4gW6nG
	 HWsg1YjK73T7okHlUCt6GK0kxjkG2SsceSqSICwvFSPIs/1O8o0LWRsbEmSw8S5gyc
	 Kh+ZH6SteCe3w==
Date: Sat, 21 Nov 2026 22:16:54 +0200
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
Subject: Re: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Message-ID: <awH8NsS5dH7FTDPv@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
 <awHtKMkyGEPTB17G@kernel.org>
 <awH3BUHarwfCPJwi@kernel.org>
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
In-Reply-To: <awH3BUHarwfCPJwi@kernel.org>

On Sat, Nov 21, 2026 at 09:54:50PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 09:12:44PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> > > On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > > > Setting up an isolated namespace environment from a multithreaded
> > > > manager process currently requires helper processes to call unshare()
> > > > and pass file descriptors back over sockets.
> > > > 
> > > > Add the rootns() system call to allocate a detached rootns instance
> > > > owning a fresh user namespace alongside dedicated empty mount
> > > > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > > > namespaces, and return its control file descriptor. Finalize the nsproxy
> > > > time namespace and pin active references for the lifetime of the rootns.
> > > > 
> > > > Co-developed-by: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > Syscall name is outdated. I'll rename it as container_create(). Does
> > > not have to be final name, but is a better wip name.
> > 
> > Something more non-generic as it inevitably would collide to something
> > (did not check). I'll figure something out.
> 
> At least for the next iteration I call the object as "vault" and rename the
> syscall as vault_open(), and that is based on:
> 
> 	$ cat /proc/kallsyms | sed -n '/call_meta__/p' | sed 's/.*call_meta__\(.*\)/\1/g; s/\(.*\)/SYS_\1 \1/; 1i #include <sys/syscall.h>' | gcc -E -P - | grep -v 'SYS_' | sort -n | uniq | grep _open
> 	240 mq_open
> 	298 perf_event_open
> 	434 pidfd_open

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

Br, Jarkko
