From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [RFC PATCH v2 3/5] btrfs: generalize btrfs_lookup_bio_sums_dio()
Date: Fri, 18 Oct 2019 15:19:45 -0700
Message-ID: <20191018221945.GB59713@vader>
References: <cover.1571164762.git.osandov@fb.com>
 <01fdb646d7572f7d0d123937835db5c605e25a5e.1571164762.git.osandov@fb.com>
 <aa49f032-f6be-8594-7c80-7101a0c6bcd0@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa49f032-f6be-8594-7c80-7101a0c6bcd0@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, Dave Chinner <david@fromorbit.com>, Jann Horn <jannh@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 16, 2019 at 12:22:33PM +0300, Nikolay Borisov wrote:
> 
> 
> On 15.10.19 г. 21:42 ч., Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > This isn't actually dio-specific; it just looks up the csums starting at
> > the given offset instead of using the page index. Rename it to
> > btrfs_lookup_bio_sums_at_offset() and add the dst parameter. We might
> > even want to expose __btrfs_lookup_bio_sums() as the public API instead
> > of having two trivial wrappers, but I'll leave that for another day.
> 
> IMO exposing btrfs_lookup_bio_sums and adding proper kernel doc for its
> parameters is the correct way forward. Consider doing this if the
> general direction of this patchset is accepted and before sending the
> final revision.

Ok, if I'm not the only one that thinks it's a good idea, I'll go ahead
with that.
