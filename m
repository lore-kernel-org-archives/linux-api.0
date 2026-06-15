Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1223EFD15
	for <linux-api@vger.kernel.org>; Mon, 15 Jun 2026 13:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781529125; cv=pass; b=iuMz4oVAR6UEeZ/hoUwGGvGZC3aqiFfB97sfgNStVd710hcwMev8vR6c4QsL2R7YPg0EfkVztuA3ufnaJm8Xl4fSORuHliklHVF1mVNjsUkiKjShEOQB0AA5y5qGqbMU0EE5eBBQJrQUFzJhp6Awk84LtZDKRRaH9Y/+YNXpy9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781529125; c=relaxed/simple;
	bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tr63AfuOtkGZ+c4vejZk2PPgCDkYxSYFKcPJGtrSNK1xnnhiwJBmX7wFDlH8I/+fEOdFbAdp7LLUXbs0maKwm6WNG2snXuiErfH2p6nL5rzQaxIHivS47NogJaPAOG/c78ZxSJNMNzhz84faCnFnzottXTifRMavBIwrWRGnYXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHYjxo+A; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHYjxo+A"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4619990ca5fso615862f8f.1
        for <linux-api@vger.kernel.org>; Mon, 15 Jun 2026 06:12:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781529123; cv=none;
        d=google.com; s=arc-20240605;
        b=kabsMh/0iHtrjNWycZjboE4f1kDM6QcDzsGtYmuyL/XYRsZIFKjnJlylWKaHdkwtgI
         Qb3LQea/XQtTXBhmLCWdScpYnC1ol0yxmqdGHlOTOjEJYxVDP3NUYOql2Td6kQRiis47
         sSr4HElnQdj3gte9k6uHAgOwiSfldJ6D0kmjHr1CPaWmJGjZq2k1m5rCc1TquB4PGu53
         Sluj3+dztqVGFMAYAwzEd7NcUTHLBlK5BEhYyT21zk1jvENB7vddeNwWH5MS3MQdpfRD
         HXUEoasXzMFvJ17EkI2kSbRYKBrxS4b7FA/0hGe+gC7FVpiaGeO+V4h/JpjIvWt9rmU4
         M7bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        fh=1yjbm5DfTg1q5dE7B4+Wq69+nhIDNZhZkk0e/ovkPdk=;
        b=WZo2ARUnLRfCs5NLgNvkMGZbkxY/gT24NTY5tKsTcr2WwZ+3AYqOI4FVqLuZDXyMNr
         zgRXQ+feR46RYqIDEr6JulIIqrPQdc6mdy6O6b20XpPMQWiGZ3g3nl7IQVACQB4jWGGu
         T8L0WssofioJRSheL2Ox4hyYrg6MPLs84/dD0bGXO/Fzu40FD+ZGiTWc60FlvVoG1MF5
         nnYhYu8pNleqWXoVee3VYGMa0V0SsCxNaGWk1HrF1UnyUi2JLkPU7RR1RpBelHxo0jGC
         XMDKUXGb2YgBaIxNrkBth2gjh9/9yHot13gvOcDWooNNh0/wPbPNJcd42VFPhZutg7P8
         Lbpg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781529123; x=1782133923; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        b=HHYjxo+ABMf4k75UFo2LHf9OhCUH4tcliJ9GS5gTe078dGmMRE4sxyCu594yeTvhvi
         zE7gNU30USct+EsLW59ZrkfrwzgTQOUZyXDVDr6XPpKSjsnL3gLsQxS7FJW9uzC9qd8S
         gOVVi44SCZ2/AkfNVgkr6WxuDs48KCFTdGvdf5KFHaHojnTw1V0bvECSlxi/CGl1oObD
         k/6Z+Aa09LJSivg1CJTF63aYbfQa7LoGwZMQGUN2lDtCryVfpYD4kVcMBdobRFrzuUGQ
         ksQhXy4RhHVImqzxsiKmZMD+HAleczHZf42jVW7GbqrCrv80rJyUKjSKrB0/gJCm/vme
         EWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781529123; x=1782133923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kKNBiJvc+rzdgShKrG5gbJxYUuppXn+sgk4q2LkXCxM=;
        b=J7m9y74fj0P0KENFHC7liimbprPurrJ3QNHCTPKQsNu8MJYeg4FgEDFW013koKKl7N
         Nc/vi6TRZ9bviHFA2TtQUnJteZv24ziMlZ3CymMFuf2XOoKXmFvw8ymfQ7VHTkNZH6xE
         mTVCaP1CI2QaJd/tl3lGtw9XUPCNUcLn7+df+M+KvK/TwIxWbuMgNM9GuD9fICXUGUup
         3NI9455uPlXBSur+a7sji/T7LJuyHLPgdFKvifjdym8BRiVy5dkyw9KPUB//z3Oiy2Js
         Ty5sTUaGcJMnUUW5maujULJEsSAnsgjpkdmH3sKllmM1VVlKl4Y89MHqV7rsXCq+3MGz
         PGLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+weGOa+OVP8ADLm6AtmR9M7k2dZ3JUN4W3+086FNX+ueUTWJqe5d8XK9FxeXDCqKhMOX+/Fn8AWYc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxksd5iAT2mLO7I0DuNfVxYLSq+r2mzo7xPXV7CM+WhS2IPAJfU
	v9OlKt/xbV1Kuge3HhE4IFgOaJTBjMXIWTSexfUmEBs64ahoc+/2qq4vUKaaD6j9TXrV0zAU5vD
	2Js80O/NdHBYVIyvhBYtNH2S2mHRQCJk=
