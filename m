From: Dennis Zhou <dennisszhou@gmail.com>
Subject: Re: [PATCH] proc: add percpu populated pages count to meminfo
Date: Tue, 7 Aug 2018 08:03:16 -0700
Message-ID: <20180807150315.GA59704@dennisz-mbp.dhcp.thefacebook.com>
References: <20180807005607.53950-1-dennisszhou@gmail.com>
 <3b792413-184b-20b1-9d90-9e69f0df8cc4@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3b792413-184b-20b1-9d90-9e69f0df8cc4@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Roman Gushchin <guro@fb.com>, kernel-team@fb.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Vlastimil,

On Tue, Aug 07, 2018 at 03:18:31PM +0200, Vlastimil Babka wrote:
> 
> Documentation/filesystems/proc.txt should be updated as well
> 

Will do.

> >  
> > +/*
> > + * The number of populated pages in use by the allocator, protected by
> > + * pcpu_lock.  This number is kept per a unit per chunk (i.e. when a page gets
> > + * allocated/deallocated, it is allocated/deallocated in all units of a chunk
> > + * and increments/decrements this count by 1).
> > + */
> > +static int pcpu_nr_populated;
> 
> It better be unsigned long, to match others.
> 

Yeah that makes sense. I've changed this for v2.

> > +/*
> > + * pcpu_nr_populated_pages - calculate total number of populated backing pages
> > + *
> > + * This reflects the number of pages populated to back the chunks.
> > + * Metadata is excluded in the number exposed in meminfo as the number of
> > + * backing pages scales with the number of cpus and can quickly outweigh the
> > + * memory used for metadata.  It also keeps this calculation nice and simple.
> > + *
> > + * RETURNS:
> > + * Total number of populated backing pages in use by the allocator.
> > + */
> > +int pcpu_nr_populated_pages(void)
> 
> Also unsigned long please.
> 

Changed for v2.

Thanks,
Dennis
