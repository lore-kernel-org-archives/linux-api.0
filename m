From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 15:04:07 +0100
Message-ID: <19638.1335449047@redhat.com>
References: <4F9088D6.9020203@cs.ucla.edu> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419163238.61D382C0DF@topped-with-meat.com>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9088D6.9020203-764C0pRuGfqVc3sceRu5cw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org> wrote:

> On 04/19/2012 09:32 AM, Roland McGrath wrote:
> > I have no comment on the functionality.  But "xstat" is probably a poor
> > choice of name. 
> 
> In AIX 7.1 the (similar) function is called statxat instead of xstat.
> The API isn't exactly the same, but it's the same basic idea.
> Might be worth looking at, not merely to see whether the API
> should be the same, but also to borrow good ideas even if not.
> 
> http://pic.dhe.ibm.com/infocenter/aix/v7r1/topic/com.ibm.aix.basetechref/doc/basetrf2/statx.htm

Interesting.  I wasn't intending to provide both statx() and statxat()
variants, just the latter, in which case I'd've though that -at suffix is
redundant.

I note that they split their time fields into separate seconds and ns fields,
presumably for better packing.

David
