From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Wed, 31 May 2017 16:19:40 +0200
Message-ID: <20170531141939.GP27783@dhcp22.suse.cz>
References: <20170524111800.GD14733@dhcp22.suse.cz>
 <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
 <20170530140456.GA8412@redhat.com>
 <20170530143941.GK7969@dhcp22.suse.cz>
 <20170530154326.GB8412@redhat.com>
 <20170531120822.GL27783@dhcp22.suse.cz>
 <8FA5E4C2-D289-4AF5-AA09-6C199E58F9A5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8FA5E4C2-D289-4AF5-AA09-6C199E58F9A5-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Rapoprt <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 31-05-17 15:39:22, Mike Rapoprt wrote:
> 
> 
> On May 31, 2017 3:08:22 PM GMT+03:00, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
[...]
> > From what Mike said a global disable THP for the whole process
> >while the post-copy is in progress is a better solution anyway.
> 
> For the CRIU usecase, disabling THP for a while and re-enabling
> it back will do the trick, provided VMAs flags are not affected,
> like in the patch you've sent.  Moreover, we may even get away with
> ioctl(UFFDIO_COPY) if it's overhead shows to be negligible.  Still,
> I believe that MADV_RESET_HUGEPAGE (or some better named) command has
> the value on its own.

I would prefer if we could go the prctl if possible and add a new
MADV_RESET_HUGEPAGE if there is really a usecase for it.
-- 
Michal Hocko
SUSE Labs
