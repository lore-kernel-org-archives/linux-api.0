From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/6] Extended file stat system call
Date: Thu, 10 May 2012 10:51:38 +0100
Message-ID: <10044.1336643498@redhat.com>
References: <20120428005856.GI9541@dastard> <20120427010610.GE9541@dastard> <20120419140558.17272.74360.stgit@warthog.procyon.org.uk> <4111.1335519545@redhat.com> <20120427131306.GG9541@dastard> <F2018580-9ACC-4A63-A8D1-155FA371749A@dilger.ca>
Return-path: <libc-alpha-return-28761-glibc-alpha=m.gmane.org@sourceware.org>
In-Reply-To: <20120428005856.GI9541@dastard>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: Dave Chinner <david@fromorbit.com>
Cc: dhowells@redhat.com, Andreas Dilger <adilger@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-ext4@vger.kernel.org, wine-devel@winehq.org, kfm-devel@kde.org, nautilus-list@gnome.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org
List-Id: linux-api@vger.kernel.org

Dave Chinner <david@fromorbit.com> wrote:

> 	st_blksize		- file block size
> 	st_alloc_blksize	- allocation block size/alignment
> 	st_small_io_size	- IO size/alignment that avoids
> 				  filesystem/page cache RMW
> 	st_preferred_io_size	- preferred IO size for general
> 				  usage.
> 	st_large_io_size	- IO size/alignment for high
> 				  bandwidth sequential IO

What is st_blksize here?  Is it directly comparable (if such a thing is
possible) to st_blksize in struct stat?  Or does st_preferred_io_size map to
the current st_blksize and your st_blksize map to actual media block size (and
if so, is that the same as st_alloc_blksize?  - I presume st_alloc_blksize
must be a multiple of the media block size).

David
