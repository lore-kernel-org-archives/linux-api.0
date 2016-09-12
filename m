From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 13:33:44 -0700
Message-ID: <20160912203344.GB2516@roeck-us.net>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
 <57D70B6D.6010208@linux.intel.com>
 <3540553.8BkpiafJJ2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3540553.8BkpiafJJ2@wuerfel>
Sender: linux-arch-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Sep 12, 2016 at 10:28:56PM +0200, Arnd Bergmann wrote:
> On Monday, September 12, 2016 1:09:17 PM CEST Dave Hansen wrote:
> > 
> > So, I've done what Arnd suggested, but I don't have a working
> > cross-compiler than can do h8300 or c6x.  Could you test the attached
> > patch and see if it gets things working for you?
> > 
> > Also, do you have a handy place to grab a cross-compiler for h8300
> > without having to build one?  The kernel.org ones don't seem to work for
> > h8300.
> > 
> 
> I haven't tested it, but it looks good to me
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> FWIW, you should be able to test this with an arm64 cross-compiler
> too, many distros ship one.
> 
arm64 builds fine, though, even w/o this patch (at least for me).

Guenter
