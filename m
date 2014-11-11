From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFC v1b] firewire: cdev: prevent kernel stack leaking into
	ioctl arguments
Date: Tue, 11 Nov 2014 17:16:44 +0100
Message-ID: <20141111171644.7f6b17c7@kant>
References: <55D28623-C1C7-47D2-9638-0B8FD0733C48@stanford.edu>
	<20141111010340.3329bbd7@kant> <20141111130143.2ff3d42e@kant>
	<20141111171356.2fc62440@kant>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20141111171356.2fc62440@kant>
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

Found by the UC-KLEE tool:  A user could supply less input to
firewire-cdev ioctls than write- or write/read-type ioctl handlers
expect.  The handlers used data from uninitialized kernel stack then.

This could partially leak back to the user if the kernel subsequently
generated fw_cdev_event_'s (to be read from the firewire-cdev fd)
which notably would contain the _u64 closure field which many of the
ioctl argument structures contain.

The fact that the handlers would act on random garbage input is a
lesser issue since all handlers must check their input anyway.

Remarks:
  - There was never any leak from kernel stack to the ioctl output
    buffer itself.  IOW, it was not possible to read kernel stack by a
    read-type or write/read-type ioctl alone; the leak could at most
    happen in combination with read()ing subsequent event data.
  - The affected character device file interface is specified in
    include/uapi/linux/firewire-cdev.h.  An overview is given in
    Documentation/ABI/stable/firewire-cdev.

This fix simply always null-initializes the entire ioctl argument buffer
regardless of the actual length of expected user input.  That is, a
runtime overhead of memset(..., 40) is added to each firewirew-cdev
ioctl() call.

Reported-by: David Ramos <daramos@stanford.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1625,32 +1625,31 @@ static int (* const ioctl_handlers[])(st
 
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
 	union ioctl_arg buffer;
 	int ret;
 
 	if (fw_device_is_shutdown(client->device))
 		return -ENODEV;
 
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
 	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) == _IOC_READ)
-		memset(&buffer, 0, _IOC_SIZE(cmd));
+	memset(&buffer, 0, sizeof(buffer));
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
 	if (ret < 0)
 		return ret;
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
 		if (copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
 
 	return ret;
 }


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
