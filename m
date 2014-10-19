From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Mon, 20 Oct 2014 06:05:47 +0800
Message-ID: <20141019220547.GC3780@kroah.com>
References: <20141016124741.GA3832@kroah.com> <20141017092601.GH23154@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20141017092601.GH23154@mwanda>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, John Stultz <john.stultz@linaro.org>, Rebecca Schultz Zavin <rebecca@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 17, 2014 at 12:26:01PM +0300, Dan Carpenter wrote:
> The code isn't very beautiful and there are lots of details wrong like
> the error codes.

Really, what is wrong with the existing error code usages?

> Al had some critical things to say about it but it looks like most of
> those issues have been fixed.

All of the ones that can be fixed, have, as far as I know.

We are stuck with some that we can't fix, which is ok as it is safe in
the Android user model.

thanks,

greg k-h
