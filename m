From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [RFCv3 0/5] enable migration of driver pages
Date: Wed, 08 Jul 2015 09:02:59 +0900
Message-ID: <559C68B3.3010105@lge.com>
References: <1436243785-24105-1-git-send-email-gioh.kim@lge.com> <20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150707153701.bfcde75108d1fb8aaedc8134@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, viro@zeniv.linux.org.uk, mst@redhat.com, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, gunho.lee@lge.com, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org



2015-07-08 =EC=98=A4=EC=A0=84 7:37=EC=97=90 Andrew Morton =EC=9D=B4(=EA=B0=
=80) =EC=93=B4 =EA=B8=80:
> On Tue,  7 Jul 2015 13:36:20 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
>
>> From: Gioh Kim <gurugio@hanmail.net>
>>
>> Hello,
>>
>> This series try to enable migration of non-LRU pages, such as driver's=
 page.
>>
>> My ARM-based platform occured severe fragmentation problem after long-=
term
>> (several days) test. Sometimes even order-3 page allocation failed. It=
 has
>> memory size 512MB ~ 1024MB. 30% ~ 40% memory is consumed for graphic p=
rocessing
>> and 20~30 memory is reserved for zram.
>>
>> I found that many pages of GPU driver and zram are non-movable pages. =
So I
>> reported Minchan Kim, the maintainer of zram, and he made the internal
>> compaction logic of zram. And I made the internal compaction of GPU dr=
iver.
>>
>> They reduced some fragmentation but they are not enough effective.
>> They are activated by its own interface, /sys, so they are not coopera=
tive
>> with kernel compaction. If there is too much fragmentation and kernel =
starts
>> to compaction, zram and GPU driver cannot work with the kernel compact=
ion.
>>
>> ...
>>
>> This patch set is tested:
>> - turn on Ubuntu 14.04 with 1G memory on qemu.
>> - do kernel building
>> - after several seconds check more than 512MB is used with free comman=
d
>> - command "balloon 512" in qemu monitor
>> - check hundreds MB of pages are migrated
>
> OK, but what happens if the balloon driver is not used to force
> compaction?  Does your test machine successfully compact pages on
> demand, so those order-3 allocations now succeed?

If any driver that has many pages like the balloon driver is forced to co=
mpact,
the system can get free high-order pages.

I have to show how this patch work with a driver existing in the kernel s=
ource,
for kernel developers' undestanding. So I selected the balloon driver
because it has already compaction and working with kernel compaction.
I can show how driver pages is compacted with lru-pages together.

Actually balloon driver is not best example to show how this patch compac=
ts pages.
The balloon driver compaction is decreasing page consumtion, for instance=
 1024MB -> 512MB.
I think it is not compaction precisely. It frees pages.
Of course there will be many high-order pages after 512MB is freed.


>
> Why are your changes to the GPU driver not included in this patch serie=
s?

My platform is ARM-based and GPU is ARM-Mali. The driver is not open sour=
ce.
It's too bad that I cannot show effect of this patch with the GPU driver.


>
>
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
