From: Mark Williamson <mwilliamson-/4lU09Eg6ahx67MzidHQgQC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCHSET v3 0/4] pagemap: make useable for non-privilege users
Date: Fri, 12 Jun 2015 19:59:31 +0100
Message-ID: <CAEVpBaK78nBijPLWrdBkmnSwLPoiZoZ5q=UQ6DzKDPmv2n-9eA@mail.gmail.com>
References: <20150609195333.21971.58194.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150609195333.21971.58194.stgit@zurg>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Konstantin,

Thanks very much for your help on this.

>From our side, I've tested our application against a patched kernel
and I confirm that the functionality can replace what we lost when
PFNs were removed from /proc/PID/pagemap.  This addresses the
functionality regression from our PoV (just requires minor userspace
changes on our part, which is fine).

I also reviewed the patch content and everything seemed good to me.

We're keen to see these get into mainline, so let us know if there's
anything we can do to help.

Cheers,
Mark

On Tue, Jun 9, 2015 at 9:00 PM, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> This patchset makes pagemap useable again in the safe way. It adds bit
> 'map-exlusive' which is set if page is mapped only here and restores
> access for non-privileged users but hides pfn from them.
>
> Last patch removes page-shift bits and completes migration to the new
> pagemap format: flags soft-dirty and mmap-exlusive are available only
> in the new format.
>
> v3: check permissions in ->open
>
> ---
>
> Konstantin Khlebnikov (4):
>       pagemap: check permissions and capabilities at open time
>       pagemap: add mmap-exclusive bit for marking pages mapped only here
>       pagemap: hide physical addresses from non-privileged users
>       pagemap: switch to the new format and do some cleanup
>
>
>  Documentation/vm/pagemap.txt |    3 -
>  fs/proc/task_mmu.c           |  219 +++++++++++++++++++-----------------------
>  tools/vm/page-types.c        |   35 +++----
>  3 files changed, 118 insertions(+), 139 deletions(-)
>
> --
> Signature
