From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Mon, 6 Nov 2017 15:46:50 +0100
Message-ID: <20171106144650.GA8743@kroah.com>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
 <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
 <20171102104407.GA14048@kroah.com>
 <20171102111019.kpsvobvzfiezdndp@sirena.co.uk>
 <CA+M3ks5pV=j_DeQ9ohhtv62WL=pzWH0Q5jdKtQby5vs=NUZT-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+M3ks5pV=j_DeQ9ohhtv62WL=pzWH0Q5jdKtQby5vs=NUZT-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Riley Andrews <riandrews-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, driverdevel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, Nov 06, 2017 at 03:42:04PM +0100, Benjamin Gaignard wrote:
> 2017-11-02 12:10 GMT+01:00 Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > On Thu, Nov 02, 2017 at 11:44:07AM +0100, Greg KH wrote:
> >> On Tue, Oct 31, 2017 at 07:11:53PM +0000, Mark Brown wrote:
> >
> >> > There was a discussion a while ago in the context of I2C/SPI MFDs
> >> > which concluded that if you need a bus and it's going to be effectively
> >> > noop then you should just use the platform bus as anything else will
> >> > consist almost entirely of cut'n'paste from the platform bus with some
> >> > light sed usage and code duplication is bad.  It's not super lovely as
> >> > it's not actually a memory mapped device but it's the best idea we've
> >> > got.
> >
> >> Ugh, I hate that.  What's wrong with using a "virtual" device instead?
> >
> > It was the duplication, initially everyone was making buses.
> >
> >> I can create a "virtual" bus for things like this if they really want a
> >> "simple" bus, abusing platform for this is the major reason I hate the
> >> platform bus code...
> >
> > In the MFD case they're physical devices, they're just usually on the
> > wrong side of an I2C or SPI link.  Plus MFD already handles platform
> > devices for things that are memory mapped so it's a bit of a more
> > natural fit there.
> 
> What I can do is to register an ion bus (like cec one for example),
> add one ion parent device so heaps will appear in /sys/bus/ion/ion*
> and /sys/devices/ion/ion*
> 
> Does that could sound good enough ?

I would like to see that...

thanks,

greg k-h
