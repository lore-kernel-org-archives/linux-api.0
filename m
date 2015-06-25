From: "Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> (gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org)"
	<gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] sysfs.txt: update show method notes about
 sprintf/snprintf/scnprintf usage
Date: Wed, 24 Jun 2015 23:03:05 -0700
Message-ID: <20150625060305.GA11905@kroah.com>
References: <DDB9C85B850785449757F9914A034FCB3F8EA364@G4W3219.americas.hpqcorp.net>
 <20150625015957.GB3365@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150625015957.GB3365@swordfish>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Seymour, Shane M" <shane.seymour-VXdhtT5mjnY@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 25, 2015 at 10:59:57AM +0900, Sergey Senozhatsky wrote:
> On (06/25/15 00:55), Seymour, Shane M wrote:
> > Changed the documentation to allow sprintf() for small
> > single values and explicitly say snprintf() must never be used in
> > a show function to format data to be returned to user space.
> > 
> > Change based on a discussion about the patch
> > st: convert DRIVER_ATTR macros to DRIVER_ATTR_RO
> > 
> > Suggested-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > Signed-off-by: Shane Seymour <shane.seymour-VXdhtT5mjnY@public.gmane.org>
> > ---
> > --- a/Documentation/filesystems/sysfs.txt	2015-06-22 14:18:40.278620871 -0500
> > +++ b/Documentation/filesystems/sysfs.txt	2015-06-24 13:42:21.344446532 -0500
> > @@ -212,7 +212,9 @@ Other notes:
> >  - show() methods should return the number of bytes printed into the
> >    buffer. This is the return value of scnprintf().
> >  
> > -- show() should always use scnprintf().
> > +- show() must not use snprintf() when formatting a value to be
> > +  returned to user space. For small single values you can use
> > +  sprintf() otherwise you must use scnprintf().
> 
> Well, a single value can easily overflow
> 
> 	sprintf(buf, "%s", dev->large_value);

That's an obviously foolish sysfs attribute, if you do that, you deserve
the kernel crash :)

> Probably the wording better be "if you guarantee that overflow will
> never happen, then you can use ...".

For a document that no one has obviously read in the past 5 years, I
really doubt we need to work too hard on the exact specific wording of
it.

thanks,

greg k-h
