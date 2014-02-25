From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/3] mm, thp: Add VM_INIT_DEF_MASK and PRCTL_THP_DISABLE
Date: Tue, 25 Feb 2014 18:03:10 -0500
Message-ID: <530D212E.3020307@redhat.com>
References: <cover.1392009759.rs.git.athorlton@sgi.com> <890608e8ec2968cf6b115411a62f76503ee10331.1392009760.git.athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <890608e8ec2968cf6b115411a62f76503ee10331.1392009760.git.athorlton@sgi.com>
Sender: owner-linux-mm@kvack.org
To: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrea Arcangeli <aarcange@redhat.com>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux390@de.ibm.com, linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 02/25/2014 03:54 PM, Alex Thorlton wrote:
> This patch adds a VM_INIT_DEF_MASK, to allow us to set the default flags
> for VMs.  It also adds a prctl control which alllows us to set the THP
> disable bit in mm->def_flags so that VMs will pick up the setting as
> they are created.
> 
> Signed-off-by: Alex Thorlton <athorlton@sgi.com>
> Suggested-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
