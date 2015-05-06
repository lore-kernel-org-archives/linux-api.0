From: Sage Weil <sweil@redhat.com>
Subject: Re: [PATCH RFC] vfs: add a O_NOMTIME flag
Date: Wed, 6 May 2015 15:19:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1505061515550.28239@cobra.newdream.net>
References: <1430949612-21356-1-git-send-email-zab@redhat.com> <CAHQdGtS0=Gjyq2E2QO+zu_HAzdrHJwxtfZ8MB5q0DjWHMEc7hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHQdGtS0=Gjyq2E2QO+zu_HAzdrHJwxtfZ8MB5q0DjWHMEc7hw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Zach Brown <zab@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux API Mailing List <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Wed, 6 May 2015, Trond Myklebust wrote:
> Hi Zach,
> 
> On Wed, May 6, 2015 at 6:00 PM, Zach Brown <zab@redhat.com> wrote:
> >
> > Add the O_NOMTIME flag which prevents mtime from being updated which can
> > greatly reduce the IO overhead of writes to allocated and initialized
> > regions of files.
> >
> > ceph servers can have loads where they perform O_DIRECT overwrites of
> > allocated file data and then sync to make sure that the O_DIRECT writes
> > are flushed from write caches.  If the writes dirty the inode with mtime
> > updates then the syncs also write out the metadata needed to track the
> > inodes which can add significant iop and latency overhead.
> >
> > The ceph servers don't use mtime at all.  They're using the local file
> > system as a backing store and any backups would be driven by their upper
> > level ceph metadata.  For ceph, slow IO from mtime updates in the file
> > system is as daft as if we had block devices slowing down IO for
> > per-block write timestamps that file systems never use.
> >
> > In simple tests a O_DIRECT|O_NOMTIME overwriting write followed by a
> > sync went from 2 serial write round trips to 1 in XFS and from 4 serial
> > IO round trips to 1 in ext4.
> >
> > file_update_time() checks for O_NOMTIME and aborts the update if it's
> > set, just like the current check for the in-kernel inode flag
> > S_NOCMTIME.  I didn't update any other mtime update sites. They could be
> > added as we decide that it's appropriate to do so.
> >
> > I opted not to name the flag O_NOCMTIME because I didn't want the name
> > to imply that ctime updates would be prevented for other inode changes
> > like updating i_size in truncate.  Not updating ctime is a side-effect
> > of removing mtime updates when it's the only thing changing in the
> > inode.
> >
> > The criteria for using O_NOMTIME is the same as for using O_NOATIME:
> > owning the file or having the CAP_FOWNER capability.  If we're not
> > comfortable allowing owners to prevent mtime/ctime updates then we
> > should add a tunable to allow O_NOMTIME.  Maybe a mount option?
> >
> 
> Just out of curiosity, if you need to modify the application anyway,
> why wouldn't use of fdatasync() when flushing be able to offer a
> similar performance boost?

Although fdatasync(2) doesn't have to update synchronously, it does 
eventually get written, and that can trigger lots of unwanted IO.

In practice we fsync(2) to avoid deferred IO that we can't control/bound, 
but that's a long and sad story.  O_NOMTIME would make for a much better 
ending!

sage
