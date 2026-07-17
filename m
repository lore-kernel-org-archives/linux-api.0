Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033C3E3C5A;
	Fri, 17 Jul 2026 09:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784282077; cv=none; b=s1lrS2Ic/fYcLtIL28Pl0TW1j5oL61gMT0eWOTp1jkKvaUFhOcs+Fqs398S/VRHddNZ6nmHqdslAsa8QRfu49l1kyXdFWzWsUmfbaQuYiAsj1gICTJjU4tUNteQw0G7ugn/dkzqlrKNhc+fFFR7xe0jCHyiPpT/mJyQlx4+qg+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784282077; c=relaxed/simple;
	bh=2vQSwiYdqJHwqjVWMWmOVkanK8eGoz7Aw+JcEikRfQQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=P3QFGV2ADDTTtn9KnnSA9hBAjVwsmAqg1kxu7dHRqLajHoEYWMgcldp5ELTkdhP28wd33JcyjXMla32CK3gAhlMxslVCb3Pr906D8esIw15R3Tu3XRLbMYf5Xlg2lyyYG3+j5bTreh1t45WOQyD2I1DiIBlGuYVs8wWKyUakx5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUinIf0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUinIf0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACF61F000E9;
	Fri, 17 Jul 2026 09:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784282075;
	bh=vXgsiHtFRkK52czGER19jIJR6pefjmZ1DtKsWwYJ9n8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=gUinIf0KMnH41IxKr2wsDsG/Qzo/vjJrCtGiKv9bz6DEOYpWJo09oomyyqbEaLQqs
	 5iaU/7YlGyVuPGC/UsO22hHHOPBsA+tTGY3xsaS0vFG6uMWI+5RfN5O4dmZXdVPDVI
	 NQPsn5CsTCOB2Ww9nRKgGwt4wpZq9oBLPJnpXb1ymRMmTfq4KzhF/21XHJURg4zZdX
	 HpiKXKZgwKrENhwtdTjdpwevw/eLH697AmNy5zxVa33+dBOlAUgvs1YDPQHN11+Cg4
	 RrifQjsm8HN5S1zhVm253xeAqRd/aDiSZ4l5c7S/MhyF92xPivSY1zP0l8TCGNnQGD
	 /EyyQhul8QwvA==
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/3] elf: load the main program from AT_EXECFD
From: Christian Brauner <brauner@kernel.org>
To: Florian Weimer <fweimer@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>, 
 Carlos O'Donell <carlos@redhat.com>, libc-alpha@sourceware.org, 
 linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <874ihyypvp.fsf@oldenburg.str.redhat.com>
References: <20260715-work-glibc-binfmt_misc-v1-0-b3b14336e664@kernel.org>
 <lhucxwoqzlu.fsf@oldenburg.str.redhat.com>
 <20260715-feuilleton-lautlos-anzweifeln-2117c47bf100@brauner>
 <87ik6fymha.fsf@oldenburg.str.redhat.com>
 <20260717-heilpflanzen-mondschein-dackel-bb9dc1dbe965@brauner>
 <874ihyypvp.fsf@oldenburg.str.redhat.com>
Date: Fri, 17 Jul 2026 11:53:20 +0200
Message-Id: <20260717-hebung-geimpft-vorweg-5872f9bd829e@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=4703; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2vQSwiYdqJHwqjVWMWmOVkanK8eGoz7Aw+JcEikRfQQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRF/p73ui3p0o/E0zYi0p+VZwqtFzyxvTzZZcczV8tn2
 74cvvB7S0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEVvAy/FP5pXfK5GxcD+tJ
 37k1abLXWS+wK6lWhMvVz990OuNb8AdGhhupH2ZEhl4LjZzOU2nt9KTlkfvE50y3+yzDNLzv22x
 sZAAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

> > At first I was very confused about this proposal but I think I
> > understand what you are after now. Your point is that we shouldn't just
> > fix argv like in my proposal but actually even fix the exe file and
> > remap.
> 
> Not sure about remap.  But I think to turn this into an it-just-works
> solution, we need to fix /proc/self/exe and the auxiliary vector.

