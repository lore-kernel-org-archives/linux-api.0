From: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Date: Wed, 23 Feb 2011 13:29:46 -0800
Message-ID: <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25@mail.gmail.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
	<20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
	<AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
	<AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 23, 2011 at 12:28 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wro=
te:
> Ya, I don't think there is anything that guarantees that dmi_header i=
s
> aligned. =A0 The access is probably the struct copy I did here:
>
> =A0 =A0 =A0 =A0/* Set the key */
> =A0 =A0 =A0 =A0entry->dh =3D *dh;

Yup - looking back at the assembly I see that one of the 2-byte
accesses is offset 2
(picking up ->handle), but the second is offset 0 (picking up ->type
and ->length). The
compiler assumed the structure was 2-byte aligned because of ->handle.

> What if we changed that guy to use memcpy? =A0We'd probably need to
> memcpy the dmi_system_event_log as well. =A0Patch attached (applies o=
n
> top of the entire patchset).

With the patch, all the unaligned accesses go away.

Tested-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

-Tony
