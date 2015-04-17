From: Jean Delvare <jdelvare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [Patch 2/3] firmware: dmi_scan: add SBMIOS entry and DMI tables
Date: Fri, 17 Apr 2015 15:02:24 +0200
Message-ID: <20150417150224.50202bcb@endymion.delvare>
References: <1427979423-22767-1-git-send-email-ivan.khoronzhuk@globallogic.com>
	<1427979423-22767-3-git-send-email-ivan.khoronzhuk@globallogic.com>
	<20150416115252.7dc964a3@endymion.delvare>
	<552FB18D.6080207@globallogic.com>
	<1429199064.4386.93.camel@chaos.site>
	<552FF0E4.709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FF0E4.709-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ivan.khoronzhuk" <ivan.khoronzhuk-hExfYMNmJl/Cnp4W7fqMDg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dmidecode-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, 16 Apr 2015 20:27:00 +0300, subscivan wrote:
> On 16.04.15 18:44, Jean Delvare wrote:
> > Le Thursday 16 April 2015 =C3=A0 15:56 +0300, Ivan.khoronzhuk a =C3=
=A9crit :
> >> We cannot be sure that firmware_kobj created at time of dmi_init()=
=2E
> >> The sources don't oblige you to call it at core level,
> >> for instance like it was done for arm64. For x86, dmi_init() can b=
e called
> >> before firmware_kobj is created.
> > Looking at the code, it seems that firmware_kobj is created very, v=
ery
> > early in the boot process. In do_basic_setup(), you can see that
> > driver_init() (which in turn calls firmware_init(), creating
> > firmware_kobj) is called before do_initcalls(). So firmware_kobj mu=
st be
> > defined before dmi_scan_machine() or dmi_init() is called.
>=20
> No. Not must, rather should. See below.
>=20
> > Oh, and this wasn't even my point ;-) I'm fine with you checking if
> > firmware_kobj is defined. My question was about the dmi_available c=
heck
> > above. But that question was silly anyway, sorry. I confused
> > dmi_available with dmi_initialized. Checking for dmi_available is
> > perfectly reasonable, please scratch my objection.
> >
> >> And if I call it from dmi_init() I suppose
> >> I would face an error. As I can't call it in dmi_init I can't be s=
ure that
> >> DMI is available at all. So, no, we have to check dmi_available he=
re and
> >> call it at subsys layer, where it's supposed to be.
> > I can't parse that, I suspect you wrote dmi_init where you actually
> > meant dmi_scan_machine? Given how early firmware_kobj is created, I
> > think the code currently in dmi_init could in fact go at the end of
> > dmi_scan_machine.
>=20
> Actually, dmi_scan_machine can be called even earlier.
> As I've sad, for x86, it's called before firmware_kobj is created.
>=20
> kernel_start()
>      setup_arch()
>          dmi_scan_machine()
>=20
> And for firmware_init(), as you noticed already:
>=20
> start_kernel()
>      rest_init()
>          kernel_init()
>              kernel_init_freeable()
>                  do_basic_setup()
>                      driver_init()
>                          firmware_init()
>=20
> Pay attentions that setup_arch() is called much earlier than rest_ini=
t().
> So dmi_init couldn't in fact go at the end of dmi_scan_machine.

Yeah, you're right, sorry. Somehow I thought that setup_arch was an
arch_initcall, but it is not, so I got the order all wrong.

--=20
Jean Delvare
SUSE L3 Support
