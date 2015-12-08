From: Dave Hansen <dave@sr71.net>
Subject: Re: [PATCH 28/34] x86: wire up mprotect_key() system call
Date: Tue, 8 Dec 2015 11:06:56 -0800
Message-ID: <56672A50.4010801@sr71.net>
References: <20151204011424.8A36E365@viggo.jf.intel.com>
 <20151204011503.2A095839@viggo.jf.intel.com>
 <alpine.DEB.2.11.1512081943270.3595@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.11.1512081943270.3595@nanos>
Sender: owner-linux-mm@kvack.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org, dave.hansen@linux.intel.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 12/08/2015 10:44 AM, Thomas Gleixner wrote:
> On Thu, 3 Dec 2015, Dave Hansen wrote:
>>  #include <asm-generic/mman.h>
>> diff -puN mm/Kconfig~pkeys-16-x86-mprotect_key mm/Kconfig
>> --- a/mm/Kconfig~pkeys-16-x86-mprotect_key	2015-12-03 16:21:31.114920208 -0800
>> +++ b/mm/Kconfig	2015-12-03 16:21:31.119920435 -0800
>> @@ -679,4 +679,5 @@ config NR_PROTECTION_KEYS
>>  	# Everything supports a _single_ key, so allow folks to
>>  	# at least call APIs that take keys, but require that the
>>  	# key be 0.
>> +	default 16 if X86_INTEL_MEMORY_PROTECTION_KEYS
>>  	default 1
> 
> What happens if I set that to 42?
> 
> I think we want to make this a runtime evaluated thingy. If pkeys are
> compiled in, but the machine does not support it then we don't support
> 16 keys, or do we?

We do have runtime evaluation:

#define arch_max_pkey() (boot_cpu_has(X86_FEATURE_OSPKE) ?      \
                             CONFIG_NR_PROTECTION_KEYS : 1)

The config option really just sets the architectural limit for how many
are supported.  So it probably needs a better name at least.  Let me
take a look at getting rid of this config option entirely.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
