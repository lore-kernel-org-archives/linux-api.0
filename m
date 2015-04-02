From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory
Date: Thu, 2 Apr 2015 15:40:56 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1504021536210.15536@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com> <alpine.LSU.2.11.1503291801400.1052@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.LSU.2.11.1503291801400.1052@eggly.anvils>
Sender: linux-doc-owner@vger.kernel.org
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Davide Libenzi <davidel@xmailserver.org>, Luiz Capitulino <lcapitulino@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andrea Arcangeli <aarcange@redhat.com>, Joern Engel <joern@logfs.org>, Jianguo Wu <wujianguo@huawei.com>, Eric B Munson <emunson@akamai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 29 Mar 2015, Hugh Dickins wrote:

> > munmap(2) of hugetlb memory requires a length that is hugepage aligned,
> > otherwise it may fail.  Add this to the documentation.
> 
> Thanks for taking this on, David.  But although munmap(2) is the one
> Davide called out, it goes beyond that, doesn't it?  To mprotect and
> madvise and ...
> 

Yes, good point, munmap(2) isn't special in this case, the alignment to 
the native page size of the platform should apply to madvise, mbind, 
mincore, mlock, mprotect, remap_file_pages, etc.

I'd hesitate to compile any authoritative list on the behavior in 
Documentation/vm/hugetlbpage.txt since it would exclude future extensions, 
but I'll update it to be more inclusive of other mm syscalls rather than 
specify only munmap(2).