Yes.

> 
> > So I think doing this purely in userspace isn't doable. The restore
> > parts can fix everything except the exe link. PR_SET_MM_MAP requires
> > capabilities in the relevant user namespace for the exe file. That makes
> > it pretty useless for us. And dropping that capability requirement isn't
> > feasible, I think. LSMs and audit trust the exe link, so an uncapped
> > exe file would let any process masquerade as an arbitrary executable.
> 
> Is the latter really a problem?

I remember that I spoke out against this about 5 years ago when I merged
CAP_CHECKPOINT_RESTORE. I think changing it is something we can try but
it would take a while.

Extending binfmt_misc to do it as an option when registering a binfmt
handler is way easier imho (and simpler).

> > Everything else (the entire saved auxv, the start/end_code/data, brk and
> > stack markers) is validated but requires no capability at all. So an
> > unprivileged ld.so can already repair /proc/<pid>/auxv and the
> > stat/statm code accounting, but never /proc/self/exe.
> 
> It's good for us if AT_SECURE does not need protecting.  We would like
> to use a fake 1 value in our test suite.
> 
> > Unmapping the first copy is also not really feasible. Even with
> > privilege making this work would be very ugly: The kernel's
> > replace_mm_exe_file() refuses with -EBUSY while any vma still maps the
> > old exe file. From my research, CRIU works around exactly this by
> > copying its restorer blob into an anonymous mapping before it unmaps the
> > old address space.
> 
> Unmapping the first copy was only my idea to make this work with the
> existing kernel facilities.  It's not required for the binfmt_misc case
> and most /usr/bin/ld.so scenarios, and actually drives up complexity
> considerably.

I mean, it is kinda moving into CRIU territory, so yes, doing it like
that will be complex. :)

> > So I think the exe link should be fixed up at exec time.
> > begin_new_exec() sets mm->exe_file to bprm->file which after the
> > binfmt_misc handoff is the interpreter. But bprm->executable is the file
> > the kernel access-checked and kept open for AT_EXECFD. We have it right
> > there. This is the file that would_dump() uses for it's decision and
> > binfmt_misc's 'C' flag derive credentials from.
> >
> > We simply need an extension to binfmt_misc that sets mm->exe_file to
> > bprm->executable. Then it is correct from the start and there's no
> > window and no privilege question and existing 'O'/'C' users (qemu-user
> > registrations) are unaffected. It then raises AT_FLAGS_PRESERVE_ARGV.
> >
> > On the userspace side, ld.so now sees this AT_* flag and in response
> > issues one uncapped PR_SET_MM_MAP (that's available completely
> > unprivileged) to retarget AT_PHDR/AT_ENTRY/AT_BASE and drop the stale
> > AT_EXECFD from saved_auxv.
> >
> > With both in place, attaching gdb to a dispatched process is fully
> > correct and /proc/self/exe-based self-location works. As a bonus the
> > program file gets the same exe_file write-denial a directly executed
> > binary has. Today it is ld.so that gets pinned and the running program's
> > file stays writable while its text is mapped.
> >
> > After this, only uninteresting differences should be left. This would be
> > a follow-up series I'm happy to do. Does that sound reasonable?
> 
> The proposal looks quite straightforward.  It's a shame that it does not

Ok, I'll work on that once the basic AT_EXECFD stuff is done.

> fix the /usr/bin/ld.so case.  Is there anything we can do to address

You mean the case where it's called in userspace. Yeah, that's a bit
more tricky.

> that?
> 
> I wouldn't mind if we had a system call that triggered the kernel ELF
> loader for the main executable.

Ok, certainly another future patch series to consider. Fwiw, if you have
some far out ideas like that (kernel related) you should always feel
free to just file an issue or a pull request at:

https://github.com/uapi-group/kernel-features/

They appear on this website:

https://uapi-group.org/kernel-features/

and we have multiple people (not just me) that regularly pick items from
this list and implement them. This is a good way to avoid ideas just
being forgotten or invisible.

