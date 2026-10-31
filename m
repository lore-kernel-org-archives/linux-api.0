Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793415808;
	b=036wJ6VbhyMzyqS3SVLQj0HmqWKb/Xo1ZwAmd8ypMiVFksHH5T3xTpYCtAsPIV8+9iQ1
	 3I+R+H22d9krzwsauJe6XU5Ik1Zj3XC5QAFjw/F7zp0EavitfSqWxKdvhVr9y6tiftDzY
	 q5PGO/csUG3FblKse+gKkfNMj6vgnKXc0XIobqnY8ews3EB7L3nMuKp2md0jJ7nQ92kQV
	 u3k6iN6fnQzQ+mCF7xCuzSqmoQfKRtP/3R8F547zthGwC4yMHnY8eJzqiiCmyOshdn88y
	 vmmU4gMgx9il9A/bHs6ynMCagwMpuWzGo7GwLxu/RNe30WRzzkuNEBNjhdEBPX55mqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793415808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
	b=1Q88BG677OOLhZlyO535ERWwZwJXTDCNuBr8MwvtWd93+iF8YPdjO28Afhw63TB0wvnM
	 tW8IVeYToJn3laFjTP2sYO8bWWCN4LM2FbqyS5n7a38vkgwYYtNpoBFU8nlBkLr/91zXU
	 zWZ02UBwb7en+lP1X3+f05txi1faLxxLrLUIalN6+JO/WZJF1kbANudT/BeBRltz6UEm/
	 nrxKML0B3LaagWUXKlht8LTC78+j/N9QEJsGmjXGvz9aMuF0duO8XaBMFKf+BMGxXheCl
	 oQE9KZSxIO65i5aAiv+o1gXNypyTItwogQpcB0HDQxE7Ox5gJdCNfhBVB755Zj5NHkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W9M2eNVq;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39919606A31C
	for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 03:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39919606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W9M2eNVq
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2e9f6a16afcso18015ad.1
        for <linux-api@vger.kernel.org>; Fri, 30 Oct 2026 20:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793415807; x=1794020607; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
        b=W9M2eNVqGDvnd6v/5r9OUqnw+qzQQykMbnpeCsUIdhVBWnVu4c0e4mxbP8S+5Ch5TQ
         UNV6HFUjENL+G4Mpexvpqm8QjQq2CPsh4xag+HJLLqLaTOE4CNcUrqHQ+XLGrmMIwWUG
         KrNYM2VnYVSJCafdXRdBRDAtgiOhOKDOmXbeePa/ubYxpcXm9gOiFYwinyfrf9LqhJbq
         DAKW7anXdBpummBWPaUftfsJKuq0ZW62MC/UeMEwhmaIn3FZ+bvgeXeJAj3DR2byJwfx
         DFYneQFULA+hyoq+IHqtql3KTMhJrb+WvzFMmPqyEQODXp3x2/zaODOe9saWCjOJO2eb
         0CDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793415807; x=1794020607;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CykDRQmyupGap9MJ8JD7H5K9Ycd/s3V7wlgI2ffH55o=;
        b=Z1Z20wj/bIVUT6qwarJ/bUW26XCzH94vgNFfVWMOuVIxCBWNWFTGoJgftauwe6zniA
         MSRiWQhkqQYbPWEBRS/L7URy71rJwccHM/KSUYJB//sYKy567KnzLGwOvfmshnVWpyx9
         t6YMio5s3ZXjYu0/KFQQoQlKhIpmU9uudZFmFTcWhmirjxGsKVonXsYRwr1ylilcQxp4
         tU3CoCcyufYvG6NgS7giL+NBEPI+IedSQZcPPBPFDGZcpp841bjAuLUZLAJRHy7O5AEH
         eb5Tgbw4Iqj8lN05u2dRo8vIBH1iMivdFBHW20ynqzTO9b9HclNuFFxFuvs8Dj1a2oKl
         Nheg==
X-Forwarded-Encrypted: i=1; AKwUvBwwqdgw0gQB4NfyyF5Hh4gHRhPsXqPE0pIasvPLJ1Tpr937jkCEI9fbctJ2Ef+ehGdIy7/veI1pwT8=@vger.kernel.org
X-Gm-Message-State: AFq9FYLyZe4DEdGhSLNd+KXklWp4KVCxeIR8wRm8hjFdF8hAdmDaqEt1
	9Gbs3IA7sVaaTX2L2F1SS4cWAewH5LP3Z+6k9s5xZ9hyLCGygcGsTDBCBMhs1hw0hQ==
