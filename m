From: David Howells <dhowells@redhat.com>
Subject: Re: Extended file stat: Splitting file- and fs-specific info?
Date: Thu, 10 May 2012 10:23:14 +0100
Message-ID: <14477.1336641794@redhat.com>
References: <73759631-F1E4-4352-9FE6-E9F576F793FB@gmail.com> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <16281.1336508382@redhat.com> <20120509002420.GL5091@dastard>
Return-path: <libc-alpha-return-28760-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <73759631-F1E4-4352-9FE6-E9F576F793FB@gmail.com>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Andreas Dilger <aedilger@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: dhowells@redhat.com, "adilger@dilger.ca" <adilger@dilger.ca>, "bfields@fieldses.org" <bfields@fieldses.org>, "smfrench@gmail.com" <smfrench@gmail.com>, "ben@decadent.org.uk" <ben@decadent.org.uk>, "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>, "roland@hack.frob.com" <roland@hack.frob.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>
List-Id: linux-api@vger.kernel.org

Andreas Dilger <aedilger@gmail.com> wrote:

> The main question I have about these fields is what the difference is
> between st_blksize and st_alloc_blksize?

I would assume that st_blksize is some ideal I/O size, not the allocation
block size.  Dave Chinner might be able to answer better as he suggested these
I/O information fields.

David
