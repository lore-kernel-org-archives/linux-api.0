From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Wed, 28 Jan 2015 14:19:11 +0100
Message-ID: <1422451151.3133.130.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com> <1422271029.3133.68.camel@opteya.com>
	 <54C73549.5000003@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C73549.5000003-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le mardi 27 janvier 2015 =C3=A0 08:50 +0200, Haggai Eran a =C3=A9crit :
> On 26/01/2015 13:17, Yann Droneaud wrote:
> > ...
> > Le dimanche 25 janvier 2015 =C3=A0 17:23 +0200, Haggai Eran a =C3=A9=
crit :
> >> On 22/01/2015 15:28, Yann Droneaud wrote:
> >>> This patch ensures the extended QUERY_DEVICE uverbs request's
> >>> comp_mask has only known values. If userspace returns unknown
> >>> features, -EINVAL will be returned, allowing to probe/discover
> >>> which features are currently supported by the kernel.
> >>
> >> This probing process will be much more cumbersome than it needs to=
 be
> >> because userspace will have to call QUERY_DEVICE repetitively with
> >> different comp_mask fields until it finds out the exact set of sup=
ported
> >> bits.
> >>
> >=20
> > O(log2(N))
>=20
> I don't think user space developers will be happy having to do trial =
and=20
> error to determine what features the kernel driver supports. It might=
 be=20
> even more then O(log2(N)). If my understanding of comp_mask bits usag=
e is=20
> correct it would O(N). But it's not the time complexity I'm worried a=
bout,
> it's the fact that it requires user-space developers to go through ho=
ops in
> order to get information that can be much more easily exported.
>=20

But there's currently *NO* such mean that could give a hint to userspac=
e
developer whether one bit of request's comp_mask is currently effective
in extended QUERY_DEVICE uverbs. While we have such mean in CREATE_FLOW
and DESTROY_FLOW: unsupported bits trigger -EINVAL.

In QUERY_DEVICE, userspace developer is allowed to set request's=20
comp_mask to -1: it won't hurt it on current kernel, so why not using=20
this value or any other random value ? The program will run: it's "Work=
s
=46or Me".

But the same program (either binary or source code) might fail on
newer kernel where some bits in comp_mask gain a meaning not supported
by the program.

> > Or you had to add a different interface, dedicated to retrieve the =
exact
> > supported feature mask.
> >=20
> >>> Moreover, it also ensure the requested features set in comp_mask
> >>> are sequentially set, not skipping intermediate features, eg. the
> >>> "highest" requested feature also request all the "lower" ones.
> >>> This way each new feature will have to be stacked on top of the
> >>> existing ones: this is especially important for the request and
> >>> response data structures where fields are added after the
> >>> current ones when expanded to support a new feature.
> >>
> >> I think it is perfectly acceptable that not all drivers will imple=
ment
> >> all available features, and so you shouldn't enforce this requirem=
ent.
> >=20
> > With regard to QUERY_DEVICE: the data structure layout depends on t=
he
> > comp_mask value. So either you propose a way to express multipart d=
ata
> > structure (see CMSG or NETLINK), or we have to ensure the data stru=
cture
> > is ever-growing, with each new chunck stacked over the existing one=
s:
> > that's the purpose of :
> >=20
> > 	if (cmd.comp_mask & (cmd.comp_mask + 1))
> > 		return -EINVAL;
> >=20
> >> Also, it makes the comp_mask nothing more than a wasteful version =
number
> >> between 0 and 63.
> >=20
> > That's what I've already explained earlier in "Re: [PATCH v3 06/17]
> > IB/core: Add support for extended query device caps":
> >=20
> > http://mid.gmane.org/1421844612.13543.40.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>=20
> Yes, you wrote there:
> > Regarding comp_mask (not for this particular verb):
> >=20
> > It's not clear whether request's comp_mask describe the request or =
the
> > response, as such I'm puzzled.
> >=20
> > How would the kernel and the userspace be able to parse the request=
 and
