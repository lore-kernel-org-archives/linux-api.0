Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878AE18C933;
	Fri, 26 Jun 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782495022; cv=none; b=dxO66VFF+uQpIgQhb9OKvr9lAuc5dyH/N9ignKvXwOlfkp2sQBTsWoHR7nbLBlkdgdTi1ZwvwMKXDnv5kJQ7Sx6tHzRdJ11vKc6QCSvFbe9YUyLs9NDDd2XQseTUh1cdiVCwccODQy0cc9z9gZT0he91SskohDDnRkMUoyePUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782495022; c=relaxed/simple;
	bh=fdzE8WKk9XytKfmKg8U5BbsfoByuUmF093+Yi2JrkXM=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rA6CUjkE6YIltlwln86Titrj6ekyWVkYUHZlUmmK5hpn70N7mOvQnQWx5M1yxU5r3AYgEFZBEY72pTqvU1gyLQzRZak/zJ1LqhHn07SpB6BeRdaqBrvbv7rF5VIqHN7ui7SFp/RpW7Q6Iqh3ImQ3ly7h+TrUpAHXXS4BdwB+tn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me; spf=pass smtp.mailfrom=johnericson.me; dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b=jGcgE5fm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PpcwJ/7k; arc=none smtp.client-ip=103.168.172.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=johnericson.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=johnericson.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=johnericson.me header.i=@johnericson.me header.b="jGcgE5fm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PpcwJ/7k"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id C0E82138021A;
	Fri, 26 Jun 2026 13:26:28 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Fri, 26 Jun 2026 13:26:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782494788; x=1782501988; bh=F2RQwL0S2/VBTjE/xlZGTYwV5SDIqeUh
	RspcCvNMHJo=; b=jGcgE5fm/SNJF+NeB2QfMDqHWD6tAYDnlE/VEuXh1ob8eNeY
	JNkWsHzS9ZPuhFDPEgShLU8SipdrgmzRs19yY15NuyZKmcb9yjJTlCpTyjS64M/U
	k0pzJ6iH7+ffQHJZRkBvxXl6jl+GDvwtwH3xjQbDnQQC+gq7q9+rOiOZX+S4YwDV
	IIKw2auqdLH5DvpwIqJeEVbaxDMhdsaMcBpvWJPD0xN1rbhhnmQHebqS12iC016F
	6beXHR/krbcxAdxe96mYsOoiID3b3iEsiwViM/k3ayNy1KXQQ5NF0gEG6PvKaZVh
	FCFTmetM+6IV47YmpOgQX23B4zNDnUs5D/fkpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782494788; x=
	1782501988; bh=F2RQwL0S2/VBTjE/xlZGTYwV5SDIqeUhRspcCvNMHJo=; b=P
	pcwJ/7kMW5Pmz6H1rv4LBMKXztsUU/tRc/Jg1x+NnJ9mo+6VruE9mwD8Z5EEI1p2
	Zj8kBGHlkpLGlK6I6bWdloNvEGBnfp2A7tK9MmR/16iLd9LSHpnF2ZgIeBpMs2Hk
	YO5mCstjyHy2EI1Ho+5uPWug9w+7jyHci+vQqlbwkPQPV8ISnzmasMuUZUTOE/mM
	7KinOBesAHG5hhpb7mXNGGdO82JEOYKfquE+19nkS0jEt9GkyArH6eNSN5LCV8yQ
	A5Q77Ydc79EkdjQyB4v45SlNbO6nHwJW0F9yvqrUPd8VNtKkGABRw3Psxn6mNMDE
	m3XAt5vebvW0WPpgiyDyA==
X-ME-Sender: <xms:Q7Y-apYyb5q46ROZzKr7butEZxfRNgMuEUP6qM8NDZeNazaiRl-96A>
    <xme:Q7Y-arMhojrg0BMt98EgIcJChfM-ouZla5lrttcwd9pP37nFlkiMfDxxrnkkYq0gG
    15z2e_32Oolrpf6Ie-imo4UIQjEyVA3Ah4lVXkASTQjRpA1z04jkxk>
