From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH RFC v1a] firewire: cdev: prevent kernel stack leaking into
	ioctl arguments
Date: Tue, 11 Nov 2014 17:15:26 +0100
Message-ID: <20141111171526.6e2a2b18@kant>
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

This fix uses a lookup table to verify that all ioctl input fields are
indeed written by the user.  Else the ioctl fails with -EINVAL.

Reported-by: David Ramos <daramos@stanford.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1609,48 +1609,81 @@ static int (* const ioctl_handlers[])(st
 	[0x0a] = ioctl_start_iso,
 	[0x0b] = ioctl_stop_iso,
 	[0x0c] = ioctl_get_cycle_timer,
 	[0x0d] = ioctl_allocate_iso_resource,
 	[0x0e] = ioctl_deallocate_iso_resource,
 	[0x0f] = ioctl_allocate_iso_resource_once,
 	[0x10] = ioctl_deallocate_iso_resource_once,
 	[0x11] = ioctl_get_speed,
 	[0x12] = ioctl_send_broadcast_request,
 	[0x13] = ioctl_send_stream_packet,
 	[0x14] = ioctl_get_cycle_timer2,
 	[0x15] = ioctl_send_phy_packet,
 	[0x16] = ioctl_receive_phy_packets,
 	[0x17] = ioctl_set_iso_channels,
 	[0x18] = ioctl_flush_iso,
 };
 
+static const char minimum_user_input[] = {
+	[0x00] = 32,	/* _IOWR fw_cdev_get_info			*/
+	[0x01] = 36,	/*  _IOW fw_cdev_send_request			*/
+	[0x02] = 20,	/* _IOWR fw_cdev_allocate			*/
+	[0x03] =  4,	/*  _IOW fw_cdev_deallocate			*/
+	[0x04] = 20,	/*  _IOW fw_cdev_send_response			*/
+	[0x05] =  4,	/*  _IOW fw_cdev_initiate_bus_reset		*/
+	[0x06] = 20,	/* _IOWR fw_cdev_add_descriptor			*/
+	[0x07] =  4,	/*  _IOW fw_cdev_remove_descriptor		*/
+	[0x08] = 24,	/* _IOWR fw_cdev_create_iso_context		*/
+	[0x09] = 24,	/* _IOWR fw_cdev_queue_iso			*/
+	[0x0a] = 16,	/*  _IOW fw_cdev_start_iso			*/
+	[0x0b] =  4,	/*  _IOW fw_cdev_stop_iso			*/
+	[0x0c] =  0,	/*  _IOR fw_cdev_get_cycle_timer		*/
+	[0x0d] = 20,	/* _IOWR fw_cdev_allocate_iso_resource		*/
+	[0x0e] =  4,	/*  _IOW fw_cdev_deallocate			*/
+	[0x0f] = 20,	/*  _IOW fw_cdev_allocate_iso_resource		*/
+	[0x10] = 20,	/*  _IOW fw_cdev_allocate_iso_resource		*/
+	[0x11] =  0,	/*   _IO					*/
+	[0x12] = 36,	/*  _IOW struct fw_cdev_send_request		*/
+	[0x13] = 40,	/*  _IOW struct fw_cdev_send_stream_packet	*/
+	[0x14] = 16,	/* _IOWR fw_cdev_get_cycle_timer2		*/
+	[0x15] = 20,	/* _IOWR fw_cdev_send_phy_packet		*/
+	[0x16] =  8,	/*  _IOW fw_cdev_receive_phy_packets		*/
+	[0x17] = 12,	/*  _IOW fw_cdev_set_iso_channels		*/
+	[0x18] =  4,	/*  _IOW struct fw_cdev_flush_iso		*/
+};
+
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
 
+	if (minimum_user_input[_IOC_NR(cmd)])
+		if (!(_IOC_DIR(cmd) & _IOC_WRITE) ||
+		    _IOC_SIZE(cmd) < minimum_user_input[_IOC_NR(cmd)])
+			return -EINVAL;
+
 	if (_IOC_DIR(cmd) == _IOC_READ)
 		memset(&buffer, 0, _IOC_SIZE(cmd));
 
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
