From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCHv8 1/6] fanotify: enable close-on-exec on events' fd when
 requested in fanotify_init()
Date: Fri, 26 Sep 2014 10:58:18 +0200
Message-ID: <1411721898.7778.18.camel@localhost.localdomain>
References: <cover.1411562410.git.ydroneaud@opteya.com>
	 <9d050a2db4f9cf68cd6cb038f16cccb0f73c6e66.1411562410.git.ydroneaud@opteya.com>
	 <542481B3.8070300@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <542481B3.8070300@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Heinrich Schuchardt <xypron.debian@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, Richard Guy Briggs <rgb@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>, Lino Sanfilippo <LinoSanfilippo@gmx.de>
List-Id: linux-api@vger.kernel.org

Hi,

Le jeudi 25 septembre 2014 =C3=A0 22:57 +0200, Heinrich Schuchardt a =C3=
=A9crit :
> On 24.09.2014 15:11, Yann Droneaud wrote:
> > According to commit 80af258867648 ('fanotify: groups can specify
> > their f_flags for new fd'), file descriptors created as part of
> > file access notification events inherit flags from the
> > event_f_flags argument passed to syscall fanotify_init(2).
> >
> > So while it is legal for userspace to call fanotify_init() with
> > O_CLOEXEC as part of its second argument, O_CLOEXEC is currently
> > silently ignored.
> >
> > Indeed event_f_flags are only given to dentry_open(), which only
> > seems to care about O_ACCMODE and O_PATH in do_dentry_open(),
> > O_DIRECT in open_check_o_direct() and O_LARGEFILE in
> > generic_file_open().
>=20
> I tested on kernel 3.17.0-rc5. I passed O_CLOEXEC in event_f_flags.
> When I called fcnt(event_metadata->fd, F_GETFD) it did not return=20
> FD_CLOEXEC. So I can confirm your observation that O_CLOEXEC is not=20
> working as expected.
>=20
> I found this definition
> #define get_unused_fd() get_unused_fd_flags(0)
>=20
> So essentially when get_unused_fd() is called for a fanotify event=20
> O_CLOEXEC is ignored.
>=20
> This is what your patch fixes.
>=20
> >
> > More, there's no effective check on event_f_flags value that
> > would catch unknown / unsupported values, unlike the one on
> > f_flags argument of the syscall (see FAN_ALL_INIT_FLAGS in
> > include/uapi/linux/fanotify.h).
>=20
> The fanotify_init(2) man page describes which flags are allowable in=20
> event_f_flags.
>=20
> Could you, please, explain why the following code in fanotify_user.c =
is=20
> not to be considered an effective check:
>=20
>      if (event_f_flags & ~FANOTIFY_INIT_ALL_EVENT_F_BITS)
>          return -EINVAL;
>=20
>      switch (event_f_flags & O_ACCMODE) {
>      case O_RDONLY:
>      case O_RDWR:
>      case O_WRONLY:
>          break;
>      default:
>          return -EINVAL;
>      }
>=20
> I CC Jan Kara as he reviewed the code.
>=20

I missed the opportunity to update my commit message.

I've sent my initial version of the patch (with the same wording) on
5th, January, 2014:

http://mid.gmane.org/3d9591f81e62a78a726721c8052b3910870db35e.138895206=
1.git.ydroneaud@opteya.com
http://lkml.kernel.org/r/3d9591f81e62a78a726721c8052b3910870db35e.13889=
52061.git.ydroneaud@opteya.com

The patch was sent again on March, 11:

http://lkml.kernel.org/r/baab31b572b216d13f2149bdf07e0f79a1bae660.13945=
32336.git.ydroneaud@opteya.com
http://mid.gmane.org/baab31b572b216d13f2149bdf07e0f79a1bae660.139453233=
6.git.ydroneaud@opteya.com

And another time, on June, 1st:

http://lkml.kernel.org/r/2c6ab28980f0007ea3b9afa7ecd7497806a6a451.14016=
30396.git.ydroneaud@opteya.com
http://mid.gmane.org/2c6ab28980f0007ea3b9afa7ecd7497806a6a451.140163039=
6.git.ydroneaud@opteya.com

So as you can see, my patch predate yours:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D48149e9d3a7e924010a0daab30a6197b7d7b6580

But I have to apologize: I haven't noticed your patch was merged betwee=
n
my previous submission and the current one. My bad.

I will update the commit message to remove my obsolete comment on the
input parameter check.

Thanks again for review and testing.

Regards.

--=20
Yann Droneaud
OPTEYA
