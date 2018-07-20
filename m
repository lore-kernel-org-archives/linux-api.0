From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 0/7] kmalloc-reclaimable caches
Date: Fri, 20 Jul 2018 11:45:02 +0200
Message-ID: <8ed44a53-fa20-a7ff-c662-72de9a9fd9e4@suse.cz>
References: <20180718133620.6205-1-vbabka@suse.cz>
 <20180719195332.GB26595@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180719195332.GB26595@castle.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@techsingularity.net>, Matthew Wilcox <willy@infradead.org>, Laura Abbott <labbott@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, Vijayanand Jitta <vjitta@codeaurora.org>
List-Id: linux-api@vger.kernel.org

On 07/19/2018 09:53 PM, Roman Gushchin wrote:
>> Vlastimil
> Overall the patchset looks solid to me.
> Please, feel free to add
> Acked-by: Roman Gushchin <guro@fb.com>

Thanks!

> Two small nits:
> 1) The last patch is unrelated to the main idea,
> and can potentially cause ABI breakage.

Yes, that's why it's last.

> I'd separate it from the rest of the patchset.

It's not independent though because there would be conflicts. It has to
be decided if it goes before of after the rest. Putting it last in the
series makes the order clear and makes it possible to revert it in case
it does break any users, without disrupting the rest of the series.

> 2) It's actually re-opening the security issue for SLOB
> users. Is the memory overhead really big enough to
> justify that?

I assume that anyone choosing SLOB has a tiny embedded device which runs
only pre-flashed code, so that's less of an issue. If somebody can
trigger the issue remotely, there are likely also other ways to exhaust
the limited memory there?

> Thanks!
