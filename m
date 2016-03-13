From: "Stefan Berger" <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 08/10] tpm: Proxy driver for supporting
 multiple emulated TPMs
Date: Sun, 13 Mar 2016 17:20:40 -0500
Message-ID: <201603132220.u2DMKrk6023870@d03av04.boulder.ibm.com>
References: <1457751065-11507-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457751065-11507-9-git-send-email-stefanb@linux.vnet.ibm.com>
	<20160312185154.GA12412@intel.com>
	<201603122327.u2CNRI56031122@d01av04.pok.ibm.com>
	<20160313200652.GA3087@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6974168471546955591=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160313200652.GA3087-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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


--===============6974168471546955591==
Content-Type: multipart/alternative;
	boundary="=_alternative 007AC0CB85257F75_="


--=_alternative 007AC0CB85257F75_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="US-ASCII"

Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote on 03/13/2016=20
04:06:52 PM:


>=20
> On Sat, Mar 12, 2016 at 06:27:13PM -0500, Stefan Berger wrote:

> >    This fix should solve the problem:
> >=20
> >    diff --git a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> >    b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> >    index d73944e..01e5070 100644
> >    --- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> >    +++ b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c
> >    @@ -456,10 +456,10 @@ err=5Fdelete=5Fproxy=5Fdev:
> >      */
> >     static void vtpm=5Fproxy=5Fdelete=5Fdevice(struct proxy=5Fdev *prox=
y=5Fdev)
> >     {
> >    -       tpm=5Fchip=5Funregister(proxy=5Fdev->chip);
> >    -
> >            vtpm=5Fproxy=5Ffops=5Fundo=5Fopen(proxy=5Fdev);
> >=20
> >    +      tpm=5Fchip=5Funregister(proxy=5Fdev->chip);
> >    +
> >            vtpm=5Fproxy=5Fdelete=5Fproxy=5Fdev(proxy=5Fdev);
> >     }
> >=20
> >    Can you let me know whether this gets it working for you? I'd=20
prepare a
> >    v9.
>=20
> So is the deadlock such that:
>=20
> * tpm=5Fchip=5Funregister() tries to write lock ops=5Fsem.
> * tpm=5Ftransmit() holds read lock to ops=5Fsem.
>=20
> This takes two minutes if no timeouts are calculated.
>=20
> And is the effect of moving vtpm=5Fproxy=5Ffops=5Fundo=5Fopen() upwards s=
uch
> that vtpm=5Fproxy=5Ftpm=5Freq=5Fcanceled() starts returning true, which in
> effect breaks the loop in tpm=5Ftransmit()?
>=20
> Yeah, the fix as a code change is very simple but I had to use perf
> probe to verify this so maybe a comment there would be in place to
> tell why tpm=5Fchip=5Funregister() must be called last (write lock).

I'll put a comment. The reason is that the client (user of /dev/tpmX) is=20
possibly holding the 'ops' lock while we the proxy driver needs it when=20
calling tom=5Fchip=5Funregister.
Thanks for trying it.

   Stefan



--=_alternative 007AC0CB85257F75_=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="US-ASCII"

<tt><font size=3D2>Jarkko Sakkinen &lt;jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org&gt;
wrote on 03/13/2016 04:06:52 PM:<br><br></font></tt><br><tt><font size=3D2>=
&gt; <br>&gt; On Sat, Mar 12, 2016 at 06:27:13PM -0500, Stefan Berger wrote=
:<br><br>&gt; &gt; &nbsp; &nbsp;This fix should solve the problem:<br>&gt; =
&gt; <br>&gt; &gt; &nbsp; &nbsp;diff --git a/drivers/char/tpm/tpm=5Fvtpm=5F=
proxy.c<br>&gt; &gt; &nbsp; &nbsp;b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c<b=
r>&gt; &gt; &nbsp; &nbsp;index d73944e..01e5070 100644<br>&gt; &gt; &nbsp; =
&nbsp;--- a/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c<br>&gt; &gt; &nbsp; &nbsp=
;+++ b/drivers/char/tpm/tpm=5Fvtpm=5Fproxy.c<br>&gt; &gt; &nbsp; &nbsp;@@ -=
456,10 +456,10 @@ err=5Fdelete=5Fproxy=5Fdev:<br>&gt; &gt; &nbsp; &nbsp; &n=
bsp;*/<br>&gt; &gt; &nbsp; &nbsp; static void vtpm=5Fproxy=5Fdelete=5Fdevic=
e(struct proxy=5Fdev
*proxy=5Fdev)<br>&gt; &gt; &nbsp; &nbsp; {<br>&gt; &gt; &nbsp; &nbsp;- &nbs=
p; &nbsp; &nbsp; tpm=5Fchip=5Funregister(proxy=5Fdev-&gt;chip);<br>&gt; &gt=
; &nbsp; &nbsp;-<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vtpm=
=5Fproxy=5Ffops=5Fundo=5Fopen(proxy=5Fdev);<br>&gt; &gt; <br>&gt; &gt; &nbs=
p; &nbsp;+ &nbsp; &nbsp; &nbsp;tpm=5Fchip=5Funregister(proxy=5Fdev-&gt;chip=
);<br>&gt; &gt; &nbsp; &nbsp;+<br>&gt; &gt; &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp;vtpm=5Fproxy=5Fdelete=5Fproxy=5Fdev(proxy=5Fdev);<br>&gt; &gt; &n=
bsp; &nbsp; }<br>&gt; &gt; <br>&gt; &gt; &nbsp; &nbsp;Can you let me know w=
hether this gets it working
for you? I'd prepare a<br>&gt; &gt; &nbsp; &nbsp;v9.<br>&gt; <br>&gt; So is=
 the deadlock such that:<br>&gt; <br>&gt; * tpm=5Fchip=5Funregister() tries=
 to write lock ops=5Fsem.<br>&gt; * tpm=5Ftransmit() holds read lock to ops=
=5Fsem.<br>&gt; <br>&gt; This takes two minutes if no timeouts are calculat=
ed.<br>&gt; <br>&gt; And is the effect of moving vtpm=5Fproxy=5Ffops=5Fundo=
=5Fopen() upwards such<br>&gt; that vtpm=5Fproxy=5Ftpm=5Freq=5Fcanceled() s=
tarts returning true, which in<br>&gt; effect breaks the loop in tpm=5Ftran=
smit()?<br>&gt; <br>&gt; Yeah, the fix as a code change is very simple but =
I had to use perf<br>&gt; probe to verify this so maybe a comment there wou=
ld be in place to<br>&gt; tell why tpm=5Fchip=5Funregister() must be called=
 last (write lock).</font></tt><br><br><tt><font size=3D2>I'll put a commen=
t. The reason is that the client
(user of /dev/tpmX) is possibly holding the 'ops' lock while we the proxy
driver needs it when calling tom=5Fchip=5Funregister.</font></tt><br><tt><f=
ont size=3D2>Thanks for trying it.</font></tt><br><br><tt><font size=3D2>&n=
bsp; &nbsp;Stefan</font></tt><br><BR>
--=_alternative 007AC0CB85257F75_=--



--===============6974168471546955591==
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
--===============6974168471546955591==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============6974168471546955591==--
