From: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Subject: Re: [PATCH v06 04/36] uapi scsi/scsi_netlink_fc.h: use __u16, __u32
 and __u64 from linux/types.h
Date: Sun, 6 Aug 2017 23:42:24 +0300
Message-ID: <20170806204224.GE28459@lakka.kapsi.fi>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-5-mikko.rapeli@iki.fi>
 <1502043773.2673.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502043773.2673.9.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

On Sun, Aug 06, 2017 at 11:22:53AM -0700, James Bottomley wrote:
> On Sun, 2017-08-06 at 18:43 +0200, Mikko Rapeli wrote:
> > Fixes userspace compilation errors like:
> > 
> > scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-list 
> > before ‘uint64_t’
> 
> Rather than patching the kernel, why not #include <stdint.h> in your
> userspace programme?

The userspace program is actually a test which checks that uapi headers
compile alone because several headers are not compiling at all and/or
require special tricks. The test is available here:

http://marc.info/?l=linux-kernel&m=150203944104544&w=2

I have tried that approach before but then:

https://lkml.org/lkml/2015/6/1/160

For some subsystems like fuse the above message was not enough and they
are including stdint.h in userspace. What shall we do with this old
scsi header file?

-Mikko
