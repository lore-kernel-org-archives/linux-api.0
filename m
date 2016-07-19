From: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 3/3] f2fs: support clone_file_range
Date: Mon, 18 Jul 2016 21:48:20 -0700
Message-ID: <20160719044820.GA80986@jaegeuk>
References: <20160717062427.56718-1-jaegeuk@kernel.org>
	<20160717062427.56718-3-jaegeuk@kernel.org>
	<20160719034736.GA4037@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <20160719034736.GA4037@infradead.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
	<mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
List-Id: linux-api@vger.kernel.org

On Mon, Jul 18, 2016 at 08:47:36PM -0700, Christoph Hellwig wrote:
> On Sat, Jul 16, 2016 at 11:24:27PM -0700, Jaegeuk Kim wrote:
> > This patch implements clone_file_range in f2fs.
> 
> [...]
> 
> > +int f2fs_clone_file_range(struct file *file_in, loff_t pos_in,
> > +		struct file *file_out, loff_t pos_out, u64 len)
> > +{
> > +	return f2fs_clone_files(file_in, pos_in, file_out, pos_out, len);
> > +}
> > +
> 
> Falling back from copy to clone should be done in the VFS.  I look into
> implementing the fallback, and the code is trivial, but we don't seem
> to have any useful coverage for copy_file_range yet, so I didn't dare
> to add it yet.  How did you test copy and clone in f2fs?  And how did
> you handle the difference in corner cases (e.g. the lacking 0 special
> case in copy)?

Frankly speaking, I confused the behaviors without being aware of corner cases.
And thus, I dropped the patches already. Instead, I realized that what I did
was moving a range of blocks from one file to another file. So, I've been
testing a new ioctl, F2FS_IOC_MOVE_RANGE.
In terms of coverage, I just did some unit tests only.

Thanks,

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity planning
reports.http://sdm.link/zohodev2dev
