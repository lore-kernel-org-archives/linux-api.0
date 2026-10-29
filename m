Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793315793;
	b=qcrW0AN4QEREv5rdRntE6Zvjhfty+9L/2pe0HsItflgYiuRJutBCfb7P0i4AIIGnJ8Ou
	 lDODUzAmGkT5sWeJA2DfRPZoRzZwPrnmR8Y9gvBy5LKNimw5xk+z2IjGLfN1srmtc0owo
	 apmLZXb8GFY91m+dozyQUrDv18IFzHqjBGlX+cQ4VZ4WYB5002rZx57Z6gMMrrWtMRfe5
	 bA4sFZrrAH9ovNR4fdjB3T/Q2evNYnNgbzBoRTczabKRYXNOkAn+38zQyDntQ1cSjoJj0
	 4t0om0Uw6OU1zch2xo7Rq1f3+m0tAOX6vpOgcBo5XkPr1Q6bCDKs999LYZTtq/vaiCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793315793;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
	b=mdDD9A2QqZpRkoZTfEe61dJnFMV/RjCnG4Di4/6RyJqtjxeH7lWZVeaBagYSUfjYZvpH
	 LVAhFoMFpLO6N6+E9220RFgWhxwWiLPkZUjgWKkTvaqYfTk+KgLPHO2qVhTkZDirVVY/R
	 3liJA7ppzydIX1/N3/XylVaARhZblImuQTJxWc31gwgnP2xKz8h+UnIvaH/81MZHT3PXI
	 MEpclyfALvgjbqjRCmahtCFbryW/37UnNWcUo4EAdcxEGDHBDPRaQf20MnVFqpaWGWNBE
	 buDvppp9AN6AKZXn4h6dxhhoqmjWOseosXu5FMUjbCv15+mpcpPTu2A/1fXRcrS4adA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pkArMhrE;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784EA606A31C
	for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 23:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 784EA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pkArMhrE
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e9f6a16afcso13375ad.1
        for <linux-api@vger.kernel.org>; Thu, 29 Oct 2026 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793315793; x=1793920593; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
        b=pkArMhrE1jC7hZiUFJ5bFlNREJAg/sMOcRWZOq9fGPBFun1oHDlSrITxDOErkPefMg
         wKP5BsVjYN24s8kTH56YdJ0ePck1+gSp2JP2CBe9i9cKQrci8fnvezDohh4IxqHAQwXr
         FuSYH6xJm4NrElJ5IYikZh0atmfVVDudq8DFYwVZn5YQjqG4pJcpY1xiarMqVGLYsNhw
         2INQvbECPAe6u5CkFosje88KshBFSv2LZ/shCNlaEKyU8jRcz9mngNUaN/+Ls3e46pco
         vXWbIru49VFW3yblEFZ5u+kqFvWKxzYwntufZRBawc24oPtI0it3Xc5kA3QzYYkE8Ed0
         ME6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793315793; x=1793920593;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3fmE280TvwYgL1SpHpcTgt7nw3en3MelpBcz6M9OOWk=;
        b=aCcEeWMo8l2FmeUCfTPHAZ8TzSKJostLJPNGcvNvHSD09U7DVDVzA/nlMVz9QilVCH
         ecoNf2rqnYTsmv5grjtt7HWtEaiQLawNxrChV/1O/de0rhHH+fs8chRHmCw0VfcOc8Uk
         xCgkwiVBr5EVHStNjiNqRnA4uGuCY0zR8jDeaRraMjoqbV1M0TAbvLI1eaf8ctkQIt6I
         doxhtydUNbEZ80kdyXjKJALObRM7tyexqFZzHzjA11slvIvJavM/B4WeTYuQtsFo4+MJ
         +UQp5v4p8KAHH8iBqFRhBWgnynw2dWC6ywyhIY6SwJAJxV0Hjdg2S67aRKxHtG2pBYo3
         Bt1g==
X-Forwarded-Encrypted: i=1; AKwUvBwtDvY42wL5uFCrcTCrle1D1Jzos1DsUewubqlao6TaCh1/Q86lxWFSB8h7XIEV3g6tbTIWoQWVwZo=@vger.kernel.org
X-Gm-Message-State: AFq9FYLorgtF4FhOnLCsCwokzUOo2NOrOjioS3W3xyvtGtvrfNkTgqdG
	AML7h5a7tJCsyMDQwBoWadw3TYRVmVCyFcFEWycyocTyFdchfHxTrwdGqeS2xiKe2Q==
