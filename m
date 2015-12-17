From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] [media] uapi/media.h: Use u32 for the number of graph
 objects
Date: Thu, 17 Dec 2015 10:45:56 -0200
Message-ID: <20151217104556.70d4f0f8@recife.lan>
References: <40e950dbb6a3b7f73da52e147fa51441b762131a.1450350558.git.mchehab@osg.samsung.com>
	<5672A69F.7020505@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <5672A69F.7020505@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org, Javier Martinez Canillas <javier@osg.samsung.com>
List-Id: linux-api@vger.kernel.org

Em Thu, 17 Dec 2015 13:12:15 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 12/17/15 12:09, Mauro Carvalho Chehab wrote:
> > While we need to keep a u64 alignment to avoid compat32 issues,
> > having the number of entities/pads/links/interfaces represented
> > by an u64 is incoherent with the ID number, with is an u32.
> > 
> > In order to make it coherent, change those quantities to u32.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  include/uapi/linux/media.h | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> > index cacfceb0d81d..5dbb208e5451 100644
> > --- a/include/uapi/linux/media.h
> > +++ b/include/uapi/linux/media.h
> > @@ -330,16 +330,20 @@ struct media_v2_link {
> >  struct media_v2_topology {
> >  	__u64 topology_version;
> >  
> > -	__u64 num_entities;
> > +	__u32 num_entities;
> > +	__u32 reserved1;

For the sake of later comments, let's call this proposal as:

alternative (1): one PAD field per num_foo, just after it.

> 
> Would a name like reserved_entities, reserved_pads, etc. be better?
> Not sure.

Not sure either.

> 
> Anyway, I like this since we might want to turn the reserved fields into,
> say, flags later.

It sounds very unlikely that we would need 4 reserved flags.

---

Just to keep it registered at the same place, Javier is in holidays
until Monday, but he commented about that at the IRC today:

(10:02:45) javier__: sailus: hi, I,m on holidays until Monday so not paying too much attention to irc and mail
(10:04:02) javier__: mchehab: I disagree with your patch that adds fields for alignment
(10:04:27) javier__: mchehab: those are not needed if you reorder your struct fields
(10:04:47) javier__: i.e all u64 first and theb u32
(10:05:42) mchehab: javier__: reordering may not be a good idea, if we need to extend the struct in the future
(10:05:56) mchehab: but yeah, for now this would be another alternative
(10:06:40) mchehab: please reply to the e-mail when you have time, as more people may comment on the possible alternatives
(10:06:47) mchehab: and it is better registered than on IRC
(10:09:12) javier__: mchehab: yes, I'm commenting here since I didn't bring my laptop and my email client in my phone doesn't wrap lines correctly
(10:09:22) javier__: but can do it on Monday
(10:10:35) javier__: mchehab: I think that if the ABI is found to need extension then a v2 of the ioctl is better with a diff struct
(10:11:12) javier__: or you could have a zero length field at the need (not sure about this one though)
(10:11:32) javier__: *at the end

If I understood well, he's proposing to do is:

struct media_v2_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u32 num_pads;
        __u32 num_links;

        __u64 ptr_entities;
        __u64 ptr_interfaces;
        __u64 ptr_pads;
        __u64 ptr_links;
};

The problem is that, if we latter need to extend it to add a new type
the extension will not be too nice. For example, I did some experimental
patches adding graph groups:
	http://git.linuxtv.org/mchehab/experimental.git/commit/?h=mc_next_gen.v8.3%2btest%2bWIP&id=37b40849506002c01d98c6aa3aef66c3cc39ecee

If we find this useful in some future and we need to export such
information to userspace, that would mean that would have to add
a media_v2_group struct:

struct media_v2_group {
	__u32 id;
	/* some other data */
};

We'll need then to add a num_groups and a ptr_groups. If we 
follow the above logic, we would need to add a pad field and
increment the struct number:

alternative (2): create a "packed" new version every time a new
type is needed with, at most, a single "PAD" field.

struct media_v3_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u32 num_pads;
        __u32 num_links;
	__u32 num_groups;	/* new */
	__u32 pad; /* to be used in the future */

        __u64 ptr_entities;
        __u64 ptr_interfaces;
        __u64 ptr_pads;
        __u64 ptr_links;
	__u64 ptr_groups;	/* new */
};

the old struct will needed to be maintained as the new definition
is incompatible with the previous one. Then, we'll need two parser
functions, one for each structure version.

alternative (3): use a "packed" struct at the beginning, but
adding new fields always at the bottom with a per-new field
PAD:

struct media_v2_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u32 num_pads;
        __u32 num_links;
        __u64 ptr_entities;
        __u64 ptr_interfaces;
        __u64 ptr_pads;
        __u64 ptr_links;

	__u32 num_groups;
	__u32 pad; /* to be used in the future */
	__u64 ptr_groups;
};

And this would be ugly. It would also mean that, for every late-added
graph type, a new pad would be needed.


There's another alternative approach:

Alternative (4): To group graph elements in couples, having, at most,
one PAD if the number of elements are ODD (e. g. one incomplete couple).

struct media_v2_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u64 ptr_entities;
        __u64 ptr_interfaces;

        __u32 num_pads;
        __u32 num_links;
        __u64 ptr_pads;
        __u64 ptr_links;
};

This way, we would have pads only if the number of graph objects
are odd. So, for the version with our new media_group, this would
be:

struct media_v2_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u64 ptr_entities;
        __u64 ptr_interfaces;

        __u32 num_pads;
        __u32 num_links;
        __u64 ptr_pads;
        __u64 ptr_links;

	__u32 num_groups;
	__u32 pad; /* to be used in the future */
	__u64 ptr_groups;
};

And a new version with another "bar" type:

struct media_v2_topology {
        __u64 topology_version;

       	__u32 num_entities;
        __u32 num_interfaces;
        __u64 ptr_entities;
        __u64 ptr_interfaces;

        __u32 num_pads;
        __u32 num_links;
        __u64 ptr_pads;
        __u64 ptr_links;

	__u32 num_groups;
	__u32 num_bars;
	__u64 ptr_groups;
	__u64 ptr_bars;
};

I'm not sure what's the best alternative, but I would either to stick
with either alternative (1) or (4).

Regards,
Mauro
