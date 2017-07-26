From: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RESEND PATCH 1/2] userfaultfd: Add feature to request for a
 signal delivery
Date: Wed, 26 Jul 2017 16:19:22 +0200
Message-ID: <20170726141922.GV29716@redhat.com>
References: <1500958062-953846-1-git-send-email-prakash.sangappa@oracle.com>
 <1500958062-953846-2-git-send-email-prakash.sangappa@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1500958062-953846-2-git-send-email-prakash.sangappa@oracle.com>
Sender: owner-linux-mm@kvack.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, mike.kravetz@oracle.com
List-Id: linux-api@vger.kernel.org

On Tue, Jul 25, 2017 at 12:47:41AM -0400, Prakash Sangappa wrote:
> In some cases, userfaultfd mechanism should just deliver a SIGBUS signal
> to the faulting process, instead of the page-fault event. Dealing with
> page-fault event using a monitor thread can be an overhead in these
> cases. For example applications like the database could use the signaling
> mechanism for robustness purpose.
> 
> Database uses hugetlbfs for performance reason. Files on hugetlbfs
> filesystem are created and huge pages allocated using fallocate() API.
> Pages are deallocated/freed using fallocate() hole punching support.
> These files are mmapped and accessed by many processes as shared memory.
> The database keeps track of which offsets in the hugetlbfs file have
> pages allocated.
> 
> Any access to mapped address over holes in the file, which can occur due
> to bugs in the application, is considered invalid and expect the process
> to simply receive a SIGBUS.  However, currently when a hole in the file is
> accessed via the mapped address, kernel/mm attempts to automatically
> allocate a page at page fault time, resulting in implicitly filling the
> hole in the file. This may not be the desired behavior for applications
> like the database that want to explicitly manage page allocations of
> hugetlbfs files.
> 
> Using userfaultfd mechanism with this support to get a signal, database
> application can prevent pages from being allocated implicitly when
> processes access mapped address over holes in the file.
> 
> This patch adds UFFD_FEATURE_SIGBUS feature to userfaultfd mechnism to
> request for a SIGBUS signal.
> 
> See following for previous discussion about the database requirement
> leading to this proposal as suggested by Andrea.
> 
> http://www.spinics.net/lists/linux-mm/msg129224.html
> 
> Signed-off-by: Prakash Sangappa <prakash.sangappa@oracle.com>
> ---
>  fs/userfaultfd.c                 |    3 +++
>  include/uapi/linux/userfaultfd.h |   10 +++++++++-
>  2 files changed, 12 insertions(+), 1 deletions(-)

Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
