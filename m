From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v1 3/8] btrfs: add .copy_file_range file operation
Date: Wed, 9 Sep 2015 10:39:11 +0200
Message-ID: <20150909083911.GC8891@twin.jikos.cz>
References: <1441397823-1203-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1441397823-1203-4-git-send-email-Anna.Schumaker@Netapp.com>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1441397823-1203-4-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

On Fri, Sep 04, 2015 at 04:16:57PM -0400, Anna Schumaker wrote:
> From: Zach Brown <zab@redhat.com>
> 
> This rearranges the existing COPY_RANGE ioctl implementation so that the
> .copy_file_range file operation can call the core loop that copies file
> data extent items.
> 
> The extent copying loop is lifted up into its own function.  It retains
> the core btrfs error checks that should be shared.
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
> Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>

Reviewed-by: David Sterba <dsterba@suse.com>
