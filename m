From: Richard Weinberger <richard@nod.at>
Subject: Re: [RFC PATCH v3 07/18] fscrypt: add FS_IOC_ADD_ENCRYPTION_KEY ioctl
Date: Thu, 21 Feb 2019 10:33:12 +0100
Message-ID: <2024630.T9XyBPH5Ub@blindfold>
References: <20190220065249.32099-1-ebiggers@kernel.org>
 <CAFLxGvy7WsV7Qo42yTbsZf9YnW563a0k6Yx2-NmASNtoektu_Q@mail.gmail.com>
 <20190221054938.GA12467@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20190221054938.GA12467@sol.localdomain>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, "open list:ABI/API" <linux-api@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Satya Tangirala <satyat@google.com>, Paul Crowley <paulcrowley@google.com>
List-Id: linux-api@vger.kernel.org

Eric,

Am Donnerstag, 21. Februar 2019, 06:49:39 CET schrieb Eric Biggers:
> Hi Richard,
> 
> On Thu, Feb 21, 2019 at 12:52:38AM +0100, Richard Weinberger wrote:
> > On Wed, Feb 20, 2019 at 7:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > +#define FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE    \
> > > +       (CONST_STRLEN("fscrypt-") + FIELD_SIZEOF(struct super_block, s_id))
> > > +
> > > +#define FSCRYPT_MK_DESCRIPTION_SIZE    (2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1)
> > > +
> > > +static void format_fs_keyring_description(
> > > +                       char description[FSCRYPT_FS_KEYRING_DESCRIPTION_SIZE],
> > > +                       const struct super_block *sb)
> > > +{
> > > +       sprintf(description, "fscrypt-%s", sb->s_id);
> > > +}
> > 
> > I fear ->s_id is not the right thing.
> > For filesystems such as ext4 ->s_id is the name of the backing block device,
> > so it is per filesysem instance unique.
> > But this is not guaranteed. For UBIFS ->s_id is just "ubifs", always.
> > So the names will clash.
> > 
> 
> What name do you suggest using for UBIFS filesystems?  The keyring name could be
> set by the filesystem via a fscrypt_operations callback if needed.

IMHO the BDI name should be used. 

> Note that the keyring name isn't particularly important, since the ioctls will
> work regardless.  But we might as well choose something logical, since the
> keyring name will still show up in /proc/keys.

I'm not done with reviewing your patches, but will it be possible to use keyctl?
For the a unique name is helpful. :)

Thanks,
//richard



______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
