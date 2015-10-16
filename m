From: =?UTF-8?Q?P=c3=a1draig_Brady?= <P@draigBrady.com>
Subject: Re: [PATCH v6 5/4] copy_file_range.2: New page documenting
 copy_file_range()
Date: Fri, 16 Oct 2015 22:42:40 +0100
Message-ID: <56216F50.7030705@draigBrady.com>
References: <1445029707-31549-1-git-send-email-Anna.Schumaker@Netapp.com>
 <1445029707-31549-6-git-send-email-Anna.Schumaker@Netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1445029707-31549-6-git-send-email-Anna.Schumaker@Netapp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Anna Schumaker <Anna.Schumaker@netapp.com>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, zab@zabbo.net, viro@zeniv.linux.org.uk, clm@fb.com, darrick.wong@oracle.com, mtk.manpages@gmail.com, andros@netapp.com, hch@infradead.org
List-Id: linux-api@vger.kernel.org

It's probably worth mentioning the sparse expansion caveat
in the docs, as it's important and not obvious.

I.E. copy_file_range() could be called from, but would
still benefit from a user space app using a SEEK_{HOLE,DATA} loop.

thanks,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
