Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793159864;
	b=eDd3hB8vqOaxeUuwTZyK+ywI8fTnskqawgXHrR1kbc2xrMRD+9aPbYy2A40CiKoowF6U
	 3hy6KMHosYtYhK3DBE2o0SkCYAwuejaEv++kAjbbly6ANnFB9McRY12FOBy/LOTBFeyss
	 2EtQ/8YBg4B5j1ZPpVCH7Lc6Zce/JleVgAx/MSDIf5IIVBjl1IQ4S1Bte1s5yqgjLRqB/
	 g5fjoFTEDZ9TcWBD7fKuz8RNnsQpTXbqDTKOvQF9bXJMfTUhbRdfAtzGjNyXG6Xv7R6gU
	 YZ/Tgll/igr1IrF9l60fOmLyt2PjB1Le6UKsRplPiOKXMq3RwsiR5/jNFjGgEzUdgRA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793159864;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
	b=gCaLTAC3RkQoXpelu+r86Xr3Y7M4LFgnFf2sNFrKMg8Uju/6lNr6c7qTt/10ThswTn5f
	 ELJDbai0YnpG5P8LzJJeqig2vOUPVf+k21224gX6N+A1vEhzwPWVpzGwXtsvwQa+ta32l
	 otxHNOBaqpbvynCE2wfF6LEtEpQPGGqKw3OztHeDqRxtKBjHXHAS5VVehQSzfQK2jnVCf
	 NdcATbE76V8oDk40uwVkzYlk9WwUj5CpbWdM5HvUjlzGfvy1b6EGmFl3xA93z1A/PPv7n
	 meKdFV95axl4eVYO0Dv6rd8+s9/ozGMRFsWMCrkLX+wwXiePpLAtRQxNaIzE7/E/5dA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="gaw+DbF/";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.49
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01D0606A336
	for <linux-api@vger.kernel.org>; Wed, 28 Oct 2026 03:57:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E01D0606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=gaw+DbF/
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5bccb867d6fso699065e87.0
        for <linux-api@vger.kernel.org>; Tue, 27 Oct 2026 20:57:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793159862; cv=none;
        d=google.com; s=arc-20260327;
        b=NeY1+BSQdmnu9o54GZm2wh8Q0ha2LqUyMHJh3EEDr+r+2hqK/IDtuCapQ7O39T7EkO
         qTbV2OCaVz/j/T+tx/gJac/di+SBCDMgtbOYGlbNQrurdOU27YamiFwIZX8eC7erwp1W
         A9J3uiIydwNuBwKVcBMsq77SyhfN+b4wVP45y2HTq7wLcqEP9OXHBV3hILuOfYS5a/Wo
         9kN4ToX/8aciLrGQDVOEUf/s4WbTEorM3fGe3krePnrJzbtgYnMqu9dJiHWvwRFwLoR8
         BujAkoelmsNp5VTpDECCzysS6cvB6yTa1GNKnKSrkjuDk4izviNX9CGPEZDSYyviH2W5
         H3iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        fh=l3gvCWoqCJLGuvtZc8K2bltSmExF2fv0k793KOUSVCk=;
        b=V3dIcTG9ZU9Bmgv9cJVicLdXzFXbwfwyuXXlV06Ej7D+1sL29okF806ucGZiJVwLCK
         22r0ng8y5vO02315Ie1ERHuxAswQXYP55bAe3solT58kAZxJE81k1VKIlmYDM710dKfN
         R7bl0EqYxg4M0v25YyHLZuLu/LH9zZvjilQ9Ovm+j003GSnfyB3q39CXXjYKm+1Bcy1J
         8417nzg8B/+1/3hsIGvmYRtrnhJDb+UDhjuNJXuBLoPzlOzI0TIjHGU3Nu2LxdsGYq/p
         6GuUjRyVA2fA0IXAAQcBUzNCdRm6IPyHIoOzTow+TwVLkMrUj8mdZgI5jSnHSeQJjAIN
         z0kA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793159862; x=1793764662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        b=gaw+DbF/nmUl3kDK8zxqfHwK29AhYno3poVrvFH+EON0nOKHPGtXEaQesZpl7p8ajG
         rkw2MBoTDlVJnO4hjaG3tIMKVF54uRl+Xz7QQn7JMuY1VBhMdKJ7mibQ4552uDCP/oGP
         JeFeUyzddTGiWDdLWwCE5G94LI1vdM747u+BzTfDchR41u8JzfXm/7h04TVnIyj4mIXF
         u1/+E3queoRBnMH0CPGHAK9YTOywC0B3ujvaPAuaIqqwuPGJ4qG/P7s0H5G7gQ8JfYu8
         /fnyjHcpNRJeD8oX7PgoslrLmdSDr9Q/7hgYIxQ24YorJuyT/zXhUfP/YyOFF8f6zopi
         /xoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793159862; x=1793764662;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NMXrGQL+HMAYYOepT9QRjy9INGR/r2c4dPSHBgR+Ovg=;
        b=PACVSHqMmtP7GxW4vvdAiVtA0FQIg/7UDuOAV8Fyj9WTORtFBzqP/vJSzldXjudmi/
         3/xryl4R4uvJvqCyIcat563P6T6oLOAJyeL2TE5vVY83kcLuyVkADxYKhp09rHga7ULz
         0l8a0zeR4+ctE2VFwNvef5q1EF9jaxS1lOtmrz+x4demjBKAqEMI9etBLF/EdC6sexbY
         ZSro7snxLEpMJg6xqJf6ve7Jv6vev2btPWc3c/qL4L05ld0et8OlZ1XqNEBkFohsDEe6
         9SJs6sOOaLY2/Q6roc2Z43mirmvp/rCiHI8h8WnBUPKDCb/Gn9AIGX0HKmhqvFa+XHY1
         /l1g==
