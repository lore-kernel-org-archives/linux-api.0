Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7F53D9550;
	Wed,  9 Sep 2026 20:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788984077; cv=none; b=r8ZlfAOH7PF6eBVfTu2crIIm5s7MmozGuOvSUNazbiqg+6pi5q455OgdaA/77A80X7OpvfyB79lzMkItet2xeg1YHooNAjdMAIv48ewUUXpJOOGl3ipYhylBNFIHXLFDFqfvyHoEMiL+f5rw68FuPLjYkcTso0oh9Bp5+8og+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788984077; c=relaxed/simple;
	bh=rNi5YhSEeETSE5FQBog3k1r0aviOJOf+s/njOtyxBZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k44KNalpfk7d54IpQpZvPeGCLAQ9lXwL4Ey0IHTRyQfWhgKCjS6tl9Dn5pfDwBs/rtlkopUWh4I1APfSvlqYkhdHqFsCQhkPYSAWABm/ryKrGx/7cWOA1HssYzWorhrNXEQECLYK4y4FI3RZI9gPGVkZDFuwfMk7+OX3eazUN28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com; spf=pass smtp.mailfrom=foss.arm.com; dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b=HnL3iTWU; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foss.arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foss.arm.com header.i=@foss.arm.com header.b="HnL3iTWU"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AB42B1570;
	Wed,  9 Sep 2026 13:01:07 -0700 (PDT)
Received: from [10.211.55.7] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BAF703F7B4;
	Wed,  9 Sep 2026 13:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=foss.arm.com; s=main;
	t=1788984071; bh=rNi5YhSEeETSE5FQBog3k1r0aviOJOf+s/njOtyxBZE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HnL3iTWUzI5pHllYz6CCHmcPV3JTw+s6qzHZZToyX8cY0TBKM130vVtUdiL2JwN+G
	 /8IMNBhLGf6IMvg5JAecf3/j2SujtIhDOIUmv1SnU6JOhvLB1iobKgEx/gCGbaofGy
	 u6UNzBwtszGomEhOE5GTTi+QO1cB/EndPZx3QVr4=
Message-ID: <c5367968-0e0d-4583-8ac9-efb3bb5b2983@foss.arm.com>
Date: Wed, 9 Sep 2026 15:01:10 -0500
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Shadow Stack Locking Semantics between arch's
To: Mark Brown <broonie@kernel.org>,
 "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: Jesse Huang <jesse.huang@sifive.com>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 linux-arm-kernel@lists.infradead.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-hardening@vger.kernel.org, linux-api@vger.kernel.org,
 dave.hansen@linux.intel.com, rick.p.edgecombe@intel.com, debug@rivosinc.com,
 andrew@sifive.com, kito.cheng@sifive.com
References: <a1946d93-370e-4ca9-85d6-60b4a20ffd47@arm.com>
 <3bb672e0-7bc3-434f-904e-aa00394dd01f@foss.arm.com>
 <d20ccb74-69ed-45d7-a810-846904873588@sirena.org.uk>
 <0ef9f4ab-4c9f-4089-bed3-f7726ec97804@foss.arm.com>
 <522bcf96-499c-491b-aaf0-34e6bbd42929@sirena.org.uk>
Content-Language: en-US
From: Bill Roberts <bill.roberts@foss.arm.com>
In-Reply-To: <522bcf96-499c-491b-aaf0-34e6bbd42929@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>>>> unsigned long locked = 0x2; // Kernel Task State -> LOCK WRITE
>>>> unsigned long cur_val = 0x3; // Kernel Task State -> WRITE and SHADOWSTACK
>>>> ENABLED
>>>> unsigned long new_val = 0x0; // Userspace Feature Change via syscall ->
>>>> DISABLE
>>>> | x86-64 | risc-v | arm64 |
>>>> | ---------- | -------- | --------- |
>>>> | Works  | Fails  | Fails     |
>>> I would not have expected that combination to work at all with the
>>> prctl() (as opposed to arch_prctl()) interface TBH, if you've locked
>>> write on you shouldn't be able to disable it.  The reason that works on
>>> x86 at the minute is that for x86 you can only change one bit at a time
>>> so the new value when disabling is effectively 0x2, not 0x0.
>> Yes, this is exactly what I am pointing out. Implementation aside, is that
>> the behavior we want?
> It seems more helpful to support changing more than one bit at once.
+ Rick in "to", I want him to weigh in as well.

I think we're still miscommunicating.  The issue is, that in the current
interface for x86 via arch_prctl, which is one bit at a time, the explicit
locking of write can be undone via turning off the shadow stack. Should
that succeed, or should that fail since it implicitly turns off write? 
Should
we preserve that as we port to prctl? Should we change that in x86
arch_prctl, was that intended?

