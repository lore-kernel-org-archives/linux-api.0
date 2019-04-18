From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the running kernel image
Date: Thu, 18 Apr 2019 16:38:54 +1000
Message-ID: <87zhonyg01.fsf@dja-thinkpad.axtens.net>
References: <20190404003249.14356-1-matthewgarrett@google.com> <20190404003249.14356-2-matthewgarrett@google.com> <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, cmr <cmr@informatik.wtf>
List-Id: linux-api@vger.kernel.org

Hi Andrew,

>> +		If CONFIG_LOCK_DOWN_KERNEL is enabled, the kernel can be
>> +		moved to a more locked down state at runtime by writing to
>> +		this attribute. Valid values are:
>> +
>> +		integrity:
>> +			The kernel will disable functionality that allows
>> +			userland to modify the running kernel image, other
>> +			than through the loading or execution of appropriately
>> +			signed objects.
>> +
>> +		confidentiality:
>> +			The kernel will disable all functionality disabled by
>> +			the integrity mode, but additionally will disable
>> +			features that potentially permit userland to obtain
>> +			confidential information stored within the kernel.
>
> [+ linuxppc, mpe, dja, cmr]
>
> I'm thinking about whether we should lock down the powerpc xmon debug 
> monitor - intuitively, I think the answer is yes if for no other reason 
> than Least Astonishment, when lockdown is enabled you probably don't 
> expect xmon to keep letting you access kernel memory.
>
> Semantically though, xmon is not a userspace process - it's in kernel 
> and reads debug commands/outputs debug data directly from/to the 
> console. Is that a threat vector that this series cares about?

I guess there are 2 ways you could think about lockdown:

 - It adds a security boundary between the kernel and UID 0, so that
   userland cannot compromise the integrity/confidentiality of the
   locked down kernel.

 - It is a bundle of related security boundaries so that the
   integrity/confidentiality of a running, locked down kernel cannot be
   compromised, even by a privileged, physically present user.

You're right that techincally xmon is in the kernel and on the console
rather than in userland, so it doesn't fall within the first concept of
lockdown. But I think usecases for lockdown tend to expect something
more like the second concept.

IOW, lockdown is a trapdoor - once you've locked down a kernel, you
can't get out of lockdown (except by rebooting). xmon would allow you to
get out of the trapdoor, so I think it should be restricted by lockdown.

Regards,
Daniel

>
>
> -- 
> Andrew Donnellan              OzLabs, ADL Canberra
> andrew.donnellan@au1.ibm.com  IBM Australia Limited
