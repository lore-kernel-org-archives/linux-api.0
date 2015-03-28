From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory
Date: Fri, 27 Mar 2015 18:37:46 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1503271833360.5628@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com> <20150327135847.GB10747@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150327135847.GB10747@akamai.com>
Sender: linux-doc-owner@vger.kernel.org
To: Eric B Munson <emunson@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, Davide Libenzi <davidel@xmailserver.org>, Luiz Capitulino <lcapitulino@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Joern Engel <joern@logfs.org>, Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, 27 Mar 2015, Eric B Munson wrote:

> > munmap(2) of hugetlb memory requires a length that is hugepage aligned,
> > otherwise it may fail.  Add this to the documentation.
> > 
> > This also cleans up the documentation and separates it into logical
> > units: one part refers to MAP_HUGETLB and another part refers to
> > requirements for shared memory segments.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> > ---
> 
> If this is the route we are going to take, this behavoir needs to be
> called out prominently in the mmap/munmap man page.
> 

Yeah, that was my next step, but before we get mtk involved I was trying 
to get this merged since man2/mmap.2 already has a 
.I Documentation/vm/hugetlbpage.txt for MAP_HUGETLB so the man page patch 
can simply reference this addition to the file as justification.
