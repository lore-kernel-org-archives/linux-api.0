From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 26 Apr 2012 15:16:00 +0100
Message-ID: <20173.1335449760@redhat.com>
References: <20120419230556.A80392C0AF@topped-with-meat.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <20120419163238.61D382C0DF@topped-with-meat.com> <4F9088D6.9020203@cs.ucla.edu>
Return-path: <libc-alpha-return-27988-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <20120419230556.A80392C0AF@topped-with-meat.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Roland McGrath <roland@hack.frob.com>
Cc: dhowells@redhat.com, Paul Eggert <eggert@cs.ucla.edu>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Roland McGrath <roland@hack.frob.com> wrote:

> statx seems like a better family of names.  I also think it's worthwhile to
> see if the interface can be made to more closely match the AIX precedent.

I'm not sure we can make Linux xstat (or whatever) match AIX statxat() very
closely, at least from a syscall interface point of view.  We really need the
AT_* flags mask to be compatible with the other Linux syscalls and the length
parameter that I originally had got argued out of existence.  I would also
like to make it so that there aren't different 32-bit and 64-bit interfaces to
the kernel - though that means a burden on glibc/uClibc/etc., I guess.

I do also want to be able to pass a mask of what we're actually interested in
- but that's not part of the AIX interface.

I also like the idea of having a larger buffer with the ability to return
extra info (such as security label xattrs), but I was told it was a poor idea,
so that got taken out.

David
