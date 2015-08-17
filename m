From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [RFC] Media Controller, the next generation
Date: Mon, 17 Aug 2015 12:22:30 -0300
Message-ID: <20150817122230.351a8084@recife.lan>
References: <55BF75B4.2060301@xs4all.nl>
	<1553545.72YdKh14yc@avalon>
	<20150816103709.444d59c1@recife.lan>
	<55D1B87A.7010107@xs4all.nl>
	<20150817093923.301ac60b@recife.lan>
	<55D1DFD2.8050807@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D1DFD2.8050807-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Cc: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Em Mon, 17 Aug 2015 15:21:22 +0200
Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:

> On 08/17/2015 02:39 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 17 Aug 2015 12:33:30 +0200
> > Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org> escreveu:
> >> That's not what I meant. I meant using the mc_ prefix instead of the media_
> >> prefix for internal structs. So media_entity in the public API would map to
> >> mc_entity in the internal API. Ditto for media_interface/mc_interface,
> >> media_pad/mc_pad, etc.
> > 
> > Ah! that could work. Yet, I guess we decided to not use mc_ internally
> > in the first place several years ago because there was already some 
> > namespace conflict.
> > 
> > Ah, yes:
> > 
> > $ git grep -e \\bmc_
> > ...
> > arch/powerpc/kernel/mce.c:      struct machine_check_event *mc_evt;
> > arch/powerpc/kernel/mce.c:              mc_evt = this_cpu_ptr(&mce_event[index]);
> > arch/powerpc/kernel/mce.c:                      *mce = *mc_evt;
> > ...
> > arch/um/drivers/line.h: struct mc_device mc;
> > ...
> > arch/um/drivers/net_kern.c:static struct mc_device net_mc = {
> > ...
> > 
> > A total of 302 references... Among them, some arch-dependent stuff,
> > including x86 and powerPC error hanlding stuff (MCE, APEI).
> > 
> > I would avoid it, as the risk of namespace collisions are high.
> 
> OK.
> 
> > 
> >> Using graph_ instead of mc_ is something I would be OK with as well.
> 
> What about graph_ as the internal prefix? Or mctl_?
> 
> >> I am a bit worried about this. To my knowledge applications that use the MC
> >> today are expected to know which pad of an entity does what, and it identifies
> >> the pad by index.
> >>
> >> The new public API should still provide applications with this information in
> >> one way or another. The pad ID won't work, certainly not in the dynamic case,
> >> the PAD_TYPE as suggested here will only work as long as there is only one
> >> pad per type. Suppose there is an entity with two output pads, both for video?
> >> One might be SDTV, one HDTV. How to tell the difference?
> > 
> > The first one will have "SDTV" as type, the other one "HDTV". So, no problem
> > with that.
> 
> So now we have SDTV and HDTV, the next entity will have YUV_420 and YUV_422 pads,
> or whatever. The number of types will quickly escalate. It's similar to the
> 'entity type' problem (e.g. sensor, flash, video encoder, scaler, etc.).

well, as new pads will require new Kernel patches, nothing prevents to add
a new #define. A string would also work.

> > 
> > There are, however, some usages where an index is enough. For example, the
> > hardware demux filter outputs can fully be identified by just an index, and
> > each index could (ideally) be mapped into a different DMA.
> > 
> > So, I guess we need to offer the flexibility to keep using indexes where
> > it makes sense.
> > 
> > That's why I proposed a find_pad function that would allow to use an
> > index:
> > 	media_pad *find_pad(struct media_entity entity, enum pad_usage usage, int idx);
> > or
> >  	media_pad *find_pad(struct media_entity entity, char *pad_name);
> > 
> >> One option might be to have a pad_type or data_type for basic type information
> >> to have generic code that just wants to find VBI/VIDEO/AUDIO streaming pads,
> >> and a name[32] field that is uniquely identifying the pad and that can be used
> >> in userspace applications (or drivers for that matter by adding a find_pad_name()).
> > 
> > just a name could be enough:
> > 	vbi_pad = find_pad(entity, "vbi");
> > 
> > However, that would require to have a strict namespace if we want the core
> > to rely on it.
> 
> I think names would work: we can make a number of 'core' names that should be
> used where appropriate, and leave it up to the driver otherwise.

OK.

> So if there is only one video source pad, then call the pad "video". If there
> are multiple video source pads, then zero or one pads can be called "video",
> the others should get different names "video-sdtv").
> 
> To be honest, I'm not terribly keen on this. I think a data/pad type + name
> would work better.

