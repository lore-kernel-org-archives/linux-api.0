From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 8/9] vfs: Add vfs_copy_file_range() support for
 pagecache copies
Date: Wed, 14 Oct 2015 11:27:01 -0700
Message-ID: <20151014182701.GC31225@infradead.org>
References: <1443634014-3026-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1443634014-3026-9-git-send-email-Anna.Schumaker@Netapp.com>
 <20151011142203.GA31867@infradead.org>
 <20151012231749.GC11398@birch.djwong.org>
 <561E980C.9010509@Netapp.com>
 <CALCETrU0-Q-q0u0BAPwu+mbyS+LVp6M1Hqro3xwzSm7eNCbEmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALCETrU0-Q-q0u0BAPwu+mbyS+LVp6M1Hqro3xwzSm7eNCbEmg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Anna Schumaker <Anna.Schumaker@netapp.com>, Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nfs@vger.kernel.org, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Zach Brown <zab@zabbo.net>, Al Viro <viro@zeniv.linux.org.uk>, Chris Mason <clm@fb.com>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, andros@netapp.com
List-Id: linux-api@vger.kernel.org

On Wed, Oct 14, 2015 at 11:08:40AM -0700, Andy Lutomirski wrote:
> > So what I'm hearing is that I should drop the reflink and dedup flags and change this system call only perform a full copy (with preserving of sparseness), correct?  I can make those changes, but only if everybody is in agreement that it's the best way forward.
> 
> I personally rather like the reflink option.  That thing is quite useful.

reflink is very useful, probably more useful than the copy actually. But it
is different from a copy.  It should be a separate interface.
