From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Build failures in -next: sys_pkey_mprotect etc. undefined
Date: Mon, 12 Sep 2016 13:32:29 -0700
Message-ID: <20160912203229.GA2516@roeck-us.net>
References: <9d74497b-1522-b350-42fa-49df2df48c4a@roeck-us.net>
 <57D70B6D.6010208@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57D70B6D.6010208@linux.intel.com>
Sender: linux-arch-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Dave,

On Mon, Sep 12, 2016 at 01:09:17PM -0700, Dave Hansen wrote:
> On 09/12/2016 07:55 AM, Guenter Roeck wrote:
> > Building h8300:allnoconfig ... failed
> > Building h8300:h8300h-sim_defconfig ... failed
> > Building c6x:dsk6455_defconfig ... failed
> > 
> > [ and more builds for the same architectures ]
> > 
> > --------------
> > Error log:
> > arch/h8300/kernel/built-in.o:(.data+0x480): undefined reference to
> > `sys_pkey_mprotect'
> > arch/h8300/kernel/built-in.o:(.data+0x484): undefined reference to
> > `sys_pkey_alloc'
> > arch/h8300/kernel/built-in.o:(.data+0x488): undefined reference to
> > `sys_pkey_free'
> 
> So, I've done what Arnd suggested, but I don't have a working
> cross-compiler than can do h8300 or c6x.  Could you test the attached
> patch and see if it gets things working for you?
> 
Works for both h8300 and c6x. Feel free to add

Tested-by: Guenter Roeck <linux@roeck-us.net>

> Also, do you have a handy place to grab a cross-compiler for h8300
> without having to build one?  The kernel.org ones don't seem to work for
> h8300.
> 
Try http://server.roeck-us.net/toolchains/. Should be position independent.

Guenter