> > the response if they ignore unknown bits ?
> >=20
> > How would they be able to skip the unrecognized chunk of the reques=
t and
> > response buffer ?
> >=20
> > How one bit in a comp_mask is related to a chunk in the request or
> > response ?
> >=20
> > It's likely the kernel or userspace would have to skip the remainin=
g
> > comp_mask's bits after encountering an unknown bit as the size of t=
he
> > corresponding chunk in request or response would be unknown, making
> > impossible to locate the corresponding chunk for the next bit set i=
n
> > comp_mask. Having said that, comp_mask is just a complicated way of
> > expressing a version, which is turn describe a size (ever growing).
>=20
> It is my understanding that each comp_mask bit marks a set of fields =
in=20
> the command or in the response struct as valid, so the struct format=20
> remains the same and the kernel and userspace don't need to make=20
> difficult calculation as to where each field is, but you can still pa=
ss=20
> a high bit set in comp_mask with one of the lower bits cleared.
>=20

How can the struct format remain the same, if some fields are added
to implement newer feature ?

> I couldn't find this explicit detail in the mailing list, but I did f=
ound
> a presentation that was presented in OFA International Developer=20
> Workshop 2013 [1], that gave an example of of an verb where each=20
> comp_mask bit marked a different field as valid.
>=20

Thanks for the link to the presentation.

As I read it the presentation:

- in request, comp_mask give hint to the kernel of additional fields in
the request.

- in response, comp_mask give hint to userspace regarding the presence
of additional fields in the response.

