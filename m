From: Andres Lagar-Cavilla <andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -mm v7 5/6] proc: add kpageidle file
Date: Tue, 14 Jul 2015 13:27:22 -0700
Message-ID: <CAJu=L59r4ohz+cUmhUAzdvXs=Qf+xEkWUcqtyn-yRLHRuKXoCA@mail.gmail.com>
References: <cover.1436623799.git.vdavydov@parallels.com>
	<25f235220bef9d799f48a060d7638a5de31fc994.1436623799.git.vdavydov@parallels.com>
	<CAJu=L59+7d_16zXZAFfJkr5HSwHsfYXi9EBu_9Sx1tAcJv2LOA@mail.gmail.com>
	<20150714110527.GA1015@esperanza>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714110527.GA1015@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Raghavendra K T <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Jul 14, 2015 at 4:05 AM, Vladimir Davydov
<vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> On Mon, Jul 13, 2015 at 12:02:57PM -0700, Andres Lagar-Cavilla wrote:
>> On Sat, Jul 11, 2015 at 7:48 AM, Vladimir Davydov
>> <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> [...]
>> > +static struct page *kpageidle_get_page(unsigned long pfn)
>> > +{
>> > +       struct page *page;
>> > +       struct zone *zone;
>> > +
>> > +       if (!pfn_valid(pfn))
>> > +               return NULL;
>> > +
>> > +       page = pfn_to_page(pfn);
>> > +       if (!page || PageTail(page) || !PageLRU(page) ||
>> > +           !get_page_unless_zero(page))
>>
>> get_page_unless_zero does not succeed for Tail pages.
>
> True. So we don't seem to need the PageTail checks here at all, because
> if kpageidle_get_page succeeds, the page must be a head, so that we
> won't dive into expensive rmap_walk for tail pages. Will remove it then.
>
>>
>> > +               return NULL;
>> > +
>> > +       if (unlikely(PageTail(page))) {
>> > +               put_page(page);
>> > +               return NULL;
>> > +       }
>> > +
>> > +       zone = page_zone(page);
>> > +       spin_lock_irq(&zone->lru_lock);
>> > +       if (unlikely(!PageLRU(page))) {
>> > +               put_page(page);
>> > +               page = NULL;
>> > +       }
>> > +       spin_unlock_irq(&zone->lru_lock);
>> > +       return page;
>> > +}
>> > +
>> > +static int kpageidle_clear_pte_refs_one(struct page *page,
>> > +                                       struct vm_area_struct *vma,
>> > +                                       unsigned long addr, void *arg)
>> > +{
>> > +       struct mm_struct *mm = vma->vm_mm;
>> > +       spinlock_t *ptl;
>> > +       pmd_t *pmd;
>> > +       pte_t *pte;
>> > +       bool referenced = false;
>> > +
>> > +       if (unlikely(PageTransHuge(page))) {
>>
>> VM_BUG_ON(!PageHead)?
>
> Don't think it's necessary, because PageTransHuge already does this sort
> of check:
>
> : static inline int PageTransHuge(struct page *page)
> : {
> :       VM_BUG_ON_PAGE(PageTail(page), page);
> :       return PageHead(page);
> : }
>
>>
>> > +               pmd = page_check_address_pmd(page, mm, addr,
>> > +                                            PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
>> > +               if (pmd) {
>> > +                       referenced = pmdp_test_and_clear_young(vma, addr, pmd);
>>
>> For any workload using MMU notifiers, this will lose significant
>> information by not querying the secondary PTE. The most
>> straightforward case is KVM. Once mappings are setup, all access
>> activity is recorded through shadow PTEs. This interface will say
>> "idle" even though the VM is blasting memory.
>
> Hmm, interesting. It seems we have to introduce
> mmu_notifier_ops.clear_young then, which, in contrast to
> clear_flush_young, won't flush TLB. Looking back at your comment to v6,
> now I see that you already mentioned it, but I missed your point :-(
> OK, will do it in the next iteration.

There's clearly value in fixing things for KVM, but I don't have
knowledge of the other MMU notifiers. I like clear_young, maybe other
mmu notifiers will turn this into a no-op().

mmmmhh. What about TLB flushing in the mmu notifier? I guess that can
be internal to each implementation.

Andres
>
> Thanks a lot for the review!
>
> Vladimir



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
