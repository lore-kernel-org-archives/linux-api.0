From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: dpt: remove i2o header in uapi
Date: Sun, 04 Oct 2015 21:04:37 +0200
Message-ID: <9360762.QKG8Z6HBYY@wuerfel>
References: <1443712510-6714-1-git-send-email-gabriel@lse.epita.fr> <1443914571-19312-1-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1443914571-19312-1-git-send-email-gabriel@lse.epita.fr>
Sender: linux-scsi-owner@vger.kernel.org
To: Gabriel Laskar <gabriel@lse.epita.fr>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "David S. Miller" <davem@davemloft.net>, Hans Verkuil <hans.verkuil@cisco.com>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Masahiro Yamada <yamada.m@jp.panasonic.com>, stephen hemminger <stephen@networkplumber.org>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, "open list:DPT_I2O SCSI RAID DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:ABI/API" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Sunday 04 October 2015 01:22:50 Gabriel Laskar wrote:
> The i2o subsystem was removed by
> commit 4a72a7af462d ("staging: remove i2o subsystem") but the header was
> still used by drivers/scsi/dpt_i2o.c driver.
> 
> This patch moves the structures used from the header into dpti_i2o.h.
> 
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Gabriel Laskar <gabriel@lse.epita.fr>
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
