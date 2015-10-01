From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] uapi: remove i2o header in uapi
Date: Thu, 01 Oct 2015 22:42:10 +0200
Message-ID: <3240889.KGmTvmSXsC@wuerfel>
References: <201510012318.Evg0jdR9%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201510012318.Evg0jdR9%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 01 October 2015 23:56:54 kbuild test robot wrote:
> Hi Gabriel,
> 
> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
> 
> config: x86_64-acpi-redef (attached as .config)
> reproduce:
>         git checkout e8edc215dd1ecc5508a7dbcd62d3f2fed6be299c
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from drivers/scsi/dpti.h:56:0,
>                     from drivers/scsi/dpt_i2o.c:71:
> >> drivers/scsi/dpt/dpti_i2o.h:22:27: fatal error: linux/i2o-dev.h: No such file or directory
>    compilation terminated.
> 
> vim +22 drivers/scsi/dpt/dpti_i2o.h

I tried to find out why this driver is still there when the subsystem is gone.
According to information from https://bugzilla.kernel.org/show_bug.cgi?id=4940,
this is an alternative driver for the same hardware (the bug was about loading
both drivers simultaneously).

The proper fix should be to move the header file into drivers/scsi/dpt/ and
remove everything that this driver does not use, at least the ioctl interface,
but possibly all of the file.

	Arnd
