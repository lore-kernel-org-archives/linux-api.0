From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Date: Thu, 12 Apr 2018 16:22:14 +0200
Message-ID: <20180412142214.fcxw3g2jxv6bvn7d@quack2.suse.cz>
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

Hello Michael!

On Thu 12-04-18 15:00:49, Michael Kerrisk (man-pages) wrote:
> Hello Jan,
> 
> I have applied your patch, and tweaked the text a little, and pushed
> the result to the git repo.

Thanks!

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

Yes, the first is correct.

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
