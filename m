From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v6 2/2] staging: ion: create one device entry per heap
Date: Thu, 2 Nov 2017 11:44:07 +0100
Message-ID: <20171102104407.GA14048@kroah.com>
References: <1508774137-13835-1-git-send-email-benjamin.gaignard@linaro.org>
 <1508774137-13835-3-git-send-email-benjamin.gaignard@linaro.org>
 <3e3af8e3-76c5-754c-caaa-3f8c9b54723f@redhat.com>
 <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171031191153.avolosp6n5gb3xao@sirena.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Brown <broonie@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>, Benjamin Gaignard <benjamin.gaignard@linaro.org>, sumit.semwal@linaro.org, arve@android.com, riandrews@android.com, dan.carpenter@oracle.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 31, 2017 at 07:11:53PM +0000, Mark Brown wrote:
> On Tue, Oct 31, 2017 at 12:03:35PM -0700, Laura Abbott wrote:
> 
> > I'm not a fan of the platform bus but I have mixed feelings about
> > creating a dedicated bus type. I guess if we really need a bus
> > type we can do it later?
> 
> There was a discussion a while ago in the context of I2C/SPI MFDs
> which concluded that if you need a bus and it's going to be effectively
> noop then you should just use the platform bus as anything else will
> consist almost entirely of cut'n'paste from the platform bus with some
> light sed usage and code duplication is bad.  It's not super lovely as
> it's not actually a memory mapped device but it's the best idea we've
> got.

Ugh, I hate that.  What's wrong with using a "virtual" device instead?

I can create a "virtual" bus for things like this if they really want a
"simple" bus, abusing platform for this is the major reason I hate the
platform bus code...

thanks,

greg k-h
