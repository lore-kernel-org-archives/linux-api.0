From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] fscrypt: reserve flags for hardware-wrapped keys feature
Date: Fri, 17 Jan 2020 17:56:24 +0100
Message-ID: <20200117165624.GC1937954@kroah.com>
References: <20200116192008.35766-1-ebiggers@kernel.org>
 <20200117081246.GA16846@infradead.org>
 <20200117164054.GD448999@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200117164054.GD448999@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, Barani Muthukumaran <bmuthuku@codeaurora.org>, Gaurav Kashyap <gaurkash@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Jan 17, 2020 at 11:40:54AM -0500, Theodore Y. Ts'o wrote:
> On Fri, Jan 17, 2020 at 12:12:46AM -0800, Christoph Hellwig wrote:
> > On Thu, Jan 16, 2020 at 11:20:08AM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Reserve flags for the hardware-wrapped keys feature which is being
> > > worked on [1].  FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY will denote that the
> > > encryption policy needs a hardware-wrapped key to be unlocked.
> > > FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED will denote that the key being added is
> > > a hardware-wrapped key.
> > > 
> > > This reservation is tentative, and these codepoints may be reused if the
> > > feature is not upstreamed.
> > 
> > NAK.  While the feature itself sounds really useful we don't just
> > reserve format bits for code not upstream.
> 
> I disagree; saving a codepoint to avoid accidental collision of a
> feature bit is a good and proper thing to do.
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

What kind of "deadline" do you have for that feature to then be merged?
I'm with Christoph here, we shouldn't be reserving bits for stuff not
in mergable state, what's the rush?

thansk,

greg k-h
