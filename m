Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793439164;
	b=CrQj2jRwWdjBjWXc1+0KARkFTFOfCcbCrHb+ljPxmCrgCnO2UNHEfLFCqLa2/bJPEVXl
	 FQk++QctUcrFOGDcXH5w479G6yJzC41emSSaOn3nWPVqhDh/DLQ16OzfhnvFKiS5siIDo
	 hWsaWVnzvW50+w5dC5E4uTnX25JyIT4PJu5f/8cOhXbofLgyiZaULNKM+KJr+sWNF6v6f
	 9jzzN0wJ8Z1Dxn9HKPrzLLcYd+G67DYVKHKrNdN1JXxtVnh9ETyn0Z0G12T/VuYkXKYK9
	 30Ar9rd52DugiaFZVquJ07BBmdlBi4NzmOleOrhJYRpuRfu2pYglwmwy7MwctjUDfVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793439164;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=jVV37u2/JFMbTqwrO/nldhPTNdr2cEJ4JwbP51ZF0as=;
	b=UBqSLhLRADSXk2emeKE6fMdS9mWiVT+1MUm8/dLa45c8th0o654IcMVSUoI7uceHjWwR
	 ik5dnHKDjjrQnbhhhcgvckkHk8HA1zVRxN5WJ2C/yMITRmivre5nxBgWL7BIPUaNX2yFR
	 Ly8trt7eHo1+JRm83MYSY03vEdc9xcEaOeTRDf+EXW/DJK1CLt/Ar7ZnzxKfkmLuh7q1L
	 26XlbkOC0E6Sbbh1xvjj+jO2SbNqyZvyojsvEcptNb7UhGHuy4Ast9g+AZ/Idrk8d+9ZT
	 ScuSRC0AX09yUy472QVHdbzrUcah908I1iKOv8+RHz76NR/RUF4hcA1cl8jczlB3LUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Cg4K3/Ax";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8555606A31A;
	Sat, 31 Oct 2026 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cg4K3/Ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CF61F000C1;
	Sat, 31 Oct 2026 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439163;
	bh=jVV37u2/JFMbTqwrO/nldhPTNdr2cEJ4JwbP51ZF0as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cg4K3/Ax3YvyEFtn0SNP9CSc1Nk8veaJhxtFdP64CVmOxVBaqGziD6b1+pBnD2HCG
	 TVpmFTnFoZprPb5oow/zeRYBZiObDg94zPComBUYuYenUE4S3d209Zy+ZPC1Jj7kEQ
	 0gVgZmal7UaOb7UN+jTfYnC1bsVG3uHV+QGOoQhv14Un4veVVSB+CP1OIvNs9WoJvC
	 0+m11isq4Tnsx5Iacv8L+cTpIo6hCp70pcfqFrt+qJTnxkvekLbITYiHWgqwADr+vc
	 46MFftPD6d5QRa33rv24eA32zC4o7DU4fJv1ncoIwIe+TF2c/slf0sogg5/ApvFgMN
	 6yzm2FAR1D/uA==
Message-ID: <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>
Date: Sat, 31 Oct 2026 10:32:32 +0100
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Post: <mailto:linux-api@vger.kernel.org>
List-Help: <mailto:linux-api+help@vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-api+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
To: Samiullah Khawaja <skhawaja@google.com>,
 Andy Lutomirski <luto@amacapital.net>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
 Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>,
 David Matlack <dmatlack@google.com>, Pasha Tatashin <tatashin@google.com>,
 linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
 <auVRLPmbWYvMnly-@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auVRLPmbWYvMnly-@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 10/31/26 04:03, Samiullah Khawaja wrote:
> On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>> On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>>
>>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>> >>>
>>> >>> We have the exact same situation when userspace maps anonymous folios
>>> into vfio
>>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend
>>> that is
>>> >>> used for such purposes.
>>> >>>
>>> >>> User space must not zap/punch things that might be pinned elsewhere.
>>> >>>
>>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>> >>>
>>> >>> I don't see a reason to make userspace (that should not shoot itself into
>>> the
>>> >>> foot) a kernel feature it must activate itself to not shoot itself into
>>> the foot.
>>>
>>> Agreed, for normal use this is userspace's problem. The seal was meant
>>> for the kernel to cheaply verify at preserve time that nothing was
>>> punched.
>>>
>>> >>
>>> >> The issue is live update doesn't preserve those background punched
>>> >> folios and now we have created an UAF attack on the kernel across
>>> >> kexec if you don't do something about it.
>>> >>
>>> >> There was some notion here that with the right sealing flags we could
>>> >> tell if everything was 'live update compatible' and then know that
>>> >> these attacks are impossible.
>>> >Just remember that there was any hole punch and refuse to live update this
>>> instance.
>>> >
>>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>>> >don't think that's required initially.
>>>
>>> If I understand correctly, you mean recording on the memfd that a hole
>>> punch happened, and refusing the live update if it did? That would work
>>> and is much cheaper than what we do today, where iommufd walks all the
>>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>>> is enough or I can record that also on the memfd. I will send patches
>>> for this.
>>
>> This entire situation continues to give me the willies.  After much
>> prodding and contemplating (in my own brain), I got a friendly LLM to
>> report:
>>
>> --- begin AI output ---
>>
>> IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>> or khugepaged] checks the old folio’s reference count, so a pin
>> acquired before that check makes collapse fail.
>>
>>  The problematic interleaving is:
>>
>>  1. collapse_file() locks and unmaps the old folio, then passes its
>> reference-count check (mm/khugepaged.c:2446).
>>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>> file’s XArray and pins it, without taking the folio lock.
>>  3. Collapse copies the contents and replaces the old cache entries
>> with the new huge folio. It does not repeat the reference check or
>> freeze the old count.
>>  4. IOAS retains the old physical pages; accesses through the file
>> use the new folio.
>>
>> --- end AI output ---
>>
>> Is this correct?  I haven't personally verified it.  But this whole
> 
> Yes, I think this is correct. memfd_pin_folios() pins the folios
> directly without taking the folio lock. Other page cache lookups lock
> the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
> memfd_pin_folios() misses it.
> 
> This scenario is different from punch hole or MADV_DONTNEED where the
> user decides to remove the pinned memory. Here the kernel is removing
> the pinned page without the user knowing. Collapse already checks the
> refcount to avoid this.
> 
> The recent fix [1] by Chris already takes the folio lock for !uptodate
> folios. I think we can take the lock unconditionally and recheck
> folio->mapping, that should fix this. I can send a patch for this fix,
> if folks agree.

I have another patch from Anthropic on my "rework schlop" queue that should fix
this:

"mm/gup: pin memfd folios under the folio lock".


We'd do just what we do in other context now, which is checking under folio lock
whether the folio was truncated.

Care to send a proper fix?

-- 
Cheers,

David
