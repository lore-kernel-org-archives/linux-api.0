From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: User-visible context-mount API
Date: Thu, 18 Jan 2018 10:48:24 +0100
Message-ID: <CAOssrKeRaA77NUctnwQ0=r6xMg_o1UVbqqTBJ60q-n4DP_LvDw@mail.gmail.com>
References: <28167.1516032442@warthog.procyon.org.uk> <CAOssrKdgudK7kKbhQBAnV9EwzHBq=4+9M26JGfmhNDGrGXmnFg@mail.gmail.com>
 <1643.1516117204@warthog.procyon.org.uk> <CAOssrKdn-ZhOB9V28uL-JK9zgNGJzF4cFBeyoqLLj4pADqNFVQ@mail.gmail.com>
 <20180117041727.GS13338@ZenIV.linux.org.uk> <CAOssrKfN_ZT5yJC1mxkhUf6FG=_eMD4nzQtETfu_4X3vOf1kHw@mail.gmail.com>
 <20180117110633.zneqvnjzgxkv4yc2@ws.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117110633.zneqvnjzgxkv4yc2-xkT7n84Rsxv/9pzu0YdTqQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jan 17, 2018 at 12:06 PM, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

>> Documenting  --make-private thing properly would also help.  To me the
>> wording "make private" strongly implies "I want to make submounts
>> private to this instance".  See for example rhbz#1432211.
>
> All propagation stuff is poorly documented in mount.8. It would be
> nice to add section about it to the man page. Volunteer? (My skills to
> explain this topic to end-users is pretty limited...)

Propagation is common to mount(2) and there's some info in there
already, but fine points like this are not explained.

Maybe a new page in section 7?

Thanks,
Miklos
