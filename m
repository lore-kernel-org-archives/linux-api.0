From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: MPK: removing a pkey
Date: Fri, 24 Nov 2017 09:38:27 +0100
Message-ID: <346db028-6f45-65d5-a531-300c2251a8eb@suse.cz>
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
 <e97e53a1-ba04-c62e-cc64-054b488d5394@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <e97e53a1-ba04-c62e-cc64-054b488d5394@redhat.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
To: Florian Weimer <fweimer@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org
Cc: linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 11/24/2017 09:35 AM, Florian Weimer wrote:
> On 11/24/2017 12:29 AM, Dave Hansen wrote:
>> Although weird, the thought here was that pkey_mprotect() callers are
>> new and should know about the interactions with PROT_EXEC.  They can
>> also*get*  PROT_EXEC semantics if they want.
>>
>> The only wart here is if you do:
>>
>> 	mprotect(..., PROT_EXEC); // key 10 is now the PROT_EXEC key
> 
> I thought the PROT_EXEC key is always 1?

Seems it assigns the first non-allocated one. Can even fail if there's
none left, and then there's no PROT_EXEC read protection. In practice I
expect PROT_EXEC mapping to be created by ELF loader (?) before the
program can even call pkey_alloc() itself, so it would be 1.
