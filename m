From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: Loosen MADV_NOHUGEPAGE to enable Qemu postcopy on
 s390
Date: Thu, 19 Nov 2015 10:31:36 +0100
Message-ID: <564D96F8.2020609@suse.cz>
References: <1447341516-18076-1-git-send-email-jjherne@linux.vnet.ibm.com>
 <564C7DCA.8010400@suse.cz> <564D86AE.1010305@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564D86AE.1010305-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "Jason J. Herne" <jjherne-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel <qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org>, "Dr. David Alan Gilbert" <dgilbert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juan Quintela <quintela-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/19/2015 09:22 AM, Christian Borntraeger wrote:
> On 11/18/2015 02:31 PM, Vlastimil Babka wrote:
>> [CC += linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
>> Anyway, I agree that it doesn't make sense to fail madvise when the given flag
>> is already set. On the other hand, I don't think the userspace app should fail
>> just because of madvise failing? It should in general be an advice that the
>> kernel is also strictly speaking free to ignore as it shouldn't affect
>> correctnes, just performance. Yeah, there are exceptions today like
>> MADV_DONTNEED, but that shouldn't apply to hugepages?
>> So I think Qemu needs fixing too.
>
> yes, I agree. David, Juan. I think The postcopy code should not fail if the madvise.
> Can you fix that?
>
>   Also what happens if the kernel is build
>> without CONFIG_TRANSPARENT_HUGEPAGE? Then madvise also returns EINVAL,
>
> Does it? To me it looks more like we would trigger a kernel bug.
>
> mm/madvise.c:
>          case MADV_HUGEPAGE:
>          case MADV_NOHUGEPAGE:
>                  error = hugepage_madvise(vma, &new_flags, behavior);  <-----
>                  if (error)
>                          goto out;
>                  break;
>          }
>
>
> include/linux/huge_mm.h:
> static inline int hugepage_madvise(struct vm_area_struct *vma,
>                                     unsigned long *vm_flags, int advice)
> {
>          BUG();
>          return 0;
> }
>
> If we just remove the BUG() statement the code would actually be correct
> in simply ignoring an MADVISE it cannot handle. If you agree, I can
> spin a patch.

Yeah this looks suspicious at first, but the code is not reachable 
thanks to madvise_behavior_valid() returning false:

...
#ifdef CONFIG_TRANSPARENT_HUGEPAGE
         case MADV_HUGEPAGE:
         case MADV_NOHUGEPAGE:
#endif
         case MADV_DONTDUMP:
         case MADV_DODUMP:
                 return true;

         default:
                 return false;

I think the BUG() is pointless (KSM doesn't use it) but not wrong. I 
wouldn't object to removal.

>
>
>> how does Qemu handle that?
>
> The normal qemu startup ignores the return value of the madvise. Only the
> recent post migration changes want to disable huge pages for userfaultd.
> And this code checks the return value. And yes, we should change that
> in QEMU.

Great, thanks :)
