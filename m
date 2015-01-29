From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 19:35:14 +0100
Message-ID: <1422556514.3133.165.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com> <1422271029.3133.68.camel@opteya.com>
	 <54C73549.5000003@mellanox.com> <1422451151.3133.130.camel@opteya.com>
	 <20150129180956.GG11842@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150129180956.GG11842-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 29 janvier 2015 =C3=A0 11:09 -0700, Jason Gunthorpe a =C3=A9cr=
it :
> On Wed, Jan 28, 2015 at 02:19:11PM +0100, Yann Droneaud wrote:
>=20
> > But the same program (either binary or source code) might fail on
> > newer kernel where some bits in comp_mask gain a meaning not suppor=
ted
> > by the program.
>=20
> To clarify some of this:
>=20
> The intention of the comp_mask scheme was to define a growing
> structure.
>=20
> The invariant is: A bigger structure allways has all smaller
> structures (past versions) as a prefix.
>=20
> So the size alone is enough for user space to know what is going
> on. userspace only processes structure members up to the size returne=
d
> by the kernel, and there is only one structure layout.
>=20

Unfortunately, the userspace don't get the size of the returned data:
it's only a single "write()" syscall after all.

So the kernel is left with the comp_mask in the response to express
the returned size.

> The purpose of the output comp_mask is to allow drivers to declare
> they do not support the new structure members, and comp_mask bits
> should only be used with new structure members do not have a natural
> 'null' value.
>=20

It's not (yet) about drivers as the output's comp_mask (in the=20
response), is set by uverbs layer.

Do you think we have to enforce a 1 to 1 relation between the request=20
comp_mask's bits and the response comp_mask's bits ?

That would not fit with my understanding of "Extending Verbs API"=20
presentation [1]: request's comp_mask describe the fields present in=20
the request and response's comp_mask describe the fields present in the=
=20
response.

> Further, we need to distinguish cases where additional data is
> mandatory or optional.
>=20
> query_device is clearly optional, the only purpose the input comp mas=
k
> serves is to reduce expensive work in the driver by indicating that
> some result bits are not needed.

That's not how I've understand the purpose of the request's comp_mask
after reading the presentation: request's comp_mask describe the conten=
t
of the request. Then that additional content can trigger the presence=20
of additional fields in the response if needed.

>  It is perfectly OK for the kernel to
> ignore the input comp mask, and OK for userspace to typically request
> all bits. (indeed, I think this is a pretty silly optimization myself=
,
> and the original patch that motivated this was restructured so it is
> not needed)
>=20

It's not at all OK to ignore request's comp_mask: it has to be checked
to find if there's a feature requested the kernel cannot fullfil, and=20
any unknown bit is a possible feature request. So the kernel has to=20
reject the request as a whole as it don't know how to process it.

As we don't know yet how we would extend the extended QUERY_DEVICE
uverbs, the kernel have to refuse any random value.

http://blog.ffwll.ch/2013/11/botching-up-ioctls.html


> Other verbs must be more strict, if one side does not understand the
> comp mask then the verb must fail in some way. Presumably the valid
> comp mask values are inferred in some way (eg query_device says the
> extended function is supported)
>=20

> Everything should fit in one of those two general cases..

I believe every interface should return an error for any unknown value
(every unused bits of a data structure), that is, there's only one case=
=2E

>  =20
> > Thanks for the link to the presentation.
>=20
> If I recall the presentation is old and had some flaws that were
> addressed before things made it into libibverbs..
>=20

I have to have a look to this part of libibverbs: I'm not sure
the extended QUERY_DEVICE is already implemented.

> Thank you for looking at this, it is very important that this scheme
> is used properly, and it is very easy to make mistakes. I haven't had
> time to review any of these new patches myself.
>=20

I hope you would find some time to review my latest patchset
so that we don't miss a corner case. It's starting to become urgent.

Regards.

--=20
Yann Droneaud
OPTEYA