Me too.

> >>> };
> >>>
> >>> And have the structs with (some) properties embed on it, like:
> >>>
> >>> struct media_graph_entity {
> >>> 	struct media_graph_object obj;
> >>
> >> This doesn't make sense: struct media_graph_topology would fill in an
> >> array of struct media_graph_object would point to media objects that
> >> in turn contain a struct media_graph_object.
> > 
> > Sorry, I didn't get your idea. Could you please give a C code example on
> > what you're thinking?
> > 
> >>
> >> I wouldn't embed a struct media_graph_object in these structs, there
> >> is no point to that. Thinking about this some more you don't need the
> >> length field either, only an id (this gives you the type, so you know
> >> whether the object_data pointer is for a media_entity or a media_pad
> >> or whatever) and the pointer. Strictly speaking you would only need
> >> the 'type' part of the ID, but I see no reason not to fill in the full
> >> ID.
> >>
> >>> 	u32 flags;
> >>> 	/* ... */
> >>> 	char name[64];
> >>> };
> >>>
> >>> Please notice that we don't need to add reserved fields at the structs,
> >>> as we're now putting the struct length at the media_graph_object.
> >>>
> >>> So, if we need to, for example, add a new "foo" inside the
> >>> media_graph_entity:
> >>>
> >>> struct media_graph_entity {
> >>> 	struct media_graph_object obj;
> >>> 	u32 flags;
> >>> 	/* ... */
> >>> 	char name[64];
> >>> 	u32 foo;
> >>> };
> >>
> >> No, you can't. Say you've compiled the application with a header that includes
> >> the foo field, and then you run the same application with an older kernel that
> >> doesn't have the foo field. Any access to foo would give garbage back (or fail).
> >>
> >> You really need those reserved fields. The alternative would be to mess around
> >> with different struct versions, and that's painful.
> > 
> > No. The length will do that. All we need to do is to document that the data
> > should be zeroed on userspace before filling the data from G_TOPOLOGY.
> > 
> > For example:
> > 
> > let's say that, on Kernel 4.3: this is declared as:
> > struct media_graph_entity {
> >  	struct media_graph_object obj;
> >  	u32 flags;
> >  	char name[64];
> > };
> > 
> > And, on Kernel 4.4, the new "foo" field got introduced:
> > 
> > struct media_graph_entity {
> >  	struct media_graph_object obj;
> >  	u32 flags;
> >  	char name[64];
> >  	u32 foo;
> > };
> > 
> > Of course, just like we do with reserved fields, we should ensure that
> > old apps can live without the "foo" field, and that new apps will
> > keep working with older Kernels.
> > 
> > Now, we have:
> > 	
> > The length of the data on 4.3 is: sizeof(obj) + 68
> > The length of the data on 4.4 is: sizeof(obj) + 72
> > 
> > As per my proposal, we need to pass the length for the public API
> > object.
> > 
> > struct media_graph_object {
> >  	u32 length;
> >  	u32 type;
> >  	u32 id;
> > 	void *data;
> > }  __attribute__ ((packed));
> > 
> > An application for the G_TOPOLOGY would do something like:
> > 	
> >  /* p is the pointer for the data returned from Kernel */
> > struct media_graph_entity
> > get_an_entity_graph_obj(struct media_graph_obj *obj)
> > {
> > 	struct media_graph_entity *ent;
> > 	int len;
> > 
> > 	len = sizeof(*ent);
> > 	if (len > obj->length)
> > 		len = obj->length;
> > 
> > 	ent = calloc(len, 1);
> > 	memcpy (ent, obj->data, len);
> > 
> > 	return ent;
> > }
> 
> OK, so everything has to be copied in userspace, unpacking the objects.

Well, that's one way, to just quickly express what I meant to say ;)

It is possible to avoid that using other data representations on
userspace, like having a get_field() macro that would return zero
if trying to access past the length.

