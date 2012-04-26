From: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 11:22:02 -0700 (PDT)
Message-ID: <20120426182202.9B2442C0EA@topped-with-meat.com>
References: <20120419230556.A80392C0AF@topped-with-meat.com>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419163238.61D382C0DF@topped-with-meat.com>
	<4F9088D6.9020203@cs.ucla.edu>
	<20173.1335449760@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: David Howells's message of  Thursday, 26 April 2012 15:16:00 +0100 <20173.1335449760-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

> Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org> wrote:
> 
> > statx seems like a better family of names.  I also think it's worthwhile to
> > see if the interface can be made to more closely match the AIX precedent.
> 
> I'm not sure we can make Linux xstat (or whatever) match AIX statxat() very
> closely, at least from a syscall interface point of view.  

OK.  It was just worth a look.


Thanks,
Roland
