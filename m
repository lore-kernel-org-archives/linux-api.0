Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793382029;
	b=VUwgGlR5GtLaTtAPEDdoPLd7S6wPDFVzGouLlGjk+Gie2NRM26AHBrFPeaPXrVk+yj7+
	 tlK9gGHGghodRNyIfvZaf//D+ZATioJ+R0pycPdYoXGVoxS9UUlcSoyDv1ogAd4sFdIvz
	 VNjIV2/fZewIEoRYN6A6jP66zfRNmQ9T3PbR+whIxLbg46UseYT4KemiFpG5uUugUnUov
	 pGtfK8/HsqgRFD+CTo09Xr6e0lcG5/EuspD8iU3aaWpUkYGb1HRGp7j5V/NyvZT9VQcF5
	 ZTcvNDYBKy56iPRsPAkYRKrPHAdicSPTQWMY3fGO0oieWYCVWrRYCxV7LtzbbqnPVnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793382029;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
	b=e6YQGdaflvNMaBoCrns7YQriFy8MP/wGEMd0L8pWMIU+LGsUSF97ojMKivN5NRvxkzTh
	 aQmlaE+4Xl3DbZdhtkdHgwx9RJ+s+NprLcY3nzMPuhNnCC8IWmMcCgZq4Oqrf+t/7xVf7
	 9rNC8DqqALzka81MqogBx0uLQ+G/nM9Tbb91LWddfnNi3qOXBgq3mZn6FdhsH8i/zedGQ
	 MgG6nAhKdO3sBCq04drsg3T6COSBpJbDPML+DCOuoIl5VkaSOcZqMeX0aibd5VGBWYx7K
	 EmwOlN57om3VRmeeOmXDRlIWsOJHfup9SVYgUq5MJtdVksZ10cJ6WnKCmJ9xlCv4EPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hFGIcN54;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A5A606A31E
	for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 17:40:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02A5A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hFGIcN54
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9f6a16afcso2095ad.1
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 10:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793382028; x=1793986828; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
        b=hFGIcN54HxCRWLwn+m1Xl4QEQDE5/cl5x+KQSXQJyEMT7wiQkby7aqDXSx488THYoh
         f5kvplnhqeV9H0k5RQGHt7kvJo1UxJbeygdqm1NlxybFI+IKbH5B7sosuiPbjK5SSmUx
         wfmzHB3MKh0KJszVevX1LoLIVaWH1EN5bVX41aH4OURNcHbwHQxwGDqCkdH3LymLeTv5
         wfhlyhEtPWyaNF3C5seBSdczetIWvRQsxsEp97tep86ff1DRBcxuV80CfWJKgoaMWYjs
         TksrH2ngp09wtcLUCyFJnya0jRB+MDR/3mR4e3RHUskJbg9rjzdXrJ5mEBF4fwPsGYs2
         gUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793382028; x=1793986828;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
        b=siDj9upZoUr700kuwwQqXTPjS+VPO+Aktu6xhET/9cl4IVH2IpoDk/XiDg8loHJhv6
         pmsSiD9TnlKNiGG/Z1Oo38AOXpCWCoMA7C7HhJ/TPvPCIcTaSocj30qEv6Nn+lzd6mxr
         nqDe6SAiEWDCcFWL0N5llCyKdP5JbX3/codfP+p0tvC8OG2hMo5mFVpuiuAwTIy0/rRR
         4+wE78b1w0eqPQ5U69CY3pCMMG+5LBX5+1C8dqSmnkwoRxHD28PXJAPfkeyRtDY3vqJ7
         dDfzDqbSYKVWh0UwRh18wOjdeUkWwzzGkbzAt1ut3I7TQtVXqzahoQHBZClFnPr0nR/6
         kOKw==
X-Forwarded-Encrypted: i=1; AKwUvBwfXlhhw+J0IJHoX0AsW+tODSJQB0Xvcq26Lo2jqN+WTyiXSjqGWN8DeE74TynEzF54XFs7im97zRU=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ5wnwGUhh7hToOwDeoHIL902VItaKVgnnP20y+I33TECoe4CyT
	i5K4dXHBq9wPqpFGxANlPR09BMm6yKqe5Bieq2Yfcmnz0WofhDl+pcohlMtCmdqbIg==
