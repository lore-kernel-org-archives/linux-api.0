From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info available [ver #3]
Date: Thu, 24 Nov 2016 07:27:33 +0000
Message-ID: <6825.1479972453@warthog.procyon.org.uk>
References: <D1A5E76A-5739-42FE-A451-B49CD1699DB0@dilger.ca> <147986254484.19139.8038609825799670925.stgit@warthog.procyon.org.uk> <147986255194.19139.9583434946564699577.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D1A5E76A-5739-42FE-A451-B49CD1699DB0-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Content-ID: <6824.1479972453.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org> wrote:

> > +		case S_IFCHR:	printf(" character special file\n");	ft = 'c'; break;
> 
> This will overflow 80 columns.  Could use just "character special"?
> 
> > +		case S_IFDIR:	printf(" directory\n");			ft = 'd'; break;
> > +		case S_IFBLK:	printf(" block special file\n");	ft = 'b'; break;
> > +		case S_IFREG:	printf(" regular file\n");		ft = '-'; break;
> > +		case S_IFLNK:	printf(" symbolic link\n");		ft = 'l'; break;
> 
> Having these all as single-word items would make it easier to parse for
> test programs.  Same with "IO Block:" -> "Blocksize:".  Not a huge deal.

Try doing "stat /dev/null".

David
