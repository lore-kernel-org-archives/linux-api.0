Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795862203;
	b=IpJ59F8sJDn5LwSCQOSXoa39enmH8IJxMKsjD5GxYVaubKtNMcC7Zt2LK2J3KM0y6oO0
	 aFs0MTkFxIcBes08Nwz0wQoDYZ7TtV6nFCBlxYD0E5cbEe09WazVLrG6S/QXdvuo8a9AY
	 scHb4Tsmqo8YrtCxcIWwr83/a3n0G8BthiMg8YtdwLW57+MQOtxH/LJTuShOntGoc40G1
	 TM/NI794LBG/DcVUYhp6DjMeDIfxg0O7/aTF8gMVPj2wgEVhnOLO1CDTFxbu56+xhTkJi
	 86CLdybCmKELn3g7JGs/OdQb6xyjxCtV1CAi6ilUAZt3L6cmYQ5d4cXpdOjObW+ugPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795862203;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=3C9fX4TIO80ht8xlUhmpeoykwcnqNbqprrFt/B+wKJc=;
	b=feJq4ES2Fx8ZD4HszVzbNWr+JiHCT82Ur4ip9of0ADwxRWzUmumtgQkXqEhadfeCCVJi
	 thkPUZL8LM6NWHAipTPmoweS32uDM/Cb6wPhju+BVQA1RZx52w0czJFhT932K1I1D+LQI
	 v/8rpo/RZqgQwUQEdsMnfusPonpjxFngA9VPt9r+KbrvfF0Gv+dYbX0Do+Rk/KsxqPvtE
	 Q6nObNR0Xi62FMO/8+pUjFlAVHkDim3QbG/sneANsPPM8Mpif1ZoBpSycNmhSMdliAR9M
	 pY1jAELS2nvvgdKSl/cRJBmxfzGm+q6t6UiJqwXbHKPzS2gw2TjstmQO8XUWC3waaPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfjJUrS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 2B14A606A31C;
	Sat, 28 Nov 2026 10:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfjJUrS3
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 057F61F00893;
	Sat, 28 Nov 2026 10:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795862202;
	bh=3C9fX4TIO80ht8xlUhmpeoykwcnqNbqprrFt/B+wKJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cfjJUrS3gUBp7Dj8bg4xSg/pcM8dtIiFwpRZtQI3hkfgOAOpj1rtAPl8EcrkgC6Yi
	 zF07mAyFPCnZBzmmYeYAJwOQBoS+Zm3JsVmcaKjKX3kQZUkiY+4E4oOgfiGSGsYo8D
	 sqv5rnd8NE4FuW168wtBtZ5sx3OUiC4ISi3UeCtp8USTmKeJN7zvOdUYZ/Wv8IPeKW
	 06Dk8OPl+36CxYkf8QRtAGB2kqhRbNtcSWPsNh5fFRMVGM627+sc3qaANYIHviDCqf
	 j+QZkklHBewmwUrwk9T2v6rua/o6Wrozl99k9QloP7arJXXV0RSFJnE2PNyYxhWrvZ
	 SnPGJ2wfA5hPA==
Date: Sat, 28 Nov 2026 12:36:39 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awqut63HdrL97iu3@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
 <awqkft-e6Tbj7dbJ@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awqkft-e6Tbj7dbJ@kernel.org>

On Sat, Nov 28, 2026 at 11:53:06AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> > On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > thinking more sequencing than data structures. I.e. I have a game where
> > > I need to end up to process creation without embryonic state, and add
> > > just enough weight to kernel to support that outcome, and that leads
> > > to ~2K'ish LOC of extra kernel complexity.
> > 
> > So you don't have embryonic state? I don't like this.
> > 
> > Let's assume the following situation. Userland's PID 1 is already running.
> > Our container manager attempts to spawn yet another process into userland.
> > As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> > and then execve.
> > This creates time hole when there is process, which already runs inside
> > userland (i. e. its PID namespace and other namespaces), but runs
> > container manager's binary and have container manager's mm.
> > This invites for bugs. Other processes, which already run inside userland,
> > may somehow take advantage of this.
> > For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> > Privilege Escalation to Host Root"
> > of https://brauner.io/2019/02/12/privileged-containers.html .
> > So, here I like embryos.
> 
> We all have things that I like but let's talk about facts instead.
> 
> CVE-2019-5736 was also not a sibling process racing the pre-execve
> window: it happened inside execve() itself via binfmt_script resolving
> container-controlled #!/proc/self/exe.
> 
> CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
> CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
> namespace, and resets exec_state->dumpable to suid_dumpable (0) when
> installing userland->user_ns. Until execve(), ptrace_may_access() checks
> CAP_SYS_PTRACE against the outer user_ns, so processes inside the
> userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.

The build phase on struct userland (USERLAND_INIT, before any task
exists) lets clone3(CLONE_INTO_USERLAND) stay an atomic copy_process()
step and execve() stay as it is.

It fully lives in the *pre-existing syscall paths*".

Br, Jarkko
