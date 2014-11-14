From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Date: Fri, 14 Nov 2014 11:39:12 -0500
Message-ID: <20141114163912.GA23769@redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
 <20141111064417.GT23575@dastard>
 <x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-aio@kvack.org>
Content-Disposition: inline
In-Reply-To: <x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
Sender: owner-linux-aio@kvack.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>, Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 14, 2014 at 11:32:53AM -0500, Jeff Moyer wrote:

 > > Can you write a test (or set of) for fstests that exercises this new
 > > functionality? I'm not worried about performance, just
 > > correctness....
 > 
 > On the subject of testing, I added support to trinity (attached,
 > untested).  That did raise one question.  Do we expect applications to
 > #include <linux/fs.h> to get the RWF_NONBLOCK definition?
 
Trinity will at least need an addition to include/compat.h for
older headers that won't have the definition.  Looks ok otherwise.

Also, I usually sit on stuff like this until the syscall numbers are
in Linus tree. This is 3.19 stuff I presume ?
istr akpm picked up execveat recently, so if that goes in first, we'll
need to respin this anyway..

	Dave

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
