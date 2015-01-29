From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 22:14:29 +0100
Message-ID: <1422566069.3133.218.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com> <1422271029.3133.68.camel@opteya.com>
	 <54C73549.5000003@mellanox.com> <1422451151.3133.130.camel@opteya.com>
	 <20150129180956.GG11842@obsidianresearch.com>
	 <1422556514.3133.165.camel@opteya.com>
	 <20150129191423.GL11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129191423.GL11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Le jeudi 29 janvier 2015 =C3=A0 12:14 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Thu, Jan 29, 2015 at 07:35:14PM +0100, Yann Droneaud wrote:
>=20
> > Unfortunately, the userspace don't get the size of the returned dat=
a:
> > it's only a single "write()" syscall after all.
>=20
> A write syscall that behaves nothing like write() actually should, so
> I don't see why we can't have
>=20
> resp_len =3D write(fd,inout_buf,sizeof(input_len));
>=20
> Returning 0 from write makes no sense at all.
>=20

0 is not the result of the write() syscall, as for extended uverbs
I've ensure the return value of the write() syscall was the size
it was given. See
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/core/uverbs_main.c?id=3Dv3.19-rc6#n599

    705                 err =3D uverbs_ex_cmd_table[command](file,
    706                                                    &ucore,
    707                                                    &uhw);
    708=20
    709                 if (err)
    710                         return err;
    711=20
    712                 return written_count;

See commit f21519b23c1 ("IB/core: extended command: an improved
infrastructure for uverbs commands")

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Df21519b23c1b6fa25366be4114ccf7fcf1c190f9

> In the fullness of your patchset it will maintain the invariant that
> resp_len <=3D sizeof(input_len)
>=20

I don't catch your point: the response can be bigger than the request.

> Which seems OK to me considering what we have to work with, and a
> significantly better choice than 0.
>=20
> > So the kernel is left with the comp_mask in the response to express
> > the returned size.
>=20
> It was never the intent that the size should be computed from
> comp_mask. If the size is necessary it must be explicit.
>=20
> In this instance if the size is not returned then libibverbs will hav=
e
> to zero the entire user buffer before passing it to the kernel,
> because it has to ensure any tail for the user app is 0'd.
>=20

The proposed patch ensure the integrity of the response regarding
comp_mask: if a bit is set in response's comp_mask that means the
related fields are presents (and valid).

So before parsing the response fields, userspace have to check
response's comp_mask: fields access must be protected by correct
check on comp_mask ... but it might be useful for the userspace
developer to clear the response buffer just in case he/she decided
to be lazy with the check.

> Remember for santity we want comp mask bits for things that can't be =
0

=46or me, it's better if a bit is set in response's comp_mask by the=20
kernel when the kernel have written something in the related fields=20
even if the those fields are all 0.

> and we want 0 for things that are not set.
>=20
> struct ib_query_device_ex res;
> ibv_query_device_ex(..,res,sizeof(res));
>=20
> printf("%u",res.foo_cap); // 0 if unsupported is OK
> if (res.comp_mask & COMP_BAR)
>   printf("%u",res.bar_thingy);  // 0 has meaning, must use COMP_BAR
>=20
> Ideally we want to minimize the number of COMP bits because it is a
> huge burden on the end user to work with them.
>=20

Sure. So I think comp_mask is just an overly complicated way of
expressing the version and the size of the response.

> > > The purpose of the output comp_mask is to allow drivers to declar=
e
> > > they do not support the new structure members, and comp_mask bits
> > > should only be used with new structure members do not have a natu=
ral
> > > 'null' value.
>=20
> > It's not (yet) about drivers as the output's comp_mask (in the=20
> > response), is set by uverbs layer.
> >=20
> > Do you think we have to enforce a 1 to 1 relation between the reque=
st=20
> > comp_mask's bits and the response comp_mask's bits ?
>=20
> In the query context I would be happy enough to just treat the in
> bound buffer as uninitialized buffer space, but certainly generally
> speaking the comp_mask+size should refer to the structure - so
> input/output are not directly related.
>=20

OK.

> > > Further, we need to distinguish cases where additional data is
> > > mandatory or optional.
> > >=20
> > > query_device is clearly optional, the only purpose the input comp=
 mask
> > > serves is to reduce expensive work in the driver by indicating th=
at
> > > some result bits are not needed.
> >=20
> > That's not how I've understand the purpose of the request's comp_ma=
sk
> > after reading the presentation: request's comp_mask describe the co=
ntent
> > of the request. Then that additional content can trigger the presen=
ce=20
> > of additional fields in the response if needed.
>=20
> Agreed - what I described was an abuse that some early Mellanox
> patches for a query_ex included and it was just a shortcut to avoid
> defining a dedicated input structure. It seems that same scheme was
> copied into these new patches.
>=20

OK

> > >  It is perfectly OK for the kernel to
> > > ignore the input comp mask, and OK for userspace to typically req=
uest
> > > all bits. (indeed, I think this is a pretty silly optimization my=
self,
> > > and the original patch that motivated this was restructured so it=
 is
> > > not needed)
> > >=20
> >=20
> > It's not at all OK to ignore request's comp_mask: it has to be chec=
ked
> > to find if there's a feature requested the kernel cannot fullfil, a=
nd=20
> > any unknown bit is a possible feature request. So the kernel has to=
=20
> > reject the request as a whole as it don't know how to process it.
>=20
> In the context of the above scheme the input structure was just this:
>=20
> struct query_input
> {
>   u64 requested_output;
> };
>=20
> ie it wasn't actually a comp_mask, it just overlapped the comp_mask
> bytes on output.
>=20
> Such a use was never explicitly documented, and IIRC was never
> actually included in libibverbs.
>=20

OK

> Unless someone has a strong reason we need to do this I am inclined t=
o
> think that your interpretation is the better one, and we could always
> add a requested_output to the input someday if it became urgent.
>=20

Sure one field can be added later: in such case, one bit of request's
comp_mask will gain the meaning: "request_output field is present in th=
e
request".

> In any event, you are right, we can't ingore the input bytes today an=
d
> expect to give them meaning tomorrow.
>=20

Sure.

> > As we don't know yet how we would extend the extended QUERY_DEVICE
> > uverbs, the kernel have to refuse any random value.
> >=20
> > http://blog.ffwll.ch/2013/11/botching-up-ioctls.html
>=20
> or the kernel treats QUERY_DEVICE as an output only function and neve=
r
> inspects the in/out buffer at all.
>=20

It's something we could think of but the extended uverbs is already
merge with the comp_mask field in the request and it cost only 4 bytes,
while allowing us to make mistake on the first iteration of the extende=
d
QUERY_DEVICE uverb (provided we manage to add the check for the field
being 0).

> > > > Thanks for the link to the presentation.
> > >=20
> > > If I recall the presentation is old and had some flaws that were
> > > addressed before things made it into libibverbs..
> >=20
> > I have to have a look to this part of libibverbs: I'm not sure
> > the extended QUERY_DEVICE is already implemented.
>=20
> The patches turned out to be unnecessary and were dropped, IIRC.
> =20

OK.

> > > Thank you for looking at this, it is very important that this sch=
eme
> > > is used properly, and it is very easy to make mistakes. I haven't=
 had
> > > time to review any of these new patches myself.
>=20
> > I hope you would find some time to review my latest patchset so tha=
t
> > we don't miss a corner case. It's starting to become urgent.
>=20
> I have and will, thank you
>=20

:)

Thanks.

Regards.

--=20
Yann Droneaud
OPTEYA
