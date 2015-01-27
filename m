From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/4] IB/uverbs: ex_query_device: check request's comp_mask
Date: Tue, 27 Jan 2015 08:50:49 +0200
Message-ID: <54C73549.5000003@mellanox.com>
References: <cover.1421931555.git.ydroneaud@opteya.com>
	 <063956366559d6919693aabb324bab83d676bc28.1421931555.git.ydroneaud@opteya.com>
	 <54C50A67.6040306@mellanox.com> <1422271029.3133.68.camel@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422271029.3133.68.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 26/01/2015 13:17, Yann Droneaud wrote:
> ...
> Le dimanche 25 janvier 2015 =C3=A0 17:23 +0200, Haggai Eran a =C3=A9c=
rit :
>> On 22/01/2015 15:28, Yann Droneaud wrote:
>>> This patch ensures the extended QUERY_DEVICE uverbs request's
>>> comp_mask has only known values. If userspace returns unknown
>>> features, -EINVAL will be returned, allowing to probe/discover
>>> which features are currently supported by the kernel.
>>
>> This probing process will be much more cumbersome than it needs to b=
e
>> because userspace will have to call QUERY_DEVICE repetitively with
>> different comp_mask fields until it finds out the exact set of suppo=
rted
>> bits.
>>
>=20
> O(log2(N))

I don't think user space developers will be happy having to do trial an=
d=20
error to determine what features the kernel driver supports. It might b=
e=20
even more then O(log2(N)). If my understanding of comp_mask bits usage =
is=20
correct it would O(N). But it's not the time complexity I'm worried abo=
ut,
it's the fact that it requires user-space developers to go through hoop=
s in
order to get information that can be much more easily exported.

> Or you had to add a different interface, dedicated to retrieve the ex=
act
> supported feature mask.
>=20
>>> Moreover, it also ensure the requested features set in comp_mask
>>> are sequentially set, not skipping intermediate features, eg. the
>>> "highest" requested feature also request all the "lower" ones.
>>> This way each new feature will have to be stacked on top of the
>>> existing ones: this is especially important for the request and
>>> response data structures where fields are added after the
>>> current ones when expanded to support a new feature.
>>
>> I think it is perfectly acceptable that not all drivers will impleme=
nt
>> all available features, and so you shouldn't enforce this requiremen=
t.
>=20
> With regard to QUERY_DEVICE: the data structure layout depends on the
> comp_mask value. So either you propose a way to express multipart dat=
a
> structure (see CMSG or NETLINK), or we have to ensure the data struct=
ure
> is ever-growing, with each new chunck stacked over the existing ones:
> that's the purpose of :
>=20
> 	if (cmd.comp_mask & (cmd.comp_mask + 1))
> 		return -EINVAL;
>=20
>> Also, it makes the comp_mask nothing more than a wasteful version nu=
mber
>> between 0 and 63.
>=20
> That's what I've already explained earlier in "Re: [PATCH v3 06/17]
> IB/core: Add support for extended query device caps":
>=20
> http://mid.gmane.org/1421844612.13543.40.camel-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Yes, you wrote there:
> Regarding comp_mask (not for this particular verb):
>=20
> It's not clear whether request's comp_mask describe the request or th=
e
> response, as such I'm puzzled.
>=20
> How would the kernel and the userspace be able to parse the request a=
nd
> the response if they ignore unknown bits ?
>=20
> How would they be able to skip the unrecognized chunk of the request =
and
> response buffer ?
>=20
> How one bit in a comp_mask is related to a chunk in the request or
> response ?
>=20
> It's likely the kernel or userspace would have to skip the remaining
> comp_mask's bits after encountering an unknown bit as the size of the
> corresponding chunk in request or response would be unknown, making
> impossible to locate the corresponding chunk for the next bit set in
> comp_mask. Having said that, comp_mask is just a complicated way of
> expressing a version, which is turn describe a size (ever growing).

It is my understanding that each comp_mask bit marks a set of fields in=
=20
the command or in the response struct as valid, so the struct format=20
remains the same and the kernel and userspace don't need to make=20
difficult calculation as to where each field is, but you can still pass=
=20
a high bit set in comp_mask with one of the lower bits cleared.

