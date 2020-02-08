From: Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] mm: extend memfd with ability to create "secret"
 memory areas
Date: Sat, 8 Feb 2020 19:39:22 +0200
Message-ID: <20200208173922.GA15879@hump>
References: <20200130162340.GA14232@rapoport-lnx>
 <df5a888b-1a11-e806-741d-94684b22c966@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <df5a888b-1a11-e806-741d-94684b22c966-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alan Cox <alan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, James Bottomley <jejb-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Reshetova, Elena" <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tycho Andersen <tycho-E0fblnxP3wo@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Feb 06, 2020 at 10:51:13AM -0800, Dave Hansen wrote:
> On 1/30/20 8:23 AM, Mike Rapoport wrote:
> >  include/linux/memfd.h      |   9 ++
> >  include/uapi/linux/magic.h |   1 +
> >  include/uapi/linux/memfd.h |   6 +
> >  mm/Kconfig                 |   4 +
> >  mm/Makefile                |   1 +
> >  mm/memfd.c                 |  10 +-
> >  mm/secretmem.c             | 244 +++++++++++++++++++++++++++++++++++++
> >  7 files changed, 273 insertions(+), 2 deletions(-)
> 
> It seems pretty self-contained and relatively harmless.
> 
> But, how much work is it going to be to tell the rest of the kernel that
> page_to_virt() doesn't work any more?

Why page_to_virt() won't work anymore? Or you refer to that the kernel code
won't be able to access the page contents?

> Do we need to make kmap() work on these?

I don't think we need to make kmap() work on these. The idea is to prevent
kernel from accessing such memory areas.
 
> I guess fixing vm_normal_page() would fix a lot of that.
> 
> In general, my concern about creating little self-contained memory types
> is that they will get popular and folks will start wanting more features
> from them.  For instance, what if I want NUMA affinity, migration, or
> large page mappings that are secret?

Sure, why not :)
Well, this is true for any feature: it may become popular, people will
start using it and it will add more complexity.

My goal is to design this thing keeping in mind that all the above (and
probably more) will be requested sooner or later.
 
> Can these pages work as guest memory?

Actually, this is one of the driving usecases. I believe that people that
use mem=X to limit kernel control of the memory and the manage the
remaining memory for the guests can switch to fd-based approach.
 
> Who would the first users of this thing be?

We were thinking about using such areas to store small secrets, e.g. with
openssl_malloc().

Another usecase is the VM memory.

-- 
Sincerely yours,
Mike.
