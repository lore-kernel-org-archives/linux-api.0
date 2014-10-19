From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Mon, 20 Oct 2014 06:04:50 +0800
Message-ID: <20141019220450.GB3780@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <20141017094329.GB18015@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141017094329.GB18015@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arve Hj?nnev?g <arve@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rebecca Schultz Zavin <rebecca@android.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 17, 2014 at 02:43:29AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 16, 2014 at 02:47:41PM +0200, Greg Kroah-Hartman wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > The Android binder code has been "stable" for many years now.  No matter
> > what comes in the future, we are going to have to support this API, so
> > might as well move it to the "real" part of the kernel as there's no
> > real work that needs to be done to the existing code.
> 
> NAK.  It's complete rubbish and does things to the FD code that it
> really shouldn't.  Android needs to completely redo the interface, and
> there's been absolutely no work towards that.

There is now work to resolve the interface, it requires someone who has
the rights to push to Android userspace.  But that is going to be a
"total rewrite", and until then, this code needs to be used, no matter
how much we hate this.

> This is exactly the sort of attitude I feared about when you started the
> whole staging concepts, and it sounds like a good reason to disband
> staging entirely, given that it's been mostly useless except for
> boasting peoples commit statistics.

I know you hate staging, which is fine, it's not there for you.  It's
there for others, and so much good stuff has happened with it, that I'm
not going to give it up.

But this code is different.  It's something like a random driver that a
distro has been carrying for 5+ years that it has to ship due to
userspace that relies on it, so the api can't be changed.  We accept
drivers like that at times, and we don't drop really old and crappy
drivers either, as long as someone is using it, and it is
self-contained.

I'll step up to maintain this and handle the interactions between grumpy
kernel developers who look at the code, and the Android developers who
are stuck with this monstrosity.

thanks,

greg k-h
