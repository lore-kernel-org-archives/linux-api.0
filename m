From: Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHv2 1/2] mm: Introduce wrappers to access mm->nr_ptes
Date: Fri, 6 Oct 2017 09:32:03 +0530
Message-ID: <856babfe-fd38-0bd2-d8d2-64dfe6672da8@linux.vnet.ibm.com>
References: <20171005101442.49555-1-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171005101442.49555-1-kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 10/05/2017 03:44 PM, Kirill A. Shutemov wrote:
> Let's add wrappers for ->nr_ptes with the same interface as for nr_pmd
> and nr_pud.
> 
> It's preparation for consolidation of page-table counters in mm_struct.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Hey Kirill,

This patch does not apply cleanly either on mainline or on the latest
mmotm branch mmotm-2017-10-03-17-08. Is there any other branch like
'linux next' you might have rebased these patches against ?

- Anshuman
