From: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH 1/3] media: Fix ALSA and DVB representation at media
 controller API
Date: Mon, 26 Jan 2015 09:00:46 -0500
Message-ID: <CAGoCfixoSxspEzpCB95BVPXBrZr2gpDVWHbaikESsuB1V=WM1g@mail.gmail.com>
References: <cover.1422273497.git.mchehab@osg.samsung.com>
	<cb0517f150942a2d3657c1f2e55754061bfae2c4.1422273497.git.mchehab@osg.samsung.com>
	<54C63D16.3070607@xs4all.nl>
	<20150126113416.311fb376@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20150126113416.311fb376@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hans.verkuil@cisco.com>, Sakari Ailus <sakari.ailus@linux.intel.com>, Antti Palosaari <crope@iki.fi>, Ricardo Ribalda <ricardo.ribalda@gmail.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

> For media-ctl, it is easier to handle major/minor, in order to identify
> the associated devnode name. Btw, media-ctl currently assumes that all
> devnode devices are specified by v4l.major/v4l.minor.

I suspect part of the motivation for the "id" that corresponds to the
adapter field was to make it easier to find the actual underlying
device node.  While it's trivial to convert a V4L device node from
major/minor to the device node (since for major number is constant and
the minor corresponds to the X in /dev/videoX), that's tougher with
DVB adapters because of the hierarchical nature of the DVB device
nodes.  Having the adapter number makes it trivial to open
/dev/dvb/adapterX.

Perhaps my POSIX is rusty -- is there a way to identify the device
node based on major minor without having to traverse the entire /dev
tree?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