X-Gm-Gg: Acq92OEpPtt8/xiVpmdE+O4G7157IPhQbOgGMYlH5DoumAinnDTwf5RuYuB4FpJ26BS
	AEx4bV+a3yBKET39N4ffppUqDWjOLvinds3Ql0mCqBzSRnxRnNBBowucfI2SVJXOHh234B0ieRy
	sT9TXbpa5TLdN5gmJqJVjxFYP9XANGhv+76VNOwZXazAB369AqTtQ2Impm3MET/bBOrTwZqU9Xb
	1/gGCebeIpZ/S+ibHeIfyzASy8GEnI8ceJ8vP+SIntP36DjJy9iygmQhjpt8xDhImKVBhnVYa2S
	auUbtGKv3EWBdOdXqzRgVBzmls4suu5RroJzJoE3DzmcuEdez3hdDp7a3AU180U9rq4=
X-Received: by 2002:a05:6000:1842:b0:45e:eec6:500c with SMTP id
 ffacd0b85a97d-46074b8a1a8mr14546144f8f.39.1781529122279; Mon, 15 Jun 2026
 06:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
In-Reply-To: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 15 Jun 2026 09:11:49 -0400
X-Gm-Features: AVVi8CeKgoUdgzfGyE3gGhvo39veJuptxa85IFXCJ5UZu0W-8unFPPqkk0CT60c
Message-ID: <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Val Packett <val@packett.cool>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 15, 2026 at 2:25=E2=80=AFAM Val Packett <val@packett.cool> wrot=
e:
>
> Hi,
>
> On 6/1/26 2:33 PM, Al Viro wrote:
> > On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
> >
> >> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> >> a big simplification.
> > FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> > Communications between the kernel and fuse server at least used to
> > seriously want that, so that would be one place to look for unhappy
> > userland...
>
> speaking of fuse_dev_splice=E2=80=A6=E2=80=A6_write actually, this series=
 has broken
> xdg-document-portal!
>
> https://github.com/flatpak/xdg-desktop-portal/issues/2026
>
> Specifically what happens is that the EINVAL is returned due to oh.len
> !=3D nbytes:
>
> fuse_dev_do_write: oh.len 16400 !=3D nbytes 15526
>
> (where 16400 =3D=3D 16384 (read len) + 16, 15526 =3D=3D 15510 (file len) =
+ 16)
>
> After reverting the series, there is no error because oh.len
> becomes 15526 too.

I think this is because of how libfuse handles eof / short reads. When
it detects a short read, it fixes up the header length after the
header was already vmspliced to the pipe because it assumes vmsplice
mapped the header's page into the pipe by reference. It assumes that
modifying the header length in place gets then reflected in what the
pipe later splices out.

The logic for this happens in fuse_send_data_iov() [1]:
a) sets out->len =3D headerlen (16) + len (16384) =3D 16400 in the
stack-allocated fuse_out_header
b) vmsplices the header to the pipe
c) splices the backing file to the pipe. if this hits EOF, it'll get
back 15510 instead of 16384
d) detects the short read [2], fixes up the stack out->len =3D 16 + 15510 =
=3D 15526
e) splices the pipe to /dev/fuse

After this patch, step b) is a straight copy which means step d)'s
fixup doesn't modify what's in the pipe. This could be fixed up in
libfuse to not depend on modify-after-vmsplice, but I don't think this
helps for applications using already-released libfuse versions. I
think this patch needs to be reverted.

Thanks,
Joanne

[1] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L846
[2] https://github.com/libfuse/libfuse/blob/master/lib/fuse_lowlevel.c#L956

>
>
> Thanks,
> ~val
>
