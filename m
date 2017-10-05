From: Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: Consolidate page table accounting
Date: Thu, 5 Oct 2017 10:38:29 +0530
Message-ID: <3aabab03-7f0a-e82e-a1c2-79120aed5ace@linux.vnet.ibm.com>
References: <20171004163648.11234-1-kirill.shutemov@linux.intel.com>
 <20171004163648.11234-2-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171004163648.11234-2-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/04/2017 10:06 PM, Kirill A. Shutemov wrote:
> This patch switches page table accounting to single counter from
> three -- nr_ptes, nr_pmds and nr_puds.
> 
> mm->pgtables_bytes is now used to account page table levels. We use
> bytes, because page table size for different levels of page table tree
> may be different.
> 
> The change has user-visible effect: we don't have VmPMD and VmPUD
> reported in /proc/[pid]/status. Not sure if anybody uses them.
> (As alternative, we can always report 0 kB for them.)
> 
> OOM-killer report is also slightly changed: we now report pgtables_bytes
> instead of nr_ptes, nr_pmd, nr_puds.

Could you please mention the motivation of doing this ? Why we are
consolidating the counters which also changes /proc/ interface as
well as OOM report ? What is the benefit ?
