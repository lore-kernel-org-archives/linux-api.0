From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's
 comp_mask
Date: Thu, 29 Jan 2015 19:00:41 +0100
Message-ID: <1422554441.3133.145.camel@opteya.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com> <1422271029.3133.68.camel@opteya.com>
	 <54C73549.5000003@mellanox.com> <1422451151.3133.130.camel@opteya.com>
	 <54C902E4.5010600@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C902E4.5010600-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

Le mercredi 28 janvier 2015 =C3=A0 17:40 +0200, Haggai Eran a =C3=A9cri=
t :
> On 28/01/2015 15:19, Yann Droneaud wrote:
> > Le mardi 27 janvier 2015 =C3=A0 08:50 +0200, Haggai Eran a =C3=A9cr=
it :
> >> On 26/01/2015 13:17, Yann Droneaud wrote:
> >>> ...
> >>> Le dimanche 25 janvier 2015 =C3=A0 17:23 +0200, Haggai Eran a =C3=
=A9crit :
> >>>> On 22/01/2015 15:28, Yann Droneaud wrote:
> >>>>> This patch ensures the extended QUERY_DEVICE uverbs request's
> >>>>> comp_mask has only known values. If userspace returns unknown
> >>>>> features, -EINVAL will be returned, allowing to probe/discover
> >>>>> which features are currently supported by the kernel.
> >>>>
> >>>> This probing process will be much more cumbersome than it needs =
to be
> >>>> because userspace will have to call QUERY_DEVICE repetitively wi=
th
> >>>> different comp_mask fields until it finds out the exact set of s=
upported
> >>>> bits.
> >>>>
> >>>
> >>> O(log2(N))
> >>
> >> I don't think user space developers will be happy having to do tri=
al and=20
> >> error to determine what features the kernel driver supports. It mi=
ght be=20
> >> even more then O(log2(N)). If my understanding of comp_mask bits u=
sage is=20
> >> correct it would O(N). But it's not the time complexity I'm worrie=
d about,
> >> it's the fact that it requires user-space developers to go through=
 hoops in
> >> order to get information that can be much more easily exported.
> >>
> >=20
> > But there's currently *NO* such mean that could give a hint to user=
space
> > developer whether one bit of request's comp_mask is currently effec=
tive
> > in extended QUERY_DEVICE uverbs. While we have such mean in CREATE_=
=46LOW
> > and DESTROY_FLOW: unsupported bits trigger -EINVAL.
> >=20
> > In QUERY_DEVICE, userspace developer is allowed to set request's=20
> > comp_mask to -1: it won't hurt it on current kernel, so why not usi=
ng=20
> > this value or any other random value ? The program will run: it's "=
Works
> > For Me".
> >=20
> > But the same program (either binary or source code) might fail on
> > newer kernel where some bits in comp_mask gain a meaning not suppor=
ted
> > by the program.
>=20
> Why don't we make the command comp_mask in QUERY_DEVICE zero in both
> versions. The behavior of the command with comp_mask =3D 0 will be to
> return the maximum amount of data that fits in the response buffer. T=
he
> kernel will return -EINVAL if the input command comp_mask is not zero=
 in
> the current version.
>=20

Yes, that's exactly what I wanted to do.

> If in the future we want to alter the behavior or add more input fiel=
ds
> to QUERY_DEVICE, we would use new bits.
>=20

Yes.

> >>> Or you had to add a different interface, dedicated to retrieve th=
e exact
> >>> supported feature mask.
> >>>
> >>>>> Moreover, it also ensure the requested features set in comp_mas=
k
> >>>>> are sequentially set, not skipping intermediate features, eg. t=
he
> >>>>> "highest" requested feature also request all the "lower" ones.
> >>>>> This way each new feature will have to be stacked on top of the
> >>>>> existing ones: this is especially important for the request and
> >>>>> response data structures where fields are added after the
> >>>>> current ones when expanded to support a new feature.
> >>>>
> >>>> I think it is perfectly acceptable that not all drivers will imp=
lement
> >>>> all available features, and so you shouldn't enforce this requir=
ement.
> >>>
> >>> With regard to QUERY_DEVICE: the data structure layout depends on=
 the
