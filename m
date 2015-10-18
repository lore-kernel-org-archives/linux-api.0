From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v6 5/4] copy_file_range.2: New page documenting
 copy_file_range()
Date: Sun, 18 Oct 2015 11:30:13 -0700
Message-ID: <20151018183013.GA11200@infradead.org>
References: <1445029707-31549-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1445029707-31549-6-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1445029707-31549-6-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>
Cc: linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

Just commenting on the man page here as the comment is about sematics.
All the infrastructure in the patch looks reasonable to me, but this
is something we need to get right.

> +.B COPY_FR_REFLINK
> +Create a lightweight "reflink", where data is not copied until
> +one of the files is modified.
> +.PP
> +The default behavior
> +.RI ( flags
> +== 0) is to perform a full data copy of the requested range.
> +.SH RETURN VALUE
> +Upon successful completion,
> +.BR copy_file_range ()
> +will return the number of bytes copied between files.
> +This could be less than the length originally requested.

As mentioned in the previous discussion I fundamentally disagree with
the way your word the flags here.

flags = 0 gives you the data from source at dest, period.  How it's
implemented is up to the file system as a user cannot observe how data
actually is stored underneath.

Additionaly I think the 'clone' option with it's stronger guarantees
should be a separate system call.  So for now just have no supported
flag and leave it up to the file system and storage device how to
implement it.

For the future a COPY_FALLOC flag taht guaranatees you do not get ENOSPC
on the copied range will be very useful, but given the complexity I
think it's not something we should add now.
