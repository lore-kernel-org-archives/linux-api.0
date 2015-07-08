From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Wed, 08 Jul 2015 09:19:50 +0900
Message-ID: <559C6CA6.1050809@lge.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com>	<20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>	<559C68B3.3010105@lge.com> <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150707170746.1b91ba0d07382cbc9ba3db92@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, viro@zeniv.linux.org.uk, mst@redhat.com, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org



2015-07-08 =EC=98=A4=EC=A0=84 9:07=EC=97=90 Andrew Morton =EC=9D=B4(=EA=
=B0=80) =EC=93=B4 =EA=B8=80:
> On Wed, 08 Jul 2015 09:02:59 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>>
>>
>> 2015-07-08 ______ 7:37___ Andrew Morton ___(___) ___ ___:
>>> On Tue,  7 Jul 2015 13:36:20 +0900 Gioh Kim <gioh.kim@lge.com> wrot=
e:
>>>
>>>> From: Gioh Kim <gurugio@hanmail.net>
>>>>
>>>> Hello,
>>>>
>>>> This series try to enable migration of non-LRU pages, such as driv=
er's page.
>>>>
>>>> My ARM-based platform occured severe fragmentation problem after l=
ong-term
>>>> (several days) test. Sometimes even order-3 page allocation failed=
=2E It has
>>>> memory size 512MB ~ 1024MB. 30% ~ 40% memory is consumed for graph=
ic processing
>>>> and 20~30 memory is reserved for zram.
>>>>
>>>> I found that many pages of GPU driver and zram are non-movable pag=
es. So I
>>>> reported Minchan Kim, the maintainer of zram, and he made the inte=
rnal
>>>> compaction logic of zram. And I made the internal compaction of GP=
U driver.
>>>>
>>>> They reduced some fragmentation but they are not enough effective.
>>>> They are activated by its own interface, /sys, so they are not coo=
perative
>>>> with kernel compaction. If there is too much fragmentation and ker=
nel starts
>>>> to compaction, zram and GPU driver cannot work with the kernel com=
paction.
>>>>
>>>> ...
>>>>
>>>> This patch set is tested:
>>>> - turn on Ubuntu 14.04 with 1G memory on qemu.
>>>> - do kernel building
>>>> - after several seconds check more than 512MB is used with free co=
mmand
>>>> - command "balloon 512" in qemu monitor
>>>> - check hundreds MB of pages are migrated
>>>
>>> OK, but what happens if the balloon driver is not used to force
>>> compaction?  Does your test machine successfully compact pages on
>>> demand, so those order-3 allocations now succeed?
>>
>> If any driver that has many pages like the balloon driver is forced =
to compact,
>> the system can get free high-order pages.
>>
>> I have to show how this patch work with a driver existing in the ker=
nel source,
>> for kernel developers' undestanding. So I selected the balloon drive=
r
>> because it has already compaction and working with kernel compaction=
=2E
>> I can show how driver pages is compacted with lru-pages together.
>>
>> Actually balloon driver is not best example to show how this patch c=
ompacts pages.
>> The balloon driver compaction is decreasing page consumtion, for ins=
tance 1024MB -> 512MB.
>> I think it is not compaction precisely. It frees pages.
>> Of course there will be many high-order pages after 512MB is freed.
>
> Can the various in-kernel GPU drivers benefit from this?  If so, wiri=
ng
> up one or more of those would be helpful?

I'm sure that other in-kernel GPU drivers can have benefit.
It must be helpful.

If I was familiar with other in-kernel GPU drivers code, I tried to pat=
ch them.
It's too bad.

Minchan Kim said he had a plan to apply this patch into zram compaction=
=2E
Many embedded machines use several hundreds MB for zram.
The zram can also have benefit with this patch as much as GPU drivers.

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
