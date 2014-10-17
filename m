From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Fri, 17 Oct 2014 02:43:29 -0700
Message-ID: <20141017094329.GB18015@infradead.org>
References: <20141016124741.GA3832@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141016124741.GA3832@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arve Hj?nnev?g <arve@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Rebecca Schultz Zavin <rebecca@android.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Thu, Oct 16, 2014 at 02:47:41PM +0200, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The Android binder code has been "stable" for many years now.  No matter
> what comes in the future, we are going to have to support this API, so
> might as well move it to the "real" part of the kernel as there's no
> real work that needs to be done to the existing code.

NAK.  It's complete rubbish and does things to the FD code that it
really shouldn't.  Android needs to completely redo the interface, and
there's been absolutely no work towards that.

This is exactly the sort of attitude I feared about when you started the
whole staging concepts, and it sounds like a good reason to disband
staging entirely, given that it's been mostly useless except for
boasting peoples commit statistics.