> > 
> > There are three cases:
> > 
> > 1) both app and Kernel are compiled against the same headers
> > 
> > No problem.
> > 
> > 2) app is compiled against v4.4 headers
> >    kernel compiled against v4.3 headers
> > 
> > As the struct were zeroed before memcpy, all entities will have foo = 0.
> > 
> > No problem.
> > 
> > 3) app is compiled against v4.3 headers
> >    kernel compiled against v4.4 headers
> > 
> > As the struct won't have the "foo" field, and it will be ignored.
> > 
> > No problem.
> > 
> > So, I don't see any usage to add reserved fields.
> > 
> >>
> >>>
> >>> There are some advantages of this approach:
> >>> - If the size of the entity will change, and obj.length will be bigger.
> >>>   Userspace will allocate more space to store the object, but will be
> >>>   backward compatible;
> >>> - We can add new object types anytime. If userspace doesn't know the new
> >>>   type, it should simply discard the object and go to the next one. Again,
> >>>   backward compatible.
> >>>
> >>> We may eventually add a way for userspace to request only a subset of
> >>> the graph elements or to add an ioctl or some other sort of event that
> >>> will report topology changes.
> >>
> >> It's an option, but the first 'advantage' doesn't actually work, and I am
> >> not sure about the second. Yes, it is an advantage but it comes at a price:
> >> the void pointer. I very much prefer strict typing.
> > 
> > See above.
> > 
> > We can avoid the void pointer with something like:
> > 
> > struct media_graph_object {
> >  	u32 length;
> >  	u32 type;
> 
> Type can be dropped.

I guess you meant to say that it can be merged with ID. Yes, agreed.

> >  	u32 id;
> > }  __attribute__ ((packed));
> > 
> > struct media_graph_entity {
> > 	struct media_graph_object obj;
> >  	char name[64];
> > }  __attribute__ ((packed));
> 
> This makes more sense without the pointer. But this also means that the
> objects pointer in media_graph_topology isn't an array. Instead the
> next graph object starts at ((void *)objects + objects->length).

Either that or we'll have an array of pointers, or, as suggested during
the MC, offsets that will be converted into pointers with something like:

	obj[4] += obj_base;

> 
> > 
> > Of course, length is needed, in order to avoid filling it with reserved
> > stuff.
> > 
> >>
> >> BTW, my initial proposal had a __u32 reserved[64] field, I'd redo that as
> >> follows:
> >>
> >> 	struct
> >> 		__u32 num_reserved;
> >> 		void *ptr_reserved;
> >> 	} reserved[32];
> >>
> >> This will make 32/64 bit pointer size differences much easier to handle.
> >>
> >> And in my opinion, if we end up with so many different object types, then
> >> we have a much bigger problem and another redesign would be required.
> > 
> > Redesign the API because we add more things is crappy! We should do
> > something that, ideally, will never require us to redesign it again.
> 
> That's not what I meant. If we end up with so many different object types,
> then the MC API has gone crazy and becomes unusable. 

Well, we currently have 80+ ioctls at V4L2, and it is still usable.

> The MC is supposed
> to have just a few types: originally entity, pad, link and now we are adding
> interface and property. 

And, from your own suggestions: connectors

> Perhaps there will be one or two more, but if we
> end up with 30 types, then there is something seriously wrong.

I agree that 30 sounds a good number, but the thing is: it is hard to
tell that in advance. As we add support for other subsystems like IIO,
different needs could popup.

For example, if I remember well, on IIO, PADs aren't needed. So we
may end by having some pad-less type of entity to fulfill its
needs.

The thing is: APIs generally start simple, but tend to grow as new
needs happen. See the crop/scaler thing... every time we discuss that,
new proposals to extend the API by creating a new ioctl or a new
type of crop that we didn't foresee in the past discussions.

> >> In general, I prefer strict typing over void pointers, and having to cast
> >> all the time is something I'd really like to avoid. This API also gives
> >> you filtering for free (just leave the relevant pointers NULL).
> > 
> > Adding a filter field is not hard, and, as pointed above, we don't need
> > void pointers.
> 
> Doing it this way means that you return a blob that needs to be unpacked
> first. It's useless without that unpacking step. Is that what I want? I
> would like to hear what others think about this. It makes this a very
> complicated and hard-to-use ioctl.

Using a single ioctl to pack different things will always require some
unpacking/parsing effort on the other side, whatever approach we take.

That's why I think we should have a way to report topology changes as
well.

> 
> Regards,
> 
> 	Hans
> 
