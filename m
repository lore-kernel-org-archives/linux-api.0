Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD35481FA5;
	Thu, 10 Sep 2026 14:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049971; cv=none; b=gCT7mVjzR4R70B/OF7VHJqxSslAa1eBKnFcG9aKWIUhuuEZhc8iotbnGzyjSDGFNNWaMSn3ktmk4SQLgMq06rA8DKEsS33fl2Fxr6KUTbv0mvN5RcBqObtxDaq+ixrpDSj1ULYqvu3c11/KtMbfJk1tJE1RbcRFviD/8UkakMRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049971; c=relaxed/simple;
	bh=YyZZgELesOQYbwi5589EMzGDv5CnlCwWEAz7cpxWzf4=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=NIG3jqn7XzjXjIDbZOdmNgSUXvhJ/22to40awHv6quxf9hxXXTgS5qbK//KH/RrUvK3pvCXoUttNr8/NEbso0p4BYxrLatCop5whPP0LaJ84TOkJxaEo9gO4qZnXypaALeJddFsinXk1mXE0HjuPoVjC0bC8/NIZLPI51PIgjuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com; spf=pass smtp.mailfrom=foss.arm.com; dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b=npJdqY2l; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b="npJdqY2l"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9536B1570;
	Thu, 10 Sep 2026 07:19:25 -0700 (PDT)
Received: from [10.211.55.7] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F0293F7B4;
	Thu, 10 Sep 2026 07:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=foss.arm.com; s=main;
	t=1789049969; bh=YyZZgELesOQYbwi5589EMzGDv5CnlCwWEAz7cpxWzf4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=npJdqY2lkzMQ1ArUoRWjCHl6JYyGW+9VlY+FuS0oSIaTEVefYoWD5nfgZa3oYgF6v
	 ay/2+Tge/AzDs2LsbDIQlY088djByVQkbuQy86vTzSrEcx8dA4k2lt+gHCIJrIfhQ1
	 5pYgG0hGhKhZ4WqQc6JDXsRvcAe54mfMS72pXNHU=
Message-ID: <615d5d1a-5266-4b83-bff2-21c8f3840040@foss.arm.com>
Date: Thu, 10 Sep 2026 09:19:23 -0500
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Shadow Stack Locking Semantics between arch's
From: Bill Roberts <bill.roberts@foss.arm.com>
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
 <0ef9f4ab-4c9f-4089-bed3-f7726ec97804@foss.arm.com>
Content-Language: en-US
In-Reply-To: <0ef9f4ab-4c9f-4089-bed3-f7726ec97804@foss.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/9/26 12:57 PM, Bill Roberts wrote:
>>
>>> 2. riscv should check that the low bit is set in locking not just 
>>> that its
>>> 0, it should be 1
>> I think for ABI compatibility RISC-V will have to continue accepting 0
>> as being equivalent to locking PR_SHADOW_STACK_ENABLE (or everything,
>> but it only supports that one bit right now).
>
> TL;DR - No users, lets fix it before risc-v lands the userspace side IIUC
>
> I can't find any libc's that support this for risc-v. It appears the 
> glibc
> patches were not merged and I commented on those patches just now
> that the interface is wrong:
>   - 
> https://inbox.sourceware.org/libc-alpha/8a5e21d0-0628-4910-9ad8-165c829e9680@foss.arm.com/
>
> Additionally, stress-ng does it "generically", and it would be broken 
> on a riscv system:
>   - 
> https://sources.debian.org/src/stress-ng/0.22.00-2/stress-prctl.c?hl=1144#L1144
>
> This is a bug and never followed the convention to begin with. So 
> risc-v is
> non-compliant to the spec and this effectively prevents the a true 
> unification
> of a generic prctl interface. The behavior on riscv doesn't adhere to 
> there own docs:
>
>   - 
> https://cdn.kernel.org/doc/html/latest/arch/riscv/zicfiss.html#prctl-enabling 


Sorry I confused two interfaces here, anyway, 
arch_set_shadow_stack_status is fine,
it's the locking interface arch_lock_shadow_stack_status, code snippet 
below:

/* If shtstk not supported or not enabled on task, nothing to lock here */
if (!is_user_shstk_enabled() ||
     !is_shstk_enabled(task) || arg != 0)
         return -EINVAL;

So even the glibc patches will be fine. But definitely something we want 
to fix.
I am going to float a patch over to the risc-v folks.



