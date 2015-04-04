From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [patch -mm] mm, doc: cleanup and clarify munmap behavior for
 hugetlb memory fix
Date: Sat, 4 Apr 2015 11:34:56 +0200
Message-ID: <20150404113456.55468dc3@lwn.net>
References: <alpine.DEB.2.10.1503261621570.20009@chino.kir.corp.google.com>
	<alpine.LSU.2.11.1503291801400.1052@eggly.anvils>
	<alpine.DEB.2.10.1504021536210.15536@chino.kir.corp.google.com>
	<alpine.DEB.2.10.1504021547330.15536@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1504021547330.15536@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Davide Libenzi <davidel@xmailserver.org>, Luiz Capitulino <lcapitulino@redhat.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andrea Arcangeli <aarcange@redhat.com>, Joern Engel <joern@logfs.org>, Jianguo Wu <wujianguo@huawei.com>, Eric B Munson <emunson@akamai.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 2 Apr 2015 15:50:15 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> Don't only specify munmap(2) behavior with respect the hugetlb memory, all 
> other syscalls get naturally aligned to the native page size of the 
> processor.  Rather, pick out munmap(2) as a specific example.

So I was going to apply this to the docs tree, but it doesn't even come
close.  What tree was this patch generated against?

Thanks,

jon
