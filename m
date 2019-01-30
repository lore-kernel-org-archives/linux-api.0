From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFD] A mount api that notices previous mounts
Date: Wed, 30 Jan 2019 07:35:39 -0600
Message-ID: <87h8dqs1xw.fsf@xmission.com>
References: <20190130120654.q5zqcexquca7u337@ws.net.home>
        <87va2716mh.fsf@xmission.com> <9871.1548853314@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9871.1548853314-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org> (David Howells's message
        of "Wed, 30 Jan 2019 13:01:54 +0000")
Sender: util-linux-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, util-linux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> It seems more elegant is to ask for Nth option as expected by fsinfo().
>
> More elegant yes, but there's an issue with atomiticity[*].  I'm in the
> process of switching to something that returns you a single buffer with all
> the options in, but each key and each value is preceded by a length count.
>
> The reasons for not using separator characters are:
>
>  (1) There's no separator char that cannot validly occur within an option[**].

*Blink*  I had missed the cifs issue.  So yes we certainly need
a better way to encode things in the buffer.  I just used a single
string as an easy way to place everything in a buffer.

>  (2) Makes it possible to return binary values if we need to.

I don't totally disagree with this.  But I will point out that
except for coda passing a file descriptor there are no filesystems
that currently take or need binary options.

I suspect that as long as userspace supports /etc/fstab and we in turn
support /proc/mounts there is going to be a lot of pressure to keep
the majority of options so they  can be encoded in a string separated by
commas.

> David
>
> [*] Atomic with respect to remount calls, that is.

There are also mount options that depend on each other and whose order
matters with respect to other mount options extN's ("sb=<NNNN>") for
example.

> [**] Oh, and look at cifs where you can *change* the separator char during
>      option parsing ("sep=<char>").
