From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] implementing tape statistics single file vs multi-file in
 sysfs
Date: Fri, 6 Feb 2015 05:01:11 -0800
Message-ID: <20150206130111.GC26247@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3BF3EADA@G9W0766.americas.hpqcorp.net>
 <20150206091354.GA1143@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150206091354.GA1143-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Bryn M. Reeves" <bmr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org" <Kai.Makisara-9Aww8k/80nUxHbG02/KK1g@public.gmane.org>, "James E.J. Bottomley (JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org)" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Laurence Oberman (loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Feb 06, 2015 at 09:13:55AM +0000, Bryn M. Reeves wrote:
> > The sysfs documentation says that files should contain one item per
> > file (with some small exceptions):
> > 
> > > "Attributes should be ASCII text files, preferably with only one value
> > > per file. It is noted that it may not be efficient to contain only one
> > > value per file, so it is socially acceptable to express an array of
> > > values of the same type."
> 
> Right: I think there's good precedent for the array file style when
> dealing with counter sets.

See my previous reply for why I strongly feel this is incorrect, sorry.

greg k-h
