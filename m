From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 22:54:41 +0100
Message-ID: <9931.1335477281@redhat.com>
References: <20120426182524.E5ADF2C0EC@topped-with-meat.com> <20120419163238.61D382C0DF@topped-with-meat.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <19184.1335448455@redhat.com>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120426182524.E5ADF2C0EC-j1d2VQoJOwwHfwO+Tb3JRVaTQe2KTcn/@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org> wrote:

> > I've no particular attachment to the name 'xstat'.  If you'd prefer
> > 'statx' I could go for that.
> 
> I prefer something other than xstat and statx(at) seems acceptable enough.
> What I'd really prefer is a name that is less meaninglessly arcane,
> but I haven't thought of any good ones.

fileinfoat() perhaps?  I think stat*at() is better, though, as people are used
to the stat function family.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
