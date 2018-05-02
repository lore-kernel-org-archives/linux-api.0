From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/6 resend] statfs: handle mount propagation
Date: Wed, 2 May 2018 17:09:39 +0100
Message-ID: <20180502160939.GU30522@ZenIV.linux.org.uk>
References: <20180502154239.14013-1-christian.brauner@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180502154239.14013-1-christian.brauner@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, tglx@linutronix.de, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, pombredanne@nexb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Wed, May 02, 2018 at 05:42:33PM +0200, Christian Brauner wrote:
> Hey,
> 
> This is the second resend of this patchset. I'm not sure whether it has
> simply been overlooked but the number of people get_maintainer.pl was
> rather small and seemed a little random so I added Linus and Christoph,
> two people I know that do look at VFS stuff at least from time to time,
> although they weren't listed by get_maintainer.pl. I hope that's ok.
> 
> This little series
> - unifies the definition of constants in statfs.h and fs.h
>   *Note, that Andreas has expressed doubts whether this unification is
>   useful. Please see https://lkml.org/lkml/2018/4/13/571 . I still think
>   it is but I'm happy to drop these two patches if others agree.*
> - extends statfs to handle mount propagation. This will let userspace
>   easily query a given mountpoint for MS_UNBINDABLE, MS_SHARED,
>   MS_PRIVATE and MS_SLAVE without always having to do costly parsing of
>   /proc/<pid>/mountinfo.
>   To this end the flags:
>   - ST_UNBINDABLE
>   - ST_SHARED
>   - ST_PRIVATE
>   - ST_SLAVE
>   are added. They have the same value as their MS_* counterparts.

How about some rationale for that in the first place?  statfs() looks like
a bad match for that - not to mention anything else, there's no way to
get anything beyond "it is a peer of something", not even "do these two
get propagation between them".  What would be using that, what would the
userland side of users look like, etc...

And in any case linux-api should've been Cc'd.  I'm not saying that this
(or something similar) would be an inherently bad idea, but the question
"why this way?" deserves a bit more than "parsing is costly"...
