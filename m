Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290890;
	b=PFcUVTVigieH9H4Yud+p/gcBqVh+vJ0pVux+ltwLwgr9ennTBElbPd+eXDlj+mpIR4g6
	 93PXREgAviSNY4cs/7YsoEwhP3ND9pctLcMGbrGx6mXYGcRHbRblddoLeN8+XEfaW9X+Y
	 /JzBhRtq5QBvTcaBp3mdQZs+g9Hn3sSls/Vfz/MatnW8OGxQ8YAvslAVf29+QxKz/7dQ6
	 h38NjxhGiYoz5uczVZoD0CIRj5h6aEMtyB2v5BHcFstrHpO/rdBJkg80NBCvQgnWfyoMC
	 470+BKB7llPjlwoFzMaAAFnfxDkwVLftvjWIHAilB5LdX0p7hFjVDPMg8/1ImOSaB6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290890;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=k3pGh/Nf6VGkSVannc1t1HSa1H+w+EAysJ0+xryVXV8=;
	b=PPp0+sYjfmAA1SQt8rJl4ZlomQe24hYMteIILeXEOOpceDAaGzFyYYNj+7ULh91bzozb
	 IQCoYCYAh5WuXEN03S7/lemKSK48w7s9f7+eyXJapShzWVA+B6zWxc/R8+yR6Jg6XCS9b
	 3WgbrLRzw2iRR8LMDNPtSB0L8bktqOdDTI1DbFEe+FnBOvw5qFpBeKaLV0AQkHXXboi4O
	 tYPqh0HqtY30Mr6MTySiA3ZCJS9iySRQqJMO8RYp4AaIoaVTuZsmjQysGZgB6J/A0w+1Z
	 RgNTLllwMRiWpTP7HBcWFTy1oj44ZTjKXhq8miwvor0AAIC5uw8a5VKP75kNMZ4nQ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7Ozz2wb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2EE03606A320;
	Sat, 21 Nov 2026 19:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7Ozz2wb
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39FA31F000C4;
	Sat, 21 Nov 2026 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290889;
	bh=k3pGh/Nf6VGkSVannc1t1HSa1H+w+EAysJ0+xryVXV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d7Ozz2wbWDdWuTNONSLPuo43rI9mXsAtcpQviZ2TpeM6KVoRdztLFFZihLhC9YOo4
	 d3eKmkFXEetcuCZ9G4+sdWZl8ixRE02VNs2YBIZFvvc1sUUs84h1hu1NPNQyBSmI6g
	 Fb2SGh3KWHgnt/RWcd4GdMO6CEBCKUpRNfWJhey/ix8VC2+L2LTKCxGIZeGI8nNi4h
	 6HjCcVHNq35yMBZwBS3A4nM0Ubvt1DztlVj/Wr9djhOADA2T+ACJmy2JezPrKfzp7B
	 jXHaF8iQZkKNh+gpgb8nmCc6QFo/ofQ79XDWm6nmUbUZH82+u97zhW34GWT5nxZJHm
	 93jBTnsZk9nZw==
Date: Sat, 21 Nov 2026 21:54:45 +0200
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
Message-ID: <awH3BUHarwfCPJwi@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
 <awHtKMkyGEPTB17G@kernel.org>
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
In-Reply-To: <awHtKMkyGEPTB17G@kernel.org>

On Sat, Nov 21, 2026 at 09:12:44PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > > Setting up an isolated namespace environment from a multithreaded
> > > manager process currently requires helper processes to call unshare()
> > > and pass file descriptors back over sockets.
> > > 
> > > Add the rootns() system call to allocate a detached rootns instance
> > > owning a fresh user namespace alongside dedicated empty mount
> > > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > > namespaces, and return its control file descriptor. Finalize the nsproxy
> > > time namespace and pin active references for the lifetime of the rootns.
> > > 
> > > Co-developed-by: David Howells <dhowells@redhat.com>
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Syscall name is outdated. I'll rename it as container_create(). Does
> > not have to be final name, but is a better wip name.
> 
> Something more non-generic as it inevitably would collide to something
> (did not check). I'll figure something out.

At least for the next iteration I call the object as "vault" and rename the
syscall as vault_open(), and that is based on:

	$ cat /proc/kallsyms | sed -n '/call_meta__/p' | sed 's/.*call_meta__\(.*\)/\1/g; s/\(.*\)/SYS_\1 \1/; 1i #include <sys/syscall.h>' | gcc -E -P - | grep -v 'SYS_' | sort -n | uniq | grep _open
	240 mq_open
	298 perf_event_open
	434 pidfd_open

Br, Jarkko
