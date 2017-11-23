From: Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: MPK: removing a pkey
Date: Thu, 23 Nov 2017 15:29:20 -0800
Message-ID: <8051353f-47d3-37a4-a402-41adc8b6eb88@linux.intel.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
 <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
 <f42fe774-bdcc-a509-bb7f-fe709fd28fcb@linux.intel.com>
 <9ec19ff3-86f6-7cfe-1a07-1ab1c5d9882c@redhat.com>
 <d98eb4b8-6e59-513d-fdf8-3395485cb851@linux.intel.com>
 <de93997a-7802-96cf-62e2-e59416e745ca@suse.cz>
 <17831167-7142-d42a-c7a0-59bdc8bbb786@linux.intel.com>
 <2d12777f-615a-8101-2156-cf861ec13aa7@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2d12777f-615a-8101-2156-cf861ec13aa7-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/23/2017 01:42 PM, Vlastimil Babka wrote:
>> It's supposed to set 0.
>>
>> -1 was, as far as I remember, an internal-to-the-kernel-only thing to
>> tell us that a key came from *mprotect()* instead of pkey_mprotect().
> So, pkey_mprotect(..., 0) will set it to 0, regardless of PROT_EXEC.

Although weird, the thought here was that pkey_mprotect() callers are
new and should know about the interactions with PROT_EXEC.  They can
also *get* PROT_EXEC semantics if they want.

The only wart here is if you do:

	mprotect(..., PROT_EXEC); // key 10 is now the PROT_EXEC key
	pkey_mprotect(..., PROT_EXEC, key=3);

I'm not sure what this does.  We should probably ensure that it returns
an error.

> pkey_mprotect(..., -1) or mprotect() will set it to 0-or-PROT_EXEC-pkey.
> 
> Can't shake the feeling that it's somewhat weird, but I guess it's
> flexible at least. So just has to be well documented.

It *is* weird.  But, layering on top of legacy APIs are often weird.  I
would have been open to other sane, but less weird ways to do it a year
ago. :)
