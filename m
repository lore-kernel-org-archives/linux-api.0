From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 3/7] arm64: HWCAP: encapsulate elf_hwcap
Date: Tue, 2 Apr 2019 16:32:57 +0100
Message-ID: <8f47d948-e5cd-68ab-b340-d40d3b11a3f5@arm.com>
References: <20190401104515.39775-1-andrew.murray@arm.com>
 <20190401104515.39775-4-andrew.murray@arm.com>
 <20190402145821.GH3567@e103592.cambridge.arm.com>
 <20190402150654.GD53702@e119886-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190402150654.GD53702@e119886-lin.cambridge.arm.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: andrew.murray@arm.com, dave.martin@arm.com
Cc: mark.rutland@arm.com, libc-alpha@sourceware.org, Szabolcs.Nagy@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, pb@pbcl.net, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Hi,

On 02/04/2019 16:06, Andrew Murray wrote:
> On Tue, Apr 02, 2019 at 03:58:21PM +0100, Dave Martin wrote:
>> On Mon, Apr 01, 2019 at 11:45:11AM +0100, Andrew Murray wrote:
>>> The introduction of AT_HWCAP2 introduced accessors which ensure that
>>> hwcap features are set and tested appropriately.
>>>
>>> Let's now mandate access to elf_hwcap via these accessors by making
>>> elf_hwcap static within cpufeature.c.
>>
>> Looks reasonable except for a couple of minor nits below.
>>
>> I had wondered whether putting these accessors out of line would affect
>> any hot paths, but I can't see these used from anything that looks like
>> a hot path.  So we're probably fine.
>>
>> cpus_have_const_cap() is preferred for places where this matters,
>> anyway.

Btw, thats for cpu_hwcaps, which is completely different from elf_hwcaps.

>>
>> [...]
>>
>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>> index 986ceeacd19f..84ca52fa75e5 100644
>>> --- a/arch/arm64/kernel/cpufeature.c
>>> +++ b/arch/arm64/kernel/cpufeature.c
>>> @@ -35,8 +35,7 @@
>>>   #include <asm/traps.h>
>>>   #include <asm/virt.h>
>>>   
>>> -unsigned long elf_hwcap __read_mostly;
>>> -EXPORT_SYMBOL_GPL(elf_hwcap);
>>> +static unsigned long elf_hwcap __read_mostly;
>>
>> Now that this doesn't correspond directly to ELF_HWCAP any more and we
>> hide it, can we rename it to avoid confusion?
>>
>> Maybe "kernel_hwcap"?
> 
> Yes this seems reasonable.

nit:

As mentioned above we have "cpu_hwcaps" for the features only internally
by the kernel. Naming it "kernel_hwcap" kind of looses the hint that the
major purpose is for userspace consumption and could easily confuse with
the poorly named "cpu_hwcaps" which should have been called kernel_hwcaps.

How about "user_hwcaps" ? Or preferrably something closer to that.

Cheers
Suzuki
