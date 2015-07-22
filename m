From: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Subject: Re: [PATCH v4 00/10] hugetlbfs: add fallocate support
Date: Wed, 22 Jul 2015 15:34:34 -0700
Message-ID: <1437604474.3298.7.camel@stgolabs.net>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
	 <20150722150647.2597c7e5be9ee1eecc438b6f@linux-foundation.org>
	 <1437603594.3298.5.camel@stgolabs.net>
	 <20150722153023.e8f15eb4e490f79cc029c8cd@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722153023.e8f15eb4e490f79cc029c8cd-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-07-22 at 15:30 -0700, Andrew Morton wrote:
> selftests is a pretty scrappy place.  It's partly a dumping ground for
> things so useful test code doesn't just get lost and bitrotted.  Partly
> a framework so people who add features can easily test them. Partly to
> provide tools to architecture maintainers when they wire up new
> syscalls and the like.

Yeah, ipc, for instance, also sucks _badly_ in selftests.
