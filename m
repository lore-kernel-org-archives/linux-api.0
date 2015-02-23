From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media controller API
Date: Mon, 23 Feb 2015 23:20:15 +0200
Message-ID: <2073043.Yp0nzaPjZq@avalon>
References: <cover.1422273497.git.mchehab@osg.samsung.com> <CAGoCfiwi0nj_9sYNzEFOp5BvedFe+HphJ2bVtx_bnBw3d-Bsyw@mail.gmail.com> <20150223105508.54c730fc@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20150223105508.54c730fc@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>, Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>, Ricardo Ribalda <ricardo.ribalda@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Mauro,

On Monday 23 February 2015 10:55:08 Mauro Carvalho Chehab wrote:
> Em Mon, 26 Jan 2015 09:41:41 -0500 Devin Heitmueller escreveu:
> >> It is actually trivial to get the device nodes once you have the
> >> major/minor. The media-ctl library does that for you. See:
> >
> > No objection then.
> > 
> > On a related note, you would be very well served to consider testing
> > your dvb changes with a device that has more than one DVB tuner (such
> > as the hvr-2200/2250).  That will help you shake out any edge cases
> > related to ensuring that the different DVB nodes appear in different
> > groups.
> 
> Hi Devin,
> 
> I did some tests (and fixes) for WinTV Nova-TD, with has two adapters.
> 
> I saw two alternatives for it:
> 
> 1) to create a media controller device for each adapter;
> 2) to create just one media controller.
> 
> I actually implemented (1), as, in the case of this device, AFAIKT, the
> two devices are indepentent, e. g. it is not possible to, for example,
> share the same tuner with two demods:
> 
> $ ls -la /dev/media?
> crw-rw----. 1 root video 249, 0 Fev 23 10:02 /dev/media0
> crw-rw----. 1 root video 249, 1 Fev 23 10:02 /dev/media1
> 
> The adapter 0 corresponds to /dev/media0, and the adapter 1
> to /dev/media1:
> 
> $ media-ctl --print-dot -d /dev/media0
> digraph board {
> 	rankdir=TB
> 	n00000001 [label="dvb-demux\n/dev/dvb/adapter0/demux0", shape=box,
> style=filled, fillcolor=yellow] n00000001 -> n00000002
> 	n00000002 [label="dvb-dvr\n/dev/dvb/adapter0/dvr0", shape=box,
> style=filled, fillcolor=yellow] n00000003
> [label="dvb-net\n/dev/dvb/adapter0/net0", shape=box, style=filled,
> fillcolor=yellow] n00000004 [label="DiBcom
> 7000PC\n/dev/dvb/adapter0/frontend0", shape=box, style=filled,
> fillcolor=yellow] n00000004 -> n00000001
> }
> 
> $ media-ctl --print-dot -d /dev/media1
> digraph board {
> 	rankdir=TB
> 	n00000001 [label="dvb-demux\n/dev/dvb/adapter1/demux0", shape=box,
> style=filled, fillcolor=yellow] n00000001 -> n00000002
> 	n00000002 [label="dvb-dvr\n/dev/dvb/adapter1/dvr0", shape=box,
> style=filled, fillcolor=yellow] n00000003
> [label="dvb-net\n/dev/dvb/adapter1/net0", shape=box, style=filled,
> fillcolor=yellow] n00000004 [label="DiBcom
> 7000PC\n/dev/dvb/adapter1/frontend0", shape=box, style=filled,
> fillcolor=yellow] n00000004 -> n00000001
> }
> 
> On a more complex hardware where some components may be rewired
> on a different way, however, using just one media controller
> would be a better approach.
> 
> Comments?

A few, yes :-)

There's surprisingly many "details" that are not fully specified in MC, and 
this is one of them. Historically the design idea was to create one media 
device per instance of master video device. For PCI devices that's roughly one 
media device per card, for platform devices one media device per master IP 
core (or group of IP cores) instance, and for USB devices one media device per 
USB control interface.

We can depart from that model in two ways.

As you mentioned above, it could make sense to create separate media device 
instances for a single master device (USB in this case) when the master device 
contains several completely independent pipelines. Completely independent 
means that no data link connects the two pipelines, and that no resource is 
shared between them in a way that affects the device's behaviour.

In the example above the only shared hardware resource seems to be the USB 
bridge chip, which implements two independent DMA channels through the same 
USB interface. If the DMA channels are really independent, in the sense that 
they have no influence on each other such as e.g. bandwidth sharing, then two 
media devices could be created. Note that there's no requirement to do so, 
creating a single media device in this case is still perfectly valid.

It should also be noted that split pipelines could be difficult to represent 
as independent media devices when an external chip is shared between the two 
pipelines, even if that chip is itself split in two independent parts. This is 
caused by how the kernel APIs used to manage composite devices (v4l2-async and 
the component framework) handle components. For instance, in the DT case, we 
can't use v4l2-async to bind to one of the subdevs create for a single I2C 
chip or IP core, as they would share the same hardware identifier (device 
name, DT node, ...) used to match subdevs. Arguably that's a framework issue 
that should be fixed, but it wouldn't be trivial.

The second way to depart from the existing model is unrelated to the DVB 
examples above, but is still worth mentioning for completeness. When several 
master devices share resources (either on-chip or off-chip), a single media 
device is required. I've discussed such a case with Jean-Michel Hautbois and 
Hans Verkuil at the FOSDEM for the i.MX6 SoC. The chip includes two 
independent IPUs (Image Processing Units), with two independent parallel 
receivers but one shared CSI-2 receiver. On the system Jean-Michel is working 
with, an external FPGA is connected to the two parallel receivers. The 
resulting media pipeline thus includes the FPGA, the CSI-2 receiver and the 
two IPUs, requiring a single media device to cover both IPUs. As the IPU 
driver is the master driver in this case, it would normally create one media 
device per hardware device instance.

A similar situation occurs when video capture devices, memory to memory 
devices and/or display devices are connected together through deep pipelining. 
Such an example can be found in the Renesas R-Car Gen2 SoCs, where a memory to 
memory video processing device (VSP1) has one output connected directly to the 
display engine (DU). The VSP1 and DU are otherwise completely separate IP 
cores, with the former supported by a V4L2 driver and the latter by a DRM/KMS 
driver. We also need a single media device to cover the whole graph, without 
intrusive changes in either the VSP1 or the DU driver as the two devices can 
operate completely independently and without both being present.

-- 
Regards,

Laurent Pinchart
