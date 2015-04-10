From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 03/21] Drivers: hv: kvp: move poll_channel() to
 hyperv_vmbus.h
Date: Fri, 10 Apr 2015 21:27:42 +0300
Message-ID: <20150410182742.GQ10964@mwanda>
References: <1428568730-6030-1-git-send-email-vkuznets@redhat.com>
 <1428568730-6030-4-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1428568730-6030-4-git-send-email-vkuznets@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Radim Krcmar <rkrcmar@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, devel@linuxdriverproject.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 09, 2015 at 10:38:32AM +0200, Vitaly Kuznetsov wrote:
> ..., make it inline and rename it to hv_poll_channel() so it can be reused
> in other hv_util modules.
> 

The "...," is fine in the git log but I noticed recently that if you're
reading patches in a web archive then often the subject and the body are
several lines apart.

http://marc.info/?l=linux-api&m=142856917031730&w=2

It's awkward to follow.

regards,
dan carpenter
