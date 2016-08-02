From: Mark Fasheh <mfasheh@suse.de>
Subject: Re: [PATCH] vfs: cap dedupe request structure size at PAGE_SIZE
Date: Mon, 1 Aug 2016 19:35:07 -0700
Message-ID: <20160802023507.GH5316@wotan.suse.de>
References: <20160728183534.GB15753@birch.djwong.org>
Reply-To: Mark Fasheh <mfasheh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20160728183534.GB15753@birch.djwong.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Vlastimil Babka <vbabka@suse.cz>
List-Id: linux-api@vger.kernel.org

On Thu, Jul 28, 2016 at 11:35:34AM -0700, Darrick J. Wong wrote:
> Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
> in any way, and uses the number to allocate kernel memory.  This causes
> high order allocation warnings in the kernel log if someone passes in a
> big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
> stressing the VM.
> 
> The two existing users of the dedupe ioctl never send more than 120
> requests, so we can safely clamp dest_range at PAGE_SIZE, because with
> 4k pages we can handle up to 127 dedupe candidates.  Given the max
> extent length of 16MB, we can end up doing 2GB of IO which is plenty.
> 
> Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
