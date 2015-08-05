From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: Re: [PATCH v3 4/4] mm, procfs: Display VmAnon, VmFile and VmShm in
 /proc/pid/status
Date: Wed, 05 Aug 2015 16:21:34 +0300
Message-ID: <55C20DDE.1080506@yandex-team.ru>
References: <1438779685-5227-1-git-send-email-vbabka@suse.cz> <1438779685-5227-5-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438779685-5227-5-git-send-email-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 05.08.2015 16:01, Vlastimil Babka wrote:
> From: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> It's currently inconvenient to retrieve MM_ANONPAGES value from status
> and statm files and there is no way to separate MM_FILEPAGES and
> MM_SHMEMPAGES. Add VmAnon, VmFile and VmShm lines in /proc/<pid>/status
> to solve these issues.
>
> Signed-off-by: Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> ---
>   Documentation/filesystems/proc.txt | 10 +++++++++-
>   fs/proc/task_mmu.c                 | 13 +++++++++++--
>   2 files changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
> index fcf67c7..fadd1b3 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -168,6 +168,9 @@ For example, to get the status information of a process, all you have to do is
>     VmLck:         0 kB
>     VmHWM:       476 kB
>     VmRSS:       476 kB
> +  VmAnon:      352 kB
> +  VmFile:      120 kB
> +  VmShm:         4 kB
>     VmData:      156 kB
>     VmStk:        88 kB
>     VmExe:        68 kB
> @@ -229,7 +232,12 @@ Table 1-2: Contents of the status files (as of 4.1)
>    VmSize                      total program size
>    VmLck                       locked memory size
>    VmHWM                       peak resident set size ("high water mark")
> - VmRSS                       size of memory portions
> + VmRSS                       size of memory portions. It contains the three
> +                             following parts (VmRSS = VmAnon + VmFile + VmShm)
> + VmAnon                      size of resident anonymous memory
> + VmFile                      size of resident file mappings
> + VmShm                       size of resident shmem memory (includes SysV shm,
> +                             mapping of tmpfs and shared anonymous mappings)

"Vm" is an acronym for Virtual Memory, but all these are not virtual.
They are real pages. Let's leave VmRSS as is and invent better prefix
for new fields: something like "Mem", "Pg", or no prefix at all.

>    VmData                      size of data, stack, and text segments
>    VmStk                       size of data, stack, and text segments
>    VmExe                       size of text segment
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 99b0efe..e299101 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -22,7 +22,7 @@
>
>   void task_mem(struct seq_file *m, struct mm_struct *mm)
>   {
> -	unsigned long data, text, lib, swap, ptes, pmds;
> +	unsigned long data, text, lib, swap, ptes, pmds, anon, file, shmem;
>   	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
>
>   	/*
> @@ -39,6 +39,9 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>   	if (hiwater_rss < mm->hiwater_rss)
>   		hiwater_rss = mm->hiwater_rss;
>
> +	anon = get_mm_counter(mm, MM_ANONPAGES);
> +	file = get_mm_counter(mm, MM_FILEPAGES);
> +	shmem = get_mm_counter_shmem(mm);
>   	data = mm->total_vm - mm->shared_vm - mm->stack_vm;
>   	text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK)) >> 10;
>   	lib = (mm->exec_vm << (PAGE_SHIFT-10)) - text;
> @@ -52,6 +55,9 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>   		"VmPin:\t%8lu kB\n"
>   		"VmHWM:\t%8lu kB\n"
>   		"VmRSS:\t%8lu kB\n"
> +		"VmAnon:\t%8lu kB\n"
> +		"VmFile:\t%8lu kB\n"
> +		"VmShm:\t%8lu kB\n"
>   		"VmData:\t%8lu kB\n"
>   		"VmStk:\t%8lu kB\n"
>   		"VmExe:\t%8lu kB\n"
> @@ -65,6 +71,9 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>   		mm->pinned_vm << (PAGE_SHIFT-10),
>   		hiwater_rss << (PAGE_SHIFT-10),
>   		total_rss << (PAGE_SHIFT-10),
> +		anon << (PAGE_SHIFT-10),
> +		file << (PAGE_SHIFT-10),
> +		shmem << (PAGE_SHIFT-10),
>   		data << (PAGE_SHIFT-10),
>   		mm->stack_vm << (PAGE_SHIFT-10), text, lib,
>   		ptes >> 10,
> @@ -82,7 +91,7 @@ unsigned long task_statm(struct mm_struct *mm,
>   			 unsigned long *data, unsigned long *resident)
>   {
>   	*shared = get_mm_counter(mm, MM_FILEPAGES) +
> -		get_mm_counter(mm, MM_SHMEMPAGES);
> +		get_mm_counter_shmem(mm);
>   	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
>   								>> PAGE_SHIFT;
>   	*data = mm->total_vm - mm->shared_vm;
>


-- 
Konstantin
