From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 00/10] hugetlbfs: add fallocate support
Date: Wed, 22 Jul 2015 17:05:20 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1507221701580.14953@chino.kir.corp.google.com>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com> <20150722150647.2597c7e5be9ee1eecc438b6f@linux-foundation.org> <1437603594.3298.5.camel@stgolabs.net> <20150722153023.e8f15eb4e490f79cc029c8cd@linux-foundation.org> <55B024C6.8010504@oracle.com>
 <1437609241.3298.19.camel@stgolabs.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1437609241.3298.19.camel@stgolabs.net>
Sender: owner-linux-mm@kvack.org
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Eric B Munson <emunson@akamai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Hugh Dickins <hughd@google.com>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Hillf Danton <hillf.zj@alibaba-inc.com>, Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Jul 2015, Davidlohr Bueso wrote:

> fwiw, I've been trying to push people towards this for a while. Ie:
> 
> commit 15610c86fa83ff778eb80d3cfaa71d6acceb628a
> Author: Davidlohr Bueso <davidlohr@hp.com>
> Date:   Wed Sep 11 14:21:48 2013 -0700
> 
>     hugepage: mention libhugetlbfs in doc
>     
>     Explicitly mention/recommend using the libhugetlbfs test cases when
>     changing related kernel code.  Developers that are unaware of the project
>     can easily miss this and introduce potential regressions that may or may
>     not be caught by community review.
>     
>     Also do some cleanups that make the document visually easier to view at a
>     first glance.
>     
>     Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> But generally speaking, I doubt this doc is read much.
> 

The mmap(2) man page cites it specifically as the source of information on 
MAP_HUGETLB and it, in turn, directs people to 
tools/testing/selftests/vm/map_hugetlb.c.  It also mentions libhugetlbfs 
as a result of your patch, so perhaps change the man page to point people 
directly there?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
