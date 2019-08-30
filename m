From: David Howells <dhowells@redhat.com>
Subject: watch_queue(7) manpage
Date: Fri, 30 Aug 2019 15:15:25 +0100
Message-ID: <4553.1567174525@warthog.procyon.org.uk>
References: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <156717343223.2204.15875738850129174524.stgit@warthog.procyon.org.uk>
Content-ID: <4552.1567174525.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>, Stephen Smalley <sds@tycho.nsa.gov>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, nicolas.dichtel@6wind.com, raven@themaw.net, Christian Brauner <christian@brauner.io>, keyrings@vger.kernel.org, linux-usb@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

.\"
.\" Copyright (C) 2019 Red Hat, Inc. All Rights Reserved.
.\" Written by David Howells (dhowells@redhat.com)
.\"
.\" This program is free software; you can redistribute it and/or
.\" modify it under the terms of the GNU General Public Licence
.\" as published by the Free Software Foundation; either version
.\" 2 of the Licence, or (at your option) any later version.
.\"
.TH WATCH_QUEUE 7 "28 Aug 2019" Linux "General Kernel Notifications"
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH NAME
/dev/watch_queue \- General kernel notification queue
.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH SYNOPSIS
#include <linux/watch_queue.h>
.EX

int fd = open("/dev/watch_queue", O_RDWR);
ioctl(fd, IOC_WATCH_QUEUE_SET_SIZE, size / page_size);
ioctl(fd, IOC_WATCH_QUEUE_SET_FILTER, &filter);
buf = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
.EE
.SH OVERVIEW
.PP
The general kernel notification queue is a general purpose transport for kernel
notification messages to userspace.  Notification messages are marked with type
information so that events from multiple sources can be distinguished.
Messages are also of variable length to accommodate different information for
each type.
.PP
This queue is implemented as a misc device that can be opened multiple times,
each opening creating a fully independent queue.  Queues are then configured
with the size and filtering, event sources are attached and the queue is mapped
into a process's VM.
.PP
Queues take the form of a ring buffer with shared index pointers, all of which
is accessed directly within the mapping.  There are no read and write methods,
though poll is provided so that the buffer can be waited upon.
.PP
A queue pins a certain amount of locked kernel memory (so that the kernel can
write a notification into it from contexts where swapping cannot be performed),
and so is subject to resource limit restrictions on
.BR RLIMIT_MEMLOCK .
.PP
Sources must be attached to a queue manually; there's no single global event
source, but rather a variety of sources, each of which can be attached to by
multiple queues.  Attachments can be set up by:
.TP
.BR keyctl_watch_key (3)
Monitor a key or keyring for changes.
.TP
.BR device_notify (2)
Monitor a global source of device events from USB and block devices, such as
device detection, device removal and I/O errors.
.PP
Because a source can produce a lot of different events, not all of which may be
of interest to the watcher, a filter can be set on a queue to determine whether
a particular event will get inserted in a queue at the point of posting inside
the kernel.

