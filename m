From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v4 09/10] hugetlbfs: add hugetlbfs_fallocate()
Date: Wed, 22 Jul 2015 15:30:55 -0700
Message-ID: <20150722153055.7431aeb4c39dadf02ca06d4c@linux-foundation.org>
References: <1437502184-14269-1-git-send-email-mike.kravetz@oracle.com>
	<1437502184-14269-10-git-send-email-mike.kravetz@oracle.com>
	<20150722150345.f8d5b0042cfa7112bd95d9ef@linux-foundation.org>
	<55B017EE.5020203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B017EE.5020203-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Aneesh Kumar <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hillf Danton <hillf.zj-gPhfCIXyaqCqndwCJWfcng@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 22 Jul 2015 15:23:42 -0700 Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> On 07/22/2015 03:03 PM, Andrew Morton wrote:
> > On Tue, 21 Jul 2015 11:09:43 -0700 Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> ...
> >> +
> >> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> >> +		return -EOPNOTSUPP;
> >
> > EOPNOTSUPP is a networking thing.  It's inappropriate here.
> >
> > The problem is that if this error is ever returned to userspace, the
> > user will be sitting looking at "Operation not supported on transport
> > endpoint" and wondering what went wrong in the networking stack.
> 
> Trying to follow FALLOCATE(2) man page:
> 
> "EOPNOTSUPP
> 	The filesystem containing the file referred to by  fd  does  not
> 	support  this  operation;  or  the  mode is not supported by the
> 	filesystem containing the file referred to by fd."
> 

Sigh.
