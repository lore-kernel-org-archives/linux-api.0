From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/2] fs: add AT_REPLACE flag for linkat() which
 replaces the target
Date: Tue, 21 Mar 2017 12:02:11 -0700
Message-ID: <CA+55aFyefhwPHzGQo9+nxtUoe-ycK6uRTOF1o1TSvLC28OXpkg@mail.gmail.com>
References: <cover.1490103963.git.osandov@fb.com> <c823982d5b46ea888dc1fdf26c067a7aa0f3585f.1490103963.git.osandov@fb.com>
 <CA+55aFxpzYqt3MYe8Yd7PVVQoPkVpae5diYYBJXh0zu4JCJrYA@mail.gmail.com> <20170321184401.GA32507@vader>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321184401.GA32507@vader>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Xi Wang <xi-GmWTxIRN22iJaUV4rX00uodd74u8MsAO@public.gmane.org>, Omar Sandoval <osandov-b10kYP2dOMg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Mar 21, 2017 at 11:44 AM, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org> wrote:
>
> This is actually the exact same check we have in vfs_rename():

Hmm. That looks bogus too exactly due to the overlayfs issues. Oh
well. I guess people don't actually use overlayfs and care.

> I tried to keep the same semantics as rename().

Ok, it does seem to match the non-exchange rename(), which I guess is
what we want. It does worry me a bit that we only check for
"may_delete()" even though we end up replacing it with a new one, but
apparently those semantics indeed aren't new.

                 Linus
