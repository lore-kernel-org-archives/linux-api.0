Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793475043;
	b=aEVHL1Ggd+dTGhZuT7Vqec2kKgiov+arGY0aS5QdIcUpYxx/uVGgD2HP9QC+UGDdOgTb
	 f5zizVpLOBN1gy+qAxMGimqX6/TE6P2bm6H04Ij6JCO428oKwjkNR7px6Nb66WYfbleV9
	 WCkDt+R+ZLCcEXxeVjvLcKfFik6eNx5UbLizLkiVtObz5JF5gtYemuYT1U0jNmOkaBkFd
	 bbDtVzoY0KRVJeDWdD584TZmw1cmbFig3cWoy+QvCgEO3r5dbmFdYC0PcM4ETVeFwXn7c
	 ILJfOAKhPEBzxNxbcdAXTB5cns7VPi+JttnWds4sqrdT1Lyv1BO9DzCsGD9eCtQWBWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793475043;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
	b=TAPbNd+H+9U47iy+3fKPUPlRub8jQAkghEPWLuDbIxxSKPPaD+Bs1oapTXDh/vpcwfgO
	 hTXAGBvm2MPJxerl0jokwLP7r8CXhthsSxgxzpXJQ+0pswSCnnSFEqoPjFjdi+IihEkMc
	 Q9XvpIXN7Z3ypZCeieJJxgtP6d+9baobOK5CAcKFEufL7AnlC8vw46yaymhPcVkixw+nI
	 lRzyvDF2RxgSDqbo6APmCvfelF2/Od5zEDxFxF+OwXpMZERsa/YpRxGFV3nLAzZq0yslc
	 m+SiwZvu8FqUWkriTsQcA1VxxFSQuvEvw/CLwcJu7HN0LTnTAIlvEjwLPQg0Z7iWUTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HhBwmS8h;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5D5606A31A
	for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 19:30:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C5D5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HhBwmS8h
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e9f6a16afcso31775ad.1
        for <linux-api@vger.kernel.org>; Sat, 31 Oct 2026 12:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793475043; x=1794079843; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
        b=HhBwmS8hyGxnbnWQ16k8eUFYhNVqQ8Pdk0pITn0ZQ0rKFcHCqClnIq4GLoWvbyCX5F
         aogBcNkbqBpnw28f0Qq0ECzOvgyN7dwKNJFnB/pfwuJVmtHIwNFj8+0p89XKCrxVg8K4
         Se2hglS5l06jFdkXfD/g8GLdVoTA9gSZUL0dVuN2MX0YYY6tWmLUIwwD+WKq0TOqpZLM
         EYs0KI37srggPyQbBF76ext6w+/OJCkWkaI1Dp6uuEqN6T1khzsBmZjaeNb/hC0mM4Jm
         4G3pKOUuA2MPiqe+xj83D5cn8sAKFCUfMTPxxLnf+5QUL4QYRdmIKAqxkE1lHYp5OMFI
         xn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793475043; x=1794079843;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+8QGpnyPZ7DhkQpiphg595uJGsoBZBg/wk/3XMNmDqI=;
        b=qOvI0GXq+VbMRabF52eDY3uJ41vM1CKIJN6hTYUjzkG/5NkUpJA11j2uCE5lLNdXvE
         MBWTpyC6/9n7fQ6T495Eqd3fSnFw5vg95KEU4qD5zlOe0P01XYgH3c/MzfWJRN0r9zRE
         m9jyDJXGxnm32NlQOKoD6mg7SHOS+5j3x+VukUY0pbFvp3+1ogLa2aTCbQaY4GjKmggt
         308uQRpHmQ3iIuWAbQP8UX7OB1KVkU6Th+PCdWCYPuqfrWI00jdVnpwVwAJcEAtFXtir
         dYJtyGTk9GrEC6jayEZXKKwrnQxrLYib4KNtz6iLHk9OY9HT2ueARXSV2MFNORIumEgu
         qO6w==
X-Forwarded-Encrypted: i=1; AKwUvByWt84+OAOPO0WvoOHTq0MJjxmyXLNxSnbG4fVf/1FtPucYRf0cYCHQczuSXaUjc2Zz854dWjviLuQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYKJo+Lz41cBgSFfFyNkLxWTMgaZi/pCzOLHGQwHsPaIJwHFVjOC
	3163CTsfScWvqGRkdo8ei9FP/FTKlH1Olvi6vBTpv4olEkVMW+OnsmAIU0TwlWL7UA==
X-Gm-Gg: AYBFou2ZN05GlVARENz0EGlINSajg+nerr9Q4E1SKeSYskv23LuXytgwE/LEuI43gUB
	OhWY3c0yL/DCgtIS/JeIM1ls6LdLt9/20YnsJU+azPRVYTVOvnLFPpODeTsEejr2pF5HoNtywEw
	KA25ylcn2k6ZL+iedxRQrssBr5kYeaNsr80QwEzRqaVCRElNKbboj99SIlCGEyLtpXAfJq5Ofhp
	ex5xW5YQJ6gOzJNHKUa07YNO5MLJuLWqgHJ8yqLhrVkOH9w00iqNLRZUlJAWG8CT3CrM+PgrQs3
	VQ5PeIwqTJyyrN2blMZTy+BgLClwoNRd5EgIKHlrrXY7A8HHTIG1zjrTb4KbnWeHsQzlN1psg2z
	A6ldGmE4sN2XQ9R8BkKD43pviPIX63o6II5q9ZD6z/VtoWAh0/f+uaA7nOXmVgdQHG8LvIMzJnR
	tdZL827uH2jDruegMTNGJkJ5ADSg5vORhOHUrVDyNpZCJ7fwji1wFZKZly8NdBcmipIXMUvrqhH
	esCIAJiRcBf4yYCqubvhMyHK2q/6VVcrQ0nnCs2ccynNodNCV8NKe1AnX0+RuQ+QrtXunRkEZ7a
	0TR5KyrLC8MAZGQBPhN9YboZ5PfdvyaULU9r5P79rAkdvQNdbDIifTWomBs9sq3tqSFRyvSgKy6
	kl74yO5224Xm9S1zg2AYmAA==
