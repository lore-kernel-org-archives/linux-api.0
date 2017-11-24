From: Florian Weimer <fweimer@redhat.com>
Subject: Re: MPK: removing a pkey
Date: Fri, 24 Nov 2017 09:35:31 +0100
Message-ID: <e97e53a1-ba04-c62e-cc64-054b488d5394@redhat.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
 <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
 <f42fe774-bdcc-a509-bb7f-fe709fd28fcb@linux.intel.com>
 <9ec19ff3-86f6-7cfe-1a07-1ab1c5d9882c@redhat.com>
 <d98eb4b8-6e59-513d-fdf8-3395485cb851@linux.intel.com>
 <de93997a-7802-96cf-62e2-e59416e745ca@suse.cz>
 <17831167-7142-d42a-c7a0-59bdc8bbb786@linux.intel.com>
 <2d12777f-615a-8101-2156-cf861ec13aa7@suse.cz>
 <8051353f-47d3-37a4-a402-41adc8b6eb88@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <8051353f-47d3-37a4-a402-41adc8b6eb88@linux.intel.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/24/2017 12:29 AM, Dave Hansen wrote:
> Although weird, the thought here was that pkey_mprotect() callers are
> new and should know about the interactions with PROT_EXEC.  They can
> also*get*  PROT_EXEC semantics if they want.
> 
> The only wart here is if you do:
> 
> 	mprotect(..., PROT_EXEC); // key 10 is now the PROT_EXEC key

I thought the PROT_EXEC key is always 1?

> 	pkey_mprotect(..., PROT_EXEC, key=3);
> 
> I'm not sure what this does.  We should probably ensure that it returns
> an error.

Without protection key support, PROT_EXEC would imply PROT_READ with an 
ordinary mprotect.  I think it makes sense to stick to this behavior. 
It is what I have documented for glibc:

   <https://sourceware.org/ml/libc-alpha/2017-11/msg00841.html>

Thanks,
Florian

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
