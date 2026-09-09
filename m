Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275E7492E42;
	Wed,  9 Sep 2026 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788976682; cv=none; b=MomUiSQAFwaUWxkUA1w2u2a62lzNSsGv7BkjFuPUKDMhttZjFvN5UkePTaqV4DnrNVxOrrU3zMmuBtdMHr3t3JSxy/jvGiB6DgUC40ApKXIat5c2t/1PAjiZsNAqKBn646vb1Bi/+v0j13pb+CIY/GGBhFl3TsfOmWJBWFT9eoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788976682; c=relaxed/simple;
	bh=j8s/pkdPWtkxGrVAkD2rab4CbgigKfGGO1TTpT60Ytc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DkXHO5IeoqSKnMIBZ0G4vKdJubFXGznaUQsCnX3ZMaY6EfDGkBhwQFa/cyYVfnrMf9+5tSJwslJiAitf6Vzy25oerajLCyL0aRAh10yCvDoUazfMCs1X01dcsOfVq/LqzRKmGPQjhAQ1/AqYDaqPHwi/BhVAQt2+MFiQVBeMndc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com; spf=pass smtp.mailfrom=foss.arm.com; dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b=RPs4/Neb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b="RPs4/Neb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60E561576;
	Wed,  9 Sep 2026 10:57:55 -0700 (PDT)
Received: from [10.211.55.7] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B7053F528;
	Wed,  9 Sep 2026 10:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=foss.arm.com; s=main;
	t=1788976679; bh=j8s/pkdPWtkxGrVAkD2rab4CbgigKfGGO1TTpT60Ytc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RPs4/Neb/y37OUPUAPtmTMK+coFcLiQBrF3yVred7gBeaz/MeVjBz12tCr7F47QPm
	 ABzvTt3YlvzFcd7TnQG0PSz8uyeNCufAq99j1K3rmmTkkA378Od8fbwEHJ6LKmH70i
	 MWzZAmfduRv183pVWxmOljB8e4xFyytHY7XinDH4=
Message-ID: <0ef9f4ab-4c9f-4089-bed3-f7726ec97804@foss.arm.com>
Date: Wed, 9 Sep 2026 12:57:57 -0500
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Shadow Stack Locking Semantics between arch's
To: Mark Brown <broonie@kernel.org>, Jesse Huang <jesse.huang@sifive.com>
Cc: "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 linux-arm-kernel@lists.infradead.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-hardening@vger.kernel.org, linux-api@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, debug@rivosinc.com,
 andrew@sifive.com, kito.cheng@sifive.com
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
Content-Language: en-US
From: Bill Roberts <bill.roberts@foss.arm.com>
In-Reply-To: <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

<snip> + Jesse, he is working on the glibc side + CC a few others on 
that thread as submitted on the glibc side from sifive. Sorry for the 
delay, I was away on vacation.

>> unsigned long locked = 0x2; // Kernel Task State -> LOCK WRITE
>> unsigned long cur_val = 0x3; // Kernel Task State -> WRITE and SHADOWSTACK
>> ENABLED
>> unsigned long new_val = 0x0; // Userspace Feature Change via syscall ->
>> DISABLE
>> | x86-64 | risc-v | arm64 |
>> | ---------- | -------- | --------- |
>> | Works  | Fails  | Fails     |
> I would not have expected that combination to work at all with the
> prctl() (as opposed to arch_prctl()) interface TBH, if you've locked
> write on you shouldn't be able to disable it.  The reason that works on
> x86 at the minute is that for x86 you can only change one bit at a time
> so the new value when disabling is effectively 0x2, not 0x0.
Yes, this is exactly what I am pointing out. Implementation aside, is that
the behavior we want?
>
>> I am proposing and have questions over the following:
>> 1. What should the behavior be if you had write locked and disable the
>> shadow stack?
>>    - I can argue both ways here, -EPERM or success. I think I and most arches
>> lead to failure.
> Given that RISC-V doesn't support control of writes it's moot there
> at the minute, and x86 currently uses arch_prctl() so will need an
> additional API, it seems the path of least resistance is to allow it.
> This also avoids locking writes (or pushes, for arm64) on effectively
> also locking enable which seems neater.
>
>> 2. riscv should check that the low bit is set in locking not just that its
>> 0, it should be 1
> I think for ABI compatibility RISC-V will have to continue accepting 0
> as being equivalent to locking PR_SHADOW_STACK_ENABLE (or everything,
> but it only supports that one bit right now).

TL;DR - No users, lets fix it before risc-v lands the userspace side IIUC

I can't find any libc's that support this for risc-v. It appears the glibc
patches were not merged and I commented on those patches just now
that the interface is wrong:
   - 
https://inbox.sourceware.org/libc-alpha/8a5e21d0-0628-4910-9ad8-165c829e9680@foss.arm.com/

Additionally, stress-ng does it "generically", and it would be broken on 
a riscv system:
   - 
https://sources.debian.org/src/stress-ng/0.22.00-2/stress-prctl.c?hl=1144#L1144

This is a bug and never followed the convention to begin with. So risc-v is
non-compliant to the spec and this effectively prevents the a true 
unification
of a generic prctl interface. The behavior on riscv doesn't adhere to 
there own docs:

   - 
https://cdn.kernel.org/doc/html/latest/arch/riscv/zicfiss.html#prctl-enabling

>
>> 3. riscv should return -EPERM vs -EINVAL
> If you mean for arch_lock_shadow_stack_status() I think -EINVAL is a
> sensible error code when the system or task does not support shadow
> stacks, I'm not sure we should return -EPERM at all.  On arm64 we
> support locking any bit, not just the ones that we currently know about.
> This is for future proofing, userspace can lock unknown flags.

No, I mean when setting a locked bit via prctl 
and PR_SET_SHADOW_STACK_STATUS.
Currently, the error codes for changing a locked bit:
x86: EPERM
arm64: EBUSY (Which we discussed offline about changing to EPERM)
risc-v:

>> If we can all agree on item 1, that locked bits check can be refactored and
>> shared in one of
>> two ways:
>> 1. within prctl itself, before the arch hook is called, we would need
>> helpers per-arch to extract the thread features and lock bits
>> 2. as a helper where folks just pass the unsigned long of the bits to get
>> the result
> For me option 1 seems a bit nicer, and moves more of the implementation
> into generic code which is something we should really be doing in
> general with the shadow stack support - there's a lot of cross arch
> duplication at the minute.  It has been on my list to look at this
> repitition at some point, it had been held up by the clone3() stuff but
> that seems to have died a death for now.
Agreed, it's more work, but I like it better.
