From: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
Date: Tue, 16 Dec 2008 11:25:41 -0500
Message-ID: <20081216162541.GB410@bombadil.infradead.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com> <20081215160311.GA23153@linux-mips.org> <4946C4B4.1020605@redhat.com> <20081216160502.GA15331@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arch-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081216160502.GA15331@linux-mips.org>
Sender: linux-arch-owner@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Gerd Hoffmann <kraxel@redhat.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 16, 2008 at 04:05:02PM +0000, Ralf Baechle wrote:
> If merge_64() was a standard macro in <asm/compat.h> on all architectures,
> compat_sys_pwrite() could invoke it directly and the need for the compat
> wrapper around the compat wrapper would go away.
> 

+1 for this.

AFAIK, there's issues on s390 and sparc (at least) with sign extension,
that they need to wrap anyway, we should really sort that out in the
generic compat wrappers as well.

cheers, Kyle
