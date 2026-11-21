Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795288364;
	b=AjZSn+kudy0KFlGMigzWQkJ9n55yXe1rVvPTP3MLt/QMEYO62dKrpoG/IQBh36aEeMXR
	 7WWTY/k4KHYWV4KPUblDg8D4/fmMv6wXJ++vqIbqLaL+K+ZfRDG3YE7NPB3ImhgzdN4iv
	 ec4o/Ai2Foe2IGRG8mdgdLN/tuwDug5XeCfIcCioxVlwpinADLBrjGA3j6IYZirsk3Imi
	 UjZpyvNcarqqUF4Ogj0PRs72VJXivwsc7YaMAxi/qr+FWYlYiqCmyVGdK6vNqKnnUNbPA
	 8ectZLgd7JBia+6mF2e3xRZfH7y+GHjvbXS+GiWv3SVjBC/5SPCsa+HYwZigQmPFvFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795288364;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=75J+TPV4gUTQlMal80OEqhZTuIvyo01lM/tzLCah7ac=;
	b=CZJEOXhVMI+pCjZ1cjcsuioJ0xuFhrV1eCAyxfzdEhvLRk9zLsJuM703+OQszQ1CLXUI
	 mK+8t4Sp6Sf7GfOnqYM9TiYRlyKxh886N22SQNz8Z5Gc/M2hMy8aAwCBgKX9ijv7ZU+OW
	 FHqfTRithJXXFDzYBRc+25ZmkuxsadGTiMFxUqkvVKWKeUJ0cna/H4SNkWMbW+RpBkwcP
	 4MwCah4P0bl937YqLx6+pSuKKF3ajb8kBkcH3lLUiXC9UD1DUqLDYnKRFGwCvBwpba73A
	 8ZAimO32N2BQ5FwVnop44b9FNet5Lv9ElXgq887+jJXSmfH7IgYNDPQn5+EKq/u7m3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W34Ribl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 848EF606A32A;
	Sat, 21 Nov 2026 19:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W34Ribl0
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8E93B1F000C6;
	Sat, 21 Nov 2026 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795288364;
	bh=75J+TPV4gUTQlMal80OEqhZTuIvyo01lM/tzLCah7ac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W34Ribl0z+7v1iFlGB13v8z4TgYNiMd+GVWrEW8Fx8AMnkQrg6P+VOBP5vlnJfkLE
	 kbLJA7xiGiPh0mPVcF3J1GBshtd3l1vOB1EjXO29Emfao1V88o+EPc3WQyIehYbx+/
	 6o7/jZGDLhwU6pt5IDamQKA0wSaik0am9reT73p1DVRQ1dVLJtXuHQ3IsDiUxayJrq
	 gcFJQiaaji47qcsJEDM4kAf4Z8UkS1t8Y1/T8eQrQhxHgYW5Vk8HRAhuDta0+xrglu
	 yXH4pJmYQKPHvutd2n4tEWoMapfHzpSlnd7OKjYNHnSbOOPkpchfCLpZZIf0f8Rj84
	 X6Yt3/s2KQ2Og==
Date: Sat, 21 Nov 2026 21:12:40 +0200
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
Message-ID: <awHtKMkyGEPTB17G@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
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
In-Reply-To: <awHsvz1vdlwsink0@kernel.org>

On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > Setting up an isolated namespace environment from a multithreaded
> > manager process currently requires helper processes to call unshare()
> > and pass file descriptors back over sockets.
> > 
> > Add the rootns() system call to allocate a detached rootns instance
> > owning a fresh user namespace alongside dedicated empty mount
> > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > namespaces, and return its control file descriptor. Finalize the nsproxy
> > time namespace and pin active references for the lifetime of the rootns.
> > 
> > Co-developed-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> Syscall name is outdated. I'll rename it as container_create(). Does
> not have to be final name, but is a better wip name.

Something more non-generic as it inevitably would collide to something
(did not check). I'll figure something out.

Br, Jarkko