.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH RING STRUCTURE
.PP
The ring buffer is divided into 8-byte slots and notification message occupies
between 1 and 63 of those slots.  Each message begins with a header of the
form:
.PP
.in +4n
.EX
struct watch_notification {
	__u32	type:24;
	__u32	subtype:8;
	__u32	info;
};
.EE
.in
.PP
Where
.I type
indicates the general class of notification,
.I subtype
indicates the specific type of notification within that class and
.I info
includes the length (in slots), the watcher's ID and some type-specific
information.
.PP
Messages inserted into the buffer aren't allowed to split over the end of the
buffer; instead a
.I skip
notification will be inserted to pad to the end of the buffer.  A skip
notification will have the type set to
.B WATCH_TYPE_META
and the subtype set to
.BR WATCH_META_SKIP_NOTIFICATION ,
with the length indicating how much should be skipped.
.PP
To avoid the need for an extra page dedicated solely to metadata pointers, the
first few slots are covered by a permanent skip notification and contain ring
metadata including the pointers.  The buffer has a 'header' of the form:
.PP
.in +4n
.EX
struct {
	struct watch_notification watch;
	__u32	head;
	__u32	tail;
	__u32	mask;
	__u32	__reserved;
};
.EE
.in
.PP
This includes the ring indices,
.IR head " and " tail ,
and a
.I mask
to mask them off with before use.  When using the ring indices, the following
precautions should be observed:
.TP
.B (1)
.I head
indicates where the kernel will insert the next message into the buffer.  Only
the kernel is allowed to change head.
.TP
.B (2)
.I tail
indicates where the next message for userspace to consume can be found; tail
will never be changed by the kernel.
.TP
.B (3)
An
.IR acquire -class
memory barrier must be used to read head.  It is not necessary to use a memory
barrier to read tail.
.TP
.B (4)
The buffer is empty if tail == head.
.TP
.B (5)
head and tail should not be masked off after increment, but rather left to wrap
naturally; this means that the index must be masked off before being used to
access the buffer.
.TP
.B (6)
After consuming a message, the length (in slots) of the message should be added
to tail and tail must not be then masked off.
.TP
.B (7)
A
.IR release -class
memory barrier must be used to update
.IR tail .
.PP
If the head and tail values become too far separated or head points to a
forbidden area of the buffer, no further message insertion will take place and
.IR poll ()
will flag
.BR POLLERR .
Otherwise, poll() will flag
.BR POLLIN " and " POLLRDNORM
if tail != head.
.PP
The ring as a whole is described by the following structure:
.PP
.in +4n
.EX
struct watch_queue_buffer {
	union {
		struct {
			struct watch_notification watch;
			__u32	head;
			__u32	tail;
			__u32	mask;
			__u32	__reserved;
		} meta;
		struct watch_notification slots[0];
	};
};
.EE
.in
.PP
Where
.I meta
covers the slots holding the ring indices and other metadata.  Note that the
metadata may be extended in future.  It's size can be determined by checking
the length of the skip pseudo-message that covers it (see
.IR meta.watch ).
.PP
In the event that the ring is full when the kernel needs to write in a
notification, it will set
.B WATCH_INFO_NOTIFICATIONS_LOST
in
.IR meta.watch.info
to indicate an overrun.  If the flag is noticed as being unset, the entire word
can be simply cleared without bothering the kernel as the kernel doesn't ever
read it.

.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH IOCTL COMMANDS
The device has the following
.IR ioctl ()
commands:
.TP
.B IOC_WATCH_QUEUE_SET_SIZE
The ioctl argument is indicates the size of the buffer in pages and must be a
power of two.  This command allocates the memory to back the buffer.
.IP
This may only be done once and the buffer cannot be mmap'd until this command
has been done.
.TP
.B IOC_WATCH_QUEUE_SET_FILTER
This is used to set filters on the notifications that get written into the
buffer.  The ioctl argument points to a structure of the following form:
.IP
.in +4n
.EX
struct watch_notification_filter {
	__u32	nr_filters;
	__u32	__reserved;
	struct watch_notification_type_filter filters[];
};
.EE
.in
.IP
Where
.I nr_filters
indicates the number of elements in the
.IR filters []
array.  Each element in the filters array specifies a filter and is of the
following form:
.IP
.in +4n
.EX
struct watch_notification_type_filter {
	__u32	type;
	__u32	info_filter;
	__u32	info_mask;
	__u32	subtype_filter[8];
};
.EE
.in
.IP
Where
.I type
refer to the type field in a notification record header, info_filter and
info_mask refer to the info field and subtype_filter is a bit-mask of subtypes.
.IP
If no filters are installed, all notifications are allowed by default and if
one or more filters are installed, notifications are disallowed by default.
.IP
A notifications matches a filter if, for notification N and filter F:
.IP
.in +4n
.EX
N->type == F->type &&
(F->subtype_filter[N->subtype >> 5] &
	(1U << (N->subtype & 31))) &&
(N->info & F->info_mask) == F->info_filter)
.EE
.in
.IP