> >>> comp_mask value. So either you propose a way to express multipart=
 data
> >>> structure (see CMSG or NETLINK), or we have to ensure the data st=
ructure
> >>> is ever-growing, with each new chunck stacked over the existing o=
nes:
> >>> that's the purpose of :
> >>>
> >>> 	if (cmd.comp_mask & (cmd.comp_mask + 1))
> >>> 		return -EINVAL;
> >>>
> >>>> Also, it makes the comp_mask nothing more than a wasteful versio=
n number
> >>>> between 0 and 63.
> >>>
> >>> That's what I've already explained earlier in "Re: [PATCH v3 06/1=
7]
> >>> IB/core: Add support for extended query device caps":
> >>>
> >>> http://mid.gmane.org/1421844612.13543.40.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> >>
> >> Yes, you wrote there:
> >>> Regarding comp_mask (not for this particular verb):
> >>>
> >>> It's not clear whether request's comp_mask describe the request o=
r the
> >>> response, as such I'm puzzled.
> >>>
> >>> How would the kernel and the userspace be able to parse the reque=
st and
> >>> the response if they ignore unknown bits ?
> >>>
> >>> How would they be able to skip the unrecognized chunk of the requ=
est and
> >>> response buffer ?
> >>>
> >>> How one bit in a comp_mask is related to a chunk in the request o=
r
> >>> response ?
> >>>
> >>> It's likely the kernel or userspace would have to skip the remain=
ing
> >>> comp_mask's bits after encountering an unknown bit as the size of=
 the
> >>> corresponding chunk in request or response would be unknown, maki=
ng
> >>> impossible to locate the corresponding chunk for the next bit set=
 in
> >>> comp_mask. Having said that, comp_mask is just a complicated way =
of
> >>> expressing a version, which is turn describe a size (ever growing=
).
> >>
> >> It is my understanding that each comp_mask bit marks a set of fiel=
ds in=20
> >> the command or in the response struct as valid, so the struct form=
at=20
> >> remains the same and the kernel and userspace don't need to make=20
> >> difficult calculation as to where each field is, but you can still=
 pass=20
> >> a high bit set in comp_mask with one of the lower bits cleared.
> >>
> >=20
> > How can the struct format remain the same, if some fields are added
> > to implement newer feature ?
>=20
> I meant that the binary format for an older version is the prefix of =
the
> binary format of the newer version.
>=20

OK.

> >> I couldn't find this explicit detail in the mailing list, but I di=
d found
> >> a presentation that was presented in OFA International Developer=20
> >> Workshop 2013 [1], that gave an example of of an verb where each=20
> >> comp_mask bit marked a different field as valid.
> >>
> >=20
> > Thanks for the link to the presentation.
> >=20
> > As I read it the presentation:
> >=20
> > - in request, comp_mask give hint to the kernel of additional field=
s in
> > the request.
> >=20
> > - in response, comp_mask give hint to userspace regarding the prese=
nce
> > of additional fields in the response.
>=20
> I'm not sure that in request you can regard the comp_mask as a hint.

It's a hint because the kernel also have to check the size match:
if userspace say: "hey I've given you more fields" but the request
size is shorter than the kernel expect for such fields, the kernel
must return an error so that userspace is taught to fix its requests.

> I agree that you need to enforce it in general and reject unknown bit=
s
> there (although I thought QUERY_DEVICE would be an exception).
>=20

I think it's better to stick to one common behavior so that every
extended uverbs behave the same way.

