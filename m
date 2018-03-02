From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 4/4] mm: Mark pages in use for page tables
Date: Fri, 2 Mar 2018 11:21:56 +0300
Message-ID: <20180302082156.ty6nchnmwpniicyb@node.shutemov.name>
References: <20180301211523.21104-1-willy@infradead.org>
 <20180301211523.21104-5-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180301211523.21104-5-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Matthew Wilcox <mawilcox@microsoft.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 01, 2018 at 01:15:23PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Define a new PageTable bit in the page_type and use it to mark pages in
> use as page tables.  This can be helpful when debugging crashdumps or
> analysing memory fragmentation.  Add a KPF flag to report these pages
> to userspace and update page-types.c to interpret that flag.

I guess it's worth noting in the commit message that PGD and P4D page
tables are not acoounted to NR_PAGETABLE and not marked with PageTable().
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
