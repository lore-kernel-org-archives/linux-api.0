Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795859587;
	b=yHFpHWECK2Zxlks6JvSxg7dRkEbRPzm0KP5iz6/jliVnYkIzIBgu0f/LDNGqW7yo12kb
	 1N1mJqdDqajUHQslxZkeREQlGL7SB2f9atPgMsENaghLNPoF9+WlDjjjqlg/NBnN3TCV8
	 dRmdBVkaWlJPNtfWUXBhqg0ANqFKbE+7hdZ6z9JA96A8MQf8vNaC3niWR4wrEHmPjAUET
	 3Mjazqz6sMc0Nhu+4R78x5E1AxuBvJvE5Bf2Ms7daj/luV2n7nQYQ6OMRIEC8xOpfm2H/
	 bIb8K2i1Watxju7icV21/Hv/Oew+1gdswkCcs3uYmVbKOJR1/b4+9r/oA9HFyNBgz7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795859587;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=uuCJfxu+5v/s3T9HZYDDO4PQ78T7+CAZAP1vnBBAvlk=;
	b=DKnV45xERraCS/3urkMRt6Fi66FZeNubL110mp0L1rL8UJNLS3/RFwX8hDJgZE/XcZrG
	 3ZuDyOJ4F5gskYKDyyz9JHgby8VEvIF238dlGvc0Z7mSq/4WQ5JR+rjgVS14knc63WnWT
	 P2wLQ5nQ1+MQTo070Lm/niWvcWti7EOBL0z0p1RGnbMTOLqECCQAvqMW763stbk+AtPXr
	 j2xWVADX5AvFihCLFnUFbdrWRWbDOifggkipwJrq1XJL0m0yNEgqKs2mGj/X9+glO4OH2
	 AJgq7zhRe/qSKVfX36naVGNJp/TwjMrtFAdq8vezRV9glSEW0HSAdBIaYQg5DTHZLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O90bpdZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EBDA2606A332;
	Sat, 28 Nov 2026 09:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O90bpdZJ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6485B1F00898;
	Sat, 28 Nov 2026 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859586;
	bh=uuCJfxu+5v/s3T9HZYDDO4PQ78T7+CAZAP1vnBBAvlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O90bpdZJYUF4YtVEHRhxLIqAQcGy50tt88f4anF0VE/73UpKeNhLHD68p2I+WORMK
	 rah82jxUIvM05z0HQJ/7Gqht46duwVcWBAA4Oly/9mfXmO+FtP3AerdVZuhwSDsTND
	 qM0CwtmBy7HUavbGOi/u6v2oO6ryFERhYnwndigZHNCMKVkkArcGDjH2cQyn7u/Yxo
	 ch06xXxQT+3tv/6rc/cH79zuTzT4aXGnW4UDzq/DNhpOjsNAQ3DeH1WZiEw6CYGr70
	 9+Za9L+aD1Tujgq7wvwmbeuoir2+LQrCzVjdS4n48dDUNG4J7VG+DZVSNmaxFXrDCA
	 BIidWv+0lMYcA==
Date: Sat, 28 Nov 2026 11:53:02 +0200
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
Message-ID: <awqkft-e6Tbj7dbJ@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
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
In-Reply-To: <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>

On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > thinking more sequencing than data structures. I.e. I have a game where
> > I need to end up to process creation without embryonic state, and add
> > just enough weight to kernel to support that outcome, and that leads
> > to ~2K'ish LOC of extra kernel complexity.
> 
> So you don't have embryonic state? I don't like this.
> 
> Let's assume the following situation. Userland's PID 1 is already running.
> Our container manager attempts to spawn yet another process into userland.
> As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> and then execve.
> This creates time hole when there is process, which already runs inside
> userland (i. e. its PID namespace and other namespaces), but runs
> container manager's binary and have container manager's mm.
> This invites for bugs. Other processes, which already run inside userland,
> may somehow take advantage of this.
> For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> Privilege Escalation to Host Root"
> of https://brauner.io/2019/02/12/privileged-containers.html .
> So, here I like embryos.

We all have things that I like but let's talk about facts instead.

CVE-2019-5736 was also not a sibling process racing the pre-execve
window: it happened inside execve() itself via binfmt_script resolving
container-controlled #!/proc/self/exe.

CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
namespace, and resets exec_state->dumpable to suid_dumpable (0) when
installing userland->user_ns. Until execve(), ptrace_may_access() checks
CAP_SYS_PTRACE against the outer user_ns, so processes inside the
userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.


> 
> -- 
> Askar Safin

Br, Jarkko
