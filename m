From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 3/4] mm: Mark pages allocated through vmalloc
Date: Fri, 2 Mar 2018 11:20:14 +0300
Message-ID: <20180302082014.4zlhvot6lzg75x66@node.shutemov.name>
References: <20180301211523.21104-1-willy@infradead.org>
 <20180301211523.21104-4-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180301211523.21104-4-willy@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Matthew Wilcox <mawilcox@microsoft.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, Mar 01, 2018 at 01:15:22PM -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> Use a bit in page_type to mark pages which have been allocated through
> vmalloc.  This can be helpful when debugging crashdumps or analysing
> memory fragmentation.  Add a KPF flag to report these pages to userspace
> and update page-types.c to interpret that flag.
> 
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
