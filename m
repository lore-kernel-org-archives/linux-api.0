Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.167.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793320022;
	b=l4/12qL/zaInGI2ZzbltSZzPOF/miF4yetKg42W3tEMRD1ij2wsT3rPLdHKoJmNf+1MM
	 0BePwqHr2VZwdyaur7zuSw/KuO33Su9983rKR9ytGd2sQfBS34fhjtiGbwa4nRA9xNiV3
	 Gvw3sw1HvP7wtHd8qFjSibS1CiDUpP1p9k7I39aFRSbyaWJkhQvdr5VTbcOKsvEg+Zfe1
	 pODReQr5/cScw5YJDKhQSXIamYj23ZuPkUc37z2MfixkugCVeQlBq0HvqRQKP5703XBUe
	 KKxeCYX9uqJdLxFrjK7xZsdlgHCHwWHMnXchw3L3/vPjspktfW2/5I1Ww+azA/7HBOA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793320022;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
	b=pHQZ09LUReD1Qu2E999wIwpu3loqEpz0Lsbde4Spgr1bszVpt3SzLGURnqO8nKJe0Dvm
	 G2iv7zrqg+HBrN8Tzt1VQtOLpTZJR/GtA+aW6fDhaT6tWVLdjAI2AYrQi7P2J04t6sei4
	 ee+ZBp2lsj05NLtVJYUkdTPrJcj89QlLC+/vYF3rXE0VO5yC9u+5Cd6qmF5kMGs0TJLxr
	 YcCS+xFfoQ8efHEHWdeYbDLoO00XJkUXakzbmdIggZYSt+/Ml7lcuDIKhIKCFK7o2hoxF
	 CRP65TehEnrsuHghbud2Lnb1x45LDFk0nHMvRCwoxPvvH+H79oRgQ6Er4yDXdt0Rzeg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=amacapital.net;
	spf=pass smtp.mailfrom=amacapital.net;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=O503UjZ7;
	arc=fail smtp.remote-ip=209.85.167.52
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A401606A31A
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 00:26:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A401606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=O503UjZ7
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5be3ed646a5so225904e87.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 17:26:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793320015; cv=none;
        d=google.com; s=arc-20260327;
        b=hpFWJZY0WyR1ULSMbWUAgaoSyuJvHN9h48E902wGUiIQC11bE5jJ7o2jcDBAuJeH41
         xABcUoBMTMEvS1UG72Z5vwePj0oRI/3M/Xd4wqQffdR8gLPAxK2nPL8IZuxZkl5Fn/3E
         mdc9Azzrcamce1RjlShGLddnhZSmzeAkSMJuoo22/ZcWhVtPeMuDt9Y3619fc9KRll0p
         8iXehOw/DrltdbA6Ti5qt84biQ8KnjPBfo49t/GBlciw0fOl0QYZG031EoLlfYT+mV9j
         JIKHs1u9GmQfRYsJLEbBMINm78xP8+ic39A2S5Nu2FJZbVWNQi1HIGCksVpTE7bAW73q
         RtvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        fh=P10IDTpMpyOQNCdhHohuuO4SF2MWJ1bpfTOVKvLT5F8=;
        b=ZNFNqqF6x5lVTypKmEY8UcGD1AwZJZ0a9LQnF9jo9DklaoHBH+F8ZPErCIiAGuoKTI
         1ohLc/2DKCmi+673YaYT7eMXXoiY7TjF/X738+u4R46iNqjnJQ9GYAiGxdCHA9i1uVEP
         jPlH4kKJAkhx9Jc96KS1Cp7ODymqVaiaozqffa2rdP32O3qiF6kpMXU0gzqsxqrajBGw
         YYclvbpsq8FdNDEOV0kvONSKVPFKco5hKRgM8GbGzP/o0KljrqBeXJuPqlpTFj2XxSxK
         zmbjTfG67rSugQSgxlWJ519TYiYg/Xcp434Pw4gE8x6VRaPoxT2PyWBSjmYb8HVhTWKD
         beDw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1793320015; x=1793924815; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        b=O503UjZ7fMXZsU1qRRq5Qfc8GFUwnWkY3mMLLrFUPM1gk/hfbdcb9Pops7GCI0GBBa
         vONTTBLAAbAFHNnZGOPQIwfyR9o/l6SNCs7fRjFQCPNDd+QjmAYtBmJSnSj9YdJ3/NKI
         Z+7a1O3MVDPsyEo6ywZ2WmcAvahNWZzS+mCPYGq1f0VbyQ0qOrLpI+R9M2/6Q1K74HMY
         cDvHBv09E01SeMZO60MfHnGTbHhfWIcOgNCtFbyGiipupUpWlUy6UbWCtfITq+8te9TG
         S5LNtPnIPh9f96dIktlAlytzu0r6RF96xDMKw8buqcXgU6Zwb6jBbPIxlx6FTmKBq7dc
         59CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793320015; x=1793924815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SqR7Qlmk74yXkmM8mpkoCIRlm5LIZR8YEquqyqfTCLY=;
        b=2eLJ55G1OocmOefUKyrm7a7uXJRCqFcTYXdHtZfwn5qXC6P/nJYpIxN06FuHR+UvLe
         QlvZ5ymbaFfFpueMwpN8gHLirleNnAa9CBNuZqL6aftrAsRU3eCE57WIjhZyIjgMEsEA
         49m+18tqlBKyojjE42jMb4XrHi8ianKNMAETe+uXUd9PK2Mi+lePJi/ENZstir3Dn1kc
         ZfHTsj4ZQKVk/QbqBrVwqqF6qkeBYjxEjCQcFnoFwO5aQnl8oHYx5HzwT1QBtMBsgcA3
         QO38doDt0t2nEb3OyG6ykeO6wpZH8aWS7kaZgQeMLvPCh9hAClbhJZHNxzeNCWTy8OpX
         LYig==
