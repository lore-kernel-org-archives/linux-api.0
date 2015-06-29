From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] mm: fix status code move_pages() returns for zero page
Date: Mon, 29 Jun 2015 09:50:48 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506290947560.3164@east.gentwo.org>
References: <1435141428-98266-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1435141428-98266-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>
List-Id: linux-api@vger.kernel.org

On Wed, 24 Jun 2015, Kirill A. Shutemov wrote:

> Man page for move_pages(2) specifies that status code for zero page is
> supposed to be -EFAULT. Currently kernel return -ENOENT in this case.
>
> follow_page() can do it for us, if we would ask for FOLL_DUMP.

FOLL_DUMP also has the consequence that the upper layer page tables pages
are no longer allocated.

Otherwise this looks ok.

Reviewed-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
