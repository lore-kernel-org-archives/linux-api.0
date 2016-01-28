From: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH v2] [media] Postpone the addition of MEDIA_IOC_G_TOPOLOGY
Date: Thu, 28 Jan 2016 18:10:05 +0200
Message-ID: <20160128161005.GL14876@valkosipuli.retiisi.org.uk>
References: <be0270ec89e6b9b49de7e533dd1f3a89ad34d205.1452523228.git.mchehab@osg.samsung.com>
 <20160127114443.GF14876@valkosipuli.retiisi.org.uk>
 <20160127110840.61d55b06@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160127110840.61d55b06@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Hans Verkuil <hverkuil@xs4all.nl>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Mauro,

On Wed, Jan 27, 2016 at 11:08:40AM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 27 Jan 2016 13:44:44 +0200
> Sakari Ailus <sakari.ailus@iki.fi> escreveu:
> 
> > Hi Mauro,
> > 
> > I see that this patch got applied to the media_tree master, but then
> > reverted a few days ago.
> 
> For Kernel 4.5, the new ioctl is disabled. It was reverted after
> pulling back from Linus tree, in order to allow the developers to
> be able to test it and improve it if needed. So, the revert patch is
> meant to reach upstream only in Kernel 4.6, as proposed in this patch.
> 
> It means that we have about 2 months to polite it before the next merge
> window.

My point is that I would prefer that an informed decision is made before the
pull request is sent rather than letting two months to pass before it
happens. The passage of time itself usually does not improve software.

> > Do you think the G_TOPOLOGY IOCTL and the
> > associated user space structs are ready for being included in a release?
> 
> Well, the only doubt we had so far is about how to make it compatible
> with 64 bits kernelspace and 32 bits userspace. 2 months seems more than
> enough for us to properly address that.
> 
> > 
> > I have a few concerns over the current interface, in decreasing order of
> > importance:
> 
> Ok, that's the first time you come with that. I still think that those
> could be addressed in the next 2 months, but, if not, we may eventually
> postpone enabling G_TOPOLOGY ioctl further.

Agreed.

> 
> > 
> > - G_TOPOLOGY IOCTL is intended to enable dynamic updates, but do we have a
> >   driver actually supporting this?
> 
> Laurent requested to postpone dynamic updates at the early stages of the MC
> patchset review. The initial patchset were using krefs to handle it. We can
> work on adding support for it for 4.6.
> 
> I'm actually working today to add MC support on em28xx USB hardware.
> On such driver, there is a master driver (em28xx) and several sub-drivers
> (em28xx-video, em28xx-dvb, em28xx-alsa and em28xx-input). The sub-drivers
> are loaded asynchronously. meaning that the topology will be dynamically
> updated during driver load. The alsa module (or snd-usb-audio - depending
> on the hardware) can be unbind/rebind dynamically.
> 
> So, while the hardware itself is not dynamic, dynamic support is
> needed, in order to avoid race conditions.

Ack.

> >   For instance, supposing that the users's
> >   knowledge of the graph state isn't what the user expected it to be
> >   (assuming the graph state changed between G_TOPOLOGY and SETUP_LINK), does
> >   the user still want to perform the SETUP_LINK IOCTL or would the user
> >   prefer that the kernel returned an error instead to tell the user has no
> >   knowledge of the current graph state? I'd like to see how that works in
> >   practice. For instance, a virtual driver such as vivi, but with MC, V4L2
> >   sub-device and V4L2 support which adds and removes a random entity every,
> >   say, five minutes, would be wonderful. If this has not been tried out in a
> >   real use case, the chances of getting it right may remain rather slim.
> 
> It can be simulated by removing/adding or binding/unbinding snd-usb-audio
> module. We may also apply the virtual MC driver, if it is ready. Not
> sure about its current review stage of the virtual driver.

Ah. I have to admit I haven't had enough time to follow up everything that's
going on on linux-media, and this one had completely escaped me. I'll try to
review it in the near future.

> > - struct media_v2_pad contains fields called "id" and "entity_id". The "id"
> >   field, as far as I understand, is the graph object id, not the pad index.
> >   In order to configure a link using MEDIA_IOC_SETUP_LINK, one does need to
> >   know the entity id and the pad index. This information you'll only get
> >   using MEDIA_IOC_ENUM_LINKS, which right now refutes the very purpose of
> >   the G_TOPOLOGY IOCTL. Knowing the pad indices is also essential for the
> >   V4L2 sub-device user space API. (I remember whether or not the pad index
> >   should be there but I don't remember the details, except that it was
> >   intentionally left out. Considering this again, I think adding it is
> >   unavoidable.)
> 
> A new ioctl to setup links is required, as we want to be able to change
> the status of multiple links at once.