X-Forwarded-Encrypted: i=1; AKwUvBwUMnBHMgM+K/9JhuxpbgjQl3LhDEtJPbk2WEHZGypAB+C37agFpJOdWJuwQj8O5NUofsETiWN8J/4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/nv/nhjkq8oFEfKQdrGxIBJh0EcrDJ9YaYcu7P5j08RBb8Qtq
	6VNG/F8ZyhKz6LtTUBzT+FLju9aANCGp7KxoIdainO6uJ6hrg3CpszVW9S5ynsJqWNpYwLa70qX
	M9PDzYIejE8vk0yzAz7eATRrTdExbxdeZ22Z7XdM1
X-Gm-Gg: AYBFou0DTTh9UjW7XFQolgKMSPrJ6a5aA6mgJhS8PWa1+QiZLoXitRvjbpVBf+XXL3F
	gA0+XxF2PhtKFymmPRBP5bYkJQdJSK52MlWO4DV/eoUgd7n5cVqXobTm7UeZWeCg2OU4eN2CiWH
	Fkl7xTZnZD/ngwkIlYbVyIAJoEPwAj5pqqpn0skpJw1mZudCoUGxwgGu5ZhEAvIQ61Bj++AjwBi
	qoNjp9CfFLvthPqcSVFyRKpdNqc+QX/2QnfcHgE+Bb0hBPSLvSKir4nZ/reZqGeRBcQbtYL0EQV
	MokFLYOEr1QfsBQSZhVNkdR/+JEOFpX92h8i8ZoCPN9Y4JwWjfR4VIXIL7x3bSxZMnx6PvhjRP3
	WhFLQai/prKbz+ywKCn284CjMt6TJ9Rm74GWPDfpVhofx3c27feruld3Yxnjp4fDq5XM7+2SP
X-Received: by 2002:a05:6512:32cb:b0:5bf:ba1e:afef with SMTP id
 2adb3069b0e04-5bfd9520081mr152686e87.6.1793320015099; Thu, 29 Oct 2026
 17:26:55 -0700 (PDT)
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
 <auEksxfAi9lHFXmT@google.com> <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com>
In-Reply-To: <auPKfqh_YjRU9Ui3@google.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 29 Oct 2026 17:26:42 -0700
X-Gm-Features: AclHuK_wmS3zhRrQoH9hx3ZcC8OW5l1uNKU_reQs4AjmGufZO3hljBUi1_f8y4I
Message-ID: <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
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

