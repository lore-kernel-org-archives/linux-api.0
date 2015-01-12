From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [v8 2/5] ext4: adds project ID support
Date: Mon, 12 Jan 2015 18:01:22 +0100
Message-ID: <20150112170122.GK4468@quack.suse.cz>
References: <1418102548-5469-1-git-send-email-lixi@ddn.com>
 <1418102548-5469-3-git-send-email-lixi@ddn.com>
 <20150108082625.GA15339@quack.suse.cz>
 <2EE35986-B398-432E-92D4-EEF875381319@dilger.ca>
 <20150109094758.GA2576@quack.suse.cz>
 <20150109234627.GN31508@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150109234627.GN31508@dastard>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Filesystem Development List <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ext4 development <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat 10-01-15 10:46:27, Dave Chinner wrote:
> On Fri, Jan 09, 2015 at 10:47:58AM +0100, Jan Kara wrote:
> > On Thu 08-01-15 15:20:21, Andreas Dilger wrote:
> > > On Jan 8, 2015, at 1:26 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > > > On Tue 09-12-14 13:22:25, Li Xi wrote:
> > > >> This patch adds a new internal field of ext4 inode to save project
> > > >> identifier. Also a new flag EXT4_INODE_PROJINHERIT is added for
> > > >> inheriting project ID from parent directory.
> > > >  I have noticed one thing you apparently changed in v7 of the patch set.
> > > > See below.
> > > > 
> > > >> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> > > >> index 29c43e7..8bd1da9 100644
> > > >> --- a/fs/ext4/ext4.h
> > > >> +++ b/fs/ext4/ext4.h
> > > >> @@ -377,16 +377,18 @@ struct flex_groups {
> > > >> #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
> > > >> #define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
> > > >> #define EXT4_INLINE_DATA_FL		0x10000000 /* Inode has inline data. */
> > > >> +#define EXT4_PROJINHERIT_FL		FS_PROJINHERIT_FL /* Create with parents projid */
> > > >  How did FS_PROJINHERIT_FL get here? There used to be 0x20000000 in older
> > > > version of the patch set which is correct - this definition is defining
> > > > ext4 on-disk format. As such it is an ext4 specific flag and should be
> > > > definined to a fixed constant independed of any other filesystem. It seems
> > > > you are somewhat mixing what is an on-disk format flag value and what is a
> > > > flag value passed from userspace. These two may be different things and
> > > > you need to convert between the values when getting / setting flags...
> > > 
> > > Currently the EXT4_*_FL and FS_*_FL values are all identical, and there
> > > is no reason to change that before it is actually needed.  Since the
> > > FS_PROJINHERIT_FL is used via chattr/lsattr from userspace, this value
> > > must also be kept the same in the future to avoid API breakage, so there
> > > is no reason to worry about incompatibilities.
> >   Agreed. I was somewhat worried about having on-disk flag defined through
> > the external non-ext4 define but you are right that neither can really
> > change once we ship a kernel with it.
> > 
> > > See also the [v8 5/5] patch, which is changing the EXT4_*_FL values to
> > > use FS_*_FL constants, where applicable, so that it is more clear that
> > > these values need to be the same.
> >   OK, I've missed that. So if things will be consistent again, I'm fine
> > with the change.
> 
> Except that I NACK'd that change (i.e patch 4/5) because it's out of
> scope of a "support project quota" patchset. not to mention that it
> is broken because it exhausts the flags space with ext4 specific
> flags and prevents future expansion of the ioctl structure.
  I agree with your objections from that review (which is why I didn't
reply to that email since I didn't have more to say).

> Any extension to the ioctl needs to be done in a spearate patch set,
> with separate justification. This patch set should only implement
> the very minimum needed to use the project quota ioctl flags....
  Agreed. I was just saying that I have nothing against defining ext4 flag
values using FS_*_FL where possible.

							Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
