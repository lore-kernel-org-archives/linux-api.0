From: Christopher Lameter <cl@linux.com>
Subject: Re: [RFC PATCH] Add /proc/<pid>/numa_vamaps for numa node
 information
Date: Tue, 8 May 2018 07:53:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.21.1805080747480.1849@nuc-kabylake>
References: <1525240686-13335-1-git-send-email-prakash.sangappa@oracle.com> <alpine.DEB.2.21.1805031259210.7831@nuc-kabylake> <c80ee329-084b-367f-1937-3175c178e978@oracle.com> <alpine.DEB.2.21.1805040955550.10847@nuc-kabylake> <98e34010-d55a-5f2d-7d98-cba424de2e74@oracle.com>
 <alpine.DEB.2.21.1805070945200.21162@nuc-kabylake> <a61bc7b6-ed98-045d-95c0-b6c91fc8d1da@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a61bc7b6-ed98-045d-95c0-b6c91fc8d1da@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "prakash.sangappa" <prakash.sangappa@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, drepper@gmail.com, rientjes@google.com
List-Id: linux-api@vger.kernel.org

On Mon, 7 May 2018, prakash.sangappa wrote:

> > each address for each page? Length of the VMA segment?
> > Physical address?
>
> Need numa node information for each virtual address with pages mapped.
> No need of physical address.

You need per page information? Note that there can only be one page
per virtual address. Or are we talking about address ranges?

https://www.kernel.org/doc/Documentation/vm/pagemap.txt ?

Also the move_pages syscall has the ability to determine the location of
individual pages.
