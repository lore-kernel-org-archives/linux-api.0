From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Subject: Re: [PATCH V32 01/27] Add the ability to lock down access to the
 running kernel image
Date: Tue, 16 Apr 2019 18:40:08 +1000
Message-ID: <059c523e-926c-24ee-0935-198031712145@au1.ibm.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
 <20190404003249.14356-2-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-2-matthewgarrett@google.com>
Content-Language: en-AU
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Axtens <dja@axtens.net>, cmr <cmr@informatik.wtf>
List-Id: linux-api@vger.kernel.org

On 4/4/19 11:32 am, Matthew Garrett wrote:
> diff --git a/Documentation/ABI/testing/lockdown b/Documentation/ABI/testing/lockdown
> new file mode 100644
> index 000000000000..5bd51e20917a
> --- /dev/null
> +++ b/Documentation/ABI/testing/lockdown
> @@ -0,0 +1,19 @@
> +What:		security/lockdown
> +Date:		March 2019
> +Contact:	Matthew Garrett <mjg59@google.com>
> +Description:
> +		If CONFIG_LOCK_DOWN_KERNEL is enabled, the kernel can be
> +		moved to a more locked down state at runtime by writing to
> +		this attribute. Valid values are:
> +
> +		integrity:
> +			The kernel will disable functionality that allows
> +			userland to modify the running kernel image, other
> +			than through the loading or execution of appropriately
> +			signed objects.
> +
> +		confidentiality:
> +			The kernel will disable all functionality disabled by
> +			the integrity mode, but additionally will disable
> +			features that potentially permit userland to obtain
> +			confidential information stored within the kernel.

[+ linuxppc, mpe, dja, cmr]

I'm thinking about whether we should lock down the powerpc xmon debug 
monitor - intuitively, I think the answer is yes if for no other reason 
than Least Astonishment, when lockdown is enabled you probably don't 
expect xmon to keep letting you access kernel memory.

Semantically though, xmon is not a userspace process - it's in kernel 
and reads debug commands/outputs debug data directly from/to the 
console. Is that a threat vector that this series cares about?


-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
