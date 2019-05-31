From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFCv2 6/6] mm: extend process_madvise syscall to support vector
 arrary
Date: Sat, 1 Jun 2019 08:18:59 +0900
Message-ID: <20190531231859.GB248371@google.com>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-7-minchan@kernel.org>
 <2fd5d462449f24b04adad2bbdf0e272647e62247.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2fd5d462449f24b04adad2bbdf0e272647e62247.camel@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

Hi Yann,

On Fri, May 31, 2019 at 12:06:52PM +0200, Yann Droneaud wrote:
> Hi,
> 
> Le vendredi 31 mai 2019 à 15:43 +0900, Minchan Kim a écrit :
> > 
> > diff --git a/include/uapi/asm-generic/mman-common.h
> > b/include/uapi/asm-generic/mman-common.h
> > index 92e347a89ddc..220c2b5eb961 100644
> > --- a/include/uapi/asm-generic/mman-common.h
> > +++ b/include/uapi/asm-generic/mman-common.h
> > @@ -75,4 +75,15 @@
> >  #define PKEY_ACCESS_MASK	(PKEY_DISABLE_ACCESS |\
> >  				 PKEY_DISABLE_WRITE)
> >  
> > +struct pr_madvise_param {
> > +	int size;		/* the size of this structure */
> > +	int cookie;		/* reserved to support atomicity */
> > +	int nr_elem;		/* count of below arrary fields */
> 
> Those should be unsigned.
> 
> There's an implicit hole here on ABI with 64bits aligned pointers
> 
> > +	int __user *hints;	/* hints for each range */
> > +	/* to store result of each operation */
> > +	const struct iovec __user *results;
> > +	/* input address ranges */
> > +	const struct iovec __user *ranges;
> 
> Using pointer type in uAPI structure require a 'compat' version of the
> syscall need to be provided.
> 
> If using iovec too.

I will fix them when I submit next revision.
Thanks for the review.
