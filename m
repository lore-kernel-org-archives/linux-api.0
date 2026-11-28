Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795859900;
	b=t9HzaQkdceO5HfDoA8Hag0IOObu9em1YWo4wGGTKICwFu3Gzw4PXmI73K83ysKFt+7Nc
	 2fOMXw024GqNVYH3fVLEEFoLnM44GIWmjDdMiH57Xhx+Qe3pyYYX2K1UpY79tKPLUxkae
	 94HmwFxaLFWA9wyihMTUCs7MtxHKMaYPvfeJ1LuZRnPyMdn3gyaQ2+/BpWhJN3HCjflly
	 ZdJ5eJ0oFEqafx8guyrEF9yLu2lj7hGTb8s1rSEQBgO0AaGy3HhOw65qYDIkbUOC66zv1
	 nsOEi1JPwGMlTf6ZYeUR6a0XAPikt+yveojqtunZqwfWtzQki1Q8VjlKB9TTw4hh3IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795859900;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=gypr9ixdbwpXyRQHyLVcFcYrxT1qcpmfLiBbRjpRDO8=;
	b=rfHBaS+2VlklEyl6YM0BwFCNxXBD/puduE1V+XIg5svkuiAk29rQORMoW6oNMJGZ+Uoe
	 jnXier8aR5WHMXNVlZUf8k9bsZaIDcqVaZOk0mviH3aiSQuUDVXBQHZcBPo8xDNVgkg82
	 ZQGiCp+yegQDX0ecD4XtDoZVRWENgebVhVJx+0Nt9xi3Q1pBhjCz7L+9pB2dkHE0B8oGC
	 8Et4FoUXmmu3RFoawHRBc7fOnHo5P290kNOhu9cjxRfbV77mxKwrURaRMcety15LN5IXb
	 b9Qd24rknnrNA/fFoNbilRFIYrCRtuJyCYD8x0E9gPfd4iW26jNE0KMRWDtRpu9fRRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xh9t4AGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C2940606A31C;
	Sat, 28 Nov 2026 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xh9t4AGi
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 65CE81F00898;
	Sat, 28 Nov 2026 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859900;
	bh=gypr9ixdbwpXyRQHyLVcFcYrxT1qcpmfLiBbRjpRDO8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xh9t4AGiLURm38vb2SU1trvChHI7gbr2j2mr89kBMmMObRqPqFb31H/Df4kMoB/QE
	 DTFrZCWcUEejYMMyf6uta0gZ1r5vlFftz5vvG1cN/u5TrwQsJYlqCJQy3985JyPZXl
	 apHx6xspTchoq4W7I8KvgHK/Hyof2wsym7vgH37qxLOTL5W1cWYCIhFm2lyesYk8R9
	 Kp0flMcZ/JKT9hHiBRBpIy3ZI+RZWDyhlwPP4rXzSm7o1dCytu8uI5iSFUHRj8LFZW
	 IVo4JQQxND28kNGxFoK6c4cDpAug7siQfOYddho75iEl1+NIV9JjSbrMQzX+NeACTy
	 NmQ3tcw1clb2g==
Date: Sat, 28 Nov 2026 11:58:16 +0200
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
Message-ID: <awqluHWbXWeNvUeS@kernel.org>
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

I mean just saying but wwanting an embryonic task state in Linux is
backwards architecturally for any possible topic.

Br, Jarkko
