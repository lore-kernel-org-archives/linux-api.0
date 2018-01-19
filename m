From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Fri, 19 Jan 2018 02:27:18 +0000
Message-ID: <20180119022717.GF13338@ZenIV.linux.org.uk>
References: <28167.1516032442@warthog.procyon.org.uk>
 <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <1643.1516117204@warthog.procyon.org.uk>
 <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ@mail.gmail.com>
 <20180117041727.GS13338@ZenIV.linux.org.uk>
 <CAOssrKfN_ZT5yJC1mxkhUf6FG=_eMD4nzQtETfu_4X3vOf1kHw@mail.gmail.com>
 <20180117110633.zneqvnjzgxkv4yc2@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180117110633.zneqvnjzgxkv4yc2-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 12:06:33PM +0100, Karel Zak wrote:

> What about new flag (for the API) rather than try to be smart with the
> current flags? But I have doubts that invest time to new mount(2)
> features is a good idea.

Would be nice, if we had any spare bits left...  We could, in principle,
turn
#define MS_BIND         4096
#define MS_MOVE         8192
into
#define MS_BIND         0x1000
#define MS_MOVE         0x2000
#define MS_SOMETHING    0x3000
seeing that they should never be used together, but... mount(2)
doesn't reject MS_BIND|MS_MOVE and treats it as MS_BIND instead.
_Probably_ nothing would care, but it risks breaking userland.

We could use one of the internal-only bits for that instead, but
they are also quietly ignored and not rejected, so that would
have the same problem.

mount(2) ABI sucks, film at 11...
--
To unsubscribe from this list: send the line "unsubscribe util-linux" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
