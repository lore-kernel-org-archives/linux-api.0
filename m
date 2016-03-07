From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2] sparc64: Add support for Application Data Integrity (ADI)
Date: Mon, 7 Mar 2016 10:08:24 -0800
Message-ID: <CALCETrXN43nT4zq2MpO90VrgK3k+DKHjOHWf7iOhS7TSBmdCPQ@mail.gmail.com>
References: <1456951177-23579-1-git-send-email-khalid.aziz@oracle.com>
 <20160305.230702.1325379875282120281.davem@davemloft.net> <56DD9949.1000106@oracle.com>
 <20160307.115626.807716799249471744.davem@davemloft.net> <56DDC2B6.6020009@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56DDC2B6.6020009-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, dingel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, bob.picco-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Gardner <rob.gardner-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Vineet.Gupta1-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, Andrew Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Benjamin Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqygBwfqmJ+zsg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Mar 7, 2016 at 10:04 AM, Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> On 03/07/2016 09:56 AM, David Miller wrote:
>>
>> From: Khalid Aziz <khalid.aziz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>> Date: Mon, 7 Mar 2016 08:07:53 -0700
>>
>>> PR_GET_SPARC_ADICAPS
>>
>>
>> Put this into a new ELF auxiliary vector entry via ARCH_DLINFO.
>>
>> So now all that's left is supposedly the TAG stuff, please explain
>> that to me so I can direct you to the correct existing interface to
>> provide that as well.
>>
>> Really, try to avoid prtctl, it's poorly typed and almost worse than
>> ioctl().
>>
>
> The two remaining operations I am looking at are:
>
> 1. Is PSTATE.mcde bit set for the process? PR_SET_SPARC_ADI provides this in
> its return value in the patch I sent.
>
> 2. Is TTE.mcd set for a given virtual address? PR_GET_SPARC_ADI_STATUS
> provides this function in the patch I sent.
>
> Setting and clearing version tags can be done entirely from userspace:
>
>         while (addr < end) {
>                 asm volatile(
>                         "stxa %1, [%0]ASI_MCD_PRIMARY\n\t"
>                         :
>                         : "r" (addr), "r" (version));
>                 addr += adicap.blksz;
>         }
> so I do not have to add any kernel code for tags.

Is the effect of that to change the tag associated with a page to
which the caller has write access?

I sense DoS issues in your future.
