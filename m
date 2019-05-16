From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC 0/5] mm: process_vm_mmap() -- syscall for duplication
 a process mapping
Date: Thu, 16 May 2019 15:52:59 +0200
Message-ID: <20190516135259.GU16651@dhcp22.suse.cz>
References: <155793276388.13922.18064660723547377633.stgit@localhost.localdomain>
 <20190516133034.GT16651@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516133034.GT16651@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, keith.busch@intel.com, kirill.shutemov@linux.intel.com, pasha.tatashin@oracle.com, alexander.h.duyck@linux.intel.com, ira.weiny@intel.com, andreyknvl@google.com, arunks@codeaurora.org, vbabka@suse.cz, cl@linux.com, riel@surriel.com, keescook@chromium.org, hannes@cmpxchg.org, npiggin@gmail.com, mathieu.desnoyers@efficios.com, shakeelb@google.com, guro@fb.com, aarcange@redhat.com, hughd@google.com, jglisse@redhat.com, mgorman@techsingularity.net, daniel.m.jordan@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu 16-05-19 15:30:34, Michal Hocko wrote:
> [You are defining a new user visible API, please always add linux-api
>  mailing list - now done]
> 
> On Wed 15-05-19 18:11:15, Kirill Tkhai wrote:
[...]
> > The proposed syscall aims to introduce an interface, which
> > supplements currently existing process_vm_writev() and
> > process_vm_readv(), and allows to solve the problem with
> > anonymous memory transfer. The above example may be rewritten as:
> > 
> > 	void *buf;
> > 
> > 	buf = mmap(NULL, n * PAGE_SIZE, PROT_READ|PROT_WRITE,
> > 		   MAP_PRIVATE|MAP_ANONYMOUS, ...);
> > 	recv(sock, buf, n * PAGE_SIZE, 0);
> > 
> > 	/* Sign of @pid is direction: "from @pid task to current" or vice versa. */
> > 	process_vm_mmap(-pid, buf, n * PAGE_SIZE, remote_addr, PVMMAP_FIXED);
> > 	munmap(buf, n * PAGE_SIZE);

AFAIU this means that you actually want to do an mmap of an anonymous
memory with a COW semantic to the remote process right? How does the
remote process find out where and what has been mmaped? What if the
range collides? This sounds quite scary to me TBH. Why cannot you simply
use shared memory for that?
-- 
Michal Hocko
SUSE Labs