X-Gm-Gg: AYBFou36xi1LtYHiCv2ppbNhR6TVfxfrtn0GZkH6Zg1BGvN2gzQJdG3kGmBpvo3+TSh
	EtNZiMfX1oGzzDngrRV/f4am7pBTdyEr9LVPtYWJA1f7TT4NzcAXGOBOO53YL68d3CLrqnjyYkv
	BWo37Ygc4yeIBfW41GWY9ni8At1pfbBlZeLIvv7pgEYkRTAFx03WMp3vp24IxGjPbPdAfqigez7
	WzGulioG/WgOc0y4KbAR5Bb3iRSBSvURENvjP8i1tptHeIda3ZG8WfEau9iiY7YpnNuQCTjBuYN
	LrL8bjlTq3cF3NIExCWkHfOLI6u5TJbBzH5XQd5EKU56PRsX3yEA4TG2usm2yqa8n8O+n4anyjg
	y/eD8bjytq04jV7sGIiRMoZeS7CtRzCBoJv915Hci2z6oBGdDz+Tm++QzltihWz5QZnQu3jIsZT
	7O/ltKxPQ5Xjl+oFgwOCXlcfcUqzacVqTkXxr/nO/KlvfmZ4ZkCCp0Kuyfo5YA2HQA65n5/dCGj
	lHoLmK4N/RtJT9RHlONDbRob/R2eJaELbKFfd3WHwtOQgJXC8i6jSKtJJCSHHHU7P4YkFegnEWW
	VUX1KKRErVCq1COHFJzeiFMfGFNTqpplzLMnH39IS99VQ5v9Y1I/0GGeMytJBQhxe8wGQJZ1yuO
	gtNkkU4Q3V04t+XGFDiMhCA==
X-Received: by 2002:a17:902:d2ce:b0:2eb:188a:1c06 with SMTP id d9443c01a7336-2eb1ec12e12mr7097365ad.9.1793315792099;
        Thu, 29 Oct 2026 16:16:32 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae84542a13sm1362240a91.5.2026.10.29.16.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 16:16:30 -0700 (PDT)
Date: Thu, 29 Oct 2026 23:16:27 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auPKfqh_YjRU9Ui3@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
 <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>

On Tue, Oct 27, 2026 at 08:57:29PM -0700, Andy Lutomirski wrote:
>On Tue, Oct 27, 2026 at 3:55 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>>
>> On Mon, Oct 26, 2026 at 03:46:34PM -0700, Andy Lutomirski wrote:
>> >On Mon, Oct 26, 2026 at 3:06 PM Samiullah Khawaja <skhawaja@google.com> wrote:
>> >>
>> >> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>> >> holes from being punched into a shmem or hugetlbfs memfd while leaving
>> >> the file fully writable.
>> >>
>> >> Background
>> >> ==========
>> >>
>> >> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>> >> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>> >> device for DMA. Pinning keeps those folios allocated, but it does not
>> >> keep them in the file. If userspace later calls
>> >> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>> >> the folios are dropped from the page cache while the device continues
>> >> to use them. The pin holder is never notified, and from that point on
>> >> the device and the file silently diverge.
>> >>
>> >> The existing seals only partially address this. F_SEAL_SHRINK prevents
>> >> pages from being dropped by truncation, which is why udmabuf requires
>> >> it. Hole punching, however, is only blocked by F_SEAL_WRITE and
>> >> F_SEAL_FUTURE_WRITE, and both of those also forbid writes. That makes
>> >> them unusable for memory that must stay writable, such as guest RAM or
>> >> DMA buffers, and udmabuf explicitly rejects memfds that carry them.
>> >>
>> >> Proposal
>> >> ========
>> >>
>> >> F_SEAL_PUNCH_HOLE fills this gap. Once it is set,
>> >> fallocate(FALLOC_FL_PUNCH_HOLE) and madvise(MADV_REMOVE) fail with
>> >> -EPERM, while reads, writes and resizing are unaffected. Combined with
>> >> F_SEAL_SHRINK, it guarantees that userspace cannot remove pages from
>> >> the memfd while the memfd remains writable.
>> >
>> >How does this solve the problem?  F_SEAL is about a userspace
>> >contract, and if there are existing users of the APIs in question, it
>> >makes very little sense to start making those users fail because they
>> >haven't taken the appropriate seal.
>>
>> It doesn't change any existing behaviour, nothing starts failing for
>> users that don't set the seal, and drivers wouldn't require it. It's
>> opt-in. Userspace that wants the guarantee seals the memfd, and a
>> kernel user that pins it can check for the seal and rely on the pages
>> staying in the file. For example, the iommufd live update path could
>> skip verifying the pinned pages at preserve time when the seal is
>> present,
>> and do the full check otherwise.
>
>Can you clarify the API you're proposing and the issue?  It seems to
>me like the user is expected to preserve HWPT state by creating a
>memfd, then using some new API to tell the driver to "persist" its
>state into the memfd (possibly by binding its existing state as folios
>into the memfd)?  And userspace is supposed to seal the memfd against
>growing and shrinking but not against writes?
>
>What if the user writes to the file?  What if the user populates
>pages/folios into the file before using it to preserve HWPT?  What if
>the user mmaps the file?
>
>Have I understood this correctly at all?  Why does memfd make sense?
>If the goal is to attach a bunch of pre-existing pages to a file so
>that the page preservation machinery can preserve them, wouldn't it
>make more sense to have a handoverfd mechanism where the kernel can
>make a handoverfd that stores its purpose and logically represents
>some pages but does *not* allow read or write or fallocate or any
>other user operation that actually acts on the data or its memory
>layout?
>

