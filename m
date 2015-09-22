From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 7/9] vfs: Remove copy_file_range mountpoint checks
Date: Tue, 22 Sep 2015 13:52:08 +0200
Message-ID: <20150922115208.GI8891@twin.jikos.cz>
References: <1442003423-6884-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1442003423-6884-8-git-send-email-Anna.Schumaker@Netapp.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1442003423-6884-8-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 11, 2015 at 04:30:20PM -0400, Anna Schumaker wrote:
> I still want to do an in-kernel copy even if the files are on different
> mountpoints, and NFS has a "server to server" copy that expects two
> files on different mountpoints.  Let's have individual filesystems
> implement this check instead.
> 
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

The cross-fs checks exist in the btrfs callback,

Reviewed-by: David Sterba <dsterba@suse.com>
