From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v06 04/36] uapi scsi/scsi_netlink_fc.h: use __u16, __u32
 and __u64 from linux/types.h
Date: Sun, 06 Aug 2017 11:22:53 -0700
Message-ID: <1502043773.2673.9.camel@HansenPartnership.com>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
         <20170806164428.2273-5-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-5-mikko.rapeli@iki.fi>
Sender: linux-scsi-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sun, 2017-08-06 at 18:43 +0200, Mikko Rapeli wrote:
> Fixes userspace compilation errors like:
> 
> scsi/scsi_netlink_fc.h:60:2: error: expected specifier-qualifier-list 
> before ‘uint64_t’

Rather than patching the kernel, why not #include <stdint.h> in your
userspace programme?

James
