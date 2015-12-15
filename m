From: Joe Perches <joe@perches.com>
Subject: Re: [RFC v5 0/8] Additional kmsg devices
Date: Tue, 15 Dec 2015 15:46:06 -0800
Message-ID: <1450223166.4142.34.camel@perches.com>
References: <1445941723-20388-1-git-send-email-p.osmialowsk@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445941723-20388-1-git-send-email-p.osmialowsk@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Osmialowski <p.osmialowsk@samsung.com>, Jonathan Corbet <corbet@lwn.net>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Mack <daniel@zonque.org>, Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Richard Weinberger <richard.weinberger@gmail.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Shuah Khan <shuahkh@osg.samsung.com>, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-api@vger.kernel.org

On Tue, 2015-10-27 at 11:28 +0100, Paul Osmialowski wrote:
> Dear All,
>=20
> This is the fifth iteration of Marcin Niesluchowski's serie of patche=
s
> extending kmsg interface with ability to dynamically create (and dest=
roy)
> kmsg-like devices which can be used by userspace for logging.
>=20
> This iteration introduces two changes:
>=20
> 1. selftests are rearranged to use kselftest.h API
>=20
> 2. A disputed=A0=A0patch "add predefined _PID, _TID, _COMM keywords t=
o kmsg*
> =A0=A0=A0log dict" is removed - no chance it will be ever accepted. I=
t is not
> =A0=A0=A0critical for this patchset as a whole.
>=20
> Best regards,
> Paul
>=20
> Marcin Niesluchowski (6):
> =A0 printk: add one function for storing log in proper format
> =A0 kmsg: introduce additional kmsg devices support
> =A0 kmsg: add additional buffers support to memory class
> =A0 kmsg: add function for adding and deleting additional buffers
> =A0 kmsg: add ioctl for adding and deleting kmsg* devices
> =A0 kmsg: add ioctl for kmsg* devices operating on buffers
>=20
> Paul Osmialowski (2):
> =A0 printk: extract kmsg-related routines from printk.c to kmsg.c
> =A0 kmsg: selftests
>=20

Andrew?  Are you or anyone else interested in picking up this patchset?
