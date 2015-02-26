From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Documenting MS_LAZYTIME
Date: Thu, 26 Feb 2015 08:31:13 -0500
Message-ID: <20150226133113.GD11217@thunk.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <54E7578E.4090809@redhat.com>
 <20150221025636.GB7922@thunk.org>
 <54EEDE23.6080009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54EEDE23.6080009@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 09:49:39AM +0100, Michael Kerrisk (man-pages) wrote:
> > How about somethign like "This mount significantly reduces writes
> > needed to update the inode's timestamps, especially mtime and actime.
> 
> What is "actime" in the preceding line? Should it be "ctime"?

Sorry, no, it should be "atime".

> I find the wording of there a little confusing. Is the following 
> a correct rewrite:
> 
>     The advantage of MS_STRICTATIME | MS_LAZYTIME is that stat(2)
>     will return the correctly updated atime, but the atime updates
>     will be flushed to disk only when (1) the inode needs to be 
>     updated for filesystem / data consistency reasons or (2) the 
>     inode is pushed out of memory, or (3) the filesystem is 
>     unmounted.)

Yes, that's correct.  The only other thing I might add is that in the
case of a crash, the atime (or mtime) fields on disk might be out of
date by at most 24 hours.

						- Ted
