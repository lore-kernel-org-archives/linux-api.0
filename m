From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 2/5] firmware: Basic dmi-sysfs support
Date: Fri, 25 Feb 2011 11:58:10 -0800
Message-ID: <20110225195810.GB8860@kroah.com>
References: <20110223015307.13068.14063.stgit@mike.mtv.corp.google.com>
 <20110223015320.13068.77428.stgit@mike.mtv.corp.google.com>
 <AANLkTinjhY3oiFTq2xq4fwQ-mtLZ8ph435+nc5irM7wZ@mail.gmail.com>
 <AANLkTi=+-Wc0bWdpvR+X6UszLf7MXKYgi8Oo6anN-jR8@mail.gmail.com>
 <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=dE5_VjJ+5H6cWf9nAtdkLiqhSXo6Gvd_uGQ25-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Olof Johansson <olofj-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Robert Lippert <rlippert-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jon Mayer <jonmayer-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Duncan Laurie <dlaurie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hendrix <dhendrix-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Feb 23, 2011 at 01:29:46PM -0800, Tony Luck wrote:
> On Wed, Feb 23, 2011 at 12:28 PM, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> w=
rote:
> > Ya, I don't think there is anything that guarantees that dmi_header=
 is
> > aligned. =A0 The access is probably the struct copy I did here:
> >
> > =A0 =A0 =A0 =A0/* Set the key */
> > =A0 =A0 =A0 =A0entry->dh =3D *dh;
>=20
> Yup - looking back at the assembly I see that one of the 2-byte
> accesses is offset 2
> (picking up ->handle), but the second is offset 0 (picking up ->type
> and ->length). The
> compiler assumed the structure was 2-byte aligned because of ->handle=
=2E
>=20
> > What if we changed that guy to use memcpy? =A0We'd probably need to
> > memcpy the dmi_system_event_log as well. =A0Patch attached (applies=
 on
> > top of the entire patchset).
>=20
> With the patch, all the unaligned accesses go away.
>=20
> Tested-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Great!

Mike, care to resend this last patch as a 6/5 patch with a proper
subject, changelog comment, and signed-off-by: section so that I can
queue it up?

thanks,

greg k-h
