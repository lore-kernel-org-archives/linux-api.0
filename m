From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 2/2] doc: Update documentation for page_idle virtual
 address indexing
Date: Fri, 26 Jul 2019 16:26:47 -0400
Message-ID: <20190726202647.GA213712@google.com>
References: <20190726152319.134152-1-joel@joelfernandes.org>
 <20190726152319.134152-2-joel@joelfernandes.org>
 <20190726201710.GA144547@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190726201710.GA144547@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: sspatil@google.com
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, bgregg@netflix.com, chansen3@cisco.com, dancol@google.com, fmayer@google.com, joaodias@google.com, corbet@lwn.net, keescook@chromium.org, kernel-team@android.com, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, rppt@linux.ibm.com, minchan@kernel.org, namhyung@google.com, guro@fb.com, sfr@canb.auug.org.au, surenb@google.com, tkjos@google.com, vdavydov.dev@gmail.com, vbabka@suse.cz, wvw@google.com, sspatil+mutt@google.com
List-Id: linux-api@vger.kernel.org

On Fri, Jul 26, 2019 at 01:17:10PM -0700, sspatil@google.com wrote:
> Thanks Joel, just a couple of nits for the doc inline below. Other than that,
> 
> Reviewed-by: Sandeep Patil <sspatil@google.com>

Thanks!

> I'll plan on making changes to Android to use this instead of the pagemap +
> page_idle. I think it will also be considerably faster.

Cool, glad to know.

> On Fri, Jul 26, 2019 at 11:23:19AM -0400, Joel Fernandes (Google) wrote:
> > This patch updates the documentation with the new page_idle tracking
> > feature which uses virtual address indexing.
> > 
> > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > ---
> >  .../admin-guide/mm/idle_page_tracking.rst     | 43 ++++++++++++++++---
> >  1 file changed, 36 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/idle_page_tracking.rst b/Documentation/admin-guide/mm/idle_page_tracking.rst
> > index df9394fb39c2..1eeac78c94a7 100644
> > --- a/Documentation/admin-guide/mm/idle_page_tracking.rst
> > +++ b/Documentation/admin-guide/mm/idle_page_tracking.rst
> > @@ -19,10 +19,14 @@ It is enabled by CONFIG_IDLE_PAGE_TRACKING=y.
> >  
> >  User API
> >  ========
> > +There are 2 ways to access the idle page tracking API. One uses physical
> > +address indexing, another uses a simpler virtual address indexing scheme.
> >  
> > -The idle page tracking API is located at ``/sys/kernel/mm/page_idle``.
> > -Currently, it consists of the only read-write file,
> > -``/sys/kernel/mm/page_idle/bitmap``.
> > +Physical address indexing
> > +-------------------------
> > +The idle page tracking API for physical address indexing using page frame
> > +numbers (PFN) is located at ``/sys/kernel/mm/page_idle``.  Currently, it
> > +consists of the only read-write file, ``/sys/kernel/mm/page_idle/bitmap``.
> >  
> >  The file implements a bitmap where each bit corresponds to a memory page. The
> >  bitmap is represented by an array of 8-byte integers, and the page at PFN #i is
> > @@ -74,6 +78,31 @@ See :ref:`Documentation/admin-guide/mm/pagemap.rst <pagemap>` for more
> >  information about ``/proc/pid/pagemap``, ``/proc/kpageflags``, and
> >  ``/proc/kpagecgroup``.
> >  
> > +Virtual address indexing
> > +------------------------
> > +The idle page tracking API for virtual address indexing using virtual page
> > +frame numbers (VFN) is located at ``/proc/<pid>/page_idle``. It is a bitmap
> > +that follows the same semantics as ``/sys/kernel/mm/page_idle/bitmap``
> > +except that it uses virtual instead of physical frame numbers.
> > +
> > +This idle page tracking API does not need deal with PFN so it does not require
> 
> s/need//
> 
> > +prior lookups of ``pagemap`` in order to find if page is idle or not. This is
> 
> s/in order to find if page is idle or not//

Fixed both, thank you! Will send out update soon.

thanks,

 - Joel
