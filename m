From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: MPK: removing a pkey
Date: Wed, 22 Nov 2017 13:49:33 +0100
Message-ID: <6299ccb2-ca6b-b49e-fca0-6baa0d6581a9@redhat.com>
References: <0f006ef4-a7b5-c0cf-5f58-d0fd1f911a54@redhat.com>
 <8741e4d6-6ac0-9c07-99f3-95d8d04940b4@suse.cz>
 <813f9736-36dd-b2e5-c850-9f2d5f94514a@redhat.com>
 <f0495f01-9821-ec36-56b4-333f109eb761@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0495f01-9821-ec36-56b4-333f109eb761-AlSwsSmVLrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/22/2017 01:46 PM, Vlastimil Babka wrote:
> On 11/22/2017 01:15 PM, Florian Weimer wrote:
>> On 11/22/2017 09:18 AM, Vlastimil Babka wrote:
>>> And, was the pkey == -1 internal wiring supposed to be exposed to the
>>> pkey_mprotect() signal, or should there have been a pre-check returning
>>> EINVAL in SYSCALL_DEFINE4(pkey_mprotect), before calling
>>> do_mprotect_pkey())? I assume it's too late to change it now anyway (or
>>> not?), so should we also document it?
>>
>> I think the -1 case to the set the default key is useful because it
>> allows you to use a key value of -1 to mean “MPK is not supported”, and
>> still call pkey_mprotect.
> 
> Hmm the current manpage says then when MPK is not supported, pkey has to
> be specified 0. Which is a value that doesn't work when MPK *is*
> supported. So -1 is more universal indeed.

-1 also chosen a different key if key 0 does not support the requested 
protection flags.

>> I plan to document this behavior on the glibc side, and glibc will call
>> mprotect (not pkey_mprotect) for key -1, so that you won't get ENOSYS
>> with kernels which do not support pkey_mprotect.
> 
> Fair enough. What will you do about pkey_alloc() in that case, emulate
> ENOSPC? Oh, the manpage already suggests so. And the return value in
> that case is... -1. Makes sense :)

The manual page is incorrect, the kernel actually returns EINVAL. 
Applications should check for EINVAL (and also ENOSYS) and activate 
fallback code.  Using -1 directly would be a bit reckless IMHO.

Thanks
Florian
