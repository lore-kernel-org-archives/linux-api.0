From: Mihai =?UTF-8?B?RG9uyJt1?= <mihai.dontu@gmail.com>
Subject: Re: [PATCHv8.1] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Thu, 2 Oct 2014 09:50:46 +0300
Message-ID: <20141002095046.3715eb69@mdontu-l>
References: <cover.1411562410.git.ydroneaud@opteya.com>
	<9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
	<542481B3.8070300@gmx.de>
	<1411721898.7778.18.camel@localhost.localdomain>
	<542666B2.9080700@gmx.de>
	<1411980555-10818-1-git-send-email-ydroneaud@opteya.com>
	<20141001153621.65e9258e65a6167bf2e4cb50@linux-foundation.org>
	<1412230855.28184.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1412230855.28184.5.camel@localhost.localdomain>
Sender: stable-owner@vger.kernel.org
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Lino Sanfilippo <LinoSanfilippo@gmx.de>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 02 Oct 2014 08:20:55 +0200 Yann Droneaud wrote:
> Hi,
>=20
> Le mercredi 01 octobre 2014 =C3=A0 15:36 -0700, Andrew Morton a =C3=A9=
crit :
> > On Mon, 29 Sep 2014 10:49:15 +0200 Yann Droneaud <ydroneaud@opteya.=
com> wrote:
> >=20
> > > According to commit 80af258867648 ('fanotify: groups can specify
> > > their f_flags for new fd'), file descriptors created as part of
> > > file access notification events inherit flags from the
> > > event_f_flags argument passed to syscall fanotify_init(2).
> > >=20
> > > So while it is legal for userspace to call fanotify_init() with
> > > O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
> > > silently ignored.
> > >=20
> > > Indeed event_f_flags are only given to dentry_open(), which only
> > > seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
> > > O_DIRECT in open_check_o_direct() and O_LARGEFILE in
> > > generic_file_open().
> > >=20
> > > But it seems logical to set close-on-exec flag on the file
> > > descriptor if userspace is allowed to request it with O_CLOEXEC.
> > >=20
> > > In fact, according to some lookup on http://codesearch.debian.net=
/
> > > and various search engine, there's already some userspace code
> > > requesting it:
> > >=20
> > > - in systemd's readahead[2]:
> > >=20
> > >     fanotify_fd =3D fanotify_init(FAN_CLOEXEC|FAN_NONBLOCK, O_RDO=
NLY|O_LARGEFILE|O_CLOEXEC|O_NOATIME);
> > >=20
> > > - in clsync[3]:
> > >=20
> > >     #define FANOTIFY_EVFLAGS (O_LARGEFILE|O_RDONLY|O_CLOEXEC)
> > >=20
> > >     int fanotify_d =3D fanotify_init(FANOTIFY_FLAGS, FANOTIFY_EVF=
LAGS);
> > >=20
> > > - in examples [4] from "Filesystem monitoring in the Linux
> > >   kernel" article[5] by Aleksander Morgado:
> > >=20
> > >     if ((fanotify_fd =3D fanotify_init (FAN_CLOEXEC,
> > >                                       O_RDONLY | O_CLOEXEC | O_LA=
RGEFILE)) < 0)
> >=20
> > So we have a number of apps which are setting O_CLOEXEC, but it doe=
sn't
> > actually work.  With this change it *will* work, so the behaviour o=
f
> > those apps might change, possibly breaking them?
> >=20
>=20
> In the other hand, not enabling close-on-exec might expose unwanted f=
ile
> descriptor to childs, creating security issues. YMMV.
>=20

As someone who uses fanotify for content introspection, I can say that
I am _explicitly_ marking the fd obtained via read() as O_CLOEXEC,
because I have encountered a situation where a child managed to create
a deadlock because it kept the fd open after the main application
responded with FAN_ALLOW.

--=20
Mihai Don=C8=9Bu
