From: Florian Weimer <fweimer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: pkeys: Support setting access rights for signal handlers
Date: Wed, 13 Dec 2017 16:08:09 +0100
Message-ID: <9f86d79e-165a-1b8e-32dd-7e4e8579da59@redhat.com>
References: <5fee976a-42d4-d469-7058-b78ad8897219@redhat.com>
 <c034f693-95d1-65b8-2031-b969c2771fed@intel.com>
 <5965d682-61b2-d7da-c4d7-c223aa396fab@redhat.com>
 <aa4d127f-0315-3ac9-3fdf-1f0a89cf60b8@intel.com>
 <20171212231324.GE5460@ram.oc3035372033.ibm.com>
 <9dc13a32-b1a6-8462-7e19-cfcf9e2c151e@redhat.com>
 <20171213113544.GG5460@ram.oc3035372033.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171213113544.GG5460-LOE2q6NSToAxGrZ80giIafUQ3DHhIser@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Pai <linuxram-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-x86_64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 12/13/2017 12:35 PM, Ram Pai wrote:
> On Wed, Dec 13, 2017 at 03:14:36AM +0100, Florian Weimer wrote:
>> On 12/13/2017 12:13 AM, Ram Pai wrote:
>>
>>> On POWER, the value of the pkey_read() i.e contents the AMR
>>> register(pkru equivalent), is always the same regardless of its
>>> context; signal handler or not.
>>>
>>> In other words, the permission of any allocated key will not
>>> reset in a signal handler context.
>>
>> That's certainly the simpler semantics, but I don't like how they
>> differ from x86.
>>
>> Is the AMR register reset to the original value upon (regular)
>> return from the signal handler?
> 
> The AMR bits are not touched upon (regular) return from the signal
> handler.
> 
> If the signal handler changes the bits in the AMR, they will continue
> to be so, even after return from the signal handler.
> 
> To illustrate with an example, lets say AMR value is 'x' and signal
> handler is invoked.  The value of AMR will be 'x' in the context of the
> signal handler.  On return from the signal handler the value of AMR will
> continue to be 'x'. However if signal handler changes the value of AMR
> to 'y', the value of AMR will be 'y' on return from the signal handler.

Okay, this model is really quite different from x86.  Is there a good 
reason for the difference?  Could we change the x86 implementation to 
behave in the same way?  Or alternatively, change the POWER 
implementation to match the existing x86 behavior?

>>> I was not aware that x86 would reset the key permissions in signal
>>> handler.  I think, the proposed behavior for PKEY_ALLOC_SETSIGNAL should
>>> actually be the default behavior.
>>
>> Note that PKEY_ALLOC_SETSIGNAL does something different: It requests
>> that the kernel sets the access rights for the key to the bits
>> specified at pkey_alloc time when the signal handler is invoked.  So
>> there is still a reset with PKEY_ALLOC_SETSIGNAL, but to a different
>> value.  It did not occur to me that it might be desirable to avoid
>> resetting the value on a per-key basis.
> 
> Ah. ok i see the subtle difference proposed by your semantics.
> 
> Will the following behavior work?
> 
> 'No bits will be reset to its initial value unless the key has been
> allocated with PKEY_ALLOC_*RE*SETSIGNAL flag'.

The existing x86 interface defaults to resetting the bits, 
unfortunately.  I'm not sure if we can or should change this now.

For my purposes, the POWER semantics would work fine as far as I can 
see.  The reset-to-default is really problematic.  I don't actually need 
the configurable behavior, but I implemented it this way to achieve a 
maximum of backwards compatibility.

Thanks,
Florian
