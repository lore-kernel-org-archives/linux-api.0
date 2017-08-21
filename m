From: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v06 27/36] uapi xen/gntdev.h: include xen/privcmd.h and
 define grant_ref_t
Date: Mon, 21 Aug 2017 16:46:05 +0200
Message-ID: <d11cef3b-e20e-0fe7-f1a7-d14ff229d87e@suse.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-28-mikko.rapeli@iki.fi>
 <ff3e726a-8e03-4543-7190-e6f8229b9e99@suse.com>
 <c4766f8b-fcd0-4158-2d70-72417bf4afbb@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c4766f8b-fcd0-4158-2d70-72417bf4afbb-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: de-DE
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 21/08/17 16:31, Boris Ostrovsky wrote:
> On 08/21/2017 09:33 AM, Juergen Gross wrote:
>> On 06/08/17 18:44, Mikko Rapeli wrote:
>>> Both are needed to compile <xen/gntdev.h> in userspace. Fixes these
>>> userspace compile errors:
>>>
>>> xen/gntdev.h:151:4: error: unknown type name ‘grant_ref_t’
>>>     grant_ref_t ref;
>>>     ^
>>> xen/gntdev.h:153:4: error: unknown type name ‘domid_t’
>>>     domid_t domid;
>>>     ^
>>>
>>> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>>> Cc: Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Cc: Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>
>>> Cc: xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
>>> ---
>>>  include/uapi/xen/gntdev.h           | 6 ++++++
>>>  include/xen/interface/grant_table.h | 6 +-----
>>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
>>> index d0661977667e..f208706b07c9 100644
>>> --- a/include/uapi/xen/gntdev.h
>>> +++ b/include/uapi/xen/gntdev.h
>>> @@ -34,6 +34,12 @@
>>>  #define __LINUX_PUBLIC_GNTDEV_H__
>>>  
>>>  #include <linux/types.h>
>>> +#include <xen/privcmd.h>
>>> +
>>> +/*
>>> + * Reference to a grant entry in a specified domain's grant table.
>>> + */
>>> +typedef __u32 grant_ref_t;
>>>  
>>>  struct ioctl_gntdev_grant_ref {
>>>  	/* The domain ID of the grant to be mapped. */
>>> diff --git a/include/xen/interface/grant_table.h b/include/xen/interface/grant_table.h
>>> index 7fb7112d667c..29b3724aec2c 100644
>>> --- a/include/xen/interface/grant_table.h
>>> +++ b/include/xen/interface/grant_table.h
>>> @@ -29,6 +29,7 @@
>>>  #define __XEN_PUBLIC_GRANT_TABLE_H__
>>>  
>>>  #include <xen/interface/xen.h>
>>> +#include <uapi/xen/gntdev.h> /* for grant_ref_t */
>> Hmm, I really don't like this. We import the Xen headers from the Xen
>> source repository. The Xen specific types shouldn't be taken from
>> non-Xen headers.
>>
>>>  
>>>  /***********************************
>>>   * GRANT TABLE REPRESENTATION
>>> @@ -85,11 +86,6 @@
>>>   */
>>>  
>>>  /*
>>> - * Reference to a grant entry in a specified domain's grant table.
>>> - */
>>> -typedef uint32_t grant_ref_t;
>>> -
>>> -/*
>>>   * A grant table comprises a packed array of grant entries in one or more
>>>   * page frames shared between Xen and a guest.
>>>   * [XEN]: This field is written by Xen and read by the sharing guest.
>>>
>> I'd rather use __u32 instead of grant_ref_t in the uapi headers.
>>
>> Boris, what do you think?
> 
> I agree that including a non-Xen file into include/xen/interface is not
> especially desirable.
> 
> Can we ifdef __KERNEL__grant_ref_t usage in uapi header, with else
> clause using __u32? And maybe stick BUILD_BUG_ON somewhere to check that
> sizes are still the same ?

I'd rather use __u32 unconditionally and have the BUILD_BUG_ON in the
grant or privcmd driver.

Otherwise we'd depend on the sequence of #includes (what happens if a
driver includes the uapi header before xen/interface/xen.h?)


Juergen
