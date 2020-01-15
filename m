From: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH RFC 0/1] mount: universally disallow mounting over
 symlinks
Date: Wed, 15 Jan 2020 14:48:31 +0000
Message-ID: <20200115144831.GJ8904@ZenIV.linux.org.uk>
References: <20200102035920.dsycgxnb6ba2jhz2@yavin.dot.cyphar.com>
 <20200103014901.GC8904@ZenIV.linux.org.uk>
 <20200108031314.GE8904@ZenIV.linux.org.uk>
 <CAHk-=wgQ3yOBuK8mxpnntD8cfX-+10ba81f86BYg8MhvwpvOMg@mail.gmail.com>
 <20200110210719.ktg3l2kwjrdutlh6@yavin>
 <20200114045733.GW8904@ZenIV.linux.org.uk>
 <20200114200150.ryld4npoblns2ybe@yavin>
 <20200115142517.GI8904@ZenIV.linux.org.uk>
 <20200115142906.saagd2lse7i7njux@yavin>
 <20200115143459.l4wurqyetkmptsdm@yavin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200115143459.l4wurqyetkmptsdm@yavin>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Biederman <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, stable <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Jan 16, 2020 at 01:34:59AM +1100, Aleksa Sarai wrote:
> On 2020-01-16, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org> wrote:
> > On 2020-01-15, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:
> > > On Wed, Jan 15, 2020 at 07:01:50AM +1100, Aleksa Sarai wrote:
> > > 
> > > > Yes, there were two patches I sent a while ago[1]. I can re-send them if
> > > > you like. The second patch switches open_how->mode to a u64, but I'm
> > > > still on the fence about whether that makes sense to do...
> > > 
> > > IMO plain __u64 is better than games with __aligned_u64 - all sizes are
> > > fixed, so...
> > > 
> > > > [1]: https://lore.kernel.org/lkml/20191219105533.12508-1-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org/
> > > 
> > > Do you want that series folded into "open: introduce openat2(2) syscall"
> > > and "selftests: add openat2(2) selftests" or would you rather have them
> > > appended at the end of the series.  Personally I'd go for "fold them in"
> > > if it had been about my code, but it's really up to you.
> > 
> > "fold them in" would probably be better to avoid making the mainline
> > history confusing afterwards. Thanks.
> 
> Also (if you prefer) I can send a v3 which uses u64s rather than
> aligned_u64s.

<mode "lazy bastard">
Could you fold and resend the results of folding (i.e. replacements
for two commits in question)?
</mode>

The hard part is, of course, in updating commit messages ;-)
