From: lixi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Date: Thu, 25 Sep 2014 19:34:38 +0800
Message-ID: <C31A739F-4502-4B40-9AE3-F2FE49291657@gmail.com>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com> <1411567470-31799-5-git-send-email-lixi@ddn.com> <20140924162507.GC27000@quack.suse.cz> <20140924162634.GA16886@infradead.org> <20140924170105.GE27000@quack.suse.cz> <20140925075912.GG4758@dastard>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140925075912.GG4758@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org


=D4=DA 2014=C4=EA9=D4=C225=C8=D5=A3=AC=CF=C2=CE=E73:59=A3=ACDave Chinne=
r <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> =D0=B4=B5=C0=A3=BA

> On Wed, Sep 24, 2014 at 07:01:05PM +0200, Jan Kara wrote:
>> On Wed 24-09-14 09:26:34, Christoph Hellwig wrote:
>>> On Wed, Sep 24, 2014 at 06:25:07PM +0200, Jan Kara wrote:
>>>> On Wed 24-09-14 22:04:30, Li Xi wrote:
>>>>> This patch adds ioctl interface for setting/getting project of ex=
t4.
>>>>  The patch looks good to me. I was just wondering whether it won't=
 be
>>>> useful to add an ioctl() which isn't ext4 specific. We could just =
extend
>>>> ->setattr() to allow setting of project ID (most filesystems would=
 just
>>>> return -EOPNOTSUPP but ext4 and xfs could do the right thing) and =
then call
>>>> ->setattr from the generic ioctl. That way userspace won't have to=
 care
>>>> about filesystem type when setting project ID... What do others th=
ink?
>>>=20
>>> Absolutely.  In general I also wonder why this patch doesn't implem=
ent
>>> the full XFS API.  Maybe there is a reason it was considered and
>>> rejected, but it would be helpful to document why.
>>  Do you mean full get/setfsxattr API?
>=20
> That's a good start.
>=20
> The bigger issue in my mind is that we already have a fully featured
> quota API that supports project quotas and userspace tools available
> that manipulate it. xfstests already uses those tools and API
> for testing project quotas.
>=20
> This whole patchset reinvents all the quota APIs, and will require
> adding support in userspace, and hence require re-inventing all the
> test infrastructure we already have because it won't be compatible
> with the existing project quota test code.
>=20
>>  That basically contains project ID,
>> flags (those that are currently get/set with FS_IOC_GETFLAGS/SETFLAG=
S), and
>> extent size hint right?
>=20
> It's a different set of flag definitions. We translate the interface
> XFS_XFLAG_* values to/from the inode on-disk XFS_DIFLAG_* inode value=
s, just
> like we translate the VFS FS_*_FL flags that get passed through the
> FS_IOC_GETFLAGS/SETFLAGS ioctl.
>=20
>> That seems workable and it would also make setting
>> of PROJINHERIT flag fs agnostic. Only we would have to create some g=
eneric
>> flags namespace and merge into that ext4 flags and have a translatio=
n
>> function for the old ext4 flags.
>=20
> The XFS_XFLAGS_* are already filesystem agnostic - they are flags
> that are only used for interfacing with userspace and hence only
> exist at the ioctl copy in/out layer.....
>=20
>> Also I'm afraid we may quickly run out of
>> 32 available flags in xflags so we'd need to extend that. But all th=
is
>> seems to be doable.
>=20
> The struct fsxattr was designed to be extensible - it has unused
> padding and enough space in the flags field to allow us to
> conditionally use that padding=A1=AD.

Hi Dave,

I was mostly working on the semantics of inherit flag on these patches.=
 And
I didn=A1=AFt realized that the interface differences would bother you =
so much. Sorry
for that.

I agree that we should choose a good interface. It would be good that i=
t is
general so that it works well for all file systems. I agree that adding=
 an
ext4 specific ioctl() is far from the best choice. I am willing to chan=
ge it to
any general interface. A general ioctl() sounds good to me. Extend seta=
ttr()
and getattr() for project ID sounds even better, since project ID looks=
 like
UID/GID. And general xattr name is another choice. But it is might be a=
 little
bit confusing if we use xattr actually, since we are not saving project=
 ID as
extended attribute on Ext4. Any choice is fine with me, as long as the
implementation won't introduce nasty codes or inconsistent design.

However, the problem is, I do not quite understand why we should keep
the interface exactly the same with XFS. It would be good if we can. Bu=
t
as far as I can see, it seems hard. XFS uses a lot interfaces which are
not so standard and used by other file systems. For example, struct
fsxattr is not used by other file systems at all except XFS. I am not s=
ure
why we should introduce this into Ext4 if there are a lot of other bett=
er
ways. I would be happy to change to XFS interfaces, if it is general.
However, I don=A1=AFt think it is general enough.

I know xfstest is using the existing project quota interfaces of XFS. A=
nd
maybe there are some applications which are using them too. But
keeping the interfaces exactly the same with XFS would cost so much
effort that I=A1=AFd like to get enough reasons before start working on=
 it. Is it
really necessary? I am not so sure. It is so easy to change user
space applications comparing to changing a weird interfaces. For
example, I think it won=A1=AFt cost even more than a day to add xfstest
support for new Ext4 project quota. And since project quota is far from
a widely used feature, I don=A1=AFt think there is much compatibility p=
roblems
for existing applications.  And If the new project interface are genera=
l
enough, there won=A1=AFt be any compatibility problems for new applicat=
ions
at all.

I might missed something important. So please let me know if you have
any advices.

Regards,
                         - Li Xi--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
