From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon, 27 Nov 2017 12:43:57 +0100
Message-ID: <20171127114357.GB3710@kroah.com>
References: <1509983985-20950-1-git-send-email-benjamin.gaignard@linaro.org>
 <1509983985-20950-3-git-send-email-benjamin.gaignard@linaro.org>
 <1e7fc718-825c-1028-1c28-a75a7320103f@redhat.com>
 <CA+M3ks6vP+W77QBzbczxzcV7YZCoBusC=wgjZPUNLrCYFFDARA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+M3ks6vP+W77QBzbczxzcV7YZCoBusC=wgjZPUNLrCYFFDARA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 27, 2017 at 11:46:18AM +0100, Benjamin Gaignard wrote:
> 2017-11-09 22:17 GMT+01:00 Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On 11/06/2017 07:59 AM, Benjamin Gaignard wrote:
> >>
> >> Instead a getting only one common device "/dev/ion" for
> >> all the heaps this patch allow to create one device
> >> entry ("/dev/ionX") per heap.
> >> Getting an entry per heap could allow to set security rules
> >> per heap and global ones for all heaps.
> >>
> >> Allocation requests will be only allowed if the mask_id
> >> match with device minor.
> >> Query request could be done on any of the devices.
> >>
> >
> > With this patch, sysfs looks like:
> >
> > $ ls /sys/devices/
> > breakpoint ion platform software system virtual
> >
> > From an Ion perspective, you can have
> >
> > Acked-by: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > Another Ack for the device model stuff would be good but I'll
> > assume deafening silence means nobody hates it.
> 
> Greg, can we get your point of view of this ?

It's 1 day after the merge window has closed, and my todo patch queue
looks like this:
	$ mdfrm -c ~/mail/todo/
	1523 messages in /home/gregkh/mail/todo/

Please give me a chance to catch up...

greg k-h
