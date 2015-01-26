From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Mon, 26 Jan 2015 12:17:09 +0100
Message-ID: <1422271029.3133.68.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C50A67.6040306-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

(adding linux-api@ for comments:

 We're introducing a new "uverb" in the InfiniBand subsystem:
 extended QUERY_DEVICE in v3.19:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/core/uverbs_cmd.c?id=3Dv3.19-rc6#n3297
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/rdma/ib_user_verbs.h?id=3Dv3.19-rc6#n209
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/inc=
lude/uapi/rdma/ib_user_verbs.h?id=3Dv3.19-rc6#n224

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D5a77abf9a97a
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D860f10a799c8

 As you may not already know, InfiniBand subsystem use a write()=20
 syscall[1] to issue ioctl()-like operations. Many operations (aka  =20
 verbs) are available [2], for each there's a query data structures
 and for some there's a response data structure [3]. As a result to a=20
 write() operation, kernel could allocate resources on the task behalf=20
 and/or write data back to userspace provided buffers whose pointers=20
 were part of buffer passed to write().

 I've expressed concern on the way the new extended QUERY_DEVICE
 was trying to be itself expandable: by silently ignoring shorter
 buffer, returning truncated data, the interface seems awkward.

"Re: [PATCH v2 06/17] IB/core: Add support for extended query device ca=
ps"
http://mid.gmane.org/1418216676.11111.45.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

"Re: [PATCH v3 06/17] IB/core: Add support for extended query device ca=
ps"
http://mid.gmane.org/1418733236.2779.26.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
http://mid.gmane.org/1418824811.3334.3.camel@dworkin
http://mid.gmane.org/1421844612.13543.40.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

 I recognize the author's intention to provide a way for userspace
 to retrieve easily the highest supported information as something
 desirable.

 But I believe we must be more strict on the request content and
 fail for any unrecognized, unsupported, incorrect bits to make
 safer to extend the interface latter.

 I've submitted a patchset[4] to address these issues.
 But, while I'm convinced it the way to go, I'm not able to find
 how it could be made to satisfy the original author expectations.
=20
 I hope linux-api@ readers could provide some insight regarding
 the way we should implement such interface

[1] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/drivers/infiniband/core/uverbs_main.c?id=3Dv3.19-rc6#n599

[2] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/drivers/infiniband/core/uverbs_main.c?id=3Dv3.19-rc6#n81

[3] http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/include/uapi/rdma/ib_user_verbs.h?id=3Dv3.19-rc6

[4] http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

)

Le dimanche 25 janvier 2015 =C3=A0 17:23 +0200, Haggai Eran a =C3=A9cri=
t :
> On 22/01/2015 15:28, Yann Droneaud wrote:
> > This patch ensures the extended QUERY_DEVICE uverbs request's
> > comp_mask has only known values. If userspace returns unknown
> > features, -EINVAL will be returned, allowing to probe/discover
> > which features are currently supported by the kernel.
>=20
> This probing process will be much more cumbersome than it needs to be
> because userspace will have to call QUERY_DEVICE repetitively with
> different comp_mask fields until it finds out the exact set of suppor=
ted
> bits.
>=20

O(log2(N))

Or you had to add a different interface, dedicated to retrieve the exac=
t
supported feature mask.

> > Moreover, it also ensure the requested features set in comp_mask
> > are sequentially set, not skipping intermediate features, eg. the
> > "highest" requested feature also request all the "lower" ones.
> > This way each new feature will have to be stacked on top of the
> > existing ones: this is especially important for the request and
> > response data structures where fields are added after the
> > current ones when expanded to support a new feature.
>=20
> I think it is perfectly acceptable that not all drivers will implemen=
t
> all available features, and so you shouldn't enforce this requirement=
=2E

With regard to QUERY_DEVICE: the data structure layout depends on the
comp_mask value. So either you propose a way to express multipart data
structure (see CMSG or NETLINK), or we have to ensure the data structur=
e
is ever-growing, with each new chunck stacked over the existing ones:
that's the purpose of :

	if (cmd.comp_mask & (cmd.comp_mask + 1))
		return -EINVAL;

> Also, it makes the comp_mask nothing more than a wasteful version num=
ber
> between 0 and 63.

That's what I've already explained earlier in "Re: [PATCH v3 06/17]
IB/core: Add support for extended query device caps":

http://mid.gmane.org/1421844612.13543.40.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

>=20
> In the specific case of QUERY_DEVICE you might argue that there isn't
> any need for input comp_mask, only for output, and then you may enfor=
ce
> the input comp_mask will always be zero.

The extended QUERY_DEVICE uverbs as currently merged is using comp_mask
from input to choose to report on-demand-paging related value. So it
seems it's needed.

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/core/uverbs_cmd.c?id=3Dv3.19-rc6#n3297

> However, you will in any case need to be able to extended the size of=
 the response in the future.
>=20

That's already the case for on demand paging.

> >=20
> > Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
> > Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infinib=
and/core/uverbs_cmd.c
> > index 8668b328b7e6..80a1c90f1dbf 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -3313,6 +3313,12 @@ int ib_uverbs_ex_query_device(struct ib_uver=
bs_file *file,
> >  	if (err)
> >  		return err;
> > =20
> > +	if (cmd.comp_mask & (cmd.comp_mask + 1))
> > +		return -EINVAL;
> > +
> > +	if (cmd.comp_mask & ~(__u32)IB_USER_VERBS_EX_QUERY_DEVICE_ODP)
> > +		return -EINVAL;
> > +

If we keep the checks on output buffer size from patch 1, returning
-ENOSPC in case of size mismatch, and if we are sure that no bit in
input comp_mask will ever trigger a call to a kernel function that can
make the uverb fail, the latter check on known value could be dropped,
allowing the userspace to set the highest mask (-1): userspace
will use -ENOSPC to probe the expected size of the response buffer
to match the highest supported comp_mask. But it's going to hurt
userspace application not ready to receive -ENOSPC on newer kernel
with extended QUERY_DEVICE ABI ... Oops.

So in this end, the safest way to ensure userspace is doing the correct
thing so that we have backward and forward compatibility is to check
for known values in comp_mask, check for response buffer size and ensur=
e
that data structure chunk are stacked.

The tighter are the checks now, the easier the interface could be
extended latter.

> >  	if (cmd.reserved)
> >  		return -EINVAL;
> > =20
> >=20
>=20

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
