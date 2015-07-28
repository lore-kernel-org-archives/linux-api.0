From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 4/4] mm: remove direct calling of migration
Date: Tue, 28 Jul 2015 09:26:18 +0900
Message-ID: <55B6CC2A.3050107@lge.com>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com> <1436776519-17337-5-git-send-email-gioh.kim@lge.com> <55B638F1.9090407@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55B638F1.9090407@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>, jlayton@poochiereds.net, bfields@fieldses.org, iamjoonsoo.kim@lge.com, viro@zeniv.linux.org.uk, mst@redhat.com, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, akpm@linux-foundation.org, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org



2015-07-27 =EC=98=A4=ED=9B=84 10:58=EC=97=90 Vlastimil Babka =EC=9D=B4(=
=EA=B0=80) =EC=93=B4 =EA=B8=80:
> On 07/13/2015 10:35 AM, Gioh Kim wrote:
>> From: Gioh Kim <gurugio@hanmail.net>
>>
>> Migration is completely generalized so that migrating mobile page
>> is processed with lru-pages in move_to_new_page.
>>
>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>> Acked-by: Rafael Aquini <aquini@redhat.com>
>
> Why not just fold this to Patch 3? You already modify this hunk there=
, and prior to patch 3, the hunk was balloon-pages specific. You made i=
t look generic only to remove it, which is unneeded code churn and I do=
n't think it adds anything wrt e.g. bisectability.
Yes, you have a point.
I'll be merged into 3/4 at next spin.

I wanted to show the process how migration is generalized with this pat=
ch.
On second thought it is not necessary.

>
>> ---
>>   mm/migrate.c | 15 ---------------
>>   1 file changed, 15 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 53f0081d..e6644ac 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -844,21 +844,6 @@ static int __unmap_and_move(struct page *page, =
struct page *newpage,
>>           }
>>       }
>>
>> -    if (unlikely(mobile_page(page))) {
>> -        /*
>> -         * A mobile page does not need any special attention from
>> -         * physical to virtual reverse mapping procedures.
>> -         * Skip any attempt to unmap PTEs or to remap swap cache,
>> -         * in order to avoid burning cycles at rmap level, and perf=
orm
>> -         * the page migration right away (proteced by page lock).
>> -         */
>> -        lock_page(newpage);
>> -        rc =3D page->mapping->a_ops->migratepage(page->mapping,
>> -                               newpage, page, mode);
>> -        unlock_page(newpage);
>> -        goto out_unlock;
>> -    }
>> -
>>       /*
>>        * Corner case handling:
>>        * 1. When a new swap-cache page is read into, it is added to =
the LRU
>>
>
>
