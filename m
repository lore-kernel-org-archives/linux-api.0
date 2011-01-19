From: David Nicol <davidnicol@gmail.com>
Subject: Re: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Wed, 19 Jan 2011 15:33:28 -0600
Message-ID: <AANLkTimJ8ufoaM2GMDkUU=cjz19QtpihrgLNjjZN8m=1@mail.gmail.com>
References: <1295399715.1949.863.camel@sli10-conroe> <20110119123451.75bb3c76.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110119123451.75bb3c76.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, "Yan, Zheng" <zheng.z.yan@linux.intel.com>, "Wu, Fengguang" <fengguang.wu@intel.com>, linux-api <linux-api@vger.kernel.org>, manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 19, 2011 at 2:34 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:

> It would be much more valuable if those 3.5 seconds were available to
> devices which really really care about bootup times, but very few of
> those devices use rotating disks nowadays, I expect?

And don't rotating disk modules read and buffer whole tracks, doing
their own readahead, anymore, anyway? Isn't that part of what "on-disk
cache" does?