But commit 860f10a799c8 ("IB/core: Add flags for on demand paging
support") on top of commit 5a77abf9a97a ("IB/core: Add support for
extended query device caps") is not doing it the expected way
as one bit set in request's comp_mask has direct effect on
the response's fields.

To be conformant with the "Extending Verbs API" presentation,
no check should be done on request's comp_mask, and on-demand paging
information should be returned to userspace in all case, provided=20
there's enough room in the response buffer.

Anyway, allowing userspace to set any "hint" in the request's comp_mask
is opening a pandora box: being allowed to set any value, userspace
program will use any random value, as it will work with current kernel.

But the same program used on newer kernel is going to trigger some
behavior unknown to the application or return an error the application
is not ready to handle ... breaking any kind of forward compatibility=20
promise.

It's likely the kernel will have to use the size of the request to=20
guess the hints in comp_mask are corrects to handle such. In such case,=
=20
relying only on the size of the request might be enough to detect=20
extended request, without the need for comp_mask.

Regarding the answer, if the response buffer is smaller than the size
of the extended response, will the kernel keep setting the response's=20
comp_mask with all the bits it supports or will it unset the bits for=20
the fields it wasn't able to fit in the response buffer ?

It's likely the kernel will have to use the size of the response buffer=
=20
to set the response's comp_mask.=20

Instead commit 860f10a799c8 ("IB/core: Add flags for on demand paging
support") on top of commit 5a77abf9a97a ("IB/core: Add support for
extended query device caps") make it possible for the kernel to return
truncated response with full comp_mask. Such is going to break silently=
=20
when one will introduce a data structure with an ABI mismatch between
userspace and kernel (for example x86 vs amd64 ... we have some recent
exemples).

> >=20
> >>
> >> In the specific case of QUERY_DEVICE you might argue that there is=
n't
> >> any need for input comp_mask, only for output, and then you may en=
force
> >> the input comp_mask will always be zero.
> >=20
> > The extended QUERY_DEVICE uverbs as currently merged is using comp_=
mask
> > from input to choose to report on-demand-paging related value. So i=
t
> > seems it's needed.
> >=20
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree=
/drivers/infiniband/core/uverbs_cmd.c?id=3Dv3.19-rc6#n3297
> >=20
> >> However, you will in any case need to be able to extended the size=
 of the response in the future.
> >>
> >=20
> > That's already the case for on demand paging.
> >=20
> >>>
> >>> Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud@opteya.=
com
> >>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> >>> ---
> >>>  drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
> >>>  1 file changed, 6 insertions(+)
> >>>
> >>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infin=
iband/core/uverbs_cmd.c
> >>> index 8668b328b7e6..80a1c90f1dbf 100644
> >>> --- a/drivers/infiniband/core/uverbs_cmd.c
> >>> +++ b/drivers/infiniband/core/uverbs_cmd.c
> >>> @@ -3313,6 +3313,12 @@ int ib_uverbs_ex_query_device(struct ib_uv=
erbs_file *file,
> >>>  	if (err)
> >>>  		return err;
> >>> =20
> >>> +	if (cmd.comp_mask & (cmd.comp_mask + 1))
> >>> +		return -EINVAL;
> >>> +
> >>> +	if (cmd.comp_mask & ~(__u32)IB_USER_VERBS_EX_QUERY_DEVICE_ODP)
> >>> +		return -EINVAL;
> >>> +
> >=20
> > If we keep the checks on output buffer size from patch 1, returning
> > -ENOSPC in case of size mismatch, and if we are sure that no bit in
> > input comp_mask will ever trigger a call to a kernel function that =
can
> > make the uverb fail, the latter check on known value could be dropp=
ed,
> > allowing the userspace to set the highest mask (-1): userspace
> > will use -ENOSPC to probe the expected size of the response buffer
> > to match the highest supported comp_mask. But it's going to hurt
> > userspace application not ready to receive -ENOSPC on newer kernel
> > with extended QUERY_DEVICE ABI ... Oops.
> >=20
> > So in this end, the safest way to ensure userspace is doing the cor=
rect
> > thing so that we have backward and forward compatibility is to chec=
k
> > for known values in comp_mask, check for response buffer size and e=
nsure
> > that data structure chunk are stacked.
> >=20
> > The tighter are the checks now, the easier the interface could be
> > extended latter.
>=20
> I understand this position, and I generally agree, but I think that=20
> specifically for a verb like QUERY_DEVICE that only reads information=
 from=20
> the kernel driver to user-space, there is no harm in the kernel just=20
> providing all the information it can fit in the response buffer provi=
ded=20
> by user-space.
>=20

Returning as much as possible information to userspace is OK,
but it's doing it the wrong way.

I'm not specifically discussing QUERY_DEVICE, as I'm concerned with=20
every extended uverbs to be added to the kernel.

> Let me explain: newer fields are added to the kernel response struct =
at the=20
> end, together with a new comp_mask bit.
>=20
> Older user-space with newer kernels will simply ask only for the buff=
er=20
> size they care about. The fact that the struct is truncated doesn't a=
ffect
> these programs because the truncated struct is a valid struct that wa=
s=20
> presented by the kernel in an older version.
>=20

You cannot ensure the userspace being correct when specifying a request=
=2E
It's a wrong assumption (perhaps not so wrong in the case of
InfiniBand/RDMA, as most userspace program are using libibverbs,
librdmacm and provider's libraries).

That's why we must not be liberal with the request and check any bit of
it for being something valid, so that erroneous values are catch now,
ensuring userspace is not trying to request things we don't know yet
and it's not aware of it too.

> They may or may not receive a comp_mask bit they don't recognize, but=
 that=20
> only tells them that the kernel supports new features they don't know=
 about.
>=20
> Newer user-space with older kernel will give a larger buffer then the=
=20
> kernel can fill. The kernel only fills in the beginning of the user-s=
pace=20
> buffer, and provides user-space with the comp_mask bits that mark whi=
ch
> fields are valid. So user-space can tell that the end of the buffer i=
sn't=20
> valid.=20
>=20

But older userspace programs with newer kernel might break, as request'=
s
comp_mask was allowed to contains invalid values in older kernel.

> In my implementation I also left the ending uninitialized, but the=20
> kernel can zero it if you think it is important.
>=20

Why not, but it's a minor point.

> So I hope you agree this scheme is extendible and allows keeping back=
ward=20
> and forward compatibility. If you can think of another scheme that wi=
ll be=20
> more strict with the buffer sizes, but doesn't require user-space to =
do=20
> extra work, I'll be happy to hear about it.
>=20

I'm sorry about that but I cannot agree with the current scheme.

> [1] Extending Verbs API, Tzahi Oved
>     https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_04=
23/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.=
pdf

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
