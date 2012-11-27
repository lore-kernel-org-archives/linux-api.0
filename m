From: Chris Metcalf <cmetcalf-kv+TWInifGbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] Preventing overlap between arch mman.h and asm-generic/mman.h
Date: Tue, 27 Nov 2012 14:18:27 -0500
Message-ID: <50B51203.3050009@tilera.com>
References: <20121121204238.GA9125@lazarus>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121121204238.GA9125@lazarus>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Carlos O'Donell <carlos-v2tUB8YBRSi3e3T8WW9gsA@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/21/2012 3:42 PM, Carlos O'Donell wrote:
> David,
>
> Thanks for the great UAPI work. While working on glibc mman.h sync I had
> the chance to look more closely at some of the UAPI headers.
>
> Currently (3.7.0-rc6) sparc, powerpc, and tile are including mman-common.h,
> but nothing in mman-common.h helps prevent the accidental definition of an
> overlapping new constant value.
>
> For example in mman.h powerpc defines:
>  #define MAP_NORESERVE  0x40            /* don't reserve swap pages */
>  #define MAP_LOCKED     0x80
>
> If someone were to add a new MAP_* value in mman-common.h at 0x40 it
> would conflict with the existing powerpc value. The powerpc maintainers
> might not notice, and that's a bug.
>
> I notice that someone is trying to avoid this kind of bug, because for
> example the new MADV_HWPOISON was chosen as 100, which is higher than
> any other MADV_* value for any architecture.
>
> Rather than avoid the problem by spot-checking, would it be acceptable
> to merge in some private macros that block out exactly which constants
> are already in use as existing values for arches using UAPI headers?
>
> Doing it this way would allow for the merged arches to more safely
> include the asm-generic version of mman.h and start benefiting from new
> constants without the usual maintenance cost (not to mention everyone
> would start in lock-step going forward). Not to mention it simplifies
> some of the glibc maintenance.

This proposal looks reasonable to me and the proposed code seems OK for
tile, at least.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