.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH EXAMPLE
To use the notification mechanism, first of all the device has to be opened,
the size must be set and the buffer mapped:
.PP
.in +4n
.EX
int wfd = open("/dev/watch_queue", O_RDWR);

ioctl(wfd, IOC_WATCH_QUEUE_SET_SIZE, 1);

struct watch_queue_buffer *buf =
	mmap(NULL, 1 * PAGE_SIZE, PROT_READ | PROT_WRITE,
	     MAP_SHARED, wfd, 0);

.EE
.in
.PP
>From this point, the buffer is open for business.  Filters can be set to
restrict the notifications that get inserted into the buffer from the sources
that are watched.  For example:
.PP
.in +4n
.EX
static struct watch_notification_filter filter = {
	.nr_filters	= 2,
	.__reserved	= 0,
	.filters = {
		[0]	= {
			.type			= WATCH_TYPE_KEY_NOTIFY,
			.subtype_filter[0]	= 1 << NOTIFY_KEY_LINKED,
			.info_filter		= 1 << WATCH_INFO_FLAG_2,
			.info_mask		= 1 << WATCH_INFO_FLAG_2,
		},
		[1]	= {
			.type			= WATCH_TYPE_USB_NOTIFY,
			.subtype_filter[0]	= 1 << NOTIFY_USB_DEVICE_ADD,
		},
	},
};

ioctl(fd, IOC_WATCH_QUEUE_SET_FILTER, &filter);
.EE
.in
.PP
will only allow key-change notifications that indicate a key is linked into a
keyring and then only if type-specific flag WATCH_INFO_FLAG_2 is set on the
notification and will only allow USB device-add notifications, blocking other
USB notifications and all block device notifications.
.PP
Sources can then be watched, for example:
.PP
.in +4n
.EX
keyctl_watch_key(KEY_SPEC_SESSION_KEYRING, wfd, 0x33);
watch_devices(wfd, 0x55, 0);
.EE
.in
.PP
The first places a watch on the process's session keyring, directing the
notifications to the buffer we just created and specifying that they should be
tagged with 0x33 in the info ID field.  The second places a watch on the global
device notifications queue, specifying that notifications from that should be
tagged with info ID 0x55.
.PP
The device file descriptor can then be polled to find out when the kernel
writes something into the buffer or if the ring indices become incoherent:
.PP
.in +4n
.EX
struct pollfd p[1];
p[0].fd = wfd;
p[0].events = POLLIN | POLLERR;
p[0].revents = 0;
poll(p, 1, -1);
.EE
.in
.PP
When it is determined that there is something in the buffer, messages can be
read out of the ring with something like the following:
.PP
.in +4n
.EX
struct watch_notification *n;
unsigned int len, head, tail, mask = buf->meta.mask;

while (head = __atomic_load_n(&buf->meta.head,
                              __ATOMIC_ACQUIRE),
       tail = buf->meta.tail,
       tail != head
       ) {
        n = &buf->slots[tail & mask];
        len = n->info & WATCH_INFO_LENGTH;
        len >>= WATCH_INFO_LENGTH__SHIFT;
        if (len == 0)
                abort();

        switch (n->type) {
        case WATCH_TYPE_META:
                switch (n->subtype) {
                case WATCH_META_REMOVAL_NOTIFICATION:
                        saw_removal_notification(n);
                        break;
                }
                break;
        case WATCH_TYPE_KEY_NOTIFY:
                saw_key_change(n);
                break;
        case WATCH_TYPE_USB_NOTIFY:
                saw_usb_event(n);
                break;
        }

        tail += len;
        __atomic_store_n(&buf->meta.tail, tail, __ATOMIC_RELEASE);
}
.EE
.in
.PP

.\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
.SH VERSIONS
The notification queue driver first appeared in v??? of the Linux kernel.
.SH SEE ALSO
.ad l
.nh
.BR ioctl (2),
.BR keyctl (1),
.BR keyctl_watch_key (3),
.BR poll (2),
.BR setrlimit (2)
