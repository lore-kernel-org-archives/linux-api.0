From: Mark Williamson <mwilliamson@undo-software.com>
Subject: Re: [PATCH v4 5/5] pagemap: add mmap-exclusive bit for marking pages
 mapped only here
Date: Fri, 24 Jul 2015 19:18:37 +0100
Message-ID: <CAEVpBaJg4ySxozrBkcVr+CUy_HZdVJNqcdimVRA1HHPE=MRPNA@mail.gmail.com>
References: <20150714152516.29844.69929.stgit@buzz>
	<20150714153749.29844.81954.stgit@buzz>
	<20150721081755.GD4490@hori1.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150721081755.GD4490@hori1.linux.bs1.fc.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Reviewed-by: Mark Williamson <mwilliamson@undo-software.com>

On Tue, Jul 21, 2015 at 9:17 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> On Tue, Jul 14, 2015 at 06:37:49PM +0300, Konstantin Khlebnikov wrote:
>> This patch sets bit 56 in pagemap if this page is mapped only once.
>> It allows to detect exclusively used pages without exposing PFN:
>>
>> present file exclusive state
>> 0       0    0         non-present
>> 1       1    0         file page mapped somewhere else
>> 1       1    1         file page mapped only here
>> 1       0    0         anon non-CoWed page (shared with parent/child)
>> 1       0    1         anon CoWed page (or never forked)
>>
>> CoWed pages in (MAP_FILE | MAP_PRIVATE) areas are anon in this context.
>>
>> MMap-exclusive bit doesn't reflect potential page-sharing via swapcache:
>> page could be mapped once but has several swap-ptes which point to it.
>> Application could detect that by swap bit in pagemap entry and touch
>> that pte via /proc/pid/mem to get real information.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> Requested-by: Mark Williamson <mwilliamson@undo-software.com>
>> Link: http://lkml.kernel.org/r/CAEVpBa+_RyACkhODZrRvQLs80iy0sqpdrd0AaP_-tgnX3Y9yNQ@mail.gmail.com
>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