> > But commit 860f10a799c8 ("IB/core: Add flags for on demand paging
> > support") on top of commit 5a77abf9a97a ("IB/core: Add support for
> > extended query device caps") is not doing it the expected way
> > as one bit set in request's comp_mask has direct effect on
> > the response's fields.
> >=20
> > To be conformant with the "Extending Verbs API" presentation,
> > no check should be done on request's comp_mask, and on-demand pagin=
g
> > information should be returned to userspace in all case, provided=20
> > there's enough room in the response buffer.
> >=20
> > Anyway, allowing userspace to set any "hint" in the request's comp_=
mask
> > is opening a pandora box: being allowed to set any value, userspace
> > program will use any random value, as it will work with current ker=
nel.
> >=20
> > But the same program used on newer kernel is going to trigger some
> > behavior unknown to the application or return an error the applicat=
ion
> > is not ready to handle ... breaking any kind of forward compatibili=
ty=20
> > promise.
>=20
> I don't think that the application should handle unknown response bit=
s
> as an error. As you wrote, I see these as hints about more data in th=
e
> response that the application is free to ignore.
>=20

I tried to explain the issue regarding older userspace setting random
bits in request's comp_mask: it older kernel allows such, the same
program will likely have issue with newer kernel where the request's
comp_mask bits have a meaning now: the program will either face
unknown behavior: the kernel does something the userspace was not
expecting, or the kernel refuse to do it because there's not enough
information in the request to fullfil it.

That's why we must catch now unknown value to prevent userspace to
use it now. If unknown value are not allowed, userspace program won't
use it and then it could run asis on newer kernel.


> > It's likely the kernel will have to use the size of the request to=20
> > guess the hints in comp_mask are corrects to handle such. In such c=
ase,=20
> > relying only on the size of the request might be enough to detect=20
> > extended request, without the need for comp_mask.
> >=20
> > Regarding the answer, if the response buffer is smaller than the si=
ze
> > of the extended response, will the kernel keep setting the response=
's=20
> > comp_mask with all the bits it supports or will it unset the bits f=
or=20
> > the fields it wasn't able to fit in the response buffer ?
> >=20
> > It's likely the kernel will have to use the size of the response bu=
ffer=20
> > to set the response's comp_mask.=20
> >=20
> > Instead commit 860f10a799c8 ("IB/core: Add flags for on demand pagi=
ng
> > support") on top of commit 5a77abf9a97a ("IB/core: Add support for
> > extended query device caps") make it possible for the kernel to ret=
urn
> > truncated response with full comp_mask. Such is going to break sile=
ntly=20
> > when one will introduce a data structure with an ABI mismatch betwe=
en
> > userspace and kernel (for example x86 vs amd64 ... we have some rec=
ent
> > exemples).
>=20
> As I said, I think unknown bits in the comp_mask are hints about unkn=
own
> fields in the response that can be ignored by the application. Howeve=
r,
> I can agree to having the kernel checking the response buffer size as
> you wrote, and only setting the valid comp_mask bits.
>=20

OK.

> >=20
> >>>
> >>>>
> >>>> In the specific case of QUERY_DEVICE you might argue that there =
isn't
> >>>> any need for input comp_mask, only for output, and then you may =
enforce
> >>>> the input comp_mask will always be zero.
> >>>
> >>> The extended QUERY_DEVICE uverbs as currently merged is using com=
p_mask
> >>> from input to choose to report on-demand-paging related value. So=
 it
> >>> seems it's needed.
> >>>
> >>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tr=
ee/drivers/infiniband/core/uverbs_cmd.c?id=3Dv3.19-rc6#n3297
> >>>
> >>>> However, you will in any case need to be able to extended the si=
ze of the response in the future.
> >>>>
> >>>
> >>> That's already the case for on demand paging.
> >>>
> >>>>>
> >>>>> Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud@optey=
a.com
> >>>>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>>>> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> >>>>> ---
> >>>>>  drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
> >>>>>  1 file changed, 6 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/inf=
iniband/core/uverbs_cmd.c
> >>>>> index 8668b328b7e6..80a1c90f1dbf 100644
> >>>>> --- a/drivers/infiniband/core/uverbs_cmd.c
> >>>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
> >>>>> @@ -3313,6 +3313,12 @@ int ib_uverbs_ex_query_device(struct ib_=
uverbs_file *file,
> >>>>>  	if (err)
> >>>>>  		return err;
> >>>>> =20
> >>>>> +	if (cmd.comp_mask & (cmd.comp_mask + 1))
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>>> +	if (cmd.comp_mask & ~(__u32)IB_USER_VERBS_EX_QUERY_DEVICE_ODP=
)
> >>>>> +		return -EINVAL;
> >>>>> +
> >>>
> >>> If we keep the checks on output buffer size from patch 1, returni=
ng
> >>> -ENOSPC in case of size mismatch, and if we are sure that no bit =
in
> >>> input comp_mask will ever trigger a call to a kernel function tha=
t can
> >>> make the uverb fail, the latter check on known value could be dro=
pped,
> >>> allowing the userspace to set the highest mask (-1): userspace
> >>> will use -ENOSPC to probe the expected size of the response buffe=
r
> >>> to match the highest supported comp_mask. But it's going to hurt
> >>> userspace application not ready to receive -ENOSPC on newer kerne=
l
> >>> with extended QUERY_DEVICE ABI ... Oops.
> >>>
> >>> So in this end, the safest way to ensure userspace is doing the c=
orrect
> >>> thing so that we have backward and forward compatibility is to ch=
eck
> >>> for known values in comp_mask, check for response buffer size and=
 ensure
> >>> that data structure chunk are stacked.
> >>>
> >>> The tighter are the checks now, the easier the interface could be
> >>> extended latter.
> >>
> >> I understand this position, and I generally agree, but I think tha=
t=20
> >> specifically for a verb like QUERY_DEVICE that only reads informat=
ion from=20
> >> the kernel driver to user-space, there is no harm in the kernel ju=
st=20
> >> providing all the information it can fit in the response buffer pr=
ovided=20
> >> by user-space.
> >>
> >=20
> > Returning as much as possible information to userspace is OK,
> > but it's doing it the wrong way.
> >=20
> > I'm not specifically discussing QUERY_DEVICE, as I'm concerned with=
=20
> > every extended uverbs to be added to the kernel.
> >=20
> >> Let me explain: newer fields are added to the kernel response stru=
ct at the=20
> >> end, together with a new comp_mask bit.
> >>
> >> Older user-space with newer kernels will simply ask only for the b=
uffer=20
> >> size they care about. The fact that the struct is truncated doesn'=
t affect
> >> these programs because the truncated struct is a valid struct that=
 was=20
> >> presented by the kernel in an older version.
> >>
> >=20
> > You cannot ensure the userspace being correct when specifying a req=
uest.
> > It's a wrong assumption (perhaps not so wrong in the case of
> > InfiniBand/RDMA, as most userspace program are using libibverbs,
> > librdmacm and provider's libraries).
> >=20
> > That's why we must not be liberal with the request and check any bi=
t of
> > it for being something valid, so that erroneous values are catch no=
w,
> > ensuring userspace is not trying to request things we don't know ye=
t
> > and it's not aware of it too.
>=20
> Does the solution I proposed above satisfy this requirement?
> - The kernel validates input size =3D=3D command struct size and
> cmd.comp_mask =3D=3D 0.
> - The kernel fills as much information as it can fit in the buffer
> provided by userspace.
> - The kernel marks which fields it was able to fill in the response's
> comp_mask.
>=20

Yes. This scheme follow the "Extending Verbs API" presention
while ensuring the command can be extended regarding to good
practice one can find in
http://blog.ffwll.ch/2013/11/botching-up-ioctls.html

I'm going to submit the patches to have this behavior.

Regards.

--=20
Yann Droneaud
OPTEYA



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