X-Gm-Gg: AYBFou3dl4ywXnW52u8ZcxZmsaT8WDOJdY62GUEFc0YXAH+nyDe3l0e952eTET/XEBi
	dG6flaUIn1rV0UpkoBRCi29s60gr5Yh3MALHEYqG1oYCTadkXFCqh/RuSTK99tW9bjCMGqssbck
	pdoBM1KBc0V+ff2w9wZ7SMiPgb1H3eCfWfEyka/EBIy8Skb2/Idshxto5hz8fBe0/PELzXorFw8
	+ijoiKjDn+l5EXFXALO/yzfpvE9uX3s+Wrc9WWmRAhvc7yF+vjvXS4bRId070bsxOf8R5gIfAON
	ldGmoU/mXiKkw438BedZiL9u8ZnqCzTeYSeeLdAoqgL4I+Ui0dGnIIgimReARsIOjZMB1do5FS1
	3jPRLuxyk5uuc9sDXm+8eHoPyTEX1u5EDVfp/Mnp/QGyg7v6n29NmoCYXmfYTj5+XUTgKhW33mp
	UerNPQP4JheGHDPnOZ+aFnA8ICBBHMdy+E52UjxsMSfLzC56nrppHrVhkpHAnC4r6tbMxT6k8Gn
	55MCEzKtLVhF5NIMpl/wuWnwyCT2weZWjnag7SZdx9cfxfr9xo4C28akK3GNWEpIX8gkJFHFUBt
	ML5y7sSGco5R0r9s8Lg86K4jKsgZFsD1RewPbvF5UKFxhVS89JCcRMm+BrheLMr7wpW9j28g5u5
	+/NV2laTvMr0oE9djf+BPuA==
X-Received: by 2002:a17:902:dad1:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2eb1b6c6ae5mr11320655ad.2.1793382027347;
        Fri, 30 Oct 2026 10:40:27 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aada9aadecsm286624b3a.48.2026.10.30.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:40:26 -0700 (PDT)
Date: Fri, 30 Oct 2026 17:40:22 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auTR9SnDLsLVmnJ7@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>

On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
>On 10/30/26 13:11, Jason Gunthorpe wrote:
>> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>> On 10/26/26 23:05, Samiullah Khawaja wrote:
>>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>>>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>>>> the file fully writable.
>>>>
>>>> Background
>>>> ==========
>>>>
>>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>>>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>>>> device for DMA. Pinning keeps those folios allocated, but it does not
>>>> keep them in the file. If userspace later calls
>>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>>>> the folios are dropped from the page cache while the device continues
>>>> to use them. The pin holder is never notified, and from that point on
>>>> the device and the file silently diverge.
>>>
>>> We have the exact same situation when userspace maps anonymous folios into vfio
>>> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
>>> used for such purposes.
>>>
>>> User space must not zap/punch things that might be pinned elsewhere.
>>>
>>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>>
>>> I don't see a reason to make userspace (that should not shoot itself into the
>>> foot) a kernel feature it must activate itself to not shoot itself into the foot.

Agreed, for normal use this is userspace's problem. The seal was meant
for the kernel to cheaply verify at preserve time that nothing was
punched.

>>
>> The issue is live update doesn't preserve those background punched
>> folios and now we have created an UAF attack on the kernel across
>> kexec if you don't do something about it.
>>
>> There was some notion here that with the right sealing flags we could
>> tell if everything was 'live update compatible' and then know that
>> these attacks are impossible.
>Just remember that there was any hole punch and refuse to live update this instance.
>
>We could likely implement "we saw hole punch on a pinned folio" as well, but I
>don't think that's required initially.

If I understand correctly, you mean recording on the memfd that a hole
punch happened, and refusing the live update if it did? That would work
and is much cheaper than what we do today, where iommufd walks all the
mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
is enough or I can record that also on the memfd. I will send patches
for this.

>
>No need for more shaky seals.
>
>-- 
>Cheers,
>
>David

Thanks for the feedback,
Sami
