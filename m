Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795865173;
	b=ZBdvYUDt69J5wZyyWxSxmS7ccnPlRcPAN3ITLKkYwKo5xKPGockSXxXCaWgWTDWAcWOH
	 aC773z8ORXofDhaIiyh/GNMDGL+LSnMj08gifuEzUxjDQVEiOMOEJuGgU0RtUhbTgybP6
	 KRN3AyrnQJ0a1bAWn5RcwLn3jPAMWEloUjgtejSmKZVF8QvJIuP3p4d3Kg/mMOHu/5Zl8
	 JcHBk06+92nPj/AiaU8YLy1n/aXe/DkLEJt0xNJuEhtp9T4QKt5v5q8J4cMcdJI3c2WGz
	 F53auuPq4oBQGfVBLxlB7FWd1KeOznY5D9XymblxEtooo/csEboPXvtnOVNUKkiWPuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795865173;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=KleLQMep/ikw4l22dunyzk0OW7JrxNRSqCmyhew0bn8=;
	b=Tq65g5NzXXcSoOT1wHlNFZ9SvlnUQqdKw4kH0oKr13x3kW2B2lvFaJz6+AkXrrE1JsAo
	 p66VjCZdQGJlpdG2rwJZ5Iu7THtK3k45YXmVd2rfVFwRU83HpYNB5CWf1BgpZ5lM0Sx++
	 DxL7vTk40LXRbqMVDc9GDW8A71Wdib+WZ8wfrouQ2RPpDTs6oJKIeC6hPHBSxBXnQ3zam
	 6WTsZwtBtG+My7/qidow9BQn5opAnAknsjJCmjfaWauZrAjqB8IqidAPu+slnxYUwtgUp
	 m9g3ZouSDIBJDNgbGCt1mvLcoAKdLkspQCAklhXI11LRqciMiSNANfbR69sPP+tx3VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dX/0MpPr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7F7A9606A336;
	Sat, 28 Nov 2026 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dX/0MpPr
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A14C91F00919;
	Sat, 28 Nov 2026 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795865173;
	bh=KleLQMep/ikw4l22dunyzk0OW7JrxNRSqCmyhew0bn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dX/0MpPrnSdz78o1T/PxNhqtu2r3DoNwoRBz44tLf+5obQ2HIKuWyBogTE8yATYqf
	 PvZtAEUPlcWWrh2QsYKHgbBNx6hLM+Hh5XJj0jv4NrO9VatW2715WZ/uJn/UtDk9nL
	 cvKzyN4a+Zurt0NbdZAmGX76PtVIJ8SpBplJixw5SgRT3Wb2qrH1bB4aam3uvF1Ci6
	 lV4+C1VUq/6GLaxJqQNibuoOTI+GbCeEz1fkXsauRv6zUnfa0tQODeQbqJ47LyziJf
	 PACLGJbeUdbkeO02ICL/RvuHPM1bJuGKz59wWd1d7YEBiCg5aHftwtHeolG7KBnl1O
	 +66cHW3diWvDQ==
Date: Sat, 28 Nov 2026 13:26:09 +0200
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
Message-ID: <awq6UXILgmgWY3Fn@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
 <awqkft-e6Tbj7dbJ@kernel.org>
 <awqut63HdrL97iu3@kernel.org>
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
In-Reply-To: <awqut63HdrL97iu3@kernel.org>

On Sat, Nov 28, 2026 at 12:36:43PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 11:53:06AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> > > On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > > > thinking more sequencing than data structures. I.e. I have a game where
> > > > I need to end up to process creation without embryonic state, and add
> > > > just enough weight to kernel to support that outcome, and that leads
> > > > to ~2K'ish LOC of extra kernel complexity.
> > > 
> > > So you don't have embryonic state? I don't like this.
> > > 
> > > Let's assume the following situation. Userland's PID 1 is already running.
> > > Our container manager attempts to spawn yet another process into userland.
> > > As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> > > and then execve.
> > > This creates time hole when there is process, which already runs inside
> > > userland (i. e. its PID namespace and other namespaces), but runs
> > > container manager's binary and have container manager's mm.
> > > This invites for bugs. Other processes, which already run inside userland,
> > > may somehow take advantage of this.
> > > For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> > > Privilege Escalation to Host Root"
> > > of https://brauner.io/2019/02/12/privileged-containers.html .
> > > So, here I like embryos.
> > 
> > We all have things that I like but let's talk about facts instead.
> > 
> > CVE-2019-5736 was also not a sibling process racing the pre-execve
> > window: it happened inside execve() itself via binfmt_script resolving
> > container-controlled #!/proc/self/exe.
> > 
> > CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
> > CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
> > namespace, and resets exec_state->dumpable to suid_dumpable (0) when
> > installing userland->user_ns. Until execve(), ptrace_may_access() checks
> > CAP_SYS_PTRACE against the outer user_ns, so processes inside the
> > userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.
> 
> The build phase on struct userland (USERLAND_INIT, before any task
> exists) lets clone3(CLONE_INTO_USERLAND) stay an atomic copy_process()
> step and execve() stay as it is.
> 
> It fully lives in the *pre-existing syscall paths*".

Noteworthy addition: this is also optimal for pre-existing LSM
infrastructure, as less you diverge better the pre-existing policies
can protect (and less there's need for change in e.g., SELinux
policies).

Br, Jarkko
