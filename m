From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v9 0/4] VFS: In-kernel copy system call
Date: Wed, 11 Nov 2015 03:38:27 +0000
Message-ID: <20151111033827.GJ22011@ZenIV.linux.org.uk>
References: <1447192413-15376-1-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447192413-15376-1-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On Tue, Nov 10, 2015 at 04:53:29PM -0500, Anna Schumaker wrote:
> Copy system calls came up during Plumbers a while ago, mostly because several
> filesystems (including NFS and XFS) are currently working on copy acceleration
> implementations.  We haven't heard from Zach Brown in a while, so I volunteered
> to push his patches upstream so individual filesystems don't need to keep
> writing their own ioctls.

OK, taken for the next cycle.  FWIW, I'm going to toss COMPAT_SYSCALL_DEFINE
counterpart in as well - right now it's doing only native, AFAICS.
