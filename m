From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Date: Thu, 12 Apr 2018 08:00:59 -0600
Message-ID: <20180412140059.GA7992@linux.intel.com>
References: <20171101153648.30166-1-jack@suse.cz>
 <20171101153648.30166-20-jack@suse.cz>
 <CAKgNAkhsFrcdkXNA2cw3o0gJV0uLRtBg9ybaCe5xy1QBC2PgqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKgNAkhsFrcdkXNA2cw3o0gJV0uLRtBg9ybaCe5xy1QBC2PgqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Darrick J . Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ext4 Developers List <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Apr 12, 2018 at 03:00:49PM +0200, Michael Kerrisk (man-pages) wrote:
> Hello Jan,
> 
> I have applied your patch, and tweaked the text a little, and pushed
> the result to the git repo.
> 
> On 1 November 2017 at 16:36, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
> > Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> 
> I have a question below.
> 
> > ---
> >  man2/mmap.2 | 35 ++++++++++++++++++++++++++++++++++-
> >  1 file changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/man2/mmap.2 b/man2/mmap.2
> > index 47c3148653be..b38ee6809327 100644
> > --- a/man2/mmap.2
> > +++ b/man2/mmap.2
> > @@ -125,6 +125,21 @@ are carried through to the underlying file.
> >  to the underlying file requires the use of
> >  .BR msync (2).)
> >  .TP
> > +.BR MAP_SHARED_VALIDATE " (since Linux 4.15)"
> > +The same as
> > +.B MAP_SHARED
> > +except that
> > +.B MAP_SHARED
> > +mappings ignore unknown flags in
> > +.IR flags .
> > +In contrast when creating mapping of
> > +.B MAP_SHARED_VALIDATE
> > +mapping type, the kernel verifies all passed flags are known and fails the
> > +mapping with
> > +.BR EOPNOTSUPP
> > +otherwise. This mapping type is also required to be able to use some mapping
> > +flags.
> > +.TP
> >  .B MAP_PRIVATE
> >  Create a private copy-on-write mapping.
> >  Updates to the mapping are not visible to other processes
> > @@ -134,7 +149,10 @@ It is unspecified whether changes made to the file after the
> >  .BR mmap ()
> >  call are visible in the mapped region.
> >  .PP
> > -Both of these flags are described in POSIX.1-2001 and POSIX.1-2008.
> > +.B MAP_SHARED
> > +and
> > +.B MAP_PRIVATE
> > +are described in POSIX.1-2001 and POSIX.1-2008.
> >  .PP
> >  In addition, zero or more of the following values can be ORed in
> >  .IR flags :
> > @@ -352,6 +370,21 @@ option.
> >  Because of the security implications,
> >  that option is normally enabled only on embedded devices
> >  (i.e., devices where one has complete control of the contents of user memory).
> > +.TP
> > +.BR MAP_SYNC " (since Linux 4.15)"
> > +This flags is available only with
> > +.B MAP_SHARED_VALIDATE
> > +mapping type. Mappings of
> > +.B MAP_SHARED
> > +type will silently ignore this flag.
> > +This flag is supported only for files supporting DAX (direct mapping of persistent
> > +memory). For other files, creating mapping with this flag results in
> > +.B EOPNOTSUPP
> > +error. Shared file mappings with this flag provide the guarantee that while
> > +some memory is writeably mapped in the address space of the process, it will
> > +be visible in the same file at the same offset even after the system crashes or
> > +is rebooted. This allows users of such mappings to make data modifications
> > +persistent in a more efficient way using appropriate CPU instructions.
> 
> It feels like there's a word missing/unclear wording in the previous
> line, before "using". Without that word, the sentence feels a bit
> ambiguous.
> 
> Should it be:
> 
> persistent in a more efficient way *through the use of* appropriate
> CPU instructions.
> 
> or:
> 
> persistent in a more efficient way *than using* appropriate CPU instructions.
> 
> ?
> 
> Is suspect the first is correct, but need to check.

You're right, the first one is correct.
