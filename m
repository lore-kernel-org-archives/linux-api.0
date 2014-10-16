From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Fri, 17 Oct 2014 01:14:57 +0200
Message-ID: <20141016231457.GB13592@kroah.com>
References: <20141016124741.GA3832@kroah.com>
 <CAKgNAkiPg8G13XZXG6CiaBFZ1yqY2J7_OAppDOGweuNpRaojuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkiPg8G13XZXG6CiaBFZ1yqY2J7_OAppDOGweuNpRaojuA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rebecca Schultz Zavin <rebecca@android.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 16, 2014 at 04:18:02PM +0200, Michael Kerrisk (man-pages) wrote:
> On Thu, Oct 16, 2014 at 2:47 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > The Android binder code has been "stable" for many years now.  No matter
> > what comes in the future, we are going to have to support this API, so
> > might as well move it to the "real" part of the kernel as there's no
> > real work that needs to be done to the existing code.
> 
> Where does one find the canonical documentation of the user-space API?

There really is only one "canonical" thing, and that is in the libbinder
code in the Android userspace repository.  And it's not really
"documentation" so much as, "a C file that interacts with the ioctls in
the binder kernel code" :(

Think of this as just a random character driver with some funny ioctls
that will never get really documented as there is only one user of it.

sorry,

greg k-h
