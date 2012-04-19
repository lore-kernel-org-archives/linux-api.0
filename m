From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 19 Apr 2012 12:11:11 -0500
Message-ID: <CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
References: <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419140558.17272.74360.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org, kfm-devel-RoXCvvDuEio@public.gmane.org, nautilus-list-rDKQcyrBJuzYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Apr 19, 2012 at 9:05 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Implement a pair of new system calls to provide extended and further extensible
 stat functions.
<snip>
> Should the default for a network fs be to do an unconditional (heavyweight)
> stat with a flag to suppress going to the server to update the locally held
> attributes and flushing pending writebacks?

Even though we can use leases (oplocks) to avoid the roundrtrip, it is
probably too expensive to default to forcing a cache flush, especially
when a common case is to get the file creation time or inode number
information (stable vs volatile).

Would it be better to make the stable vs volatile inode number an attribute
of the volume  or something returned by the proposed xstat?

> Should things like the Windows Archive, Hidden and System bits be handled
> through IOC flags, perhaps expanded to 64-bits?

Today I export these through an psuedo-xattr in cifs.ko, I am curious how
NTFS and FAT export these on linux.

> ==========
> TO BE DONE
> ==========
>
> Autofs, ntfs, btrfs, ...

Given the overlap in optional attributes between the network
protocol and local NTFS (and ReFS and to a lesser extent FAT)
I would expect cifs.ko and the ntfs implementations
info to map pretty closely.

> I should perhaps use u8/u32/u64 rather than uint8/32/64_t.
>
> Handle remote filesystems being offline and indicate this with
> XSTAT_INFO_OFFLINE.

You already have support for an indicator for offline files (HSM),
would XSTAT_INFO_OFFLINE be intended for the case
where the network session to the server is disconnected
(and in which you case the application does not want to reconnect)?

-- 
Thanks,

Steve