Not quite. Let me elaborate my use case.

For live update we need to preserve HWPT (iommu domain) so the devices
can continue to do DMA during live update. Domains are preserved by
preserving page tables and relevant data structures using KHO.

To make sure that the devices can only DMA to preserved memory, the user
preserves the memfds (into KHO) that are mapped in the preserved hwpts.
During iommufd preservation we need to check that the memory backing the
iommu mappings is preserved. We do this by checking if the mapped memfd
is preserved, but if the memfd had a hole punched into it before its
preservation then the punched pages will not be preserved. For this we
need to do a complete page table walk and test each page separately.

A punch hole seal, before the memfd preservation, allows iommufd to
optimize the validation path and avoid doing full page walks.

The HWPTs are not preserved into memfd; the memfds are mapped into HWPT
and we need to make sure that the mapped memfd has not mutated and the
pages mapped from it are preserved. Also it is ok if the user writes to
the file or mmaps it.

>>
>> https://lore.kernel.org/all/arVYa_90j0oN1hnu@google.com/
>> >
>> >Would it make more sense for the drivers in question to set some flag
>> >(refcount?) on the file to block hole punching?  Or perhaps to have
>> >the hole punch code notice that it's trying to punch out a folio that
>> >is pinned or otherwise referenced and to refuse to do it?
>>
>> The pins already keep the memory alive while it's used for DMA; the
>> problem is only that the page silently stops being part of the file.
>> Refusing to punch pinned folios on every file would change behaviour for
>> existing users: fallocate() would start failing whenever a page is
>> pinned, even briefly by O_DIRECT. A flag set on the file by long-term
>> pinners would avoid the short-term case, but it would still make punches
>> start failing for existing users of those drivers, which is why I went
>> for an opt-in seal.
>
>Wait a moment here.  Given my comments above, I'm not sure this is
>relevant to this patchset, but...
>
>As far as I know, right now, a program can open a file, register some
>of its pages with io_uring or RDMA, and then use io_uring or RDMA to
>write to those pages later.
>
>And another program can open that same file and use fallocate to punch a hole.
>
>And then the first program thinks it's reading into the file, and it
>ends up not reading into the file.  Which makes the hole punch
>operation rather different from the write-zeros operation that it's
>supposed to be a fancy version of.
>
>Now this doesn't sound like a security problem per se, since the
>offending hole-puncher needed write access (admittedly that write
>access is only needed at hole punch time, not in the indefinite future
>when weird behavior happens).  But this whole sequence seems highly
>suspect to me.
>
>Are you *sure* it wouldn't make sense for a GUP'd or similar reference
>(whether pinned or not) to *actually preserve that folio's status as
>part of the file*?  Or maybe for there to be an extra pin bit to do
>this?  Because the current behavior is pretty strange.  And I'm not at
>all convinced that anyone would really object if the kernel prevents
>hole-punching a range with an active GUP, especially if this behavior
>is restricted to writable GUPs.
>
>I admit that truncate seems slightly different in the sense that it
>seems more likely that someone would be annoyed by an inability to
>truncate a file.  But still, truncate does have the same issue.  Maybe
>extending a file could notice that there is still a folio covering the
>newly extended range and stick that back into the file?  Seems messy.

For live update either approach works. If pinned pages cannot be punched
or truncated, iommufd can rely on that directly and the seal is not
needed. I went with an opt-in seal only to avoid changing existing
behaviour. If folks are fine with blocking punch hole and truncate on
pinned pages, I can send patches for that instead.

>
>
>-- 
>Andy Lutomirski
>AMA Capital Management, LLC

Thanks,
Sami
