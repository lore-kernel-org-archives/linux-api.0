From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Adds general codes to enforces project quota limits
Date: Wed, 24 Sep 2014 10:13:06 -0700
Message-ID: <20140924171306.GA23874@infradead.org>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
 <1411567470-31799-2-git-send-email-lixi@ddn.com>
 <20140924161417.GA1978@infradead.org>
 <20140924171020.GF27000@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140924171020.GF27000-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Xi <pkuelelixi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Sep 24, 2014 at 07:10:20PM +0200, Jan Kara wrote:
>   Yeah, I'm aware of that but I decided I won't bother Li Xi with that
> since it's independent issue and 8 bytes aren't that terrible.

For the inode of which we have so many instances it is.  Especially when
only one filesystem can make use of this new field.
 
> Personally
> I somewhat prefer what I did in
> http://www.spinics.net/lists/linux-fsdevel/msg74927.html
> where we don't introduce additional method but rather a table with field
> offsets in superblock. If people agree with this, I can cook up a patch for
> quota relatively quickly.

There's an even better way.  We stopped calling the dquot_* functions
from generic code, so now the filesystem can simply pass in a pointer
to the dquot array.
