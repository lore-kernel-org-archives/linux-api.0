From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 2/2] mm, fs: daxfile, an interface for
 byte-addressable updates to pmem
Date: Wed, 21 Jun 2017 09:53:46 +1000
Message-ID: <20170620235346.GK17542@dastard>
References: <CAPcyv4j4UEegViDJcLZjVv5AFGC18-DcvHFnhZatB0hH3BY85g@mail.gmail.com>
 <CALCETrUfv26pvmyQ1gOkKbzfSXK2DnmeBG6VmSWjFy1WBhknTw@mail.gmail.com>
 <CAPcyv4iPb69e+rE3fJUzm9U_P_dLfhantU9mvYmV-R0oQee4rA@mail.gmail.com>
 <CALCETrVY38h2ajpod2U_2pdHSp8zO4mG2p19h=OnnHmhGTairw@mail.gmail.com>
 <20170619132107.GG11993@dastard>
 <CALCETrUe0igzK0RZTSSondkCY3ApYQti89tOh00f0j_APrf_dQ@mail.gmail.com>
 <20170620004653.GI17542@dastard>
 <CALCETrVuoPDRuuhc9X8eVCYiFUzWLSTRkcjbD6jas_2J2GixNQ@mail.gmail.com>
 <20170620084924.GA9752@lst.de>
 <CAPcyv4jkH6iwDoG4NnCaTNXozwYgVXiJDe2iFSONcE63KvGQoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jkH6iwDoG4NnCaTNXozwYgVXiJDe2iFSONcE63KvGQoA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Lutomirski <luto@kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "Rudoff, Andy" <andy.rudoff@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 20, 2017 at 09:17:36AM -0700, Dan Williams wrote:
> On Tue, Jun 20, 2017 at 1:49 AM, Christoph Hellwig <hch@lst.de> wrote:
> > [stripped giant fullquotes]
> >
> > On Mon, Jun 19, 2017 at 10:53:12PM -0700, Andy Lutomirski wrote:
> >> But that's my whole point.  The kernel doesn't really need to prevent
> >> all these background maintenance operations -- it just needs to block
> >> .page_mkwrite until they are synced.  I think that whatever new
> >> mechanism we add for this should be sticky, but I see no reason why
> >> the filesystem should have to block reflink on a DAX file entirely.
> >
> > Agreed - IFF we want to support write through semantics this is the
> > only somewhat feasible way.  It still has massive downsides of forcing
> > the full sync machinery to run from the page fauly handler, which
> > I'm rather scared off, but that's still better than creating a magic
> > special case that isn't managable at all.
> 
> An immutable-extent DAX-file and a reflink-capable DAX-file are not
> mutually exclusive,

Actually, they are mutually exclusive: when the immutable extent DAX
inode is breaking the extent sharing done during the reflink
operation, the copy-on-write operation requires allocating and
freeing extents on the inode that has immutable extents. Which, if
the inode really has immutable extents, cannot be done.

That said, if the extent sharing is broken on the other side of the
reflink (i.e. the non-immutable inode created by the reflink) then
the extent map of the inode with immutable extents will remain
unchanged. i.e. there are two sides to this, and if you only see one
side you might come to the wrong conclusion.

However, we cannot guarantee that no writes occur to the inode with
immutable extent maps (especially as the whole point is to allow
userspace writes and commits without the kernel being involved), so
extent sharing on immutable extent maps cannot be allowed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
