From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: android: binder: move to the "real" part of the
 kernel
Date: Fri, 17 Oct 2014 12:26:01 +0300
Message-ID: <20141017092601.GH23154@mwanda>
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
Cc: devel@driverdev.osuosl.org, Anup Patel <anup.patel@linaro.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, John Stultz <john.stultz@linaro.org>, Rebecca Schultz Zavin <rebecca@android.com>, Santosh Shilimkar <santosh.shilimkar@ti.com>, Sumit Semwal <sumit.semwal@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: linux-api@vger.kernel.org

The code isn't very beautiful and there are lots of details wrong like
the error codes.

Al had some critical things to say about it but it looks like most of
those issues have been fixed.

regards,
dan carpenter
