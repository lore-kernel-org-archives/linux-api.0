From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 22/23] userfaultfd: avoid mmap_sem read recursion in
 mcopy_atomic
Date: Fri, 22 May 2015 14:18:30 -0700
Message-ID: <20150522141830.f969b285ad072a23bb28f196@linux-foundation.org>
References: <1431624680-20153-1-git-send-email-aarcange@redhat.com>
	<1431624680-20153-23-git-send-email-aarcange@redhat.com>
	<20150522131822.74f374dd5a75a0285577c714@linux-foundation.org>
	<20150522204809.GB4251@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150522204809.GB4251@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-api@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>
List-Id: linux-api@vger.kernel.org


There's a more serious failure with i386 allmodconfig:

fs/userfaultfd.c:145:2: note: in expansion of macro 'BUILD_BUG_ON'
  BUILD_BUG_ON(sizeof(struct uffd_msg) != 32);

I'm surprised the feature is even reachable on i386 builds?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
