From: "Carlos O'Donell" <carlos-v2tUB8YBRSi3e3T8WW9gsA@public.gmane.org>
Subject: Re: Why no flag to unlink a file on creation?
Date: Tue, 27 Mar 2012 09:40:44 -0400
Message-ID: <CADZpyiwdLS3h6_MdYx_KqnQWbhKutLx2tcu4EOdTwwzbY1i+0w@mail.gmail.com>
References: <1332854971.15139.10.camel@Jann-PC.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332854971.15139.10.camel-kHgebVDnKAGa6lf8Wg2v7Z5kstrrjoWp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Mar 27, 2012 at 9:29 AM, Jann Horn <jannhorn-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> Hello,
> I'm not too familiar with the internals of the kernel, so this question
> might be stupid, and I'm not sure whether this is the right place to ask
> about it, but anyway:
> Why is there no flag for the "open" syscall to specify that you want the
> file you're opening to be deleted? I think that it would be very useful
> in combination with O_CREAT - you could create temporary files without
> actually leaving files on the filesystem, given that the filesystem
> supports it.

The open() function behaviour is dictated both by POSIX and ISO C.

You really want to ask this on either the related C library mailing
list or the related POSIX standards group mailing list.

libc-help-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org - The GNU C Library help mailing list.
* List for discussing GNU C Library issues and ISO C11 questions.
* http://www.gnu.org/software/libc/libc.html

or

austin-group-l-7882/jkIBncuagvECLh61g@public.gmane.org - Austin Common Standards Revision List.
* List for discussing POSIX related issues
* http://www.opengroup.org/austin/lists.html

Cheers,
Carlos.
