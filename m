From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
Date: Wed, 10 Dec 2014 09:45:16 +0800
Message-ID: <5487A5AC.8050503@gmail.com>
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54822B19.2070804-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org" <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, "ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org" <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, "mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, "deller-Mmb7MZpHnFY@public.gmane.org" <deller-Mmb7MZpHnFY@public.gmane.org>, "chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org" <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>, "jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Carlos O'Donell <carlos-v2tUB8YBRSi3e3T8WW9gsA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dietlibc-a6ha8lKT7ZQ@public.gmane.org, Felix von Leitner <felix-a6ha8lKT7ZQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Andrew:

Could you help check this patch, when you have time. And apply it if
possible.

I guess, this patch is a little urgent, since it changes uapi, if wait
a little longer, more user mode programs (e.g. libc) may use MADV_FREE
as various values.

Thanks.

On 12/6/14 06:00, Chen Gang wrote:
> On 12/05/2014 02:54 PM, Minchan Kim wrote:
>> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>>> For uapi, need try to let all macros have same value, and MADV_FREE is
>>> added into main branch recently, so need redefine MADV_FREE for it.
>>>
>>> At present, '8' can be shared with all architectures, so redefine it to
>>> '8'.
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Hello Chen,
>>
>> Thanks for looking at this.
>> Feel free to add my sign.
>>
>> Acked-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
> 
> OK, thanks.
> 
> Originally I sent the same patch like you sent (but later than yours).
> Geert suggested to use same value for MADV_FREE, and Carlos confirmed
> it and suggested more things (sorry, I forgot to Cc them in this mail).
> 

-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
