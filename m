From: Alex Thorlton <athorlton@sgi.com>
Subject: Re: Documenting prctl() PR_SET_THP_DISABLE and PR_GET_THP_DISABLE
Date: Mon, 14 Apr 2014 10:49:11 -0500
Message-ID: <20140414154911.GH3308@sgi.com>
References: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0VCzR7oqNXkwELuAsNQnnvF8Xoo=CuCaM64-GzjDuoFA@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-mm <linux-mm@kvack.org>, Linux API <linux-api@vger.kernel.org>, linux-man@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Apr 14, 2014 at 12:15:01PM +0200, Michael Kerrisk wrote:
> Alex,
> 
> Your commit a0715cc22601e8830ace98366c0c2bd8da52af52 added the prctl()
> PR_SET_THP_DISABLE and PR_GET_THP_DISABLE flags.
> 
> The text below attempts to document these flags for the prctl(3).
> Could you (and anyone else who is willing) please review the text
> below (one or two p[ieces of which are drawn from your commit message)
> to verify that it accurately reflects reality and your intent, and
> that I have not missed any significant details.

Looks fine to me!

- Alex

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