X-ME-Proxy-Cause: dmFkZTGXKVzao0YncuT4RAnLE/QsHNCC0UboLlIUDyeCJjeLHHZRHdxcvPsPzDS2xVKsHQ
    GYl3fc96MpX6xhtF7obx24gHFAtP5WIh2T5EX2P0wKHxRH2Peq9vtBcWEP2W3DSbrHf+mv
    UBfjgRve7aAMMxnL6Dn2f33M6yyqz5GX9xJJ+38zUfrrhx1hr7NaldLsT5Dul+CLLzh0/M
    4jN2FGDqmMfKaOY+Ipd2MF/rBhzoB9D3psamhdsgVWS55EOUpExs5NIJLv4Uk4xttzOX+j
    BZjDs/iO7ZP6xvPHDBmY6AD5I2ogEhDn+DATFHmBjnh0uiqaTvpLDaxQH/Jfb0QdMJFOPD
    pa7EcU5vZMPzvlv2IxiPe75IUFFFg6JncZdTr6ButkcOMRUn/Rf4NnU7vtdk0kwlDe6IML
    yt5W+9bnQGUkPM1j2KSYDWBMj2DDFLMtkqEdFxYc/qtc00gQaQkc+k3buyHFidz7pIRXZy
    sVTK4H9k/2J54dRQzw+0IsAoQUL+RSViYHznZr2TZF/ggHGJ1m3GHLHs/cZcHe0EfH8YVX
    OE7PeS2WPxGWkyys4xeyswuAXXEwlccBjWRuWAnP6u7wAM7lhVlvDIpegjFhYjdjrwV4db
    Yp4Yhotp4G6nNM/fpP3pAslU2X5KJWi6cOe2MvzDzDlh1/0UDzucwao+J00g
X-ME-Proxy: <xmx:Q7Y-alYdIPQ2AVA4Nmw8ijq_09lgV-FM8PNc7Og5_JqrQtVmJ8UIXw>
    <xmx:Q7Y-ahS1oG3TaXU7YoV1SbwvUIam-X82itxpZMbZhbV66nWSX6bciQ>
    <xmx:Q7Y-algiua63ltREhcMehgDbIh8rWCGTDQbmmxii20GZk8i7Ca2hRA>
    <xmx:Q7Y-alt_cb_PDz8TwtXQ6jf0Ce09-yLqtURl2fnjtYWMjh5LbBwtKQ>
    <xmx:RLY-atTr08hYhLgO9zJmj95aaRxyoL8orhMyAJ-wJ0G1UGvX-03p7O0l>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 987882CC0083; Fri, 26 Jun 2026 13:26:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AG8qDlxFSDr7
Date: Fri, 26 Jun 2026 13:23:50 -0400
From: "John Ericson" <mail@johnericson.me>
To: "David Laight" <david.laight.linux@gmail.com>,
 "Andy Lutomirski" <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
 "Li Chen" <me@linux.beauty>, "Cong Wang" <cwang@multikernel.io>,
 "Christian Brauner" <brauner@kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Kees Cook" <kees@kernel.org>, "Sergei Zimmerman" <sergei@zimmerman.foo>,
 "Farid Zakaria" <farid.m.zakaria@gmail.com>
Message-Id: <497dadf6-c7af-4052-8e2b-dacff204d90c@app.fastmail.com>
In-Reply-To: <20260626092750.58a8de9c@pumpkin>
References: <a49ce818-f38d-41b0-bbf7-80b8aad998b1@app.fastmail.com>
 <20260624231219.GL2636677@ZenIV>
 <29cd3188-2d7c-4470-a39a-6648638f795e@zytor.com>
 <614b290f-e274-4eb2-b687-008b004de526@app.fastmail.com>
 <CALCETrWxi1g1wy2Bi4y6URW728Cmo8D3tchdMqs4GZ7S476iJA@mail.gmail.com>
 <20260626092750.58a8de9c@pumpkin>
