From: Mike Waychison <mikew@google.com>
Subject: [PATCH v1 05/12] netoops: add core functionality
Date: Tue, 02 Nov 2010 18:29:55 -0700
Message-ID: <20101103012954.4641.4982.stgit@crlf.mtv.corp.google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: simon.kagstrom@netinsight.net, davem@davemloft.net
Cc: adurbin@google.com, akpm@linux-foundation.org, chavey@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The kernel network dumper provides information about a crashed machine
on the network.

On a crash, the kernel spits out the contents of the kernel message buffer
along with a few other useful tidbits of information via unicast UDP.
Each packet is sent a total of three times to deal with packet loss on the
connection. Furthermore a small amount critical data is present in every
packet, so even if only a single packet gets through, we still witness the
crash.  In the same vein, we send packet in reverse order to handle cases where
the kernel fatally crashes before transmission can be completed because often
the most interesting bits of a crash can be found in the tail of the log.

Configuration of the netoops device currently uses a file in proc.  It is
programmed by writing in a u32 that represents the destination IP of the target
netoops catcher.  This can probably be made more general.

/proc/sys/kernel/net_dump_device
    Takes a u32 in ascii representing the destination ipv4 address for dumps.

Signed-off-by: Mike Waychison <mikew@google.com>
---

The packet format described in this and subsequent patches currently represent
the packet format used by Google.  It is _not_ generally applicable though, as
it does contain several fields that are x86 specific.  I've included them here
nevertheless to foster discussion as to how best to abstract this sort of
information away.

In this commit, there are several fields that are marked "__reserved*" in the
packet header.  These are replaced with actual definitions in later commits.

TODO: Figure out a better interface than plugging in an integer representing
an IPv4 address.
TODO: The netdev event handling is sufficient for our environment, but it
probably could use some work.  For instance, it may not make sense to actually
pin the neighbor, but instead just keep a copy of the MAC around.
TODO: UDP port numbers shouldn't be hardcoded like this.
---
 drivers/net/Kconfig   |   11 +
 drivers/net/Makefile  |    1 
 drivers/net/netoops.c |  550 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 561 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/netoops.c

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 5db667c..4dc53d4 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3320,8 +3320,17 @@ config NETCONSOLE_DYNAMIC
 	  at runtime through a userspace interface exported using configfs.
 	  See <file:Documentation/networking/netconsole.txt> for details.
 
+config NETOOPS
+	bool "Network oops support"
+	depends on PROC_FS
+	help
+	  This option enables the ability to have the kernel logs emitted on
+	  the network when a machine Oopses or Panics.  Configuration of this
+	  option is done at runtime by configuring a destination IP address.
+	  If unsure, say N.
+
 config NETPOLL
-	def_bool NETCONSOLE
+	def_bool NETCONSOLE || NETOOPS
 
 config NETPOLL_TRAP
 	bool "Netpoll traffic trapping"
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 3e8f150..a8b0113 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -284,6 +284,7 @@ obj-$(CONFIG_ETRAX_ETHERNET) += cris/
 obj-$(CONFIG_ENP2611_MSF_NET) += ixp2000/
 
 obj-$(CONFIG_NETCONSOLE) += netconsole.o
+obj-$(CONFIG_NETOOPS) += netoops.o
 
 obj-$(CONFIG_FS_ENET) += fs_enet/
 
diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
new file mode 100644
index 0000000..e9fdda3
--- /dev/null
+++ b/drivers/net/netoops.c
@@ -0,0 +1,550 @@
+/*
+ * drivers/net/netoops.c
+ * Copyright (C) 2004 and beyond Google Inc.
+ *
+ * Original Author Ross Biro
+ * Revisions Rebecca Schultz
+ * Cleaned up by Mike Waychison <mikew@google.com>
+ *
+ * This is very simple code to use the polling
+ * mode of the network drivers to send the
+ * contents of the printk buffer via udp w/o
+ * checksum to a unicast address.
+ */
+
+#include <linux/delay.h>
+#include <linux/in.h>
+#include <linux/notifier.h>
+#include <linux/kernel.h>
+#include <linux/netpoll.h>
+#include <linux/nmi.h>
+#include <linux/utsname.h>
+#include <linux/watchdog.h>
+#include <net/arp.h>
+#include <net/flow.h>
+#include <net/neighbour.h>
+#include <net/route.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/kmsg_dump.h>
+
+#define NETOOPS_TYPE_PRINTK_BUFFER 1
+#define NETOOPS_TYPE_PRINTK_BUFFER_SOFT 3
+#define NETOOPS_VERSION 0x0002
+#define NETOOPS_PORT 2004
+#define NETOOPS_RETRANSMIT_COUNT 3
+
+#if defined(__i386__) || defined(__x86_64__)
+#define NETOOPS_ARCH 2
+#else
+#error "unsupported architecture"
+#endif
+
+#define NETOOPS_DATA_BYTES 1024
+
+struct netoops_msg {
+	struct {
+		u16 version;    /* MUST be @ offset 0 */
+		/*
+		 * Size of this header before data[] starts.
+		 */
+		u16 header_size;
+		u16 arch;
+		u16 dump_id;    /* MUST be @ offset 6 */
+		u16 type;
+		u32 packet_count;
+		u32 packet_no;
+		u32 __reserved1;
+		u8 __reserved2;
+		u8 __reserved3;
+		u8 __reserved4;
+		/*
+		 * NOTE: fixed length strings for a packet.  NULL
+		 * termination not required.
+		 */
+		char kernel_version[64];
+		char __reserved5[64];
+		char __reserved6[64];
+	} __attribute__ ((packed)) header;
+	char data[NETOOPS_DATA_BYTES];
+} __attribute__ ((packed));
+
+static struct netpoll *np;
+static struct neighbour *netoops_neighbour;
+static DEFINE_SPINLOCK(netoops_lock);
+static struct netoops_msg msg;
+
+static void save_and_disable_netoops(struct net_device *dev);
+static void restore_netoops(struct net_device *dev);
+
+static int netoops_netdev_event(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct net_device *event_dev = ptr;
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		save_and_disable_netoops(event_dev);
+		break;
+	case NETDEV_CHANGE:
+		/* LINK UP */
+		if (netif_carrier_ok(event_dev))
+			restore_netoops(event_dev);
+		break;
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block netoops_notifier = {
+	.notifier_call = netoops_netdev_event,
+};
+
+static void disable_netoops(void);
+static void enable_netoops(char *dev_name, u32 dest_ip, u32 src_ip,
+			   struct neighbour *dest_neighbour);
+
+static void set_netoops_dest(u32 dest_ip)
+{
+	struct rtable *rt = NULL;
+	struct flowi fli;
+
+	memset(&fli, 0, sizeof(fli));
+	fli.fl4_dst = htonl(dest_ip);
+	fli.fl4_src = htonl(0);
+	/* get a route to the destination */
+	if (!ip_route_output_key(&init_net, &rt, &fli))
+		/* now get an arp entry for the neighbour */
+		if (!arp_bind_neighbour(&rt->dst))
+			neigh_event_send(rt->dst.neighbour, NULL);
+
+	/* if route to destination was found */
+	if (rt && rt->dst.neighbour) {
+		/* use the device the route was found on,
+		 * and take the remote mac from the neighbour entry */
+		enable_netoops(rt->dst.neighbour->dev->name, dest_ip,
+			       ntohl(rt->rt_src),
+			       neigh_clone(rt->dst.neighbour));
+	} else
+		disable_netoops();
+
+	/* decrement the reference counters on the route and neighbour */
+	if (rt)
+		ip_rt_put(rt);
+}
+
+static void disable_netoops(void)
+{
+	unsigned long flags;
+	struct netpoll *saved_np = NULL;
+	struct neighbour *cleanup_neighbour;
+
+	spin_lock_irqsave(&netoops_lock, flags);
+	cleanup_neighbour = netoops_neighbour;
+	netoops_neighbour = NULL;
+	saved_np = np;
+	np = NULL;
+	spin_unlock_irqrestore(&netoops_lock, flags);
+
+	if (saved_np && saved_np->dev)
+		netpoll_cleanup(saved_np);
+
+	kfree(saved_np);
+
+	/* refcount cannot be decreased with interrupt disabled. */
+	if (cleanup_neighbour)
+		neigh_release(cleanup_neighbour);
+}
+
+static void enable_netoops(char *dev_name, u32 dest_ip, u32 src_ip,
+			   struct neighbour *dest_neighbour)
+{
+	unsigned long flags;
+	struct neighbour *neighbour = NULL;
+
+	struct netpoll *new_np = kzalloc(sizeof(struct netpoll), GFP_KERNEL);
+	struct netpoll *saved_np = NULL;
+
+	if (new_np == NULL) {
+		printk(KERN_ERR "netpoll_setup failed, netoops disabled.");
+		disable_netoops();
+		return;
+	}
+	new_np->name = "network_dumper";
+	new_np->rx_hook = NULL;
+	new_np->local_port = NETOOPS_PORT;
+	new_np->remote_port = NETOOPS_PORT;
+
+	strncpy(new_np->dev_name, dev_name, sizeof(np->dev_name));
+	new_np->local_ip = htonl(src_ip);
+	new_np->remote_ip = htonl(dest_ip);
+
+	if (netpoll_setup(new_np)) {
+		printk(KERN_ERR "netpoll_setup failed, netoops disabled.");
+		disable_netoops();
+		kfree(new_np);
+		return;
+	}
+
+	spin_lock_irqsave(&netoops_lock, flags);
+	saved_np = np;
+	np = new_np;
+	neighbour = netoops_neighbour;
+	netoops_neighbour = dest_neighbour;
+	spin_unlock_irqrestore(&netoops_lock, flags);
+
+	/* refcount cannot be decreased with interrupt disabled. */
+	if (neighbour)
+		neigh_release(neighbour);
+
+	if (saved_np) {
+		netpoll_cleanup(saved_np);
+		kfree(saved_np);
+	}
+	return;
+}
+
+static void restore_netoops(struct net_device *dev)
+{
+	unsigned long flags;
+	u32 dest_ip;
+	u32 src_ip;
+	struct netpoll *saved_np;
+
+	/* Disable netoopss while saving off the destination IP address */
+	spin_lock_irqsave(&netoops_lock, flags);
+	if (!np || strcmp(np->dev_name, dev->name)) {
+		spin_unlock_irqrestore(&netoops_lock, flags);
+		return;
+	}
+	src_ip = ntohl(np->local_ip);
+	dest_ip = ntohl(np->remote_ip);
+	saved_np = np;
+	np = NULL;
+	spin_unlock_irqrestore(&netoops_lock, flags);
+
+	/* Restart the netoops configuration using the previous target IP */
+	set_netoops_dest(dest_ip);
+
+	/* Check to see if that worked at all, if not, silently continue trying
+	 * to use the existing configuration. */
+	spin_lock_irqsave(&netoops_lock, flags);
+	if (!np) {
+		np = saved_np;
+		spin_unlock_irqrestore(&netoops_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&netoops_lock, flags);
+
+	/* Cleanup the old netpoll config */
+	if (saved_np->dev)
+		netpoll_cleanup(saved_np);
+	kfree(saved_np);
+}
+
+static void save_and_disable_netoops(struct net_device *dev)
+{
+	unsigned long flags;
+	struct neighbour *neighbour = NULL;
+	struct netpoll *saved_np;
+
+	spin_lock_irqsave(&netoops_lock, flags);
+	if (np && np->dev && np->dev == dev) {
+		neighbour = netoops_neighbour;
+		netoops_neighbour = NULL;
+		saved_np = np;
+		np = NULL;
+
+		/* netpoll_cleanup calls __cancel_work_timer, and the later
+		 * can sleep
+		 */
+		spin_unlock_irqrestore(&netoops_lock, flags);
+		netpoll_cleanup(saved_np);
+		spin_lock_irqsave(&netoops_lock, flags);
+
+		BUG_ON(saved_np->dev != NULL);
+		BUG_ON(!strlen(saved_np->dev_name));
+		if (np) {
+			kfree(saved_np);
+			saved_np = NULL;
+		} else {
+			np = saved_np;
+		}
+	}
+	spin_unlock_irqrestore(&netoops_lock, flags);
+
+	/* refcount cannot be decreased with interrupt disabled. */
+	if (neighbour)
+		neigh_release(neighbour);
+}
+
+static void get_netoops_dest(char *buff, int buffsize, u32 *dest, u32 *src)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&netoops_lock, flags);
+	if (np != NULL) {
+		if (dest != NULL)
+			*dest = ntohl(np->remote_ip);
+		if (src != NULL)
+			*src = ntohl(np->local_ip);
+		memset(buff, 0, buffsize);
+		if (np->dev_name != NULL && buffsize > 1)
+			strncpy(buff, np->dev_name, min(buffsize-1, IFNAMSIZ));
+	} else {
+		if (dest != NULL)
+			*dest = 0;
+		if (src != NULL)
+			*src = 0;
+		memset(buff, 0, buffsize);
+	}
+	spin_unlock_irqrestore(&netoops_lock, flags);
+}
+
+static void setup_packet_header(int packet_count, int soft_dump)
+{
+	msg.header.version = NETOOPS_VERSION;
+	msg.header.arch = NETOOPS_ARCH;
+	msg.header.type = soft_dump ? NETOOPS_TYPE_PRINTK_BUFFER_SOFT :
+				      NETOOPS_TYPE_PRINTK_BUFFER;
+	msg.header.dump_id = (jiffies/HZ) & 0xffff;
+	msg.header.packet_count = packet_count;
+	msg.header.header_size = sizeof(msg.header);
+	strncpy(msg.header.kernel_version,
+		utsname()->release,
+		min(sizeof(msg.header.kernel_version),
+		    sizeof(utsname()->release)));
+}
+
+static int packet_count_from_length(unsigned long l)
+{
+	return (l + NETOOPS_DATA_BYTES - 1) / NETOOPS_DATA_BYTES;
+}
+
+static void netoops_send_packet(int packet_nr)
+{
+	msg.header.packet_no = packet_nr;
+
+	netpoll_send_udp(np, (char *)&msg, sizeof(msg));
+}
+
+
+/*
+ * Send the passed in segment of kmsg via netpoll.  Packets are sent in reverse
+ * order, with the tail packet (the first one transmitted) zero-padded.
+ */
+static void netoops_send_segment(int packet_offset,
+				 const char *s, unsigned long l)
+{
+	int packet_count = packet_count_from_length(l);
+	size_t data_length;
+	int i;
+
+	for (i = packet_count - 1; i >= 0; i--) {
+		/* Usually messages completely fill the data field */
+		data_length = NETOOPS_DATA_BYTES;
+		if (i == packet_count - 1) {
+			/* Except the tail packet, which is zero-padded */
+			data_length = l % NETOOPS_DATA_BYTES;
+			memset(msg.data + data_length, 0,
+			       NETOOPS_DATA_BYTES - data_length);
+		}
+		BUG_ON(data_length > NETOOPS_DATA_BYTES);
+
+		/* Copy the payload into the packet and send */
+		memcpy(msg.data, s + (i * NETOOPS_DATA_BYTES), data_length);
+		netoops_send_packet((packet_count - i - 1) + packet_offset);
+
+		touch_nmi_watchdog();
+	}
+}
+
+/*
+ * Callback used by the kmsg_dumper.
+ *
+ * Called with interrupts disabled locally.
+ */
+static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
+		    struct pt_regs *regs,
+		    const char *s1, unsigned long l1,
+		    const char *s2, unsigned long l2) {
+	int packet_count_1, packet_count_2;
+	int soft_dump = 0;
+	int i;
+
+	/* Only handle fatal problems */
+	if (reason != KMSG_DUMP_OOPS
+	 && reason != KMSG_DUMP_PANIC
+	 && reason != KMSG_DUMP_SOFT)
+		return;
+
+	if (reason == KMSG_DUMP_SOFT)
+		soft_dump = 1;
+
+	if (!spin_trylock(&netoops_lock))
+		return;
+
+	if (np == NULL || np->dev == NULL) {
+		spin_unlock(&netoops_lock);
+		return;
+	}
+
+	/*
+	 * This looks a little suspicious?  Where are we sending the packets if
+	 * the neighbor isn't valid?
+	 */
+	if (netoops_neighbour && (netoops_neighbour->nud_state & NUD_VALID))
+		memcpy(np->remote_mac, netoops_neighbour->ha, IFHWADDRLEN);
+
+	/* compute total length of the message we are going to send */
+	packet_count_1 = packet_count_from_length(l1);
+	packet_count_2 = packet_count_from_length(l2);
+
+	/* setup the non varying parts of the message */
+	memset(&msg, 0, sizeof(msg));
+	setup_packet_header(packet_count_1 + packet_count_2, soft_dump);
+
+	/* Transmission loop */
+	for (i = 0; i < NETOOPS_RETRANSMIT_COUNT; i++) {
+		/* Send the full packets from the second segment */
+		netoops_send_segment(0, s2, l2);
+		netoops_send_segment(packet_count_2, s1, l1);
+	}
+
+	spin_unlock(&netoops_lock);
+}
+
+static struct kmsg_dumper netoops_dumper = {
+	.dump = netoops,
+};
+
+static int proc_netoops_device(struct ctl_table *table, int write,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	char buff2[IFNAMSIZ+40];
+	char *s, *e;
+	u32 dest;
+	u32 src;
+
+	if (*ppos) {
+		*lenp = 0;
+		return 0;
+	}
+
+	if (!write) {
+		char devname[IFNAMSIZ+1];
+		if (!*lenp)
+			return 0;
+
+		get_netoops_dest(devname, sizeof(devname), &dest, &src);
+		snprintf(buff2, sizeof(buff2)-1, "%s,0x%08X,0x%08X\n",
+			 devname, dest, src);
+		buff2[sizeof(buff2)-1] = 0;
+		if (copy_to_user(buffer, buff2, min(strlen(buff2), *lenp)))
+			return -EFAULT;
+
+		*lenp = min(*lenp, strlen(buff2));
+		*ppos += *lenp;
+		return 0;
+	}
+
+	/* The input is in one of three formats:
+	 * 1) "off", disable netoops
+	 * 2) a dest address as a 32 bit number in host order
+	 *
+	 * CASE 1) netoopss are disabled
+	 * CASE 2) configure for unicast netoopss to that address.
+	 *
+	 * Supplying a broadcast or multicast address to case 2 or a
+	 * unicast address to case 3 will result in netoopss being disabled.
+	 */
+	if (copy_from_user(buff2, buffer, min(sizeof(buff2)-1, *lenp)))
+		return -EFAULT;
+
+	buff2[sizeof(buff2)-1] = 0;
+	e = buff2;
+	s = strsep(&e, ",");
+	if (!strncmp(s, "off", 3)) {
+		/* disable netoopss */
+		disable_netoops();
+	} else {
+		/*
+		 * Check if the first thing in the input is a valid net address
+		 */
+		if (strict_strtoul(buff2, 0, &dest)) {
+			disable_netoops();
+			return -EIO;
+		}
+		/* assume CASE 2 unicast netoopss */
+		set_netoops_dest(dest);
+		*ppos += *lenp;
+		return 0;
+	}
+
+	*ppos += *lenp;
+
+	return 0;
+}
+
+static struct ctl_table kern_table[] = {
+	{
+		.procname       = "net_dump_device",
+		.mode           = 0644,
+		.proc_handler   = &proc_netoops_device,
+	},
+	{},
+};
+
+static struct ctl_table root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= kern_table,
+	},
+	{}
+};
+
+static struct ctl_table_header *proc_table_header;
+
+static int __init netoops_init(void)
+{
+	int retval = -EINVAL;
+
+	BUILD_BUG_ON(offsetof(struct netoops_msg, header.version) != 0);
+	BUILD_BUG_ON(offsetof(struct netoops_msg, header.dump_id) != 6);
+
+	retval = kmsg_dump_register(&netoops_dumper);
+	if (retval)
+		goto out;
+
+	/* Register hooks */
+	retval = register_netdevice_notifier(&netoops_notifier);
+	if (retval)
+		goto cleanup_kmsg_dump;
+
+	proc_table_header = register_sysctl_table(root_table);
+	if (proc_table_header == NULL) {
+		retval = -EBUSY;
+		goto cleanup_netdevice;
+	}
+
+	return 0;
+cleanup_netdevice:
+	unregister_netdevice_notifier(&netoops_notifier);
+cleanup_kmsg_dump:
+	kmsg_dump_unregister(&netoops_dumper);
+out:
+	return retval;
+}
+
+static void __exit netoops_exit(void)
+{
+	unregister_sysctl_table(proc_table_header);
+	unregister_netdevice_notifier(&netoops_notifier);
+	disable_netoops();
+	kmsg_dump_unregister(&netoops_dumper);
+}
+
+module_init(netoops_init);
+module_exit(netoops_exit);
