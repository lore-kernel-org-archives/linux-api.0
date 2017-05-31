From: Mike Rapoprt <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 15:39:22 +0300
Message-ID: <8FA5E4C2-D289-4AF5-AA09-6C199E58F9A5@linux.vnet.ibm.com>
References: <c59a0893-d370-130b-5c33-d567a4621903@suse.cz> <20170524103947.GC3063@rapoport-lnx> <20170524111800.GD14733@dhcp22.suse.cz> <20170524142735.GF3063@rapoport-lnx> <20170530074408.GA7969@dhcp22.suse.cz> <20170530101921.GA25738@rapoport-lnx> <20170530103930.GB7969@dhcp22.suse.cz> <20170530140456.GA8412@redhat.com> <20170530143941.GK7969@dhcp22.suse.cz> <20170530154326.GB8412@redhat.com> <20170531120822.GL27783@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531120822.GL27783-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On May 31, 2017 3:08:22 PM GMT+03:00, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>On Tue 30-05-17 17:43:26, Andrea Arcangeli wrote:
>> On Tue, May 30, 2017 at 04:39:41PM +0200, Michal Hocko wrote:
>> > I sysctl for the mapcount can be increased, right? I also assume
>that
>> > those vmas will get merged after the post copy is done.
>> 
>> Assuming you enlarge the sysctl to the worst possible case, with
>64bit
>> address space you can have billions of VMAs if you're migrating 4T of
>> RAM and you're unlucky and the address space gets fragmented. The
>> unswappable kernel memory overhead would be relatively large
>> (i.e. dozen gigabytes of RAM in vm_area_struct slab), and each
>> find_vma operation would need to walk ~40 steps across that large vma
>> rbtree. There's a reason the sysctl exist. Not to tell all those
>> unnecessary vma mangling operations would be protected by the
>mmap_sem
>> for writing.
>> 
>> Not creating a ton of vmas and enabling vma-less pte mangling with a
>> single large vma and only using mmap_sem for reading during all the
>> pte mangling, is one of the primary design motivations for
>> userfaultfd.
>
>Yes, I am aware of fallouts of too many vmas. I was asking merely to
>learn whether this will really happen under the the specific usecase
>Mike is after.

That depends on the application access pattern in the period between the pre-dump is finished and the application is frozen. If the accesses are random enough, the dirty pages that would be post copied could get spread all over the address space.

>> > I understand that part but it sounds awfully one purpose thing to
>me.
>> > Are we going to add other MADVISE_RESET_$FOO to clear other flags
>just
>> > because we can race in this specific use case?
>> 
>> Those already exists, see for example MADV_NORMAL, clearing
>> ~VM_RAND_READ & ~VM_SEQ_READ after calling MADV_SEQUENTIAL or
>> MADV_RANDOM.
>
>I would argue that MADV_NORMAL is everything but a clear madvise
>command. Why doesn't it clear all the sticky MADV* flags?

That would be helpful :)
Still, the problem here is more with the naming that with the action. If it was called MADV_DEFAULT_READ or something, it would be fine, wouldn't it?

>> Or MADV_DOFORK after MADV_DONTFORK. MADV_DONTDUMP after MADV_DODUMP.
>Etc..
>>
>> > But we already have MADV_HUGEPAGE, MADV_NOHUGEPAGE and prctl to
>> > enable/disable thp. Doesn't that sound little bit too much for a
>single
>> > feature to you?
>> 
>> MADV_NOHUGEPAGE doesn't mean clearing the flag set with
>> MADV_HUGEPAGE. MADV_NOHUGEPAGE disables THP on the region if the
>> global sysfs "enabled" tune is set to "always". MADV_HUGEPAGE enables
>> THP if the global "enabled" sysfs tune is set to "madvise". The two
>> MADV_NOHUGEPAGE and MADV_HUGEPAGE are needed to leverage the
>three-way
>> setting of "never" "madvise" "always" of the global tune.
>> 
>> The "madvise" global tune exists if you want to save RAM and you
>don't
>> care much about performance but still allowing apps like QEMU where
>no
>> memory is lost by enabling THP, to use THP.
>> 
>> There's no way to clear either of those two flags and bring back the
>> default behavior of the global sysfs tune, so it's not redundant at
>> the very least.
>
>Yes I am not a huge fan of the current MADV*HUGEPAGE semantic but I
>would really like to see a strong usecase for adding another command on
>top. 

Well, another command makes the semantic a bit better, IMHO...

> From what Mike said a global disable THP for the whole process
>while the post-copy is in progress is a better solution anyway.

For the CRIU usecase, disabling THP for a while and re-enabling it back will do the trick, provided VMAs flags are not affected, like in the patch you've sent.
Moreover, we may even get away with ioctl(UFFDIO_COPY) if it's overhead shows to be negligible​.
Still, I believe that MADV_RESET_HUGEPAGE (or some better named) command has the value on its own.
--
Sincerely yours,
Mike.
