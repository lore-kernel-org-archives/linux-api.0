From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] drivers/firewire: fix use/leak of uninitialized stack
	memory in dispatch_ioctl()
Date: Tue, 11 Nov 2014 17:13:56 +0100
Message-ID: <20141111171356.2fc62440@kant>
References: <55D28623-C1C7-47D2-9638-0B8FD0733C48@stanford.edu>
	<20141111010340.3329bbd7@kant> <20141111130143.2ff3d42e@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20141111130143.2ff3d42e@kant>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, David Ramos <daramos@stanford.edu>
List-Id: linux-api@vger.kernel.org

Adding Cc: linux-api and lkml, quoting parent message in full

On Nov 11 Stefan Richter wrote:
> On Nov 11 Stefan Richter wrote:
> > On Nov 10 David Ramos wrote:
> > > This patch fixes an uninitialized memory use/leak bug discovered
> > > by our UC-KLEE tool in the 3.16.3 kernel.
> > 
> > There is uninitialized memory use, but no leak.
> 
> Actually there could be leaks too.  If later fw_cdev_event_ are
> generated, they will contain the __u64 closure field that many of the
> ioctl argument structures contain.
> 
> > [...]
> > > If a user carefully crafts an ioctl command such that _IOC_DIR(cmd)
> > > == 0, 'buffer' is left uninitialized. Each of the ioctl_handlers then
> > > accesses the pre-existing stack values, which will cause unpredictable
> > > behavior.
> > 
> > Not all (but indeed almost all) ioctl handlers will use uninitialized
> > memory in that case.  The damage should be marginal though, because all of
> > these handlers must implement sufficient arguments checking anyway.
> > 
> > > This patch checks for an invalid cmd and rejects it with -ENOTTY.
> > 
> > This is not exactly what your patch does.  Rather...
> > 
> > > --- a/drivers/firewire/core-cdev.c
> > > +++ b/drivers/firewire/core-cdev.c
> > > @@ -1632,7 +1632,8 @@ static int dispatch_ioctl(struct client *client,
> > >  	if (fw_device_is_shutdown(client->device))
> > >  		return -ENODEV;
> > >  
> > > -	if (_IOC_TYPE(cmd) != '#' ||
> > > +	if (_IOC_DIR(cmd) == _IOC_NONE ||
> > > +	    _IOC_TYPE(cmd) != '#' ||
> > >  	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
> > >  	    _IOC_SIZE(cmd) > sizeof(buffer))
> > >  		return -ENOTTY;
> > 
> > ...it quits *all* _IOC_NONE ioctls with -ENOTTY, not just invalid ones.
> > If you have a look at the ABI definition in
> > include/uapi/linux/firewire-cdev.h, you will notice that this approach is
> > insufficient.
> 
> I suppose we should add checks
>   1. for _IOC_DIR matching the expected direction depending on _IOC_NR
>      (or at least for presence of _IOC_WRITE when expected), and
>   2. for _IOC_SIZE being at least as big as the minimum unaligned argument
>      size depending on _IOC_NR (at least in case of
>      _IOC_DIR(cmd) & _IOC_WRITE).
> 
> BTW, I don't think it is worthwhile to check for upper bounds of _IOC_SIZE
> besides the present check against sizeof(buffer), since the precise size of
> arguments depends on structure alignment of the user code and on ABI
> version.

I will follow up with two alternative patches for discussion; either one
should fix the issue but they differ in complexity and runtime cost:
    [PATCH RFC v1a] firewire: cdev: prevent kernel stack leaking into ioctl arguments
    [PATCH RFC v1b] firewire: cdev: prevent kernel stack leaking into ioctl arguments
If I receive no feedback to the contrary, I will probably submit patch v1b
to upstream, which is the simpler one of the two.
-- 
Stefan Richter
-=====-====- =-== -=-==
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Comprehensive Server Monitoring with Site24x7.
Monitor 10 servers for $9/Month.
Get alerted through email, SMS, voice calls or mobile push notifications.
Take corrective actions from your mobile device.
http://pubads.g.doubleclick.net/gampad/clk?id=154624111&iu=/4140/ostg.clktrk