On Thu, Oct 29, 2026 at 4:16=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Tue, Oct 27, 2026 at 08:57:29PM -0700, Andy Lutomirski wrote:
> >On Tue, Oct 27, 2026 at 3:55=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >>
> >> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
> >> >On Mon, Oct 26, 2026 at 3:06=E2=80=AFPM Samiullah Khawaja <skhawaja@g=
oogle.com> wrote:
> >> >>
> >> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that pre=
vents
> >> >> holes from being punched into a shmem or hugetlbfs memfd while leav=
ing
> >> >> the file fully writable.
> >> >>
> >> >> Background
> >> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> >>
> >> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
> >> >> memfd_pin_folios() to pin the folios backing a memfd and hand them =
to a
> >> >> device for DMA. Pinning keeps those folios allocated, but it does n=
ot
> >> >> keep them in the file. If userspace later calls
> >> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the rang=
e,
> >> >> the folios are dropped from the page cache while the device continu=
es
> >> >> to use them. The pin holder is never notified, and from that point =
on
> >> >> the device and the file silently diverge.
> >> >>
> >> >> The existing seals only partially address this. F_SEAL_SHRINK preve=
nts
> >> >> pages from being dropped by truncation, which is why udmabuf requir=
es
> >> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
> >> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That mak=
es
> >> >> them unusable for memory that must stay writable, such as guest RAM=
 or
> >> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
> >> >>
> >> >> Proposal
> >> >> =3D=3D=3D=3D=3D=3D=3D=3D
> >> >>
> >> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
> >> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
> >> >> -EPERM, while reads, writes and resizing are unaffected. Combined w=
ith
> >> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages fro=
m
> >> >> the memfd while the memfd remains writable.
> >> >
> >> >How does this solve the problem?  F_SEAL is about a userspace
> >> >contract, and if there are existing users of the APIs in question, it
> >> >makes very little sense to start making those users fail because they
> >> >haven't taken the appropriate seal.
> >>
> >> It doesn't change any existing behaviour, nothing starts failing for
> >> users that don't set the seal, and drivers wouldn't require it. It's
> >> opt-in. Userspace that wants the guarantee seals the memfd, and a
> >> kernel user that pins it can check for the seal and rely on the pages
> >> staying in the file. For example, the iommufd live update path could
> >> skip verifying the pinned pages at preserve time when the seal is
> >> present,
> >> and do the full check otherwise.
> >
> >Can you clarify the API you're proposing and the issue?  It seems to
> >me like the user is expected to preserve HWPT state by creating a
> >memfd, then using some new API to tell the driver to "persist" its
> >state into the memfd (possibly by binding its existing state as folios
> >into the memfd)?  And userspace is supposed to seal the memfd against
> >growing and shrinking but not against writes?
> >
> >What if the user writes to the file?  What if the user populates
> >pages/folios into the file before using it to preserve HWPT?  What if
> >the user mmaps the file?
> >
> >Have I understood this correctly at all?  Why does memfd make sense?
> >If the goal is to attach a bunch of pre-existing pages to a file so
> >that the page preservation machinery can preserve them, wouldn't it
> >make more sense to have a handoverfd mechanism where the kernel can
> >make a handoverfd that stores its purpose and logically represents
> >some pages but does *not* allow read or write or fallocate or any
> >other user operation that actually acts on the data or its memory
> >layout?
> >
>
> Not quite. Let me elaborate my use case.
>
> For live update we need to preserve HWPT (iommu domain) so the devices
> can continue to do DMA during live update. Domains are preserved by
> preserving page tables and relevant data structures using KHO.
>
> To make sure that the devices can only DMA to preserved memory, the user
> preserves the memfds (into KHO) that are mapped in the preserved hwpts.
> During iommufd preservation we need to check that the memory backing the
> iommu mappings is preserved. We do this by checking if the mapped memfd
> is preserved, but if the memfd had a hole punched into it before its
> preservation then the punched pages will not be preserved. For this we
> need to do a complete page table walk and test each page separately.