X-Forwarded-Encrypted: i=1; AKwUvBzUrJ/2O1LcNdR9eRzlieXY0eP3uoYUs3N3/03aDe+vxRL/R13QLdlhnabd2r2L8y8tx0PJZkeIYpI=@vger.kernel.org
X-Gm-Message-State: AFq9FYLXpXDfiI9tr9aeEwJT9HUkPvVascjl3AfeUitlWzRIJ29S7I9I
	vIsmxuztsMtJ76zp7EY+Ei1G8+8+tGJ5QIZbP+7ADn72nl/yENyh3bz1HyjSbqxg9cPBs8taAam
	HNnE4PTLhntavYdgGGcHeHo1myG8ADjsrTqdXCiEY
X-Gm-Gg: AYBFou2lwgkwGyTSTWWh2V+SfAZazRHaOHmmJYNVZMticpxA43xBKAcnzdt1nytnyVq
	A8vMq+GlYhc9hpoC9S0haTRJFbZN9PoAtCxH6CSrNheBtGgxi/T/0sU0eTA32dfhK7+XIDs9gwl
	qt2duvhI7XKuc+0LAjoaSEMSd2fz0dVh+++b7JZi3/AhvDbwN6Fmkx5RnZusyB/vDfloW17nLwC
	/uYFNcbmDrcugO/Gyq/UXPnfqFuo3+V5evkxT9MC4/r0nsBffG+xIxnIj+kDp97mwcb2XHpPVZc
	clv7iT5MtEPjRyT45DZJv/iOVxIeTBt34B953q0DzoGBayxpv9Q1wQvJdJhP56Jqc2r6xls+rE4
	H5BBA1Ju+tEFarsjS81AVEMOnwZ8RtGqEqQ==
