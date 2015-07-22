From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 00/10] hugetlbfs: add fallocate support
Date: Wed, 22 Jul 2015 15:30:23 -0700
Message-ID: <20150722153023.e8f15eb4e490f79cc029c8cd@linux-foundation.org>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
	<20150722150647.2597c7e5be9ee1eecc438b6f@linux-foundation.org>
	<1437603594.3298.5.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437603594.3298.5.camel-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>
Cc: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Jul 2015 15:19:54 -0700 Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org> wrote:

> > 
> > I didn't know that libhugetlbfs has tests.  I wonder if that makes
> > tools/testing/selftests/vm's hugetlbfstest harmful?
> 
> Why harmful? Redundant, maybe(?).

The presence of the in-kernel tests will cause people to add stuff to
them when it would be better if they were to apply that effort to
making libhugetlbfs better.  Or vice versa.

Mike's work is an example.  Someone later makes a change to hugetlbfs, runs
the kernel selftest and says "yay, everything works", unaware that they
just broke fallocate support.

> Does anyone even use selftests for
> hugetlbfs regression testing? Lets see, we also have these:
> 
> - hugepage-{mmap,shm}.c
> - map_hugetlb.c
> 
> There's probably a lot of room for improvement here.

selftests is a pretty scrappy place.  It's partly a dumping ground for
things so useful test code doesn't just get lost and bitrotted.  Partly
a framework so people who add features can easily test them. Partly to
provide tools to architecture maintainers when they wire up new
syscalls and the like.

Unless there's some good reason to retain the hugetlb part of
selftests, I'm thinking we should just remove it to avoid
distracting/misleading people.  Or possibly move the libhugetlbfs test
code into the kernel tree and maintain it there.
