From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH V4 2/6] mm: mlock: Add new mlock, munlock, and munlockall
 system calls
Date: Fri, 24 Jul 2015 08:46:38 -0700
Message-ID: <55B25DDE.8090107@roeck-us.net>
References: <1437508781-28655-1-git-send-email-emunson@akamai.com> <1437508781-28655-3-git-send-email-emunson@akamai.com> <20150721134441.d69e4e1099bd43e56835b3c5@linux-foundation.org> <1437528316.16792.7.camel@ellerman.id.au> <20150722141501.GA3203@akamai.com> <20150723065830.GA5919@linux-mips.org> <20150724143936.GE9203@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150724143936.GE9203-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
Cc: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-m68k-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sh-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-am33-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-xtensa-PjhNF2WwrV/0Sa2dR60CXw@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adi-buildroot-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-cris-kernel-VrBV9hrLPhE@public.gmane.org, linux-parisc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-alpha-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 07/24/2015 07:39 AM, Eric B Munson wrote:
> On Thu, 23 Jul 2015, Ralf Baechle wrote:
>
>> On Wed, Jul 22, 2015 at 10:15:01AM -0400, Eric B Munson wrote:
>>
>>>>
>>>> You haven't wired it up properly on powerpc, but I haven't mentioned it because
>>>> I'd rather we did it.
>>>>
>>>> cheers
>>>
>>> It looks like I will be spinning a V5, so I will drop all but the x86
>>> system calls additions in that version.
>>
>> The MIPS bits are looking good however, so
>>
>> Acked-by: Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>
>>
>> With my ack, will you keep them or maybe carry them as a separate patch?
>
> I will keep the MIPS additions as a separate patch in the series, though
> I have dropped two of the new syscalls after some discussion.  So I will
> not include your ack on the new patch.
>
> Eric
>

Hi Eric,

next-20150724 still has some failures due to this patch set. Are those
being looked at (I know parisc builds fail, but there may be others) ?

Thanks,
Guenter
