From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 2/3] mm/filemap: initiate readahead even if IOCB_NOWAIT
 is set for the I/O
Date: Thu, 31 Jan 2019 13:08:00 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1901311306570.3281@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-3-vbabka@suse.cz> <aea9a09a-9d01-fd08-d210-96b94162aba6@gruss.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aea9a09a-9d01-fd08-d210-96b94162aba6@gruss.cc>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Gruss <daniel@gruss.cc>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>
List-Id: linux-api@vger.kernel.org

On Thu, 31 Jan 2019, Daniel Gruss wrote:

> If I understood it correctly, this patch just removes the advantages of 
> preadv2 over mmmap+access for the attacker.

Which is the desired effect. We are not trying to solve the timing aspect, 
as I don't think there is a reasonable way to do it, is there?

-- 
Jiri Kosina
SUSE Labs
