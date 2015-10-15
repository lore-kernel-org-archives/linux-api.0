From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 75/79] include/uapi/xen/privcmd.h: fix compilation
 in userspace
Date: Thu, 15 Oct 2015 12:24:39 +0100
Message-ID: <561F8CF7.9070102@citrix.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-76-git-send-email-mikko.rapeli@iki.fi>
 <561F7FF8.9030703@citrix.com> <20151015111801.GW6104@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015111801.GW6104-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 15/10/15 12:18, Mikko Rapeli wrote:
> On Thu, Oct 15, 2015 at 11:29:12AM +0100, David Vrabel wrote:
>> On 15/10/15 06:56, Mikko Rapeli wrote:
>>> xen/interface/xen.h is not exported from kernel headers so remove the
>>> dependency and provide needed defines for domid_t and xen_pfn_t if they
>>> are not already defined by some other e.g. Xen specific headers.
>>>
>>> Suggested by Andrew Cooper <andrew.cooper3-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> on lkml message
>>> <5569F9C9.8000607-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>.
>>>
>>> The ifdef for ARM is ugly but did not find better solutions for it.
>>>
>>> Fixes userspace compilation error:
>>>
>>> xen/privcmd.h:38:31: fatal error: xen/interface/xen.h: No such file or directory
>> [...]
>>> --- a/include/uapi/xen/privcmd.h
>>> +++ b/include/uapi/xen/privcmd.h
>>> @@ -35,7 +35,19 @@
>>>  
>>>  #include <linux/types.h>
>>>  #include <linux/compiler.h>
>>> -#include <xen/interface/xen.h>
>>> +
>>> +/* Might be defined by Xen specific headers, but if not */
>>> +#ifndef domid_t
>>> +typedef __u16 domid_t;
>>> +#endif /* domid_t */
>>
>> As the kbuild bot points out, this does not work since the existence of
>> a typedef cannot be checked with #ifdef.
> 
> Yeah, this hack doesn't cut it. Sorry. Tried to implement these changes:
> http://www.spinics.net/lists/linux-api/msg11048.html
> 
>> I'm not really sure what problem you're trying to solve.  A user space
>> program making use of this interface gets the domid_t and xen_pfn_t etc
>> typedefs from the headers provided as part of the libxenctrl library.
> 
> I'm trying to make sure that kernel headers in userspace compile with minimal
> dependencies which are gcc and libc.
> 
> For me it is clear by now that many Linux API's and ABI's like Xen parts do
> not live in the uapi header files and instead there's a separate userspace
> library with needed headers and defines which have embedded copies of
> the needed API and ABI definitions, like header files.
> 
> So how could this file be changed so that it compiles in userspace without
> definitions from libxenctrl?

I don't think anything needs to be changed.

Instead I would make your compilation check of this header dependent on
the existence of the xen/interface/xen.h header. Or you may exclude the
check of this header entirely.

> I guess I could copy the needed definitions for domid_t and xen_pfn_t from
> xen/interface/xen.h of libxenctrl. That I should have done to begin with
> instead of trying to hack something on my own.

I do not want definitions duplicated/copied from the hypervisor ABI
headers.  This causes problems when support for new architectures is
added (for example).

David
