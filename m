From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Documenting MS_LAZYTIME
Date: Thu, 26 Feb 2015 19:04:09 -0500
Message-ID: <20150227000409.GC17174@thunk.org>
References: <CAHO5Pa0k7QkV_6BDjwTVxa7LV9tFyN9nGFFcSvOC6HYO08wfrw@mail.gmail.com>
 <54E7578E.4090809@redhat.com>
 <20150221025636.GB7922@thunk.org>
 <54EEDE23.6080009@gmail.com>
 <20150226133113.GD11217@thunk.org>
 <54EF2161.90607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54EF2161.90607@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, linux-man@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Thu, Feb 26, 2015 at 02:36:33PM +0100, Michael Kerrisk (man-pages) wrote:
> 
>     The disadvantage of MS_STRICTATIME | MS_LAZYTIME is that
>     in the case of a system crash, the atime and mtime fields
>     on disk might be out of date by at most 24 hours.

I'd change to "The disadvantage of MS_LAZYTIME is that..."  and
perhaps move that so it's clear it applies to any use of MS_LAZYTIME
has this as a downside.

Does that make sense?

						- Ted
