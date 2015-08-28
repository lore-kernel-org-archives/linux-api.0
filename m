From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v8 3/6] mm: Introduce VM_LOCKONFAULT
Date: Fri, 28 Aug 2015 16:54:16 +0200
Message-ID: <55E07618.9090905@suse.cz>
References: <1440613465-30393-1-git-send-email-emunson@akamai.com>
 <1440613465-30393-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440613465-30393-4-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/26/2015 08:24 PM, Eric B Munson wrote:
> The cost of faulting in all memory to be locked can be very high when
> working with large mappings.  If only portions of the mapping will be
> used this can incur a high penalty for locking.
>
> For the example of a large file, this is the usage pattern for a large
> statical language model (probably applies to other statical or graphical
> models as well).  For the security example, any application transacting
> in data that cannot be swapped out (credit card data, medical records,
> etc).
>
> This patch introduces the ability to request that pages are not
> pre-faulted, but are placed on the unevictable LRU when they are finally
> faulted in.  The VM_LOCKONFAULT flag will be used together with
> VM_LOCKED and has no effect when set without VM_LOCKED.  Setting the
> VM_LOCKONFAULT flag for a VMA will cause pages faulted into that VMA to
> be added to the unevictable LRU when they are faulted or if they are
> already present, but will not cause any missing pages to be faulted in.
>
> Exposing this new lock state means that we cannot overload the meaning
> of the FOLL_POPULATE flag any longer.  Prior to this patch it was used
> to mean that the VMA for a fault was locked.  This means we need the
> new FOLL_MLOCK flag to communicate the locked state of a VMA.
> FOLL_POPULATE will now only control if the VMA should be populated and
> in the case of VM_LOCKONFAULT, it will not be set.
>
> Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

I just wonder if the call to populate_vma_page_range from mprotect_fixup 
is just an potentially expensive no-op for VM_LOCKONFAULT vma's? It 
might find many cow candidates but faultin_page() won't do anything. And 
it shouldn't find any existing pages to put on the unevictable list from 
this context.

But it's a corner case and preventing it would mean putting in another 
VM_LOCKONFAULT check so maybe we can leave it like this.
-
