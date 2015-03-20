From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/45] drm.h: include stdlib.h in userspace
Date: Fri, 20 Mar 2015 20:25:40 +0000
Message-ID: <CACvgo50PA5nb27EcxQqXY49C5hmvDDxi3WOqB=op-wx_WEGd+Q@mail.gmail.com>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
	<1424127948-22484-6-git-send-email-mikko.rapeli@iki.fi>
	<54EB0072.8020909@gmail.com>
	<20150223103548.GT12550@lakka.kapsi.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150223103548.GT12550-dqH1CgrzRhOk/eJAJmRu5A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Dave Airlie <airlied-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ML dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 23 February 2015 at 10:35, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> On Mon, Feb 23, 2015 at 10:26:58AM +0000, Emil Velikov wrote:
>> On 16/02/15 23:05, Mikko Rapeli wrote:
>> > Fixes <drm/drm.h> compilation error:
>> >
>> > drm/drm.h:132:2: error: unknown type name =E2=80=98size_t=E2=80=99
>> >
>> Hi Mikko,
>>
>> Can you let us know how you're getting these (series-wise) errors ? =
I've
>> been meaning to sync the uapi/drm and libdrm headers and would be ni=
ce
>> to have an extra step to test things.
>
> This should have everything needed to reproduce these compile errors,
> though some of the errors hide behind other errors and fixes:
>
> https://lkml.org/lkml/2015/2/16/525
>
Thanks for the link Mikko.

Afaict the general consensus seems to be that one should avoid using
stdint's uint8_t, but stick to __u8 and friends. Did you had the
chance to roll out another series that does so ?

That aside I'm not 100% sure that doing the UAPI split, as is, was the
perfect solution. Afaik drm used to live as an out of tree userspace
library(libdrm). Not sure at which point the major restructuring took
part, but one is certain - libdrm remains the only authoritative
sources of the headers. It's possible that some buggy programs pull
the UAPI headers while linking against the library, but I'd say that
won't end up well in the long term. Additionally since the UAPI split
the `make update-headers' target used to sync libdrm's headers have
been broken leading people to copy misc. hunks and/or files. Leading
to greater chance of things going sour.

All that said, I will need to gather some opinions for drm developers
and maintainers if the idea of part revering 718dcedd7e8(UAPI:
(Scripted) Disintegrate include/drm) will be the way forward.

Thanks
Emil