Let me see if I understand.  If I'm following, the user makes a memfd
and does something that maps that into HWPT so that devices can DMA
to/from it.  And this is presumably something that works independently
of KHO, and it's preexisting, which is why I had a hard time finding
it in your patch set :)

And the hole punch issue is already present today and will cause
incoherence vs the user's view of the memfd but not actual corruption,
right?  So maybe that should be fixed but maybe it's okay?  (I still
think it's nasty that hole punch while pages/folios are GUPped or
otherwise gotten or pinned causes incoherence.)

But during KHO the system will ensure that the memfd is preserved but
doesn't preserve these detached folios?  If so, maybe the actual issue
is that either it should be impossible for folios like that to exist
(i.e. blocking the hole punch) or perhaps KHO should also preserve
these detached folios?

Certainly the *clean* solution seems to be to disallow punching a
folio out of a file if someone else has a reference to that folio, but
I can definitely see how that's a real can of worms.

>
> A punch hole seal, before the memfd preservation, allows iommufd to
> optimize the validation path and avoid doing full page walks.
>
> The HWPTs are not preserved into memfd; the memfds are mapped into HWPT
> and we need to make sure that the mapped memfd has not mutated and the
> pages mapped from it are preserved. Also it is ok if the user writes to
> the file or mmaps it.
>
> >>
> >> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
> >> >
> >> >Would it make more sense for the drivers in question to set some flag
> >> >(refcount?) on the file to block hole punching?  Or perhaps to have
> >> >the hole punch code notice that it's trying to punch out a folio that
> >> >is pinned or otherwise referenced and to refuse to do it?
> >>
> >> The pins already keep the memory alive while it's used for DMA; the
> >> problem is only that the page silently stops being part of the file.
> >> Refusing to punch pinned folios on every file would change behaviour f=
or
> >> existing users: fallocate() would start failing whenever a page is
> >> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
> >> pinners would avoid the short-term case, but it would still make punch=
es
> >> start failing for existing users of those drivers, which is why I went
> >> for an opt-in seal.
> >
> >Wait a moment here.  Given my comments above, I'm not sure this is
> >relevant to this patchset, but...
> >
> >As far as I know, right now, a program can open a file, register some
> >of its pages with io_uring or RDMA, and then use io_uring or RDMA to
> >write to those pages later.
> >
> >And another program can open that same file and use fallocate to punch a=
 hole.
> >
> >And then the first program thinks it's reading into the file, and it
> >ends up not reading into the file.  Which makes the hole punch
> >operation rather different from the write-zeros operation that it's
> >supposed to be a fancy version of.
> >
> >Now this doesn't sound like a security problem per se, since the
> >offending hole-puncher needed write access (admittedly that write
> >access is only needed at hole punch time, not in the indefinite future
> >when weird behavior happens).  But this whole sequence seems highly
> >suspect to me.
> >
> >Are you *sure* it wouldn't make sense for a GUP'd or similar reference
> >(whether pinned or not) to *actually preserve that folio's status as
> >part of the file*?  Or maybe for there to be an extra pin bit to do
> >this?  Because the current behavior is pretty strange.  And I'm not at
> >all convinced that anyone would really object if the kernel prevents
> >hole-punching a range with an active GUP, especially if this behavior
> >is restricted to writable GUPs.
> >
> >I admit that truncate seems slightly different in the sense that it
> >seems more likely that someone would be annoyed by an inability to
> >truncate a file.  But still, truncate does have the same issue.  Maybe
> >extending a file could notice that there is still a folio covering the
> >newly extended range and stick that back into the file?  Seems messy.
>
> For live update either approach works. If pinned pages cannot be punched
> or truncated, iommufd can rely on that directly and the seal is not
> needed. I went with an opt-in seal only to avoid changing existing
> behaviour. If folks are fine with blocking punch hole and truncate on
> pinned pages, I can send patches for that instead.

That needs opinions from other people :)

My two cents are that blocking hole punch (or making hole punch fall
back to writing zeros) seems entirely sensible, but I'm less confident
I know what to do about truncate.

--Andy



--=20
Andy Lutomirski
AMA Capital Management, LLC
