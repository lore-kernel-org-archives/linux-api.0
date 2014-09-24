From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Adds general codes to enforces project quota limits
Date: Wed, 24 Sep 2014 19:10:20 +0200
Message-ID: <20140924171020.GF27000@quack.suse.cz>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-2-git-send-email-lixi@ddn.com>
 <20140924161417.GA1978@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140924161417.GA1978-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 24-09-14 09:14:17, Christoph Hellwig wrote:
> > -#define MAXQUOTAS 2
> > +#define MAXQUOTAS 3
> 
> This bloats every single inode in the system.  I think this would be a
> good opportunity to move i_dquot into the per-filesystem structures
> and provide a little get_dquots methods to get at them from the
> quota code.
  Yeah, I'm aware of that but I decided I won't bother Li Xi with that
since it's independent issue and 8 bytes aren't that terrible. Personally
I somewhat prefer what I did in
http://www.spinics.net/lists/linux-fsdevel/msg74927.html
where we don't introduce additional method but rather a table with field
offsets in superblock. If people agree with this, I can cook up a patch for
quota relatively quickly.

								Honza
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
