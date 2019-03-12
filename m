From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 0/2] prevent mincore() page cache leaks
Date: Tue, 12 Mar 2019 15:17:06 +0100
Message-ID: <20190312141708.6652-1-vbabka@suse.cz>
References: <20190130124420.1834-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190130124420.1834-1-vbabka@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, Andy Lutomirski <luto@amacapital.net>, Cyril Hrubis <chrubis@suse.cz>, Daniel Gruss <daniel@gruss.cc>, Dave Chinner <david@fromorbit.com>, Dominique Martinet <asmadeus@codewreck.org>, Jiri Kosina <jikos@kernel.org>, Jiri Kosina <jkosina@suse.cz>, Josh Snyder <joshs@netflix.com>, Kevin Easton <kevin@guarana.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-api@vger.kernel.org

Here's a new version of the mincore() patches, with feedback from Andrew Morton
applied. The IOCB_NOWAIT patch was dropped since David Chinner pointed out it's
incomplete. We definitely want the first patch, while for the second Linus
said:

  I think that's fine, and probably the right thing to do, but I also
  suspect that nobody actually cares ;(

Whether or not somebody cares, we should hear of no breakage. If somebody does
care after all, without second patch we might hear of breakage, so I would
suggest applying it. It's not that complicated after all (famous last words?)


Jiri Kosina (1):
  mm/mincore: make mincore() more conservative

Vlastimil Babka (1):
  mm/mincore: provide mapped status when cached status is not allowed

 mm/mincore.c | 80 ++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 12 deletions(-)

-- 
2.20.1
