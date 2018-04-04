From: Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: don't reserve ZONE_HIGHMEM for
 ZONE_MOVABLE request
Date: Wed, 4 Apr 2018 09:24:06 +0900
Message-ID: <CAAmzW4NGv7RyCYyokPoj4aR3ySKub4jaBZ3k=pt_YReFbByvsw@mail.gmail.com>
References: <1504672525-17915-1-git-send-email-iamjoonsoo.kim@lge.com> <20170914132452.d5klyizce72rhjaa@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170914132452.d5klyizce72rhjaa@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@techsingularity.net>, Johannes Weiner <hannes@cmpxchg.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello, Michal.

Sorry for a really long delay.

2017-09-14 22:24 GMT+09:00 Michal Hocko <mhocko@kernel.org>:
> [Sorry for a later reply]
>
> On Wed 06-09-17 13:35:25, Joonsoo Kim wrote:
>> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>
>> Freepage on ZONE_HIGHMEM doesn't work for kernel memory so it's not that
>> important to reserve.
>
> I am still not convinced this is a good idea. I do agree that reserving
> memory in both HIGHMEM and MOVABLE is just wasting memory but removing
> the reserve from the highmem as well will result that an oom victim will
> allocate from lower zones and that might have unexpected side effects.

Looks like you are confused.

This patch only affects the situation that ZONE_HIGHMEM and ZONE_MOVABLE is
used at the same time. In that case, before this patch, ZONE_HIGHMEM has
reserve for GFP_HIGHMEM | GFP_MOVABLE request, but, with this patch,  no reserve
in ZONE_HIGHMEM for GFP_HIGHMEM | GFP_MOVABLE request. This perfectly
matchs with your hope. :)

> Can we simply leave HIGHMEM reserve and only remove it from the movable
> zone if both are present?

There is no higher zone than ZONE_MOVABLE so ZONE_MOVABLE has no reserve
with/without this patch. To save memory, we need to remove the reserve in
ZONE_HIGHMEM.

Thanks.
