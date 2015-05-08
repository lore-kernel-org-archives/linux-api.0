From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 04/18] media controller: Rename camera entities
Date: Fri, 08 May 2015 15:13:20 +0200
Message-ID: <554CB670.70107@xs4all.nl>
References: <cover.1431046915.git.mchehab@osg.samsung.com>	<a1a45e1b62e9dc69fd0a2d11dff57a414304c541.1431046915.git.mchehab@osg.samsung.com>	<554CA5F5.1040101@xs4all.nl> <20150508095347.3f6e2a5a@recife.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <20150508095347.3f6e2a5a@recife.lan>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Sakari Ailus <sakari.ailus@iki.fi>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Kyungmin Park <kyungmin.park@samsung.com>, Heungjun Kim <riverful.kim@samsung.com>, Prabhakar Lad <prabhakar.csengg@gmail.com>, Andrzej Hajda <a.hajda@samsung.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>, Boris BREZILLON <boris.brezillon@free-electrons.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 05/08/2015 02:53 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 08 May 2015 14:03:01 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
>>> As explained before, the hole idea of subtypes at entities was
>>
>> hole -> whole
>>
>>> not nice. All V4L2 subdevs may have a device node associated.
>>>
>>> Also, the hole idea is to expose hardware IP blocks, so calling
>>> them as V4L2 is a very bad practice, as they were not designed
>>> for the V4L2 API. It is just the reverse.
>>>
>>> So, instead of using V4L2_SUBDEV, let's call the camera sub-
>>> devices with CAM, instead:
>>>
>>> 	MEDIA_ENT_T_V4L2_SUBDEV_SENSOR -> MEDIA_ENT_T_CAM_SENSOR
>>> 	MEDIA_ENT_T_V4L2_SUBDEV_FLASH  -> MEDIA_ENT_T_CAM_FLASH
>>> 	MEDIA_ENT_T_V4L2_SUBDEV_LENS   -> MEDIA_ENT_T_CAM_LENS
>>
>> I would actually postpone this until Laurent has a properties API ready.
>> These entity types are fatally flawed since an entity can combine functions
>> in one. E.g. an i2c device (generally represented as a single entity) might
>> provide for both sensor and flash. Or combine tuner and video decoder, etc.
> 
> Mapping one I2C address as one entity is plain wrong.

I said 'i2c device', not i2c address. That would definitely be wrong. I'm also
not saying that each i2c device (chip) maps always to one entity, although this
is generally true. In the end it depends on the driver author to decide how
to split up the functionality of the device into entities. There is no hard
and fast rule for that.

> So, if a single piece of hardware has the functions of two entities
> (sensor and flash), it should be represented as two separate entities.

Perhaps, perhaps not. There is in the general case no clear rule at what
level you design your entities. In a complex pipeline it would be madness
to map every little HW block to an entity since you would get a zillion
entities, which is highly impractical. The cx25840 combines multiple
functions (tuner, audio/video decoders), and I am not at all sure you
would gain anything from splitting that up into smaller entities. In the
end, if you would write a block diagram of your board the cx25840 would be
a single block. And experience has shown that that is typically the right
level for deciding what will be an entity or not.

Also, in such devices the various functions are often intertwined and
generally not easy to separate.

> 
> The I2C bus would matter if we were mapping the control plane of the
> entities, adding PADs for the control lines. But last time I checked,
> Laurent was still strongly opposed to that.
> 
>> Basically an entity like this is a sub-device (as in the literal meaning
>> of being a part of a larger device) that has one or more functions and may
>> have device node(s) associated with it. That is best expressed as properties.
>>
>> And you really do have to tell userspace that these entities expose a
>> v4l-subdev device node. Renaming them doesn't make that go away.
> 
> Well, we should decide if we want the namespace and the entities
> representing the hardware or representing the Linux API.
> V4L2_SUBDEV has nothing to do with hardware. It is just an abstraction
> that we've created on one of our subsystems.

I agree. MEDIA_ENT_T_V4L2_SUBDEV_SENSOR basically contains two bits of
information: the linux API used to access the entity and the function.

Since you don't combine multiple APIs (e.g. ALSA and V4L2) for a single
device node (I would certainly never allow such code in the kernel!) there
is only one of those, but one entity can certainly combine multiple functions
as I argued for above. Hence, those should be properties.

Anyway, let's wait what Laurent thinks and setup an irc session for this.

Regards,

	Hans
