From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] uapi/media.h: Use u32 for the number of graph
 objects
Date: Thu, 17 Dec 2015 12:58:06 -0200
Message-ID: <20151217125806.3f4f879e@recife.lan>
References: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com>
	<5672A69F.7020505@xs4all.nl>
	<20151217104556.70d4f0f8@recife.lan>
	<2035986.3qXU4Qokl3@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <2035986.3qXU4Qokl3@wuerfel>
Sender: linux-media-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Em Thu, 17 Dec 2015 14:55:11 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Thursday 17 December 2015 10:45:56 Mauro Carvalho Chehab wrote:
> > If I understood well, he's proposing to do is:
> > 
> > struct media_v2_topology {
> >         __u64 topology_version;
> > 
> >         __u32 num_entities;
> >         __u32 num_interfaces;
> >         __u32 num_pads;
> >         __u32 num_links;
> > 
> >         __u64 ptr_entities;
> >         __u64 ptr_interfaces;
> >         __u64 ptr_pads;
> >         __u64 ptr_links;
> > };
> > 
> > The problem is that, if we latter need to extend it to add a new type
> > the extension will not be too nice. For example, I did some experimental
> > patches adding graph groups:
> > 
> 
> Can you clarify how the 'topology_version' is used here? Is that
> the version of the structure layout that decides how we interpret the
> rest, or is it a number that is runtime dependent?

No, topology_version is just a mononotonic counter that starts on 0
and it is incremented every time a graph object is added or removed. 

It is meant to be used to track if the topology changes after a previous
call to this ioctl.

On existing media controller embedded device hardware, it should
always be zero, but on devices that allow dynamic hardware changes
(some embedded DTV hardware allows that - also on devices with FPGA,
with RISC CPUs or hot-pluggable devices) should use it to know if the
hardware got modified. 

This is also needed on multi-function devices where different drivers 
are used for each function. That's the case of au0828, with uses a
media driver for video, and the standard USB Audio Class driver for
audio. As the drivers are independent, the topology_version will
be zero when the first driver is loaded, but it will change during
at probe time on second driver. It will also be increased if one
of the drivers got unbind.

> If this is an API version, I think the answer can simply be to drop
> the topology_version field entirely, and use a new ioctl command code
> whenever the API changes. This is the preferred method anyway.

Regards,
Mauro.
