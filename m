From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCHSET v4 0/5] pagemap: make useable for non-privilege users
Date: Fri, 24 Jul 2015 18:34:19 +0100
Message-ID: <CAEVpBaLeG=C=01L39Dk76aY4PNLmnj5g5gKpE_nYZb84T9rHNg@mail.gmail.com>
References: <20150714152516.29844.69929.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150714152516.29844.69929.stgit@buzz>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Konstantin,

Thank you for the further update - I tested this patchset against our
code and it allows our software to work correctly (with minor userland
changes, as before).

I'll follow up with review messages but there aren't really any
concerns that I can see.

Cheers,
Mark

On Tue, Jul 14, 2015 at 4:37 PM, Konstantin Khlebnikov
<khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org> wrote:
> This patchset makes pagemap useable again in the safe way (after row hammer
> bug it was made CAP_SYS_ADMIN-only). This patchset restores access for
> non-privileged users but hides PFNs from them.
>
> Also it adds bit 'map-exlusive' which is set if page is mapped only here:
> it helps in estimation of working set without exposing pfns and allows to
> distinguish CoWed and non-CoWed private anonymous pages.
>
> Second patch removes page-shift bits and completes migration to the new
> pagemap format: flags soft-dirty and mmap-exlusive are available only
> in the new format.
>
> Changes since v3:
> * patches reordered: cleanup now in second patch
> * update pagemap for hugetlb, add missing 'FILE' bit
> * fix PM_PFRAME_BITS: its 55 not 54 as was in previous versions
>
> ---
>
> Konstantin Khlebnikov (5):
>       pagemap: check permissions and capabilities at open time
>       pagemap: switch to the new format and do some cleanup
>       pagemap: rework hugetlb and thp report
>       pagemap: hide physical addresses from non-privileged users
>       pagemap: add mmap-exclusive bit for marking pages mapped only here
>
>
>  Documentation/vm/pagemap.txt |    3
>  fs/proc/task_mmu.c           |  267 ++++++++++++++++++------------------------
>  tools/vm/page-types.c        |   35 +++---
>  3 files changed, 137 insertions(+), 168 deletions(-)
>
> --
> Konstantin