I couldn't find this explicit detail in the mailing list, but I did fou=
nd
a presentation that was presented in OFA International Developer=20
Workshop 2013 [1], that gave an example of of an verb where each=20
comp_mask bit marked a different field as valid.

>=20
>>
>> In the specific case of QUERY_DEVICE you might argue that there isn'=
t
>> any need for input comp_mask, only for output, and then you may enfo=
rce
>> the input comp_mask will always be zero.
>=20
> The extended QUERY_DEVICE uverbs as currently merged is using comp_ma=
sk
> from input to choose to report on-demand-paging related value. So it
> seems it's needed.
>=20
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/d=
rivers/infiniband/core/uverbs_cmd.c?id=3Dv3.19-rc6#n3297
>=20
>> However, you will in any case need to be able to extended the size o=
f the response in the future.
>>
>=20
> That's already the case for on demand paging.
>=20
>>>
>>> Link: http://mid.gmane.org/cover.1421931555.git.ydroneaud-RlY5vtjFyJ1hl2p70BpVqQ@public.gmane.org=
m
>>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
>>>  1 file changed, 6 insertions(+)
>>>
>>> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infinib=
and/core/uverbs_cmd.c
>>> index 8668b328b7e6..80a1c90f1dbf 100644
>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>> @@ -3313,6 +3313,12 @@ int ib_uverbs_ex_query_device(struct ib_uver=
bs_file *file,
>>>  	if (err)
>>>  		return err;
>>> =20
>>> +	if (cmd.comp_mask & (cmd.comp_mask + 1))
>>> +		return -EINVAL;
>>> +
>>> +	if (cmd.comp_mask & ~(__u32)IB_USER_VERBS_EX_QUERY_DEVICE_ODP)
>>> +		return -EINVAL;
>>> +
>=20
> If we keep the checks on output buffer size from patch 1, returning
> -ENOSPC in case of size mismatch, and if we are sure that no bit in
> input comp_mask will ever trigger a call to a kernel function that ca=
n
> make the uverb fail, the latter check on known value could be dropped=
,
> allowing the userspace to set the highest mask (-1): userspace
> will use -ENOSPC to probe the expected size of the response buffer
> to match the highest supported comp_mask. But it's going to hurt
> userspace application not ready to receive -ENOSPC on newer kernel
> with extended QUERY_DEVICE ABI ... Oops.
>=20
> So in this end, the safest way to ensure userspace is doing the corre=
ct
> thing so that we have backward and forward compatibility is to check
> for known values in comp_mask, check for response buffer size and ens=
ure
> that data structure chunk are stacked.
>=20
> The tighter are the checks now, the easier the interface could be
> extended latter.

I understand this position, and I generally agree, but I think that=20
specifically for a verb like QUERY_DEVICE that only reads information f=
rom=20
the kernel driver to user-space, there is no harm in the kernel just=20
providing all the information it can fit in the response buffer provide=
d=20
by user-space.

Let me explain: newer fields are added to the kernel response struct at=
 the=20
end, together with a new comp_mask bit.

Older user-space with newer kernels will simply ask only for the buffer=
=20
size they care about. The fact that the struct is truncated doesn't aff=
ect
these programs because the truncated struct is a valid struct that was=20
presented by the kernel in an older version.

They may or may not receive a comp_mask bit they don't recognize, but t=
hat=20
only tells them that the kernel supports new features they don't know a=
bout.

Newer user-space with older kernel will give a larger buffer then the=20
kernel can fill. The kernel only fills in the beginning of the user-spa=
ce=20
buffer, and provides user-space with the comp_mask bits that mark which
fields are valid. So user-space can tell that the end of the buffer isn=
't=20
valid.=20

In my implementation I also left the ending uninitialized, but the=20
kernel can zero it if you think it is important.

So I hope you agree this scheme is extendible and allows keeping backwa=
rd=20
and forward compatibility. If you can think of another scheme that will=
 be=20
more strict with the buffer sizes, but doesn't require user-space to do=
=20
extra work, I'll be happy to hear about it.

Regards,
Haggai

[1] Extending Verbs API, Tzahi Oved
    https://www.openfabrics.org/images/docs/2013_Dev_Workshop/Tues_0423=
/2013_Workshop_Tues_0830_Tzahi_Oved-verbs_extensions_ofa_2013-tzahio.pd=
f
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
