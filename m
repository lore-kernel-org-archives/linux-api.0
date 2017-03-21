From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH v2 1/2] fs: add AT_REPLACE flag for linkat() which
 replaces the target
Date: Tue, 21 Mar 2017 21:37:25 +0100
Message-ID: <CAELBmZBDLNkNRCh+q+zs3_z5NnsBctF_FA7F91SduADmS_xCJQ@mail.gmail.com>
References: <cover.1490103963.git.osandov@fb.com> <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
 <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA@mail.gmail.com>
 <20170321184401.GA32507@vader> <CA+55aFyefhwPHzGQo9+nxtUoe-ycK6uRTOF1o1TSvLC28OXpkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyefhwPHzGQo9+nxtUoe-ycK6uRTOF1o1TSvLC28OXpkg@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Omar Sandoval <osandov@osandov.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Xi Wang <xi@cs.washington.edu>, Omar Sandoval <osandov@fb.com>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 21, 2017 at 8:02 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 21, 2017 at 11:44 AM, Omar Sandoval <osandov@osandov.com> wrote:
>>
>> This is actually the exact same check we have in vfs_rename():
>
> Hmm. That looks bogus too exactly due to the overlayfs issues. Oh
> well. I guess people don't actually use overlayfs and care.

What overlayfs issues?  Overlayfs behaves exactly like a normal
filesystem wrt negative dentries.

If you are referring to whiteouts, they are not visible on the overlay
layer (remember overlay duplicates the dentry tree of the merged
dentry trees of the underlying layers).

>> I tried to keep the same semantics as rename().
>
> Ok, it does seem to match the non-exchange rename(), which I guess is
> what we want. It does worry me a bit that we only check for
> "may_delete()" even though we end up replacing it with a new one, but
> apparently those semantics indeed aren't new.

I think this is historic.  may_delete() was doing the same as
may_create() and more.  Doesn't look like that's still strictly true,
so it might make sense to add a may_replace() operation that does
both.

Thanks,
Miklos
