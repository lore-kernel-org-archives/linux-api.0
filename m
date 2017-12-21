From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] mmap.2: MAP_FIXED updated documentation
Date: Thu, 21 Dec 2017 14:24:16 -0800
Message-ID: <20171221142416.188c4d49cb225488781ef8b0@linux-foundation.org>
References: <20171213092550.2774-1-mhocko@kernel.org>
	<20171213093110.3550-1-mhocko@kernel.org>
	<20171213093110.3550-2-mhocko@kernel.org>
	<20171213125540.GA18897@amd>
	<20171213130458.GI25185@dhcp22.suse.cz>
	<20171213130900.GA19932@amd>
	<20171213131640.GJ25185@dhcp22.suse.cz>
	<20171213132105.GA20517@amd>
	<20171213144050.GG11493@rei>
	<CAGXu5jLqE6cUxk-Girx6PG7upEzz8jmu1OH_3LVC26iJc2vTxQ@mail.gmail.com>
	<c7c7a30e-a122-1bbf-88a2-3349d755c62d@gmail.com>
	<CAGXu5jJ289R9koVoHmxcvUWr6XHSZR2p0qq3WtpNyN-iNSvrNQ@mail.gmail.com>
	<87po78fe7m.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87po78fe7m.fsf@concordia.ellerman.id.au>
Sender: owner-linux-mm@kvack.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Kees Cook <keescook@chromium.org>, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Cyril Hrubis <chrubis@suse.cz>, Pavel Machek <pavel@ucw.cz>, Michal Hocko <mhocko@kernel.org>, Linux API <linux-api@vger.kernel.org>, Khalid Aziz <khalid.aziz@oracle.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Florian Weimer <fweimer@redhat.com>, John Hubbard <jhubbard@nvidia.com>, Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

On Thu, 21 Dec 2017 23:38:37 +1100 Michael Ellerman <mpe@ellerman.id.au> wrote:

> > Andrew, can you s/MAP_FIXED_SAFE/MAP_FIXED_NOREPLACE/g in the series?

Done.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
