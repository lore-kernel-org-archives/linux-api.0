From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 04/79] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Wed, 21 Oct 2015 16:09:30 +0100
Message-ID: <CACvgo50c+fz-Gk8ia5odUY=jPWy=sknGY+EKO01OwWQTpfEEVg@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-5-git-send-email-mikko.rapeli@iki.fi>
	<CADnq5_N5LK4Dy1okY7G6jPNB68PN2ijpwv=bt2bBC0FPGASoSQ@mail.gmail.com>
	<20151015134844.GY6104@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151015134844.GY6104-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Alex,

On 15 October 2015 at 14:48, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> On Thu, Oct 15, 2015 at 09:32:10AM -0400, Alex Deucher wrote:
>> On Thu, Oct 15, 2015 at 1:55 AM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> =
wrote:
>> > Fixes userspace compilation error:
>> >
>> > drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32_t=E2=
=80=99
>> >
>> > Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
>>
>> NACK on all these type conversions.  This has not been a problem for
>> years and years and the result looks terrible.
>
> Documentation/CodingStyle, section 5
>
>  (e) Types safe for use in userspace.
>
>      In certain structures which are visible to userspace, we cannot
>      require C99 types and cannot use the 'u32' form above. Thus, we
>      use __u32 and similar types in all structures which are shared
>      with userspace.
>
> I have only been looking at kernel headers from userspace occationall=
y in
> the past 10 years and had a several cases where the provided headers =
did
> not compile when included into trivial programs trying to use the str=
ucts
> for an ioctl() for example. This long lasting problem triggered me to=
 write
> a test for this and provide these fixes too. In previous reviews usag=
e
> of <stdint.h> and its types in kernel headers was already NACK'ed
> so I changed several places from uint32_t's to __u32.
>
> With these changes it is btw trivial now to add a grep test the there
> are no uint32_t's in include/uapi/ anymore, thus enforcing that codin=
g style
> rule.
>
Based of the reply from Mikko, can you please elaborate your concern ?
Are you thinking about some corner case where this may cause breakage,
or it's solely on stylistic point of view ?

Over the last few years we've been doing some ad-hoc 'synchronisation'
with the headers in libdrm, and this will get us one step closer to
doing things properly.

=46wiw I fully support these changes, as does Gustavo for exynos and Ro=
b for msm.
Reviewed-by: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Thanks
Emil
