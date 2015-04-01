From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [v10 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Wed, 1 Apr 2015 17:00:01 +0800
Message-ID: <CAPTn0cBk8MEFxZRyuUg-D6=sSb+0eYcHWRtji-xUPYgCyBsRrA@mail.gmail.com>
References: <1426705497-22158-1-git-send-email-lixi@ddn.com>
	<1426705497-22158-5-git-send-email-lixi@ddn.com>
	<20150319095634.GF28368@quack.suse.cz>
	<CAPTn0cAkHZ7xhrR2RPpDqffX-Mndt7aPQ-PTHb3tkfCdUWLPBA@mail.gmail.com>
	<20150401072037.GA25311@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150401072037.GA25311@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "hch@infradead.org" <hch@infradead.org>, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: linux-api@vger.kernel.org

Hi Jan Kara,

Hope you=E2=80=98ve recovered physically. :)

I've pushed the version 11 patches which still disallow the ownder of
a file to change its project ID. I will remove this limit in the
coming verion 12 patches.

On Wed, Apr 1, 2015 at 3:20 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 20-03-15 21:24:07, Li Xi wrote:
>> On Thu, Mar 19, 2015 at 5:56 PM, Jan Kara <jack@suse.cz> wrote:
>> > On Thu 19-03-15 04:04:56, Li Xi wrote:
>> >> This patch adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR ioctl interfa=
ce
>> >> support for ext4. The interface is kept consistent with
>> >> XFS_IOC_FSGETXATTR/XFS_IOC_FSGETXATTR.
>> >   Two more comments below.
>> >
>> >>
>> >> Signed-off-by: Li Xi <lixi@ddn.com>
>> > ...
>> >> +static int ext4_ioctl_setproject(struct file *filp, __u32 projid=
)
>> >> +{
>> >> +     struct inode *inode =3D file_inode(filp);
>> >> +     struct super_block *sb =3D inode->i_sb;
>> >> +     struct ext4_inode_info *ei =3D EXT4_I(inode);
>> >> +     int err;
>> >> +     handle_t *handle;
>> >> +     kprojid_t kprojid;
>> >> +     struct ext4_iloc iloc;
>> >> +     struct ext4_inode *raw_inode;
>> >> +
>> >> +     struct dquot *transfer_to[EXT4_MAXQUOTAS] =3D { };
>> >> +
>> >> +     /* Make sure caller can change project. */
>> >> +     if (!capable(CAP_SYS_ADMIN))
>> >> +             return -EACCES;
>> >   Why do you test capabilities here when you already test permissi=
on in
>> > EXT4_IOC_FSSETXATTR? Furthermore this test is too restrictive. Jus=
t delete
>> > it.
>> It seems we need this restrictive permission. Otherwise the owner of=
 the file
>> can change the project ID to any other project. That means, the owne=
r can
>> walk around the quota limit whenever he/she wants. But I agree check=
ing
>> permission twice is not good.
>   Sorry for a late reply but I was catching up with stuff after a
> conference and then got ill. So I agree that owner of a file can esca=
pe
> project quota limit whenever he/she wants by setting project to somet=
hing
> else. Sadly that's how project quota has been originally designed and=
 how
> it works in XFS for years. So we should start with being compatible w=
ith
> this behavior.
>
> Konstantin has in his patches patch "fs: protected project id" which
> creates a sysctl which controls whether or not owner is able to set
> arbitrary project id. That is one way to improve the situation so tha=
t
> project quotas are usable also in situations where setting project qu=
otas
> to any project by file owner is undesirable. Christoph also had an id=
ea
> that we could allow owner to set project to anything when current pro=
ject
> is unset (0). Once project is set, only CAP_SYS_ADMIN (maybe better
> capability would be CAP_CHOWN actually) process can change it. We can
> discuss how to change the current XFS model to suit new usecases but =
IMHO
> we should start the way XFS is...
>
>                                                                 Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
