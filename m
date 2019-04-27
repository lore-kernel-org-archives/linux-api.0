From: Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH v10 00/18] Introduce the Counter subsystem
Date: Sat, 27 Apr 2019 12:49:36 +0100
Message-ID: <20190427124937.1a9920ea@archlinux>
References: <cover.1554184734.git.vilhelm.gray@gmail.com>
        <20190407152550.451a7f63@archlinux>
        <20190425193624.GA11240@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190425193624.GA11240@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: William Breathitt Gray <vilhelm.gray@gmail.com>, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, fabrice.gasnier@st.com, benjamin.gaignard@st.com, knaack.h@gmx.de, lars@metafoo.de, pmeerw@pmeerw.net, akpm@linux-foundation.org, david@lechnology.com, robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org, leoyang.li@nxp.com, daniel.lezcano@linaro.org, tglx@linutronix.de, thierry.reding@gmail.com, esben@haabendal.dk, linux-pwm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, patrick.havelange@essensium.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, 25 Apr 2019 21:36:24 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Sun, Apr 07, 2019 at 03:25:50PM +0100, Jonathan Cameron wrote:
> > On Tue,  2 Apr 2019 15:30:35 +0900
> > William Breathitt Gray <vilhelm.gray@gmail.com> wrote:
> >   
> > > Changes in v10:
> > >   - Fix minor typographical errors in documentation
> > >   - Merge the FlexTimer Module Quadrature decoder counter driver patches
> > > 
> > > This revision is functionally identical to the last; changes in this
> > > version were made to fix minor typos in the documentation files and also
> > > to pull in the new FTM quadrature decoder counter driver.
> > > 
> > > The Generic Counter API has been and is still in a feature freeze until
> > > it is merged into the mainline. The following features will be
> > > investigated after the merge: interrupt support for counter devices, and
> > > a character device interface for low-latency applications.  
> > 
> > Hi William / al,
> > 
> > So the question is how to move this forwards?  I'm happy with how it turned
> > out and the existing drivers we had in IIO are a lot cleaner under
> > the counter subsystem (other than the backwards compatibility for those that
> > ever existed in IIO).  For those  not following closely the situation is:  
> 
> I've now sucked this into my staging-testing branch and if 0-day is fine
> with it, I'll merge it to staging-next in a day or so.  This way you can
> build on it for any iio drivers that might be coming.

Great thanks. 

> 
> I do have reservations about that one sysfs file that is multi-line, and
> I think it will come to bite you in the end over time, so I reserve the
> right to say "I told you so" when that happens...
> 
> But, I don't have a better answer for it now, so don't really worry
> about it :)
> 
> thanks,
> 
> greg k-h

Looks like a few late breaking comments came in, but nothing that can't
be fixed up before this reaches a release.

Thanks,

Jonathan
