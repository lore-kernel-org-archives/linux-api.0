From: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH 01/24] Add the ability to lock down access to the running kernel image
Date: Wed, 11 Apr 2018 17:05:04 -0400
Message-ID: <8z0aRQyD-6Krqntk8UD9WQjK5JSqEai2Pt5oeFU2EplgxoWiHlX5nlJXwCDHQ1WcS1oIprXimgz7UvwHCWDB9Z3dYFrEmZmtkEJSqaYMel8=@protonmail.ch>
References: <152346387861.4030.4408662483445703127.stgit@warthog.procyon.org.uk>
 <152346388583.4030.15146667041427303547.stgit@warthog.procyon.org.uk>
 <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzPo-dip8dgyo0U+g5qai9SAJU+D1c+AFJ0zV9_PBAB8Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-man <linux-man@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, James Morris <jmorris@namei.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On April 11, 2018 8:09 PM, Linus Torvalds <torvalds@linux-foundation.org> w=
rote:

> On Wed, Apr 11, 2018 at 9:24 AM, David Howells dhowells@redhat.com wrote:
>=20
> > Provide a single call to allow kernel code to determine whether the sys=
tem
> >=20
> > should be locked down, thereby disallowing various accesses that might
> >=20
> > allow the running kernel image to be changed, including:
> >=20
> > -   /dev/mem and similar
> > -   Loading of unauthorised modules
> > -   Fiddling with MSR registers
> > -   Suspend to disk managed by the kernel
> > -   Use of device DMA
>=20
> So what I stlll absolutely detest about this series is that I think
>=20
> many of these things should simply be done as separate config options.
>=20
> For example, if the distro is sure that it doesn't need /dev/mem, then
>=20
> why the hell is this tied to "lockdown" that then may have to be
>=20
> disabled because other changes may not be acceptable (eg people may
>=20
> need that device DMA, or whatever).
>=20
> If that /dev/mem access prevention was just instead done as an even
>=20
> stricter mode of the existing CONFIG_STRICT_DEVMEM, it could just be
>=20
> enabled unconditionally.

CONFIG_DEVMEM=3Dn

>=20
> So none of these patches raise my hackles per se. But what continues
>=20
> to makes me very very uncomfortable is how this is all tied together.
>=20
> Why is this one magical mode that then - because it has such a big
>=20
> impact - has to be enabled/disabled as a single magical mode and with
>=20
> very odd rules?
>=20
> I think a lot of people would be happier if this wasn't so incestuous
>=20
> and mixing together independent things under one name, and one flag.
>=20
> I think a lot of the secure boot problems were exacerbated by that mixup.
>=20
> So I would seriously ask that the distros that have been using these
>=20
> patches look at which parts of lockdown they could make unconditional
>=20
> (because it doesn't break machines), and which ones need that escape
>=20
> clause.
>=20
> Linus
>=20

=E2=80=8BJordan