X-Gm-Gg: AYBFou2Kr4tnEhj+m+0qQGhwGcnweV2gRf7V4wpib3GZAM/lJfXGXg4KmivFWuIutSV
	N+T86/sabXzuOk6IafPtSkS3kcdOFvMkA4qR3xmT1uipy8z8eHqmpU0s+zHbhb48xpyNOo3catt
	ieEqc1P64nW8uwd30Di7FLqjbyu7Qqred/MMZAMasMc8iq9QACX4o88N1bBOFLu+2nSpAOLJSIt
	RdyvvE2Foom/My7f8oLkaS4srHwAAiZrM0WmX4MhOWf6SZUcAewt4L82gKqFEZuQQoxqTa7HB/k
	ysYV/+t69ifv0FqyqPdsodK9uTdsFIBJF3TyAljdrJ9+fg/EBOjwc8elYkiTx7GBH879TmDlJPd
	C+06KwWB4iyP09aexznANt1i8+Pv9Q3GdHrO24xkBMhwuFGKBgB4FeS/Ul64Zl6uP1x548pPV+p
	+m6962KgayF5T/Rq6FV2W4xCkZYsDyv+Pl1JH4opetXDZwjKd3/6WB0KPZsrhhg8ud2SsWpmkrC
	AHEjjJ+aL31KKjzjuEI4SlxgLoRaEJG7q1MSaDvZgi1t5IDIYgo1mpWNGM4GM969P7XzzpS3S2N
	uVNHdFSlnuEf9ne/SrMm/EuelfYEhcV9AeplprOYS8PaAdhjzcTYwu4HeGjNLHafNfbRmdqfWK3
	CPsY7lSyjv/1QbVcmB54CkvW3EW5oPPE/c1FOlmWEaHs=
X-Received: by 2002:a17:903:2c04:b0:2c9:b404:b55 with SMTP id d9443c01a7336-2eb1b8c1cddmr13716365ad.6.1793415806880;
        Fri, 30 Oct 2026 20:03:26 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845429e6sm5927972a91.6.2026.10.30.20.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 20:03:25 -0700 (PDT)
Date: Sat, 31 Oct 2026 03:03:21 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auVRLPmbWYvMnly-@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
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
In-Reply-To: <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>

On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>
>> On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>> >>> On 10/26/26 23:05, Samiullah Khawaja wrote:
>> >>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>> >>>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>> >>>> the file fully writable.
>> >>>>
>> >>>> Background
>> >>>> ==========
>> >>>>
>> >>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>> >>>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>> >>>> device for DMA. Pinning keeps those folios allocated, but it does not
>> >>>> keep them in the file. If userspace later calls
>> >>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>> >>>> the folios are dropped from the page cache while the device continues
>> >>>> to use them. The pin holder is never notified, and from that point on
>> >>>> the device and the file silently diverge.
>> >>>
>> >>> We have the exact same situation when userspace maps anonymous folios into vfio
>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
>> >>> used for such purposes.
>> >>>
>> >>> User space must not zap/punch things that might be pinned elsewhere.
>> >>>
>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>> >>>
>> >>> I don't see a reason to make userspace (that should not shoot itself into the
>> >>> foot) a kernel feature it must activate itself to not shoot itself into the foot.
>>
>> Agreed, for normal use this is userspace's problem. The seal was meant
>> for the kernel to cheaply verify at preserve time that nothing was
>> punched.
>>
>> >>
>> >> The issue is live update doesn't preserve those background punched
>> >> folios and now we have created an UAF attack on the kernel across
>> >> kexec if you don't do something about it.
>> >>
>> >> There was some notion here that with the right sealing flags we could
>> >> tell if everything was 'live update compatible' and then know that
>> >> these attacks are impossible.
>> >Just remember that there was any hole punch and refuse to live update this instance.
>> >
>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>> >don't think that's required initially.
>>
>> If I understand correctly, you mean recording on the memfd that a hole
>> punch happened, and refusing the live update if it did? That would work
>> and is much cheaper than what we do today, where iommufd walks all the
>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>> is enough or I can record that also on the memfd. I will send patches
>> for this.
>
>This entire situation continues to give me the willies.  After much
>prodding and contemplating (in my own brain), I got a friendly LLM to
>report:
>
>--- begin AI output ---
>
>IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>or khugepaged] checks the old folio’s reference count, so a pin
>acquired before that check makes collapse fail.
>
>  The problematic interleaving is:
>
>  1. collapse_file() locks and unmaps the old folio, then passes its
>reference-count check (mm/khugepaged.c:2446).
>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>file’s XArray and pins it, without taking the folio lock.
>  3. Collapse copies the contents and replaces the old cache entries
>with the new huge folio. It does not repeat the reference check or
>freeze the old count.
>  4. IOAS retains the old physical pages; accesses through the file
>use the new folio.
>
>--- end AI output ---
>
>Is this correct?  I haven't personally verified it.  But this whole

Yes, I think this is correct. memfd_pin_folios() pins the folios
directly without taking the folio lock. Other page cache lookups lock
the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
memfd_pin_folios() misses it.

This scenario is different from punch hole or MADV_DONTNEED where the
user decides to remove the pinned memory. Here the kernel is removing
the pinned page without the user knowing. Collapse already checks the
refcount to avoid this.

The recent fix [1] by Chris already takes the folio lock for !uptodate
folios. I think we can take the lock unconditionally and recheck
folio->mapping, that should fix this. I can send a patch for this fix,
if folks agree.

[1] https://lore.kernel.org/all/20261029-fixes_core-v2-20-a64ce7f83abb@kernel.org/

Thanks,
Sami
