From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
Date: Mon, 26 Jan 2015 12:31:29 -0200
Message-ID: <20150126123129.2076b9f8@recife.lan>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
	<CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>, Ricardo Ribalda <ricardo.ribalda@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Em Mon, 26 Jan 2015 09:00:46 -0500
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> > For media-ctl, it is easier to handle major/minor, in order to identify
> > the associated devnode name. Btw, media-ctl currently assumes that all
> > devnode devices are specified by v4l.major/v4l.minor.
> 
> I suspect part of the motivation for the "id" that corresponds to the
> adapter field was to make it easier to find the actual underlying
> device node. 

Yes, that was the reason why, back in 2007, we believed that just id
would be enough. Yet, we never tried to implement it, until the end
of the last year.

> While it's trivial to convert a V4L device node from
> major/minor to the device node (since for major number is constant and
> the minor corresponds to the X in /dev/videoX), that's tougher with
> DVB adapters because of the hierarchical nature of the DVB device
> nodes.  Having the adapter number makes it trivial to open
> /dev/dvb/adapterX.
> 
> Perhaps my POSIX is rusty -- is there a way to identify the device
> node based on major minor without having to traverse the entire /dev
> tree?

It is actually trivial to get the device nodes once you have the
major/minor. The media-ctl library does that for you. See:

$ media-ctl --print-dot
digraph board {
	rankdir=TB
	n00000001 [label="{{<port0> 0} | cx25840 19-0044 | {<port1> 1 | <port2> 2}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000001:port1 -> n00000003
	n00000001:port2 -> n00000004
	n00000002 [label="{{} | NXP TDA18271HD | {<port0> 0}}", shape=Mrecord, style=filled, fillcolor=green]
	n00000002:port0 -> n00000005 [style=dashed]
	n00000002:port0 -> n00000001:port0
	n00000003 [label="cx231xx #0 video\n/dev/video0", shape=box, style=filled, fillcolor=yellow]
	n00000004 [label="cx231xx #0 vbi\n/dev/vbi0", shape=box, style=filled, fillcolor=yellow]
	n00000005 [label="Fujitsu mb86A20s\n/dev/dvb/adapter0/frontend0", shape=box, style=filled, fillcolor=yellow]
	n00000005 -> n00000006
	n00000006 [label="demux\n/dev/dvb/adapter0/demux0", shape=box, style=filled, fillcolor=yellow]
	n00000006 -> n00000007
	n00000007 [label="dvr\n/dev/dvb/adapter0/dvr0", shape=box, style=filled, fillcolor=yellow]
	n00000008 [label="dvb net\n/dev/dvb/adapter0/net0", shape=box, style=filled, fillcolor=yellow]
}

There are two routines inside the media-ctl libraries to convert from
major/minor into a devnode name like: /dev/dvb/adapter0/demux0.

The first one uses sysfs:

 $ ls -la /sys/dev/char|grep dvb
lrwxrwxrwx. 1 root root 0 Jan 26 10:32 212:0 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/dvb/dvb0.frontend0
lrwxrwxrwx. 1 root root 0 Jan 26 10:32 212:1 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/dvb/dvb0.demux0
lrwxrwxrwx. 1 root root 0 Jan 26 10:32 212:2 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/dvb/dvb0.dvr0
lrwxrwxrwx. 1 root root 0 Jan 26 10:32 212:3 -> ../../devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.1/dvb/dvb0.net0

Unfortunately, the sysfs nodes are "dvb0" for adapter0, so a patch is needed 
to fix it:
	http://git.linuxtv.org/cgit.cgi/mchehab/experimental-v4l-utils.git/commit/?h=dvb-media-ctl&id=d854a9bb24706dbfc878484e4538d79b1ac52aae

The second (and better) approach is to require udev to return the name of the
devnode. The logic, implemented at utils/media-ctl/libmediactl.c, inside
v4l-utils, is:

	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
	media_dbg(entity->media, "looking up device: %u:%u\n",
		  major(devnum), minor(devnum));
	device = udev_device_new_from_devnum(udev, 'c', devnum);

Right now, by default, media-ctl will use the sysfs approach, except
if an extra option is called at ./configure, in order to enable it to
use the udev library.

IMHO, we should make udev the default behavior, if libudev-dev(el) is 
there at compilation time.

Regards,
Mauro