X-Received: by 2002:a05:6512:39cd:b0:5bf:c619:b088 with SMTP id
 2adb3069b0e04-5bfcad172c1mr381529e87.20.1793159861277; Tue, 27 Oct 2026
 20:57:41 -0700 (PDT)
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com> <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
In-Reply-To: <auEksxfAi9lHFXmT@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 27 Oct 2026 20:57:29 -0700
X-Gm-Features: AclHuK-ukwGAOGBSGCB4Bz_ycZfHCvtj9w2gkhhBJhRypC_kHO1bNXVuIJcmKsM
Message-ID: <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 3:55=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
> >On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >>
> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that preven=
ts
> >> holes from being punched into a shmem or hugetlbfs memfd while leaving
> >> the file fully writable.
> >>
> >> Background
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >> memfd_pin_folios() to pin the folios backing a memfd and hand them to =
a
> >> device for DMA. Pinning keeps those folios allocated, but it does not
> >> keep them in the file. If userspace later calls
> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
> >> the folios are dropped from the page cache while the device continues
> >> to use them. The pin holder is never notified, and from that point on
> >> the device and the file silently diverge.
> >>
> >> The existing seals only partially address this. F_SEAL_SHRINK prevents
> >> pages from being dropped by truncation, which is why udmabuf requires
> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
> >> them unusable for memory that must stay writable, such as guest RAM or
> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
> >>
> >> Proposal
> >> =3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> >> -EPERM, while reads, writes and resizing are unaffected. Combined with
> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
> >> the memfd while the memfd remains writable.
> >
> >How does this solve the problem?  F_SEAL is about a userspace
> >contract, and if there are existing users of the APIs in question, it
> >makes very little sense to start making those users fail because they
> >haven't taken the appropriate seal.
>
> It doesn't change any existing behaviour, nothing starts failing for
> users that don't set the seal, and drivers wouldn't require it. It's
> opt-in. Userspace that wants the guarantee seals the memfd, and a kernel
> user that pins it can check for the seal and rely on the pages staying
> in the file. For example, the iommufd live update path could skip
> verifying the pinned pages at preserve time when the seal is present,
> and do the full check otherwise.

Can you clarify the API you're proposing and the issue?  It seems to
me like the user is expected to preserve HWPT state by creating a
memfd, then using some new API to tell the driver to "persist" its
state into the memfd (possibly by binding its existing state as folios
into the memfd)?  And userspace is supposed to seal the memfd against
growing and shrinking but not against writes?

What if the user writes to the file?  What if the user populates
pages/folios into the file before using it to preserve HWPT?  What if
the user mmaps the file?

Have I understood this correctly at all?  Why does memfd make sense?
If the goal is to attach a bunch of pre-existing pages to a file so
that the page preservation machinery can preserve them, wouldn't it
make more sense to have a handoverfd mechanism where the kernel can
make a handoverfd that stores its purpose and logically represents
some pages but does *not* allow read or write or fallocate or any
other user operation that actually acts on the data or its memory
layout?

>
> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
> >
> >Would it make more sense for the drivers in question to set some flag
> >(refcount?) on the file to block hole punching?  Or perhaps to have
> >the hole punch code notice that it's trying to punch out a folio that
> >is pinned or otherwise referenced and to refuse to do it?
>
> The pins already keep the memory alive while it's used for DMA; the
> problem is only that the page silently stops being part of the file.
> Refusing to punch pinned folios on every file would change behaviour for
> existing users: fallocate() would start failing whenever a page is
> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
> pinners would avoid the short-term case, but it would still make punches
> start failing for existing users of those drivers, which is why I went
> for an opt-in seal.

Wait a moment here.  Given my comments above, I'm not sure this is
relevant to this patchset, but...

As far as I know, right now, a program can open a file, register some
of its pages with io_uring or RDMA, and then use io_uring or RDMA to
write to those pages later.

And another program can open that same file and use fallocate to punch a ho=
le.

And then the first program thinks it's reading into the file, and it
ends up not reading into the file.  Which makes the hole punch
operation rather different from the write-zeros operation that it's
supposed to be a fancy version of.

Now this doesn't sound like a security problem per se, since the
offending hole-puncher needed write access (admittedly that write
access is only needed at hole punch time, not in the indefinite future
when weird behavior happens).  But this whole sequence seems highly
suspect to me.

Are you *sure* it wouldn't make sense for a GUP'd or similar reference
(whether pinned or not) to *actually preserve that folio's status as
part of the file*?  Or maybe for there to be an extra pin bit to do
this?  Because the current behavior is pretty strange.  And I'm not at
all convinced that anyone would really object if the kernel prevents
hole-punching a range with an active GUP, especially if this behavior
is restricted to writable GUPs.

I admit that truncate seems slightly different in the sense that it
seems more likely that someone would be annoyed by an inability to
truncate a file.  But still, truncate does have the same issue.  Maybe
extending a file could notice that there is still a folio covering the
newly extended range and stick that back into the file?  Seems messy.


--=20
Andy Lutomirski
AMA Capital Management, LLC
