From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 04/79] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Wed, 21 Oct 2015 18:42:10 +0100
Message-ID: <CACvgo53P4_SRqi6WTZQdMSG5RZBmNdzzeH+T1j=dw_1ZLWa1aA@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-5-git-send-email-mikko.rapeli@iki.fi>
	<CADnq5_N5LK4Dy1okY7G6jPNB68PN2ijpwv=bt2bBC0FPGASoSQ@mail.gmail.com>
	<20151015134844.GY6104@lakka.kapsi.fi>
	<CACvgo50c+fz-Gk8ia5odUY=jPWy=sknGY+EKO01OwWQTpfEEVg@mail.gmail.com>
	<CADnq5_MMzO+bmMmw96=n998hDgGXPbuvFmboO3tw9PMk9S3UdQ@mail.gmail.com>
	<CACvgo50XzhdjqF1j_rRH4LTKYvNY_qq+tjy1U6WuzPmB8oTfqw@mail.gmail.com>
	<CADnq5_OgN6tNKSGU-zUdhjNbqK+XRkGXccgxVtz+5092unza4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADnq5_OgN6tNKSGU-zUdhjNbqK+XRkGXccgxVtz+5092unza4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 21 October 2015 at 17:27, Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> On Wed, Oct 21, 2015 at 12:21 PM, Emil Velikov <emil.l.velikov@gmail.=
com> wrote:
>> On 21 October 2015 at 16:18, Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wr=
ote:
>>> On Wed, Oct 21, 2015 at 11:09 AM, Emil Velikov <emil.l.velikov@gmai=
l.com> wrote:
>>>> Hi Alex,
>>>>
>>>> On 15 October 2015 at 14:48, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wr=
ote:
>>>>> On Thu, Oct 15, 2015 at 09:32:10AM -0400, Alex Deucher wrote:
>>>>>> On Thu, Oct 15, 2015 at 1:55 AM, Mikko Rapeli <mikko.rapeli@iki.=
fi> wrote:
>>>>>> > Fixes userspace compilation error:
>>>>>> >
>>>>>> > drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32=
_t=E2=80=99
>>>>>> >
>>>>>> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>>>>>>
>>>>>> NACK on all these type conversions.  This has not been a problem=
 for
>>>>>> years and years and the result looks terrible.
>>>>>
>>>>> Documentation/CodingStyle, section 5
>>>>>
>>>>>  (e) Types safe for use in userspace.
>>>>>
>>>>>      In certain structures which are visible to userspace, we can=
not
>>>>>      require C99 types and cannot use the 'u32' form above. Thus,=
 we
>>>>>      use __u32 and similar types in all structures which are shar=
ed
>>>>>      with userspace.
>>>>>
>>>>> I have only been looking at kernel headers from userspace occatio=
nally in
>>>>> the past 10 years and had a several cases where the provided head=
ers did
>>>>> not compile when included into trivial programs trying to use the=
 structs
>>>>> for an ioctl() for example. This long lasting problem triggered m=
e to write
>>>>> a test for this and provide these fixes too. In previous reviews =
usage
>>>>> of <stdint.h> and its types in kernel headers was already NACK'ed
>>>>> so I changed several places from uint32_t's to __u32.
>>>>>
>>>>> With these changes it is btw trivial now to add a grep test the t=
here
>>>>> are no uint32_t's in include/uapi/ anymore, thus enforcing that c=
oding style
>>>>> rule.
>>>>>
>>>> Based of the reply from Mikko, can you please elaborate your conce=
rn ?
>>>> Are you thinking about some corner case where this may cause break=
age,
>>>> or it's solely on stylistic point of view ?
>>>
>>> Style.
>>>
>> In that case shouldn't the kernel coding style (not to mention the
>> issues with stdint.h types Linus has brought a while back) be
>> considered/prevail ?
>
> I don't really have a strong opinion one way or another at this point=
=2E
> The types just look ugly.
>
=46wiw I don't find them too appealing either. But the alternative did
not fare so well :(

>>
>>>>
>>>> Over the last few years we've been doing some ad-hoc 'synchronisat=
ion'
>>>> with the headers in libdrm, and this will get us one step closer t=
o
>>>> doing things properly.
>>>
>>> How does this affect libdrm one way or another?
>>>
>> In a strange way. Some (most?) distributions do not ship the uapi
>> headers from the kernel, but rely on the ones in libdrm. Due to
>> various issues (as addressed in the series) we have not synchronised
>> the headers, thus users such as the gallium radeon winsys has ended =
up
>> redefining/duplicating internally.
>
> The problem is that you generally need the latest headers to support
> the latest features in the user mode stacks, so if the user tries to
> build against an older kernel, they will be missing definitions.
>
Pretty much that's why we have the loose release criteria for libdrm.
Get the functionality upstream (mainline or -next), pull the changes
(sync) and release. As the sync has been busted for a while, people
are forced to do unpleasant things.

-Emil
