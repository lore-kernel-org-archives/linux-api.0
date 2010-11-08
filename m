From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 18/23] sys-rq: Add option to soft dump
Date: Mon, 8 Nov 2010 14:31:04 -0800
Message-ID: <20101108143104.a3167543.randy.dunlap@oracle.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
	<20101108203322.22479.47929.stgit@crlf.mtv.corp.google.com>
	<20101108130939.13436673.randy.dunlap@oracle.com>
	<AANLkTikBvbp44ttPG95Pf4aymjJk_Ke7H=sg_ZLcpfge@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikBvbp44ttPG95Pf4aymjJk_Ke7H=sg_ZLcpfge-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: simon.kagstrom-vI6UBbBVNY+JA8cjQkG2/g@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon, 8 Nov 2010 14:27:59 -0800 Mike Waychison wrote:

> On Mon, Nov 8, 2010 at 1:09 PM, Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
> wrote:
> > On Mon, 08 Nov 2010 12:33:23 -0800 Mike Waychison wrote:
> >
> >> It is very useful to provide some means to force the kernel logs t=
o make it out
> >> via the kmsg_oops implementations on the console. =A0Add a new opt=
ion 'Y' to
> >> sysrq to allow dumping of logs to kmsg_dumper drivers.
> >>
> >> Signed-off-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Hi,
> >
> > Please add 'y' to Documentation/sysrq.txt .
>=20
> Ok.
>=20
> Looking at the docs though, sparc64 has 'y' mapped to "Show global CP=
U
> Registers".  The only slot available is 'a' if the list is up to date=
=2E

'a' has a big fat warning not to use it.
'x' is powerpc-specific, just as 'y' is sparc64 specific.

DaveM, any comments/suggestions on these?

Looks like one day soon we'll have to make a way to allow more sysrq ke=
ys...


> An alternative may be to overload 'v' "Forcefully restores framebuffe=
r
> console" and "Causes ETM buffer dump [ARM-specific]" as these actions
> seem to be about making crash data visible.
>=20
> >
> >> ---
> >> =A0drivers/char/sysrq.c | =A0 14 +++++++++++++-
> >> =A01 files changed, 13 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
> >> index eaa5d3e..058d3c8 100644
> >> --- a/drivers/char/sysrq.c
> >> +++ b/drivers/char/sysrq.c
> >> @@ -41,6 +41,7 @@
> >> =A0#include <linux/oom.h>
> >> =A0#include <linux/slab.h>
> >> =A0#include <linux/input.h>
> >> +#include <linux/kmsg_dump.h>
> >>
> >> =A0#include <asm/ptrace.h>
> >> =A0#include <asm/irq_regs.h>
> >> @@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op =3D =
{
> >> =A0 =A0 =A0 .enable_mask =A0 =A0=3D SYSRQ_ENABLE_RTNICE,
> >> =A0};
> >>
> >> +static void sysrq_handle_softdump(int key)
> >> +{
> >> + =A0 =A0 kmsg_dump(KMSG_DUMP_SOFT, NULL);
> >> +}
> >> +static struct sysrq_key_op sysrq_softdump_op =3D {
> >> + =A0 =A0 .handler =A0 =A0 =A0 =A0=3D sysrq_handle_softdump,
> >> + =A0 =A0 .help_msg =A0 =A0 =A0 =3D "soft-dump(Y)",
> >> + =A0 =A0 .action_msg =A0 =A0 =3D "Trigger a soft dump",
> >> + =A0 =A0 .enable_mask =A0 =A0=3D SYSRQ_ENABLE_DUMP,
> >> +};
> >> +
> >> =A0/* Key Operations table and lock */
> >> =A0static DEFINE_SPINLOCK(sysrq_key_table_lock);
> >>
> >> @@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36=
] =3D {
> >> =A0 =A0 =A0 /* x: May be registered on ppc/powerpc for xmon */
> >> =A0 =A0 =A0 NULL, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 /* x */
> >> =A0 =A0 =A0 /* y: May be registered on sparc64 for global register=
 dump */
> >> - =A0 =A0 NULL, =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 /* y */
> >> + =A0 =A0 &sysrq_softdump_op, =A0 =A0 =A0 =A0 =A0 =A0 /* y */
> >> =A0 =A0 =A0 &sysrq_ftrace_dump_op, =A0 =A0 =A0 =A0 =A0/* z */
> >> =A0};
> >
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your=
 code ***
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***
