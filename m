From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH 2/3] mm: introduce fincore()
Date: Mon,  2 Jun 2014 10:21:30 -0400
Message-ID: <538c88a1.e225b40a.612b.ffff9109SMTPIN_ADDED_BROKEN@mx.google.com>
References: <20140521193336.5df90456.akpm@linux-foundation.org> <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1401686699-9723-3-git-send-email-n-horiguchi@ah.jp.nec.com> <CAHO5Pa3iQXRZPXG89OyRCmD6jPKp0M8TCfJind6XD0wbyoguxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAHO5Pa3iQXRZPXG89OyRCmD6jPKp0M8TCfJind6XD0wbyoguxg@mail.gmail.com>
Content-Disposition: inline
Sender: owner-linux-mm@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@alien8.de>, "Kirill A. Shutemov" <kirill@shutemov.name>, Johannes Weiner <hannes@cmpxchg.org>, Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>, Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jun 02, 2014 at 09:06:34AM +0200, Michael Kerrisk wrote:
> Hello Naoya,
> 
> As Christoph noted, it would be best to provide some good user
> documentation for this proposed system call, to aid design review.
> 
> Also, as per Documentation/SubmitChecklist, patches that change the
> kernel-userspace API/ABI should CC
> linux-api@vger.kernel.org (see
> https://www.kernel.org/doc/man-pages/linux-api-ml.html).

OK, I didn't check it, so will do hereafter.
Thank you!

Naoya Horiguchi

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