Subject: Re: [RFC] Null Namespaces
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I am replying to both Andy and David in a single email --- hope that is
not confusing.

On Thu, Jun 25, 2026, at 7:09 PM, Andy Lutomirski wrote:
> On Thu, Jun 25, 2026 at 2:53=E2=80=AFPM John Ericson <mail@johnericson=
.me> wrote:
> >
> > The argument against just having an empty, immutable root directory =
and
> > calling it a day is the tie-in with a new process-spawning API discu=
ssed
> > near the bottom of my original email. I want to have nice secure
> > defaults, rather than forcing the programmer to remember to unshare,=
 but
> > I also don't want to degrade performance by speculatively creating n=
ew
> > empty mount namespaces that might just be thrown away. Null fields a=
lone
> > get us both --- security and good performance.
>
> This seems like a false dichotomy.  There's such thing as a singleton.
>
> In fact, we have this spiffy nullfs_fs_get_tree.  It seems relatively
> straightforward to have an API to get an fd to the singleton nullfs,
> and the default for a newly spawned process could even be to have cwd
> pointing at nullfs.

Ah! This is the first I am learning about the new nullfs. OK yes I agree
this gives us both properties, since it is truly immutably empty.

I still have a slight preference for something that also makes
statting/opening/etc. of `/` itself fail, but this is otherwise good ---
there's no denying it.

> root is still harder, because of the shadowing issue.  I think I
> proposed, ages ago, relaxing the chroot rules so that, at least under
> certain circumstances (e.g. the task is not already chrooted) an
> unprivileged task could chroot.  chrooting to nullfs seems like a
> somewhat useful operation.
>
> I can imagine more complex schemes to allow even a chrooted process to
> safely start acting as though their root is nullfs, but that would be
> potentially fairly nasty.  *Maybe* everything would work if there was
> a root-for-dotdot and a separate root-for-absolute-paths, and
> nameidata->root could point to the former, but I'm certainly not
> willing to say that I think this would work with any confidence at
> all.

I really like these ideas!

- Splitting the two uses of root sounds great. Even more generally (at
  least as a thought experiment, I don't like the O(n) performance), one
  can imagine a set of paths one must not `cd ..` past. Conceptually, I
  feel optimistic that inserting another boundary path into the set on
  every `chroot` makes it safe.

- In the original "real root", the "root for .." field could be null,
  since no `..` check is actually needed. Then, if we only want to have
  a single "root for .." (to avoid the O(n)), only the initial
  assignment of it from null to non-null would be unprivileged --- this
  would implement your "task is not already chrooted" idea. Subsequent
  assignment would still be privileged since we are replacing, not
  extending our "set". (The nullable single path means we have 0 or 1
  paths in our set.)

----

On Fri, Jun 26, 2026, at 4:27 AM, David Laight wrote:
>
> You'd also need to sort out the 'pwd' mess.
> The kernel inode always has its real parent, inside a chroot the scan =
stops
> when the inode is the same as that of the base of the chroot.
> But faf about with namespaces (IIRC I was doing an unshare to get out =
of
> a network namespace) and that comparison can fail (if the chroot base =
isn't
> a mount point) - so "../.." can go all the way back to the real root r=
ather
> than stopping at the base of the chroot (as you would expect).
>
> David

I did get the impression that the `..` check is...rather fragile. I am
also thinking that a global setting like `openat2`'s `RESOLVE_BENEATH`
to make `..` never work would be useful; then all manner of chrooting is
trivially safe, because you cannot go up regardless!

----

Given the state of the discussion, I'll go submit my null cwd and root
patch momentarily. The nullfs alternative is quite compelling; to the
extent that I do prefer making the root operations fail as I said above,
I think my best shot is demonstrating that this patch is so small and
lightweight that this slight benefit is paid for by the simplicity of
the implementation.

John
