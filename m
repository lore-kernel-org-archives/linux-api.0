From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 08/10] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Sat, 12 Mar 2016 18:27:13 -0500
Message-ID: <201603122327.u2CNRGVa026001@d01av03.pok.ibm.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com><1457751065-11507-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160312185154.GA12412@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6116504829655354580=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160312185154.GA12412-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org


--===============6116504829655354580==
Content-Type: multipart/alternative;
	boundary="=_alternative 0080D82285257F74_="


--=_alternative 0080D82285257F74_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/12/2016=20
01:51:54 PM:

>=20
> On Fri, Mar 11, 2016 at 09:51:03PM -0500, Stefan Berger wrote:
> > This patch implements a proxy driver for supporting multiple emulated=20
TPMs
> > in a system.
> >=20
> > The driver implements a device /dev/vtpmx that is used to created
> > a client device pair /dev/tpmX (e.g., /dev/tpm10) and a server side=20
that
> > is accessed using a file descriptor returned by an ioctl.
> > The device /dev/tpmX is the usual TPM device created by the core TPM
> > driver. Applications or kernel subsystems can send TPM commands to it
> > and the corresponding server-side file descriptor receives these
> > commands and delivers them to an emulated TPM.
>=20
> With my test script [1] running on QEMU and TPM 2.0 simulator running on =

the
> host side I get this:
>=20
> $ python tpm2-simulator-vtpm --host=3D10.0.2.2
> cmd
> 80 01 00 00 00 0c 00 00 01 44 00 00
> rsp
> 80 01 00 00 00 0a 00 00 00 00
> Traceback (most recent call last):
>   File "tpm2-simulator-vtpm", line 85, in <module>
>     main()
>   File "tpm2-simulator-vtpm", line 80, in main
>     resp =3D client.send=5Fcmd(stream)
>   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 454, in send=5Fcmd
>     rsp =3D self.simulator.send=5Fcmd(cmd)
>   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 436, in send=5Fcmd
>     raise SimulatorError("Empty response")
> tpm2.SimulatorError: Empty response
>=20
> However, the process does not exit before the read call expires:
>=20
> $ python tpm2-list-handles
> Traceback (most recent call last):
>   File "tpm2-list-handles", line 61, in <module>
>     main()
>   File "tpm2-list-handles", line 51, in main
>     handles +=3D client.get=5Fcap(tpm2.TPM2=5FCAP=5FHANDLES,=20
tpm2.HR=5FLOADED=5FSESSION)
>   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 782, in get=5Fcap
>     next=5Fhandles, more=5Fdata =3D self.=5F=5Fget=5Fcap=5Fcnt(cap, pt, 1)
>   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 766, in =5F=5Fget=5Fcap=
=5Fcnt
>     rsp =3D self.send=5Fcmd(cmd)[10:]
>   File "/home/tpmdd/tpm2-scripts/tpm2.py", line 458, in send=5Fcmd
>     rsp =3D f.read()
> IOError: [Errno 62] Timer expired
>=20
> The server side stays stuck unti this happens.

This fix should solve the problem:

diff --git a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c=20
b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
index d73944e..01e5070 100644
--- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
+++ b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
@@ -456,10 +456,10 @@ err=5Fdelete=5Fproxy=5Fdev:
  */
 static void vtpm=5Fproxy=5Fdelete=5Fdevice(struct proxy=5Fdev *proxy=5Fdev)
 {
-       tpm=5Fchip=5Funregister(proxy=5Fdev->chip);
-
        vtpm=5Fproxy=5Ffops=5Fundo=5Fopen(proxy=5Fdev);

+       tpm=5Fchip=5Funregister(proxy=5Fdev->chip);
+
        vtpm=5Fproxy=5Fdelete=5Fproxy=5Fdev(proxy=5Fdev);
 }


Can you let me know whether this gets it working for you? I'd prepare a=20
v9.

   Stefan



--=_alternative 0080D82285257F74_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/12/2016 01:51:54 PM:<br><br>&gt; <br>&gt; On Fri, Mar 11, 2016 =
at 09:51:03PM -0500, Stefan Berger wrote:<br>&gt; &gt; This patch implement=
s a proxy driver for supporting multiple
emulated TPMs<br>&gt; &gt; in a system.<br>&gt; &gt; <br>&gt; &gt; The driv=
er implements a device /dev/vtpmx that is used to created<br>&gt; &gt; a cl=
ient device pair /dev/tpmX (e.g., /dev/tpm10) and a server
side that<br>&gt; &gt; is accessed using a file descriptor returned by an i=
octl.<br>&gt; &gt; The device /dev/tpmX is the usual TPM device created by =
the core
TPM<br>&gt; &gt; driver. Applications or kernel subsystems can send TPM com=
mands
to it<br>&gt; &gt; and the corresponding server-side file descriptor receiv=
es these<br>&gt; &gt; commands and delivers them to an emulated TPM.<br>&gt=
; <br>&gt; With my test script [1] running on QEMU and TPM 2.0 simulator ru=
nning
on the<br>&gt; host side I get this:<br>&gt; <br>&gt; $ python tpm2-simulat=
or-vtpm --host=3D10.0.2.2<br>&gt; cmd<br>&gt; 80 01 00 00 00 0c 00 00 01 44=
 00 00<br>&gt; rsp<br>&gt; 80 01 00 00 00 0a 00 00 00 00<br>&gt; Traceback =
