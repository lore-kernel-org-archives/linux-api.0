From: Dave Chinner <david@fromorbit.com>
Subject: Re: [v8 4/5] ext4: adds FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR
 interface support
Date: Fri, 6 Feb 2015 08:05:01 +1100
Message-ID: <20150205210501.GR4251@dastard>
References: <20150123015307.GD24722@dastard>
 <54C23751.7000009@yandex-team.ru>
 <20150123233026.GP16552@dastard>
 <CALCETrXPCrOTrkoAMuW2os=z6anaEfv4F4D2yDxo6VtCuEtRZw@mail.gmail.com>
 <20150127080239.GQ16552@dastard>
 <54C76C3D.4070404@yandex-team.ru>
 <20150128003746.GR16552@dastard>
 <54D23919.3000408@yandex-team.ru>
 <20150204225844.GA12722@dastard>
 <20150205163815.GK4258@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150205163815.GK4258@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Andy Lutomirski <luto@amacapital.net>, Li Xi <pkuelelixi@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 05, 2015 at 05:38:15PM +0100, Jan Kara wrote:
>   Hello,
> 
> > Users have *always* been allowed to set the project ID of
> > their own files. How else are they going to set the project ID on
> > files they create in random directories so to account them to the
> > correct project they are working on?
> > 
> > However, you keep making the assumption that project quotas ==
> > directory subtree quotas.  Project quotas are *not limited* to
> > directory subtrees - the subtree quota implementation is just an
> > implementation that *sets the default project ID* on files as they
> > are created.
> > 
> > e.g. there are production systems out there where project quotas are
> > used to track home directory space usage rather than user quotas.
> > This means users can take actions like "this file actually belongs
> > to project X and it shouldn't be accounted against my home
> > directory". Users can create their own sub directories that account
> > everything by default to project X rather than their own home
> > directory.
> > 
> > Again: project quotas are an *accounting* mechanism, not a security
> > mechanism.
>   OK, but now I got confused ;) So if users can change project ID of files
> they own, what's the point of project quotas? If I need to create a file
> and project quota doesn't allow me, I just set its project ID to some
> random number and I'm done with that...

Sure, but the admin is going to notice those random numbers in the
next quota report they run and then a user is going to get
re-educated with a clue bat.

> So are really project quotas just
> "advisory" - i.e., all users of a system cooperate so that project X
> doesn't use more space than it should (and project quotas make this
> cooperation somewhat simpler) or is there something which limits which
> project IDs user can set? I didn't find anything...

Not directly.  Project quotas have historically been used in tandem
with user quotas - user quotas cannot be escaped and that puts a
limit on the shenanigans that users can play with project quota.

[ Indeed, Irix only had user and project quotas - it *never* had group
quotas. e.g. when XFS was ported to Linux the project quota inode
was re-purposed for group quotas in 2001:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=749b2bf3ed5ff064efd69370e6b31ea44c4a78a6
]

However, if you have a fileystem system that users can't directly
access (e.g. an NFS server) then you can use project quotas as a
space enforcement mechanism because users can't change the project
ID on the files on the server. We've used the same model with
containers - for the host to be able to use project quotas as space
resource controller, users inside a container must not be able to
change the project ID of a file....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
