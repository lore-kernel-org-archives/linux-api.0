From: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] introduce sys_syncfs to sync a single file system
Date: Sat, 12 Mar 2011 21:22:16 +0200
Message-ID: <1299957736.2332.4.camel@koala>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
	 <Pine.LNX.4.64.1103101125150.4190@cobra.newdream.net>
	 <edfa4cf081249734807e582c14253fca.squirrel@webmail.greenhost.nl>
	 <201103111255.44979.arnd@arndb.de>
	 <ffafd3ccb3fd1be7c40348c9cee84aef.squirrel@webmail.greenhost.nl>
	 <4D7AC0FE.8070806@gmail.com>
	 <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel@webmail.greenhost.nl>
Reply-To: dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1d4d1b7ae64da97f44cad0e2bda4f832.squirrel-2RFepEojUI3wYrDfM2ltn5vKXLoBo5SK@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Indan Zupancic <indan-1J6HnF7K7zE@public.gmane.org>
Cc: Ric Wheeler <ricwheeler-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sage Weil <sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K. V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, l@jasper.es
List-Id: linux-api@vger.kernel.org

On Sat, 2011-03-12 at 02:33 +0100, Indan Zupancic wrote:
> > I think that you missed the point of the extension.
> >
> > Ric
>=20
> The point is clear, it's to synchronize a specific file system instea=
d
> of all of them.
>=20
> But actually doing that from a program is harder than it looks, becau=
se
> programs work with files, not file systems. To make this feature usef=
ul
> the program needs meta information it can't easily get. That was my f=
irst
> point.

I had a program, actually a set of programs, which test a file-system.
And this set of programs needed such a feature quite a lot, to sync the
=46S which is being tested and nothing else - for both performance reas=
ons
and to put more stress to the FS under testing. We used -o remount, rw
for this - but this forced us to run under root.

IOW, there are programs which take a mount point as an input parameter
and want do things with the whole FS, not only individual files.

--=20
Best Regards,
Artem Bityutskiy (=D0=91=D0=B8=D1=82=D1=8E=D1=86=D0=BA=D0=B8=D0=B9 =D0=90=
=D1=80=D1=82=D1=91=D0=BC)
