From: Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH 05/21] userfaultfd: add vm_userfaultfd_ctx to the vm_area_struct
Date: Thu, 5 Mar 2015 20:48:22 +0300
Message-ID: <54F896E6.2010800@parallels.com>
References: <1425575884-2574-1-git-send-email-aarcange@redhat.com> <1425575884-2574-6-git-send-email-aarcange@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1425575884-2574-6-git-send-email-aarcange@redhat.com>
Sender: owner-linux-mm@kvack.org
To: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, Android Kernel Team <kernel-team@android.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Sanidhya Kashyap <sanidhya.gatech@gmail.com>, zhang.zhanghailiang@huawei.com, Linus Torvalds <torvalds@linux-foundation.org>, Andres Lagar-Cavilla <andreslc@google.com>, Dave Hansen <dave@sr71.net>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>, Peter Feiner <pfeiner@google.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Christopher Covington <cov@codeaurora.org>, Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>, Dmitry Adamushko <dmitry.adamushko@gmail.com>, Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.mo>
List-Id: linux-api@vger.kernel.org

> diff --git a/kernel/fork.c b/kernel/fork.c
> index cf65139..cb215c0 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -425,6 +425,7 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  			goto fail_nomem_anon_vma_fork;
>  		tmp->vm_flags &= ~VM_LOCKED;
>  		tmp->vm_next = tmp->vm_prev = NULL;
> +		tmp->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;

This creates an interesting effect when the userfaultfd is used outside of
the process which created and activated one. If I try to monitor the memory
usage of one task with another, once the first task fork()-s, its child
begins to see zero-pages in the places where the monitor task was supposed
to insert pages with data.

>  		file = tmp->vm_file;
>  		if (file) {
>  			struct inode *inode = file_inode(file);
> .
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
