From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH RFC 0/5] mm/ksm, proc: introduce remote madvise
Date: Thu, 16 May 2019 20:24:52 +0300
Message-ID: <20190516172452.GA2106@avx2>
References: <20190516094234.9116-1-oleksandr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190516094234.9116-1-oleksandr@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@virtuozzo.com>, Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <willy@infradead.org>, Pavel Tatashin <pasha.tatashin@soleen.com>, Greg KH <greg@kroah.com>, Suren Baghdasaryan <surenb@google.com>, Minchan Kim <minchan@kernel.org>, Timofey Titovets <nefelim4ag@gmail.com>, Aaron Tomlin <atomlin@redhat.com>, Grzegorz Halat <ghalat@redhat.com>, linux-mm@kvack.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Thu, May 16, 2019 at 11:42:29AM +0200, Oleksandr Natalenko wrote:

> * to mark all the eligible VMAs as mergeable, use:
> 
>    # echo merge > /proc/<pid>/madvise
> 
> * to unmerge all the VMAs, use:
> 
>    # echo unmerge > /proc/<pid>/madvise

Please make a real system call (or abuse prctl(2) passing target's pid).

Your example automerge daemon could just call it and not bother with /proc.
