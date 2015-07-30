From: Gioh Kim <gioh.kim@lge.com>
Subject: Re: [PATCH 0/4] enable migration of driver pages
Date: Thu, 30 Jul 2015 09:21:09 +0900
Message-ID: <55B96DF5.40602@lge.com>
References: <1436776519-17337-1-git-send-email-gioh.kim@lge.com>
 <20150729104945.GA30872@techsingularity.net>
 <20150729105554.GU16722@phenom.ffwll.local>
 <20150729121614.GA19352@techsingularity.net>
 <20150729124635.GW16722@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150729124635.GW16722@phenom.ffwll.local>
Sender: owner-linux-mm@kvack.org
To: Mel Gorman <mgorman@techsingularity.net>, jlayton@poochiereds.net, bfields@fieldses.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, viro@zeniv.linux.org.uk, mst@redhat.com, koct9i@gmail.com, minchan@kernel.org, aquini@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, akpm@linux-foundation.org, Gioh Kim <gurugio@hanmail.net>
List-Id: linux-api@vger.kernel.org



2015-07-29 =EC=98=A4=ED=9B=84 9:46=EC=97=90 Daniel Vetter =EC=9D=B4(=EA=B0=
=80) =EC=93=B4 =EA=B8=80:
> On Wed, Jul 29, 2015 at 01:16:14PM +0100, Mel Gorman wrote:
>> On Wed, Jul 29, 2015 at 12:55:54PM +0200, Daniel Vetter wrote:
>>> On Wed, Jul 29, 2015 at 11:49:45AM +0100, Mel Gorman wrote:
>>>> On Mon, Jul 13, 2015 at 05:35:15PM +0900, Gioh Kim wrote:
>>>>> My ARM-based platform occured severe fragmentation problem after lo=
ng-term
>>>>> (several days) test. Sometimes even order-3 page allocation failed.=
 It has
>>>>> memory size 512MB ~ 1024MB. 30% ~ 40% memory is consumed for graphi=
c processing
>>>>> and 20~30 memory is reserved for zram.
>>>>>
>>>>
>>>> The primary motivation of this series is to reduce fragmentation by =
allowing
>>>> more kernel pages to be moved. Conceptually that is a worthwhile goa=
l but
>>>> there should be at least one major in-kernel user and while balloon
>>>> pages were a good starting point, I think we really need to see what=
 the
>>>> zram changes look like at the same time.
>>>
>>> I think gpu drivers really would be the perfect candidate for compact=
ing
>>> kernel page allocations. And this also seems the primary motivation f=
or
>>> this patch series, so I think that's really what we should use to jud=
ge
>>> these patches.
>>>
>>> Of course then there's the seemingly eternal chicken/egg problem of
>>> upstream gpu drivers for SoCs :(
>>
>> I recognised that the driver he had modified was not an in-tree user s=
o
>> it did not really help the review or the design. I did not think it wa=
s
>> very fair to ask that an in-tree GPU driver be converted when it would=
 not
>> help the embedded platform of interest. Converting zram is both a usef=
ul
>> illustration of the aops requirements and is expected to be beneficial=
 on
>> the embedded platform. Now, if a GPU driver author was willing to conv=
ert
>> theirs as an example then that would be useful!
>
> Well my concern is more with merging infrastructure to upstream for
> drivers which aren't upstream and with no plan to make that happen anyt=
ime
> soon. Seems like just offload a bit to me ... but in the end core mm is=
n't
> my thing so not my decision.
> -Daniel
>

I get idea from the out-tree driver but this infrastructure will be usefu=
l
for zram and balloon. That is agreed by the maintainers of each driver.

I'm currently accepting feedbacks from
balloon and zram and trying to be applicable for them.
Of course I hope there will be more application. It'll be more useful
if it has more application.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
