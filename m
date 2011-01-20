From: Shaohua Li <shaohua.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/5]add new ioctls to do metadata readahead in btrfs
Date: Thu, 20 Jan 2011 10:27:13 +0800
Message-ID: <1295490433.1949.886.camel@sli10-conroe>
References: <1295399715.1949.863.camel@sli10-conroe>
	 <20110119123451.75bb3c76.akpm@linux-foundation.org>
	 <AANLkTimJ8ufoaM2GMDkUU=cjz19QtpihrgLNjjZN8m=1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimJ8ufoaM2GMDkUU=cjz19QtpihrgLNjjZN8m=1@mail.gmail.com>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Nicol <davidnicol-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Yan, Zheng" <zheng.z.yan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Wu, Fengguang" <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 2011-01-20 at 05:33 +0800, David Nicol wrote:
> On Wed, Jan 19, 2011 at 2:34 PM, Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> 
> > It would be much more valuable if those 3.5 seconds were available to
> > devices which really really care about bootup times, but very few of
> > those devices use rotating disks nowadays, I expect?
> 
> And don't rotating disk modules read and buffer whole tracks, doing
> their own readahead, anymore, anyway? Isn't that part of what "on-disk
> cache" does?
The disk readahead and the metadata readahead is completely different,
you didn't even look at the patch or log before saying this.