Indeed, that's needed. But do we technically need a new IOCTL for that
purpose? The request API should cover that already, and much more.

Link configuration alone is often not enough, you very likely need to
configure V4L2 sub-device formats as well --- if you have sub-devices. The
new IOCTL could cover setting up multiple links at once, but for formats
you'd still need request API. This will get complex, I can promise you.

> 
> The thing with the PAD index is that it should be replaced by something
> more generic, via the properties API. On some cases, just an index is
> enough (when the pads are, for example, the output pins of a demux).

The pad index could be passed through the property API, I agree. But until
we have the property API, we need something else.

> 
> But, in general, what an application would want is to specify the
> "audio out pin" or the "video out pin" of a device. As the index
> number may vary depending on the specific device, Such application
> should not have the index numbers hardcoded on it, but, instead, 
> they should discover it via the userspace API. What we've agreed
> is that such information would be coded as a property via the
> properties API.

I fully agree with that.

The applications using the MC interface so far have mostly been test
programs and hardware-specific applications which are fine as such, but with
this level of detail it's not easy to write generic applications. The
applications do need more information on the device, and that's where the
property API indeed will help.

> 
> >   This together with the above point suggest there are no
> >   real applications using G_TOPOLOGY yet.
> 
> MEDIA_IOC_SETUP_LINK is a must only for subdev-centric hardware, like
> OMAP3. For device-node-centric hardware (like em28xx, au0828, etc),
> G_TOPOLOGY itself is useful to allow describing the hardware interfaces
> and their connections, e. g. to reimplement libmedia_dev at v4l-utils
> to use MC instead of sysfs.

Do you mean you only have a single pad on each entity? Or that you do not do
link specific configuration for non-zero pads? I may have missed
something... do you have the media graph of the em28xx somewhere?

Pads are an integral part of the graph and it'd be important to provide the
user with complete information on them. There are reserved field though so
it can always be added later on.

> 
> > - Some more thought should be given to the state of the reserved fields, in
> >   e.g. struct media_v2_pad there are __u32 fields only, except a reserved
> >   field which is a __u16 array of 9. While this isn't exactly wrong it makes
> >   no sense either.
> 
> Well, 2 months is enough for us to address the reserved fields ;)

I think we need patches rather than time. :-)

I may try to submit some, but time is a limited resource for me as well. :-I

> 
> > - KernelDoc documentation would be nice for the G_TOPOLOGY argument structs.
> >   DocBook documentation for G_TOPOLOGY as itself is fine, but I think it
> >   reflects an older version of the structs than what's now defined in
> >   include/uapi/linux/media.h.
> 
> See:
> 	https://linuxtv.org/downloads/v4l-dvb-apis/media-g-topology.html
> 
> Indeed, there is one missing struct there (media_v2_link). Not sure what
> happened here. I guess I lost one hunk when I wrote the KernelDoc
> patch. Anyway, adding it is easy. I'll prepare a patch for it soon.
> 
> The description of media_v2_topology actually matches our last
> discussion (where we decided to not use any _reserved field there). 
> 
> Yet, this difference is actually the reason why we've delayed it in the
> first place, as my guts tell that we need more discussions about it.

Right. Let's find out the intended layout for the structs in the header and
then update the documentation.

> 
> > Please give some thought on this. There are some obvious gaps that need to
> > be filled, and when doing so, I don't think we want to start guessing
> > whether there might be an application that depends on the current API/ABI.
> > 
> > If you'd like the G_TOPOLOGY IOCTL and its argument structs to be available
> > for developers without kernel changes, I propose to add a new Kconfig option
> > for G_TOPOLOGY and make it depend on BROKEN.
> > 
> > What do you think?
> 
> Making it depending on BROKEN at our development tree is not a good
> thing, as BROKEN is not an option that can be changed with make
> menuconfig/xconfig. It needs to be easy to do tests on our
> development tree, in order for it to be tested by a broader audience.
> 
> Ok, if we end by needing to postpone it even further, we could do
> something different, but it sounds to early to do that, as we can postpone
> such decision to happen closer to the next merge window (or even to
> happen just before releasing Kernel 4.6, if we discover too late some
> real issue there).

An additional Kconfig option marked EXPERIMENTAL defaulting to no might
still be a good idea. Let's see how things are before the pull request time,
ok?

In its current state I would suggest that at least, if not depend on BROKEN.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
