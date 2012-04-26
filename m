From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 15:25:58 +0100
Message-ID: <20656.1335450358@redhat.com>
References: <CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk>
Return-path: <libc-alpha-return-27990-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <CAH2r5ms4WQV3DnTvqNN=2N71Cj8UHwj8Z6+RHXgrAOv6mSoyQg@mail.gmail.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Steve French <smfrench@gmail.com> wrote:

> Would it be better to make the stable vs volatile inode number an attribute
> of the volume  or something returned by the proposed xstat?

I'm not sure what you mean by a stable vs a volatile inode number.

> > Should things like the Windows Archive, Hidden and System bits be handled
> > through IOC flags, perhaps expanded to 64-bits?
> 
> Today I export these through an psuedo-xattr in cifs.ko, I am curious how
> NTFS and FAT export these on linux.

NTFS: Not at all.

FAT: The hidden bit causes the filename to get a dot prepended (and nothing
else is noted).

> > Autofs, ntfs, btrfs, ...
> 
> Given the overlap in optional attributes between the network
> protocol and local NTFS (and ReFS and to a lesser extent FAT)
> I would expect cifs.ko and the ntfs implementations
> info to map pretty closely.

Yep.  I wasn't going to do more filesystems till we'd finished arguing about
the basic arrangement of things in struct xstat.

> > Handle remote filesystems being offline and indicate this with
> > XSTAT_INFO_OFFLINE.
> 
> You already have support for an indicator for offline files (HSM),

HSM?

> would XSTAT_INFO_OFFLINE be intended for the case
> where the network session to the server is disconnected
> (and in which you case the application does not want to reconnect)?

Hmmm...  Interesting question.  Both NTFS and CIFS have an offline attribute
(which is where I originally got this from) - but should I have a separate
indicator to indicate the client can't access a server over a network
(ie. we've gone to disconnected operation on this file)?  E.g. should there be
a XSTAT_INFO_DISCONNECTED too?

David