(most recent call last):<br>&gt; &nbsp; File &quot;tpm2-simulator-vtpm&quot=
;, line 85, in &lt;module&gt;<br>&gt; &nbsp; &nbsp; main()<br>&gt; &nbsp; F=
ile &quot;tpm2-simulator-vtpm&quot;, line 80, in main<br>&gt; &nbsp; &nbsp;=
 resp =3D client.send=5Fcmd(stream)<br>&gt; &nbsp; File &quot;/home/tpmdd/t=
pm2-scripts/tpm2.py&quot;, line 454,
in send=5Fcmd<br>&gt; &nbsp; &nbsp; rsp =3D self.simulator.send=5Fcmd(cmd)<=
br>&gt; &nbsp; File &quot;/home/tpmdd/tpm2-scripts/tpm2.py&quot;, line 436,
in send=5Fcmd<br>&gt; &nbsp; &nbsp; raise SimulatorError(&quot;Empty respon=
se&quot;)<br>&gt; tpm2.SimulatorError: Empty response<br>&gt; <br>&gt; Howe=
ver, the process does not exit before the read call expires:<br>&gt; <br>&g=
t; $ python tpm2-list-handles<br>&gt; Traceback (most recent call last):<br=
>&gt; &nbsp; File &quot;tpm2-list-handles&quot;, line 61, in &lt;module&gt;=
<br>&gt; &nbsp; &nbsp; main()<br>&gt; &nbsp; File &quot;tpm2-list-handles&q=
uot;, line 51, in main<br>&gt; &nbsp; &nbsp; handles +=3D client.get=5Fcap(=
tpm2.TPM2=5FCAP=5FHANDLES, tpm2.HR=5FLOADED=5FSESSION)<br>&gt; &nbsp; File =
&quot;/home/tpmdd/tpm2-scripts/tpm2.py&quot;, line 782,
in get=5Fcap<br>&gt; &nbsp; &nbsp; next=5Fhandles, more=5Fdata =3D self.=5F=
=5Fget=5Fcap=5Fcnt(cap, pt,
1)<br>&gt; &nbsp; File &quot;/home/tpmdd/tpm2-scripts/tpm2.py&quot;, line 7=
66,
in =5F=5Fget=5Fcap=5Fcnt<br>&gt; &nbsp; &nbsp; rsp =3D self.send=5Fcmd(cmd)=
[10:]<br>&gt; &nbsp; File &quot;/home/tpmdd/tpm2-scripts/tpm2.py&quot;, lin=
e 458,
in send=5Fcmd<br>&gt; &nbsp; &nbsp; rsp =3D f.read()<br>&gt; IOError: [Errn=
o 62] Timer expired<br>&gt; <br>&gt; The server side stays stuck unti this =
happens.</font></tt><br><br><tt><font size=3D2>This fix should solve the pr=
oblem:</font></tt><br><br><font size=3D4 face=3D"Lucida Console"><b>diff --=
git a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c</b></font><br><font size=3D4 face=
=3D"Lucida Console"><b>index d73944e..01e5070 100644</b></font><br><font si=
ze=3D4 face=3D"Lucida Console"><b>--- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy=
.c</b></font><br><font size=3D4 face=3D"Lucida Console"><b>+++ b/drivers/ch=
ar/tpm/tpm=5Fvtpm=5Fproxy.c</b></font><br><font size=3D4 color=3D#00c1c2 fa=
ce=3D"Lucida Console">@@ -456,10 +456,10
@@</font><font size=3D4 face=3D"Lucida Console"> err=5Fdelete=5Fproxy=5Fdev=
:</font><br><font size=3D4 face=3D"Lucida Console">&nbsp; */</font><br><fon=
t size=3D4 face=3D"Lucida Console">&nbsp;static void vtpm=5Fproxy=5Fdelete=
=5Fdevice(struct
proxy=5Fdev *proxy=5Fdev)</font><br><font size=3D4 face=3D"Lucida Console">=
&nbsp;{</font><br><font size=3D4 color=3D#c20000 face=3D"Lucida Console">- =
&nbsp; &nbsp; &nbsp;
tpm=5Fchip=5Funregister(proxy=5Fdev-&gt;chip);</font><br><font size=3D4 col=
or=3D#c20000 face=3D"Lucida Console">-</font><br><font size=3D4 face=3D"Luc=
ida Console">&nbsp; &nbsp; &nbsp; &nbsp; vtpm=5Fproxy=5Ffops=5Fundo=5Fopen(=
proxy=5Fdev);</font><br><br><font size=3D4 color=3D#00c200 face=3D"Lucida C=
onsole">+</font><font size=3D4 face=3D"Lucida Console">&nbsp; &nbsp; &nbsp;=
 </font><font size=3D4 color=3D#00c200 face=3D"Lucida Console">tpm=5Fchip=
=5Funregister(proxy=5Fdev-&gt;chip);</font><br><font size=3D4 color=3D#00c2=
00 face=3D"Lucida Console">+</font><br><font size=3D4 face=3D"Lucida Consol=
e">&nbsp; &nbsp; &nbsp; &nbsp; vtpm=5Fproxy=5Fdelete=5Fproxy=5Fdev(proxy=5F=
dev);</font><br><font size=3D4 face=3D"Lucida Console">&nbsp;}</font><br><b=
r><br><tt><font size=3D2>Can you let me know whether this gets it working f=
or
you? I'd prepare a v9.</font></tt><br><br><tt><font size=3D2>&nbsp; &nbsp;S=
tefan</font></tt><br><BR>
--=_alternative 0080D82285257F74_=--



--===============6116504829655354580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
--===============6116504829655354580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6116504829655354580==--
