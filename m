From: Richard Weinberger <richard@nod.at>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add
 FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Fri, 22 Mar 2019 23:02:49 +0100
Message-ID: <4190811.5ckf3pJJgb@blindfold>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <20190221184203.GB140206@gmail.com> <20190318230830.GA40545@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190318230830.GA40545@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-ext4@vger.kernel.org, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

Ericm

Am Dienstag, 19. M=E4rz 2019, 00:08:31 CET schrieb Eric Biggers:
> I tried using sb->s_bdi->name, but it's still "ubifs" for all UBIFS files=
ystems.

hmpf.
 =

> Perhaps there's a way you can make ->s_id for UBIFS unique?  There are al=
ready
> existing places that log ->s_id, so perhaps you should do it anyway regar=
dless
> of this patchset?

Yes, let me implement that.
ubifs does:
super_setup_bdi_name(sb, "ubifs_%d_%d", c->vi.ubi_num, c->vi.vol_id);

So, I try to set ->s_id also to ubifs_%d_%d.

> > > =

> > > > Note that the keyring name isn't particularly important, since the =
ioctls will
> > > > work regardless.  But we might as well choose something logical, si=
nce the
> > > > keyring name will still show up in /proc/keys.
> > > =

> > > I'm not done with reviewing your patches, but will it be possible to =
use keyctl?
> > > For the a unique name is helpful. :)
> > > =

> > =

> > Not for adding keys, removing keys, or getting a key's status -- those =
are what
> > the ioctls are for.
> > =

> > See e.g. the discussion in patch 7 ("fscrypt: add FS_IOC_ADD_ENCRYPTION=
_KEY
> > ioctl") for why the keyrings syscalls are a poor fit for fscrypt.
> > =

> =

> Anyway, perhaps I should reconsider whether fscrypt should even use the k=
eyrings
> subsystem at all, even just "internally", as its quirks still leak out a =
bit.
> I'd prefer a nice clean API without any quirks like having to name the ke=
yrings
> and assign SELinux labels to the keys just to make the keyrings subsystem=
 happy.

IMHO the keys subsytem is a good fit. For example for stuff like this one:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1945778.html

We use UBIFS on many embedded systems with crypto hardware.

Thanks,
//richard