X-Received: by 2002:a17:903:3904:b0:2e2:d665:6ad8 with SMTP id d9443c01a7336-2eb1b81b9e8mr16615795ad.4.1793475041906;
        Sat, 31 Oct 2026 12:30:41 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9b1506sm12552004a91.15.2026.10.31.12.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 12:30:39 -0700 (PDT)
Date: Sat, 31 Oct 2026 19:30:36 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auZAViCjlzN3gd6g@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
 <auTR9SnDLsLVmnJ7@google.com>
 <CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com>
 <auVRLPmbWYvMnly-@google.com>
 <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>
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
In-Reply-To: <bb50fcfa-9d71-4905-a76a-ab7bc149d62b@kernel.org>

On Sat, Oct 31, 2026 at 10:32:32AM +0100, David Hildenbrand (Arm) wrote:
>On 10/31/26 04:03, Samiullah Khawaja wrote:
>> On Fri, Oct 30, 2026 at 03:43:53PM -0700, Andy Lutomirski wrote:
>>> On Fri, Oct 30, 2026 at 10:40 AM Samiullah Khawaja <skhawaja@google.com> wrote:
>>>>
>>>> >On 10/30/26 13:11, Jason Gunthorpe wrote:
>>>> >> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>>> >>>
>>>> >>> We have the exact same situation when userspace maps anonymous folios
>>>> into vfio
>>>> >>> and then desides to MADV_DONTNEED the pages. Or any other memory backend
>>>> that is
>>>> >>> used for such purposes.
>>>> >>>
>>>> >>> User space must not zap/punch things that might be pinned elsewhere.
>>>> >>>
>>>> >>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>>> >>>
>>>> >>> I don't see a reason to make userspace (that should not shoot itself into
>>>> the
>>>> >>> foot) a kernel feature it must activate itself to not shoot itself into
>>>> the foot.
>>>>
>>>> Agreed, for normal use this is userspace's problem. The seal was meant
>>>> for the kernel to cheaply verify at preserve time that nothing was
>>>> punched.
>>>>
>>>> >>
>>>> >> The issue is live update doesn't preserve those background punched
>>>> >> folios and now we have created an UAF attack on the kernel across
>>>> >> kexec if you don't do something about it.
>>>> >>
>>>> >> There was some notion here that with the right sealing flags we could
>>>> >> tell if everything was 'live update compatible' and then know that
>>>> >> these attacks are impossible.
>>>> >Just remember that there was any hole punch and refuse to live update this
>>>> instance.
>>>> >
>>>> >We could likely implement "we saw hole punch on a pinned folio" as well, but I
>>>> >don't think that's required initially.
>>>>
>>>> If I understand correctly, you mean recording on the memfd that a hole
>>>> punch happened, and refusing the live update if it did? That would work
>>>> and is much cheaper than what we do today, where iommufd walks all the
>>>> mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
>>>> is enough or I can record that also on the memfd. I will send patches
>>>> for this.
>>>
>>> This entire situation continues to give me the willies.  After much
>>> prodding and contemplating (in my own brain), I got a friendly LLM to
>>> report:
>>>
>>> --- begin AI output ---
>>>
>>> IOMMU_IOAS_MAP_FILE uses memfd_pin_folios(). Collapse [MADV_COLLAPSE
>>> or khugepaged] checks the old folio’s reference count, so a pin
>>> acquired before that check makes collapse fail.
>>>
>>>  The problematic interleaving is:
>>>
>>>  1. collapse_file() locks and unmaps the old folio, then passes its
>>> reference-count check (mm/khugepaged.c:2446).
>>>  2. memfd_pin_folios() (mm/gup.c:3483) obtains the old folio from the
>>> file’s XArray and pins it, without taking the folio lock.
>>>  3. Collapse copies the contents and replaces the old cache entries
>>> with the new huge folio. It does not repeat the reference check or
>>> freeze the old count.
>>>  4. IOAS retains the old physical pages; accesses through the file
>>> use the new folio.
>>>
>>> --- end AI output ---
>>>
>>> Is this correct?  I haven't personally verified it.  But this whole
>>
>> Yes, I think this is correct. memfd_pin_folios() pins the folios
>> directly without taking the folio lock. Other page cache lookups lock
>> the folio and recheck folio->mapping, e.g. shmem_get_folio_gfp(). Only
>> memfd_pin_folios() misses it.
>>
>> This scenario is different from punch hole or MADV_DONTNEED where the
>> user decides to remove the pinned memory. Here the kernel is removing
>> the pinned page without the user knowing. Collapse already checks the
>> refcount to avoid this.
>>
>> The recent fix [1] by Chris already takes the folio lock for !uptodate
>> folios. I think we can take the lock unconditionally and recheck
>> folio->mapping, that should fix this. I can send a patch for this fix,
>> if folks agree.
>
>I have another patch from Anthropic on my "rework schlop" queue that should fix
>this:
>
>"mm/gup: pin memfd folios under the folio lock".
>
>
>We'd do just what we do in other context now, which is checking under folio lock
>whether the folio was truncated.
>
>Care to send a proper fix?

Sure, I will send a fix.

Thanks,
Sami
