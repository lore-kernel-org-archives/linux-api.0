From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH v2 5/5] btrfs: implement RWF_ENCODED writes
Date: Mon, 21 Oct 2019 15:14:52 +0200
Message-ID: <20191021131452.GH3001@twin.jikos.cz>
References: <cover.1571164762.git.osandov@fb.com>
 <904de93d9bbe630aff7f725fd587810c6eb48344.1571164762.git.osandov@fb.com>
 <0da91628-7f54-7d24-bf58-6807eb9535a5@suse.com>
 <20191018225513.GD59713@vader>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191018225513.GD59713@vader>
Sender: linux-btrfs-owner@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Oct 18, 2019 at 03:55:13PM -0700, Omar Sandoval wrote:
> > > +	nr_pages = (disk_num_bytes + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > 
> > nit: nr_pages = DIV_ROUND_UP(disk_num_bytes, PAGE_SIZE)
> 
> disk_num_bytes is a u64, so that would expand to a 64-bit division. The
> compiler is probably smart enough to optimize it to a shift, but I
> didn't want to rely on that, because that would cause build failures on
> 32-bit.

There are several DIV_ROUND_UP(u64, PAGE_SIZE) in btrfs code, no build
brekages have been reported so far, you can use it.
