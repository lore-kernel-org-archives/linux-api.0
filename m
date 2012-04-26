From: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 11:24:01 -0700 (PDT)
Message-ID: <20120426182401.B246E2C0EA@topped-with-meat.com>
References: <4F9088D6.9020203@cs.ucla.edu>
	<20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
	<20120419163238.61D382C0DF@topped-with-meat.com>
	<19638.1335449047@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: David Howells's message of  Thursday, 26 April 2012 15:04:07 +0100 <19638.1335449047-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Paul Eggert <eggert-764C0pRuGfqVc3sceRu5cw@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

> Interesting.  I wasn't intending to provide both statx() and statxat()
> variants, just the latter, in which case I'd've though that -at suffix is
> redundant.

It's certainly fine to provide only *at flavors for any new syscall, IMHO.
The * case is always just a simple degenerate case of *at, and libc can
trivially provide the simpler user API as well using the *at syscall.

But please keep the uniformity that everything taking a descriptor and AT_*
flags is named *at.


Thanks,
Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
