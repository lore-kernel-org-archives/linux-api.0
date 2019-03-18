From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add
 FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Mon, 18 Mar 2019 16:08:31 -0700
Message-ID: <20190318230830.GA40545@gmail.com>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
 <20190221054938.GA12467@sol.localdomain>
 <2024630.T9XyBPH5Ub@blindfold> <20190221184203.GB140206@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20190221184203.GB140206@gmail.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Richard Weinberger <richard@nod.at>
Cc: linux-ext4@vger.kernel.org, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

Hi Richard,

On Thu, Feb 21, 2019 at 10:42:03AM -0800, Eric Biggers wrote:
> On Thu, Feb 21, 2019 at 10:33:12AM +0100, Richard Weinberger wrote:
> > Eric,
> > 
> > Am Donnerstag, 21. Februar 2019, 06:49:39 CET schrieb Eric Biggers:
> > > Hi Richard,
> > > 
> > > On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> > > > On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > > > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > > > > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > > > > +
> > > > > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > > > > +
> > > > > +static void format_fs_keyring_description(
> > > > > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > > > > +                       const struct super_block *sb)
> > > > > +{
> > > > > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > > > > +}
> > > > 
> > > > I fear ->s_id is not the right thing.
> > > > For filesystems such as ext4 ->s_id is the name of the backing block device,
> > > > so it is per filesysem instance unique.
> > > > But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> > > > So the names will clash.
> > > > 
> > > 
> > > What name do you suggest using for UBIFS filesystems?  The keyring name could be
> > > set by the filesystem via a fscrypt_operations callback if needed.
> > 
> > IMHO the BDI name should be used. 

I tried using sb->s_bdi->name, but it's still "ubifs" for all UBIFS filesystems.

Perhaps there's a way you can make ->s_id for UBIFS unique?  There are already
existing places that log ->s_id, so perhaps you should do it anyway regardless
of this patchset?

> > 
> > > Note that the keyring name isn't particularly important, since the ioctls will
> > > work regardless.  But we might as well choose something logical, since the
> > > keyring name will still show up in /proc/keys.
> > 
> > I'm not done with reviewing your patches, but will it be possible to use keyctl?
> > For the a unique name is helpful. :)
> > 
> 
> Not for adding keys, removing keys, or getting a key's status -- those are what
> the ioctls are for.
> 
> See e.g. the discussion in patch 7 ("fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY
> ioctl") for why the keyrings syscalls are a poor fit for fscrypt.
> 

Anyway, perhaps I should reconsider whether fscrypt should even use the keyrings
subsystem at all, even just "internally", as its quirks still leak out a bit.
I'd prefer a nice clean API without any quirks like having to name the keyrings
and assign SELinux labels to the keys just to make the keyrings subsystem happy.

- Eric
