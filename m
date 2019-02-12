From: Jiri Kosina <jikos@kernel.org>
Subject: Re: [PATCH 3/3] mm/mincore: provide mapped status when cached status
 is not allowed
Date: Tue, 12 Feb 2019 14:09:03 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1902121405440.11598@cbobk.fhfr.pm>
References: <nycvar.YFH.7.76.1901051817390.16954@cbobk.fhfr.pm> <20190130124420.1834-1-vbabka@suse.cz> <20190130124420.1834-4-vbabka@suse.cz> <20190131100907.GS18811@dhcp22.suse.cz> <99ee4d3e-aeb2-0104-22be-b028938e7f88@suse.cz> <nycvar.YFH.7.76.1902120440430.11598@cbobk.fhfr.pm>
 <20190212063643.GL15609@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190212063643.GL15609@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, Jann Horn <jannh@google.com>, Dominique Martinet <asmadeus@codewreck.org>, Andy Lutomirski <luto@amacapital.net>, Dave Chinner <david@fromorbit.com>, Kevin Easton <kevin@guarana.org>, Matthew Wilcox <willy@infradead.org>, Cyril Hrubis <chrubis@suse.cz>, Tejun Heo <tj@kernel.org>, "Kirill A . Shutemov" <kirill@shutemov.name>, Daniel Gruss <daniel@gruss.cc>, Josh Snyder <joshs@netflix.com>
List-Id: linux-api@vger.kernel.org

On Tue, 12 Feb 2019, Michal Hocko wrote:

> I would go with patch 1 for 5.1. Patches 2 still sounds controversial or
> incomplete to me. 

Is it because of the disagreement what 'non-blocking' really means, or do 
you see something else missing?

Merging patch just patch 1 withouth patch 2 is probably sort of useless 
excercise, unfortunately.

Thanks,

-- 
Jiri Kosina
SUSE Labs
