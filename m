From: Chen Gang <gang.chen.5i5j-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
Date: Sat, 06 Dec 2014 05:51:49 +0800
Message-ID: <548228F5.4020801@gmail.com>
References: <5480E715.3020900@gmail.com> <20141205001446.GC10064@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141205001446.GC10064-PTl6brltDGh4DFYR7WNSRA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org" <rth-hL46jP5Bxq7R7s880joybQ@public.gmane.org>, "ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org" <ink-biIs/Y0ymYJMZLIVYojuPNP0rXTJTi09@public.gmane.org>, "mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mattst88-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, "jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org" <jejb-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>, "deller-Mmb7MZpHnFY@public.gmane.org" <deller-Mmb7MZpHnFY@public.gmane.org>, "chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org" <chris-YvXeqwSYzG2sTnJN9+BGXg@public.gmane.org>, "jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <jcmvbkbc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/05/2014 08:14 AM, Darrick J. Wong wrote:
> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>> For uapi, need try to let all macros have same value, and MADV_FREE is
>> added into main branch recently, so need redefine MADV_FREE for it.
>>
>> At present, '8' can be shared with all architectures, so redefine it to
>> '8'.
> 
> Hmmm... you might want to talk to the dietlibc people if you do this:
> 
> $ grep -rn MADV_FREE /usr/include/
> /usr/include/diet/sys/mman.h:101:#define MADV_FREE      0x5             /* (Solaris) contents can be freed */
> 
> Though the sole definition only exists on sparc/powerpc/powerpc64, so who
> knows...
>

Excuse me, I am not quite familiar about dietlibc. If possible, please
help forward this mail to them, and Cc me (if necessary).

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
