From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date: Tue, 19 Nov 2019 02:06:02 -0800
Message-ID: <CALCETrVXGuShozaf5RpgmQnwtTpAbmaTVny+E0q8OE4OLuWwAQ@mail.gmail.com>
References: <2476454.l8LQlgn7Hv@positron.chronox.de> <4EB89769-7A2C-4A03-A832-9A0539DD3336@amacapital.net>
 <3043322.Kq9igzfA0K@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3043322.Kq9igzfA0K@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Vito Caputo <vcaputo@pengaru.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>, William Jon McCann <mccann@jhu.edu>, zhangjs <zachary@baishancloud.com>, Andy Lutomirski <luto@kernel.org>, Florian Weimer <fweimer@redhat.com>, Lennart Poettering <mzxreary@0>
List-Id: linux-api@vger.kernel.org

On Sun, Nov 17, 2019 at 4:16 AM Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
>
> Am Samstag, 16. November 2019, 17:39:40 CET schrieb Andy Lutomirski:
>
> Hi Andy,
>
> > > On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de=
> wrote:
> > >
> > > =EF=BB=BFThe LRNG /proc interface provides the same files as the lega=
cy
> > > /dev/random. These files behave identically. Yet, all files are
> > > documented at [1].
> >
> > Why?
>
> I am not sure here: are you referring to the documentation? Or the one
> additional file?
>
> If it is the documentation, do you want me to add it to the patch descrip=
tion?
> I initially did not add it as these files were present and seemingly know=
n
> what they provide. But I would add that documentation to the patch descri=
ption
> if this is desired.

Sorry, I should have been a lot more explicit.  Why do you want to add
a new interface to read the RNG?  What's wrong with the old one?

I think your patch description should explain the purpose of the patch.
