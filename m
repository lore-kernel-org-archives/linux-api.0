From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 2/2] mm: Consolidate page table accounting
Date: Thu, 5 Oct 2017 13:10:48 +0300
Message-ID: <20171005101048.qa62lqk6gjfz6azt@node.shutemov.name>
References: <20171004163648.11234-1-kirill.shutemov@linux.intel.com>
 <20171004163648.11234-2-kirill.shutemov@linux.intel.com>
 <3aabab03-7f0a-e82e-a1c2-79120aed5ace@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3aabab03-7f0a-e82e-a1c2-79120aed5ace@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Michal Hocko <mhocko@kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 05, 2017 at 10:38:29AM +0530, Anshuman Khandual wrote:
> On 10/04/2017 10:06 PM, Kirill A. Shutemov wrote:
> > This patch switches page table accounting to single counter from
> > three -- nr_ptes, nr_pmds and nr_puds.
> > 
> > mm->pgtables_bytes is now used to account page table levels. We use
> > bytes, because page table size for different levels of page table tree
> > may be different.
> > 
> > The change has user-visible effect: we don't have VmPMD and VmPUD
> > reported in /proc/[pid]/status. Not sure if anybody uses them.
> > (As alternative, we can always report 0 kB for them.)
> > 
> > OOM-killer report is also slightly changed: we now report pgtables_bytes
> > instead of nr_ptes, nr_pmd, nr_puds.
> 
> Could you please mention the motivation of doing this ? Why we are
> consolidating the counters which also changes /proc/ interface as
> well as OOM report ? What is the benefit ?

Sure, I'll update description.

-- 
 Kirill A. Shutemov
