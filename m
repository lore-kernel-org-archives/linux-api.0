From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v06 04/36] uapi scsi/scsi_netlink_fc.h: use __u16, __u32
 and __u64 from linux/types.h
Date: Sun, 06 Aug 2017 15:09:21 -0700
Message-ID: <1502057361.2673.21.camel@HansenPartnership.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
         <20170806164428.2273-5-mikko.rapeli@iki.fi>
         <1502043773.2673.9.camel@HansenPartnership.com>
         <20170806204224.GE28459@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20170806204224.GE28459@lakka.kapsi.fi>
Sender: linux-scsi-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 2017-08-06 at 23:42 +0300, Mikko Rapeli wrote:
> Hi,
> 
> On Sun, Aug 06, 2017 at 11:22:53AM -0700, James Bottomley wrote:
> > 
> > On Sun, 2017-08-06 at 18:43 +0200, Mikko Rapeli wrote:
> > > 
> > > Fixes userspace compilation errors like:
> > > 
> > > scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-
> > > list  before ‘uint64_t’
> > 
> > Rather than patching the kernel, why not #include <stdint.h> in
> > your userspace programme?
> 
> The userspace program is actually a test which checks that uapi
> headers compile alone because several headers are not compiling at
> all and/or require special tricks. The test is available here:
> 
> http://marc.info/?l=linux-kernel&m=150203944104544&w=2

But you don't seem to be detecting or fixing an existing problem.
 These types are width unambiguous and all current consumers of these
headers include stdint.h so you're churning the kernel for a problem
which doesn't currently exist for any consumer of this header.

I can agree not adding any more external uint<x>_t types for newly
exported headers so new consumers don't depend on an external standard
is reasonable, so checkpatch should warn if someone tries to add them;
I just don't see the benefit of going over the whole kernel changing
stuff that has worked fine for years.  Now if you can tell me there's
an actual bug somewhere, that's different ...

James
